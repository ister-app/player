import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientManager {
  static final ClientManager _instance = ClientManager._internal();

  static ClientManager get instance => _instance;

  ClientManager._internal() {
    _sharedPreferencesAsync.getString("currentServer").then(
      (value) {
        _lastClientUsed = value;
      },
    );
  }

  final SharedPreferencesAsync _sharedPreferencesAsync = SharedPreferencesAsync();
  String? _lastClientUsed;
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
    if (url.contains("localhost")) {
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
    final HttpLink httpLink = HttpLink(
      '${getHttpOrHttps(url)}://$url/graphql',
    );

    final AuthLink authLink =
        AuthLink(getToken: () => LoginManager.getToken(url));

    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore()), queryRequestTimeout: Duration(seconds: 30)),
    );
    return client;
  }
}
