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
    final ipv4 = RegExp(r'^\d+\.\d+\.\d+\.\d+');
    final ipv6 = RegExp(r'^\[?[0-9a-fA-F:]+\]?');
    if (url.startsWith('localhost') || ipv4.hasMatch(url) || ipv6.hasMatch(url)) {
      return "http";
    } else {
      return "https";
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

    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore()), queryRequestTimeout: Duration(seconds: 30)),
    );
    return client;
  }
}
