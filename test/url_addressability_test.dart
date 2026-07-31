import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/MovieScroll.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/SearchPage.dart';
import 'package:player/pages/ShowHomePage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LibrarySelectionNotifier.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL() => MockClient((request) async {
      final query = json.decode(request.body)['query'] as String? ?? '';
      if (query.contains('adminLibraries')) {
        return _json({'__typename': 'Query', 'libraries': <dynamic>[]});
      }
      if (query.contains('adminUsers') || query.startsWith('query users')) {
        return _json({
          '__typename': 'Query',
          'users': [
            {
              '__typename': 'User',
              'id': 'user-1',
              'name': 'Alice',
              'email': 'alice@example.org',
              'isAdmin': false,
              'grantedLibraries': <dynamic>[],
            }
          ],
        });
      }
      if (query.contains('libraries {')) {
        return _json({
          '__typename': 'Query',
          'libraries': [
            {
              '__typename': 'Library',
              'id': 'movie-lib-1',
              'name': 'Movies',
              'type': 'MOVIE',
              'sorting': 'NAME',
              'sortingOrder': 'ASCENDING',
            },
            {
              '__typename': 'Library',
              'id': 'movie-lib-2',
              'name': 'More Movies',
              'type': 'MOVIE',
              'sorting': 'NAME',
              'sortingOrder': 'ASCENDING',
            },
          ],
        });
      }
      if (query.contains('movies(')) {
        return _json({
          '__typename': 'Query',
          'movies': {
            '__typename': 'MoviePage',
            'content': <dynamic>[],
            'totalPages': 0,
            'totalElements': 0,
            'number': 0,
            'size': 15,
          },
        });
      }
      if (query.contains('search(')) {
        return _json({'__typename': 'Query', 'search': <dynamic>[]});
      }
      return _json({'__typename': 'Query'});
    });

GraphQLClient _client(http.Client httpClient) => GraphQLClient(
      link: HttpLink('https://api.example/graphql', httpClient: httpClient),
      cache: GraphQLCache(),
    );

Widget _wrapWidget(Widget child, http.Client client) => GraphQLProvider(
      client: ValueNotifier(_client(client)),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: child,
      ),
    );

/// Cold-URL router hosting the REAL generated pages, so the generated args
/// factories (argsAs orElse → query params) are what a bare URL exercises.
class _ColdRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('RootRoute',
              builder: (data) => const Scaffold(body: Text('root'))),
        ),
        AutoRoute(path: '/server/:serverName/list', page: MediaListRoute.page),
        AutoRoute(
            path: '/server/:serverName/settings/users/:userId',
            page: AdminUserAccessRoute.page),
      ];
}

Widget _wrapRouter(_ColdRouter router, http.Client client) => GraphQLProvider(
      client: ValueNotifier(_client(client)),
      child: MaterialApp.router(
        routerConfig: router.config(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    );

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // SearchPage touches MediaPlayerHandler.instance (musicPlayerOpen), whose
  // singleton constructs a media_kit Player; force it into existence once,
  // like test/person_page_test.dart does.
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
    pendingLibrarySelection.value = null;
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
    pendingLibrarySelection.value = null;
  });

  testWidgets('cold /list URL builds without args and shows watch next',
      (tester) async {
    final client = _fakeGraphQL();
    final router = _ColdRouter();
    await tester.pumpWidget(_wrapRouter(router, client));
    await _pump(tester);

    await router.navigatePath('/server/$_server/list');
    await _pump(tester);

    expect(find.text('Continue watching'), findsOneWidget);

    await router.navigatePath(
        '/server/$_server/list?kind=recently-added&libraryId=movie-lib-1&libraryType=MOVIE');
    await _pump(tester);

    expect(find.text('Recently added'), findsOneWidget);
    expect(find.byType(MovieScroll), findsOneWidget);
  });

  testWidgets('cold admin-user URL builds and resolves the name from the query',
      (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _ColdRouter();
    await tester.pumpWidget(_wrapRouter(router, client));
    await _pump(tester);

    await router.navigatePath('/server/$_server/settings/users/user-1');
    await _pump(tester);

    expect(find.text('Alice'), findsOneWidget);
  });

  testWidgets('library-tab URL params beat prefs and a pending selection',
      (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final prefs = SharedPreferencesAsync();
    await prefs.setString('selected_library_id_$_server', 'movie-lib-1');
    await prefs.setString('selected_library_type_$_server', 'MOVIE');
    await prefs.setString('library_view_$_server', 'discover');
    pendingLibrarySelection.value = const PendingLibrarySelection(
      serverName: _server,
      libraryId: 'movie-lib-1',
      libraryType: Enum$LibraryType.MOVIE,
    );

    await tester.pumpWidget(_wrapWidget(
      const ShowHomePage(
          serverName: _server, libraryId: 'movie-lib-2', view: 'browse'),
      client,
    ));
    await _pump(tester);

    // URL wins: library 2 in Browse mode, despite prefs + pending saying
    // library 1 / discover.
    expect(find.text('More Movies'), findsOneWidget);
    expect(find.byType(MovieScroll), findsOneWidget);
    // And the adopted choice persists on-device.
    expect(await prefs.getString('selected_library_id_$_server'),
        'movie-lib-2');
    expect(await prefs.getString('library_view_$_server'), 'browse');
  });

  testWidgets('search seeds from ?q= and searches immediately',
      (tester) async {
    final searched = <String>[];
    final client = MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      if (query.contains('search(')) {
        searched.add(
            (body['variables'] as Map<String, dynamic>)['term'] as String);
        return _json({'__typename': 'Query', 'search': <dynamic>[]});
      }
      return _json({'__typename': 'Query'});
    });
    ClientManager.testClientBuilder = (_) => _client(client);

    await tester.pumpWidget(_wrapWidget(
      const SearchPage(serverName: _server, query: 'batman'),
      client,
    ));
    await _pump(tester);

    expect(find.widgetWithText(TextField, 'batman'), findsOneWidget);
    expect(searched, contains('batman'));
  });
}
