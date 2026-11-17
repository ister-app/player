import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/SearchService.dart';

GraphQLClient _client(Map<String, dynamic> payload, {List<String>? terms}) =>
    GraphQLClient(
      link: HttpLink('https://api.example/graphql',
          httpClient: MockClient((request) async {
            final body = json.decode(request.body) as Map<String, dynamic>;
            terms?.add('${(body['variables'] as Map)['term']}');
            return http.Response(json.encode(payload), 200,
                headers: {'content-type': 'application/json'});
          })),
      cache: GraphQLCache(),
    );

void main() {
  final failing = {
    'errors': [
      {'message': 'search backend down'}
    ]
  };
  final empty = {
    'data': {'__typename': 'Query', 'search': <dynamic>[]}
  };

  test('a failed search is null, so a page can tell it from no results',
      () async {
    expect(await SearchService().searchOrNull(_client(failing), 'dragon'), isNull);
    expect(await SearchService().searchOrNull(_client(empty), 'dragon'), isEmpty);
  });

  test('search itself degrades to an empty list', () async {
    expect(await SearchService().search(_client(failing), 'dragon'), isEmpty);
  });

  test('a blank term never reaches the server; the term is trimmed', () async {
    final terms = <String>[];
    final client = _client(empty, terms: terms);
    expect(await SearchService().searchOrNull(client, '   '), isEmpty);
    expect(terms, isEmpty);
    await SearchService().searchOrNull(client, '  dragon ');
    expect(terms, ['dragon']);
  });
}
