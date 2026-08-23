import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/StreamTokenService.dart';

const _server = 'localhost:8080/api';

void main() {
  var mutations = 0;
  var minted = 0;

  setUp(() {
    mutations = 0;
    minted = 0;
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.example/graphql',
              httpClient: MockClient((req) async {
            mutations++;
            // A late responder, so several callers really do overlap.
            await Future<void>.delayed(const Duration(milliseconds: 20));
            return http.Response(
                json.encode({
                  'data': {
                    '__typename': 'Mutation',
                    'createStreamToken': {
                      '__typename': 'StreamToken',
                      'token': 'tok-${++minted}',
                      'expiresAt': DateTime.now()
                          .add(const Duration(hours: 24))
                          .toIso8601String(),
                    }
                  }
                }),
                200,
                headers: {'content-type': 'application/json'});
          })),
        );
    StreamTokenService.resetForTest();
  });

  tearDown(() {
    StreamTokenService.resetForTest();
    ClientManager.testClientBuilder = null;
    ClientManager.clients.clear();
  });

  test('callers racing for a token mint exactly one', () async {
    final tokens = await Future.wait(
        [for (var i = 0; i < 8; i++) StreamTokenService.ensureToken(_server)]);

    expect(mutations, 1,
        reason: 'the server hands out a new token per mutation; '
            'racing fetches would leave 7 of them unused');
    expect(tokens.toSet(), {'tok-1'},
        reason: 'every caller gets the same token');
  });

  test('a cached token is reused without a mutation', () async {
    await StreamTokenService.ensureToken(_server);
    expect(mutations, 1);
    expect(await StreamTokenService.ensureToken(_server), 'tok-1');
    expect(mutations, 1);
  });

  test('after an invalidation the next race mints one new token', () async {
    await StreamTokenService.ensureToken(_server);
    StreamTokenService.invalidateToken(_server);

    final tokens = await Future.wait(
        [for (var i = 0; i < 4; i++) StreamTokenService.ensureToken(_server)]);
    expect(mutations, 2);
    expect(tokens.toSet(), {'tok-2'});
  });
}
