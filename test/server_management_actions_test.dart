import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/ConfirmDialog.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerSettingsClusterPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

/// Answers the cluster page's queries and records every maintenance mutation
/// (name + variables) in [mutations].
MockClient _fakeGraphQL(List<(String, Map<String, dynamic>)> mutations) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('mutation refreshMetadata') ||
          query.contains('mutation scanLibraries') ||
          query.contains('mutation rebuildSearchIndex')) {
        final name = RegExp(r'mutation (\w+)').firstMatch(query)!.group(1)!;
        mutations.add((name, (body['variables'] as Map<String, dynamic>?) ?? {}));
        payload = {
          'data': {'__typename': 'Mutation', name: true}
        };
      } else if (query.contains('me {')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'me': {
              '__typename': 'Me',
              'id': 'user-1',
              'name': 'Admin',
              'email': 'admin@example.org',
              'isAdmin': true,
            },
          }
        };
      } else if (query.contains('subscription serverActivity')) {
        payload = {
          'errors': [
            {'message': 'subscriptions are not supported over http'}
          ]
        };
      } else if (query.contains('serverActivitySnapshot')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'serverActivitySnapshot': {
              '__typename': 'ServerActivitySnapshot',
              'nodes': [],
              'queueStats': [],
              'recentFailures': [],
              'nowPlaying': [],
              'transcodes': [],
            },
          }
        };
      } else if (query.contains('getServerInfo')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'getServerInfo': {
              '__typename': 'ServerInfo',
              'name': 'test',
              'openIdUrl': 'https://idp.example',
              'url': 'https://api.example',
              'nodes': [],
            },
          }
        };
      } else if (query.contains('libraries {')) {
        payload = {
          'data': {
            '__typename': 'Query',
            'libraries': [
              {
                '__typename': 'Library',
                'id': 'lib-1',
                'name': 'Movies',
                'type': 'MOVIE',
                'sorting': 'NAME',
                'sortingOrder': 'ASCENDING',
              },
            ],
          }
        };
      } else {
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(
        json.encode(payload),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

Widget _app(Widget home) => GraphQLProvider(
      client: ClientManager.getClientForUrl(_server),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: home,
      ),
    );

void main() {
  late List<(String, Map<String, dynamic>)> mutations;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
    mutations = [];
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL(mutations)),
          cache: GraphQLCache(),
        );
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  group('showConfirmDialog', () {
    testWidgets('returns true on confirm and false on cancel', (tester) async {
      bool? outcome;
      await tester.pumpWidget(_app(Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () async {
              outcome = await showConfirmDialog(
                context,
                title: 'Rebuild metadata?',
                body: 'Body text',
                confirmLabel: 'Rebuild',
              );
            },
            child: const Text('open'),
          ),
        ),
      )));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Rebuild metadata?'), findsOneWidget);
      expect(find.text('Body text'), findsOneWidget);
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();
      expect(outcome, isTrue);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(outcome, isFalse);
    });
  });

  group('management actions', () {
    setUp(() {
      // The management card sits at the bottom of the activity page; a taller
      // surface keeps every tile tappable without fighting the scrollable.
      TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
        ..physicalSize = const Size(800, 2400)
        ..devicePixelRatio = 1.0;
    });

    tearDown(() {
      TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });

    testWidgets('every tile carries an explanatory subtitle', (tester) async {
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      expect(find.text('Looks for newly added files in all libraries. Quick and safe.'),
          findsOneWidget);
      expect(
          find.text(
              'Downloads metadata and artwork only where they are missing. Safe to run anytime.'),
          findsOneWidget);
      expect(
          find.text(
              'Deletes and re-downloads all metadata and artwork for one library. Heavy; can take a long time.'),
          findsOneWidget);
      expect(
          find.text(
              'Recreates the search index from the database. Search stays available while it runs.'),
          findsOneWidget);
    });

    testWidgets('fetch missing metadata sends a MISSING refresh',
        (tester) async {
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fetch missing metadata'));
      await tester.pumpAndSettle();

      expect(mutations, hasLength(1));
      expect(mutations.single.$1, 'refreshMetadata');
      expect(mutations.single.$2['mode'], 'MISSING');
      expect(mutations.single.$2['libraryId'], isNull);
    });

    testWidgets('cancelling the rebuild confirmation sends no mutation',
        (tester) async {
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rebuild library metadata'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Movies'));
      await tester.pumpAndSettle();
      expect(find.text('Rebuild metadata?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(mutations, isEmpty);
    });

    testWidgets('confirming the rebuild sends a FORCE refresh for the library',
        (tester) async {
      await tester.pumpWidget(
          _app(const ServerSettingsClusterPage(serverName: _server)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rebuild library metadata'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Movies'));
      await tester.pumpAndSettle();
      // The confirm button carries the action label.
      await tester.tap(find.widgetWithText(FilledButton, 'Rebuild library metadata'));
      await tester.pumpAndSettle();

      expect(mutations, hasLength(1));
      expect(mutations.single.$1, 'refreshMetadata');
      expect(mutations.single.$2['mode'], 'FORCE');
      expect(mutations.single.$2['libraryId'], 'lib-1');
    });
  });
}
