import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/LoginManager.dart';

class ClientManager {
  static Map<String, ValueNotifier<GraphQLClient>> clients = {};

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
      'https://$url/graphql',
    );

    final AuthLink authLink =
        AuthLink(getToken: () => LoginManager.getToken(url));

    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: InMemoryStore())),
    );
    return client;
  }
}
