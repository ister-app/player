import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/SessionListenersSheet.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';
const _queueId = 'queue-1';

Map<String, dynamic> _follower({
  String userId = 'user-2',
  String? userName = 'Anna',
  String deviceId = 'device-a',
  String? deviceName = 'Kitchen',
  String? platform = 'ANDROID',
}) =>
    {
      '__typename': 'SessionFollower',
      'userId': userId,
      'userName': userName,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      'since': '2026-08-05T12:00:00Z',
    };

/// Routes on query text: the follower list and the kick mutation, recording the mutation
/// variables so a test can assert what was actually asked of the server.
MockClient _fakeGraphQL(
  List<Map<String, dynamic>> followers, {
  List<Map<String, dynamic>>? kicks,
  bool removeSucceeds = true,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('removeFollower')) {
        kicks?.add(body['variables'] as Map<String, dynamic>);
        payload = {
          'data': {'__typename': 'Mutation', 'removeFollower': removeSucceeds}
        };
      } else if (query.contains('sessionFollowers')) {
        payload = {
          'data': {'__typename': 'Query', 'sessionFollowers': followers}
        };
      } else {
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: home,
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  /// Opens a sheet embedding the list and settles it. The list polls, so every
  /// test must close it again (see [close]) before finishing, or its timer
  /// outlives the test.
  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(_app(Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (_) => const SingleChildScrollView(
              child: SessionListenersList(
                serverName: _server,
                playQueueId: _queueId,
                canKick: true,
              ),
            ),
          ),
          child: const Text('open'),
        ),
      ),
    )));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    Navigator.of(tester.element(find.text('open'))).pop();
    await tester.pumpAndSettle();
  }

  testWidgets('groups the followers per user', (tester) async {
    useClient(_fakeGraphQL([
      _follower(deviceId: 'device-a', deviceName: 'Kitchen'),
      _follower(deviceId: 'device-b', deviceName: 'Bedroom'),
      _follower(userId: 'user-3', userName: 'Kees', deviceId: 'device-c', deviceName: 'Attic'),
    ]));
    await openSheet(tester);

    // One row per user, with their device count, plus one row per device.
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('2 devices listening along'), findsOneWidget);
    expect(find.text('Kees'), findsOneWidget);
    expect(find.text('1 device listening along'), findsOneWidget);
    expect(find.text('Kitchen'), findsOneWidget);
    expect(find.text('Bedroom'), findsOneWidget);
    expect(find.text('Attic'), findsOneWidget);

    await close(tester);
  });

  testWidgets('names a device the server knows nothing about', (tester) async {
    useClient(_fakeGraphQL([
      _follower(userName: null, deviceName: null, platform: null),
    ]));
    await openSheet(tester);

    expect(find.text('Unknown user'), findsOneWidget);
    expect(find.text('Unknown device'), findsOneWidget);

    await close(tester);
  });

  testWidgets('removing one device kicks only that device', (tester) async {
    final kicks = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL([
      _follower(deviceId: 'device-a', deviceName: 'Kitchen'),
      _follower(deviceId: 'device-b', deviceName: 'Bedroom'),
    ], kicks: kicks));
    await openSheet(tester);

    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pumpAndSettle();
    expect(find.text('Stop Bedroom from listening along?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    expect(kicks, hasLength(1));
    expect(kicks.single['userId'], 'user-2');
    expect(kicks.single['deviceId'], 'device-b');
    expect(find.text('Bedroom is no longer listening along'), findsOneWidget);

    await close(tester);
  });

  testWidgets('removing a user kicks all of their devices at once', (tester) async {
    final kicks = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL([
      _follower(deviceId: 'device-a'),
      _follower(deviceId: 'device-b'),
    ], kicks: kicks));
    await openSheet(tester);

    await tester.tap(find.byIcon(Icons.person_remove));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();

    // No device id: the server decides which of that user's devices are following.
    expect(kicks, hasLength(1));
    expect(kicks.single['userId'], 'user-2');
    expect(kicks.single['deviceId'], isNull);

    await close(tester);
  });

  testWidgets('says nobody is listening when the list is empty', (tester) async {
    useClient(_fakeGraphQL([]));
    await openSheet(tester);

    expect(find.text('Nobody is listening along right now'), findsOneWidget);

    await close(tester);
  });

  testWidgets('reports a server that does not know the query as a load failure',
      (tester) async {
    useClient(MockClient((_) async => http.Response(
        json.encode({
          'errors': [
            {'message': "Validation error: Field 'sessionFollowers' is undefined"}
          ]
        }),
        200,
        headers: {'content-type': 'application/json'})));
    await openSheet(tester);

    expect(find.text('Could not load the listeners'), findsOneWidget);

    await close(tester);
  });
}
