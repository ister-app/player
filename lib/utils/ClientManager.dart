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

  /// Drops all per-server state for [url] (used when a server is deleted).
  static void removeClient(String url) {
    clients.remove(url);
    _webSocketLinks.remove(url)?.dispose();
    if (instance._lastClientUsed == url) {
      instance.lastClientUsed = null;
    }
  }

  static ValueNotifier<GraphQLClient> getClientForUrl(String url) {
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
    final WebSocketLink wsLink = WebSocketLink(
      wsUrl,
      subProtocol: GraphQLProtocol.graphqlTransportWs,
      config: SocketClientConfig(
        autoReconnect: true,
        delayBetweenReconnectionAttempts: const Duration(seconds: 5),
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
