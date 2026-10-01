import 'dart:convert';

import 'package:fake_async/fake_async.dart';
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

  failureClassificationTests();
}

/// A GraphQLClient whose MockClient answers `createStreamToken` with [body]
/// and [status], counting the calls in [calls].
GraphQLClient _answering(List<int> calls, String body, int status) =>
    GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('https://api.example/graphql',
          httpClient: MockClient((req) async {
        calls.add(status);
        return http.Response(body, status,
            headers: {'content-type': 'application/json'});
      })),
    );

String _gqlError(String message, String classification) => json.encode({
      'errors': [
        {
          'message': message,
          'extensions': {'classification': classification}
        }
      ],
      'data': null,
    });

void failureClassificationTests() {
  group('classifyFailure', () {
    OperationException gql(String message, [String? classification]) =>
        OperationException(graphqlErrors: [
          GraphQLError(
              message: message,
              extensions:
                  classification == null ? null : {'classification': classification})
        ]);
    OperationException http_(int status) => OperationException(
        linkException: HttpLinkServerException(
            response: http.Response('{}', status),
            parsedResponse: const Response(response: {}),
            statusCode: status));

    test('HTTP 401 on the link: the bearer itself was rejected', () {
      expect(StreamTokenService.classifyFailure(http_(401)),
          StreamTokenFailure.unauthenticated);
    });
    test('HTTP 403 on the link', () {
      expect(StreamTokenService.classifyFailure(http_(403)),
          StreamTokenFailure.forbidden);
    });
    test('Spring GraphQL denial for an anonymous request', () {
      expect(StreamTokenService.classifyFailure(gql('Unauthorized', 'UNAUTHORIZED')),
          StreamTokenFailure.unauthenticated);
    });
    test('Spring GraphQL denial for a user without the role', () {
      expect(StreamTokenService.classifyFailure(gql('Forbidden', 'FORBIDDEN')),
          StreamTokenFailure.forbidden);
      expect(StreamTokenService.classifyFailure(gql('Access Denied')),
          StreamTokenFailure.forbidden);
    });
    test('anything else is a transient failure', () {
      expect(StreamTokenService.classifyFailure(http_(503)),
          StreamTokenFailure.other);
      expect(StreamTokenService.classifyFailure(gql('Internal error', 'INTERNAL_ERROR')),
          StreamTokenFailure.other);
      expect(
          StreamTokenService.classifyFailure(OperationException(
              linkException: const ServerException(originalException: 'x'))),
          StreamTokenFailure.other);
      expect(StreamTokenService.classifyFailure(null), StreamTokenFailure.other);
    });
  });

  group('retry policy', () {
    final calls = <int>[];
    setUp(() {
      calls.clear();
      ClientManager.clients.clear();
      StreamTokenService.resetForTest();
    });
    tearDown(() {
      StreamTokenService.resetForTest();
      ClientManager.testClientBuilder = null;
      ClientManager.clients.clear();
    });

    test('a rejected bearer is recorded and not retried on a timer', () {
      fakeAsync((async) {
        ClientManager.testClientBuilder =
            (_) => _answering(calls, '{"error":"Unauthorized"}', 401);
        String? token;
        StreamTokenService.ensureToken(_server).then((t) => token = t);
        async.flushMicrotasks();
        expect(token, isNull);
        expect(StreamTokenService.failureFor(_server),
            StreamTokenFailure.unauthenticated);
        async.elapse(const Duration(minutes: 5));
        expect(calls.length, 1, reason: 'no retry timer for a dead session');
      });
    });

    test('a forbidden user is polled slowly, not every few seconds', () {
      fakeAsync((async) {
        ClientManager.testClientBuilder =
            (_) => _answering(calls, _gqlError('Forbidden', 'FORBIDDEN'), 200);
        StreamTokenService.ensureToken(_server);
        async.flushMicrotasks();
        expect(StreamTokenService.failureFor(_server),
            StreamTokenFailure.forbidden);
        async.elapse(const Duration(seconds: 30));
        expect(calls.length, 1);
        async.elapse(const Duration(seconds: 31));
        expect(calls.length, 2, reason: 'retried after a minute');
      });
    });

    test('a server error keeps the quick retry', () {
      fakeAsync((async) {
        ClientManager.testClientBuilder =
            (_) => _answering(calls, '{"error":"boom"}', 500);
        StreamTokenService.ensureToken(_server);
        async.flushMicrotasks();
        expect(StreamTokenService.failureFor(_server), StreamTokenFailure.other);
        async.elapse(const Duration(seconds: 6));
        expect(calls.length, 2);
      });
    });

    test('invalidateToken clears the recorded failure', () {
      fakeAsync((async) {
        ClientManager.testClientBuilder =
            (_) => _answering(calls, _gqlError('Forbidden', 'FORBIDDEN'), 200);
        StreamTokenService.ensureToken(_server);
        async.flushMicrotasks();
        StreamTokenService.invalidateToken(_server);
        expect(StreamTokenService.failureFor(_server), StreamTokenFailure.none);
        async.elapse(const Duration(minutes: 2));
        expect(calls.length, 1, reason: 'invalidation cancelled the retry');
      });
    });
  });
}
