import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientManager {
  static final ClientManager _instance = ClientManager._internal();

  static ClientManager get instance => _instance;

  ClientManager._internal() {
    _readyFuture = _sharedPreferencesAsync.getString("currentServer").then(
      (value) {
        _lastClientUsed = value;
      },
    );
  }

  final SharedPreferencesAsync _sharedPreferencesAsync = SharedPreferencesAsync();
  String? _lastClientUsed;
  late final Future<void> _readyFuture;

  static Future<void> ensureInitialized() => ClientManager.instance._readyFuture;
  static Map<String, ValueNotifier<GraphQLClient>> clients = {};

  String? get lastClientUsed => _lastClientUsed;
  set lastClientUsed(String? value) {
    _lastClientUsed = value;
    if (value != null) {
      _sharedPreferencesAsync.setString("currentServer", value);
    } else {
      _sharedPreferencesAsync.remove("currentServer");
    }
  }

  static String getHttpOrHttps(String url) {
    // Extract the host from "host", "host:port", "host/path" or "[ipv6]:port".
    final authority = url.split('/').first;
    final String host;
    if (authority.startsWith('[')) {
      final end = authority.indexOf(']');
      host = end == -1 ? authority.substring(1) : authority.substring(1, end);
    } else {
      host = authority.split(':').first;
    }
    final ipv4 = RegExp(r'^\d{1,3}(\.\d{1,3}){3}$');
    final ipv6 = RegExp(r'^[0-9a-fA-F:]+$');
    final isIpv6 = host.contains(':') && ipv6.hasMatch(host);
    if (host == 'localhost' || ipv4.hasMatch(host) || isIpv6) {
      return "http";
    } else {
      return "https";
    }
  }

  static final Map<String, WebSocketLink> _webSocketLinks = {};

  /// Per-server hand brake on the websocket: pushing disconnect+connect makes
  /// the socket client drop its connection and re-register every live
  /// subscription on a fresh one (see [resetWebSockets]).
  static final Map<String, StreamController<ToggleConnectionState>>
      _socketToggles = {};

  /// After doze or a network switch, mobile OSes can leave a TCP connection
  /// half-open: dead, but without ever surfacing a close or error to the app.
  /// The graphql socket client cannot detect that state (its keepalive ping is
  /// only re-armed by the matching pong, which never arrives), so every
  /// subscription would silently stay frozen. This forces each connected
  /// socket through a disconnect→connect cycle; sockets that are idle or
  /// mid-(re)connect ignore the pulses.
  static Future<void> resetWebSockets() async {
    for (final toggle in _socketToggles.values) {
      toggle.add(ToggleConnectionState.disconnect);
    }
    // The connect pulse is only honoured in the notConnected state; give the
    // disconnect a beat to close the channel and get there.
    await Future.delayed(const Duration(milliseconds: 300));
    for (final toggle in _socketToggles.values) {
      toggle.add(ToggleConnectionState.connect);
    }
  }

  /// Observe the reset pulses [resetWebSockets] sends for [url].
  @visibleForTesting
  static Stream<ToggleConnectionState>? socketToggleStreamFor(String url) =>
      _socketToggles[url]?.stream;

  /// Drops all per-server state for [url] (used when a server is deleted).
  static void removeClient(String url) {
    clients.remove(url);
    _webSocketLinks.remove(url)?.dispose();
    _socketToggles.remove(url)?.close();
    if (instance._lastClientUsed == url) {
      instance.lastClientUsed = null;
    }
  }

  /// Widget-test seam: when set, [getClientForUrl] builds clients through this
  /// instead of the well-known/OIDC plumbing (which needs a live server).
  @visibleForTesting
  static GraphQLClient Function(String url)? testClientBuilder;

  /// True when [testClientBuilder] is installed. Production code may branch on
  /// this (e.g. to skip OIDC waits against stubbed clients) without tripping
  /// the visible-for-testing lint.
  static bool get usesTestClients => testClientBuilder != null;

  static ValueNotifier<GraphQLClient> getClientForUrl(String url) {
    final builder = testClientBuilder;
    if (builder != null) {
      return clients.putIfAbsent(url, () => ValueNotifier(builder(url)));
    }
    if (clients.containsKey(url)) {
      return clients[url]!;
    } else {
      ValueNotifier<GraphQLClient> client = createClient(url);
      clients[url] = client;
      return client;
    }
  }

  static ValueNotifier<GraphQLClient> createClient(String url) {
    final cachedInfo = WellKnownService.getCached(url);
    if (cachedInfo == null) {
      throw StateError(
          'WellKnownInfo not cached for $url — fetch must complete before createClient');
    }
    final HttpLink httpLink = HttpLink('${cachedInfo.serverUrl}/graphql');

    final AuthLink authLink =
        AuthLink(getToken: () => LoginManager.getToken(url));

    // Subscriptions go over graphql-transport-ws on the same /graphql path.
    // serverUrl already carries a scheme, so http→ws / https→wss. The server
    // authenticates the connection via the connection_init payload; passing
    // initialPayload as a function makes every reconnect pick up a fresh
    // token. The socket only opens once something actually subscribes.
    final wsUrl =
        '${cachedInfo.serverUrl}/graphql'.replaceFirst(RegExp(r'^http'), 'ws');
    final toggle = _socketToggles.putIfAbsent(
        url, () => StreamController<ToggleConnectionState>.broadcast());
    final WebSocketLink wsLink = WebSocketLink(
      wsUrl,
      subProtocol: GraphQLProtocol.graphqlTransportWs,
      config: SocketClientConfig(
        autoReconnect: true,
        delayBetweenReconnectionAttempts: const Duration(seconds: 5),
        toggleConnection: toggle.stream,
        initialPayload: () async {
          // A null Authorization guarantees the server closes with 4401, so
          // wait for a token rather than burning the connect attempt. The key
          // is omitted entirely when no token can be had.
          final token = await LoginManager.getToken(url) ??
              await LoginManager.waitForToken(url);
          return {if (token != null) 'Authorization': token};
        },
      ),
    );
    _webSocketLinks[url]?.dispose();
    _webSocketLinks[url] = wsLink;

    final Link link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      authLink.concat(httpLink),
    );
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore()), queryRequestTimeout: Duration(seconds: 30)),
    );
    return client;
  }
}
