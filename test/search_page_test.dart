import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/SearchPage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

MockClient _fakeGraphQL() => MockClient((request) async {
      final query = json.decode(request.body)['query'] as String? ?? '';
      if (query.contains('search(')) {
        return _json({
          '__typename': 'Query',
          'search': [
            {
              '__typename': 'Episode',
              'id': 'ep-1',
              'number': 3,
              'show': {'__typename': 'Show', 'id': 'show-1', 'name': 'Dragons'},
              'season': {'__typename': 'Season', 'id': 'season-1', 'number': 1},
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
            {
              '__typename': 'Movie',
              'id': 'movie-1',
              'name': 'Dragon Movie',
              'releaseYear': 2020,
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
            {
              '__typename': 'Show',
              'id': 'show-1',
              'name': 'Dragons',
              'releaseYear': 2019,
              'images': <dynamic>[],
              'metadata': <dynamic>[],
            },
          ],
        });
      }
      return _json({'__typename': 'Query'});
    });

GraphQLClient _client(http.Client httpClient) => GraphQLClient(
      link: HttpLink('https://api.example/graphql', httpClient: httpClient),
      cache: GraphQLCache(),
    );

/// Hosts the real SearchPage as root; the navigation targets are stubs matched
/// by route NAME, so a tap only "lands" when the pushed route resolves — a
/// direct push of the nested ShowEpisodeRoute would fail and render nothing.
class _StubRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('SearchHostRoute',
              builder: (data) =>
                  const SearchPage(serverName: _server, query: 'dragon')),
        ),
        AutoRoute(
          path: '/shows/:showId',
          page: PageInfo('ShowOverviewRoute',
              builder: (data) => const Scaffold(body: AutoRouter())),
          children: [
            AutoRoute(
              path: 'overview',
              initial: true,
              page: PageInfo('ShowOverviewContentRoute',
                  builder: (data) => const Text('show-overview-stub')),
            ),
            AutoRoute(
              path: 'episodes/:episodeId',
              page: PageInfo('ShowEpisodeRoute',
                  builder: (data) => Text(
                      'episode-stub ${data.params.getString('showId')}/${data.params.getString('episodeId')}')),
            ),
          ],
        ),
        AutoRoute(
          path: '/movies/:movieId',
          page: PageInfo('MovieRoute',
              builder: (data) => Text(
                  'movie-stub ${data.params.getString('movieId')}')),
        ),
      ];
}

/// Answers `libraries` with two libraries and `search` with nothing,
/// recording the `libraryId` variable of every search it sees.
MockClient _scopedGraphQL(List<String?> searchedLibraries) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      if (query.contains('search(')) {
        searchedLibraries.add(
            (body['variables'] as Map<String, dynamic>)['libraryId'] as String?);
        return _json({'__typename': 'Query', 'search': <dynamic>[]});
      }
      if (query.contains('libraries')) {
        return _json({
          '__typename': 'Query',
          'libraries': [
            for (final (id, name) in [('lib-1', 'Movies'), ('lib-2', 'Music')])
              {
                '__typename': 'Library',
                'id': id,
                'name': name,
                'type': 'MOVIE',
                'sorting': 'NAME',
                'sortingOrder': 'ASCENDING',
              },
          ],
        });
      }
      return _json({'__typename': 'Query'});
    });

/// Hosts SearchPage under the real route name, so its own URL reflection and
/// an outside navigate (the library page's search button) both land on it.
class _SearchRouteRouter extends RootStackRouter {
  _SearchRouteRouter(this.initialLibraryId);

  final String? initialLibraryId;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('HostRoute',
              builder: (data) => const Scaffold(body: AutoRouter())),
          children: [
            AutoRoute(
              path: '',
              initial: true,
              page: PageInfo('SearchRoute',
                  builder: (data) => SearchPage(
                        serverName: _server,
                        libraryId: data.queryParams
                            .optString('libraryId', initialLibraryId),
                        query: data.queryParams.optString('q', 'dragon'),
                      )),
            ),
          ],
        ),
      ];
}

/// Mirrors the server shell: search and a library stand-in as sibling tabs.
/// The library tab's button makes the same call as ShowHomePage's.
class _TabsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('TabsHostRoute',
              builder: (data) => AutoTabsRouter(
                    routes: [SearchRoute(), const PageRouteInfo('LibraryStubRoute')],
                    builder: (context, child) => Scaffold(body: child),
                  )),
          children: [
            AutoRoute(
              path: 'search',
              page: PageInfo('SearchRoute',
                  builder: (data) => SearchPage(
                        serverName: _server,
                        libraryId: data.queryParams.optString('libraryId'),
                        query: data.queryParams.optString('q'),
                      )),
            ),
            AutoRoute(
              path: 'library',
              page: PageInfo('LibraryStubRoute',
                  builder: (data) => Builder(
                        builder: (context) => TextButton(
                          onPressed: () => context.router
                              .navigate(SearchRoute(libraryId: 'lib-2')),
                          child: const Text('library-search'),
                        ),
                      )),
            ),
          ],
        ),
      ];
}

bool _chipSelected(WidgetTester tester, String key) =>
    tester.widget<ChoiceChip>(find.byKey(ValueKey(key))).selected;

Widget _wrap(RootStackRouter router, http.Client client) => GraphQLProvider(
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
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // SearchPage touches MediaPlayerHandler.instance (musicPlayerOpen), whose
  // singleton constructs a media_kit Player; force it into existence once.
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  testWidgets('tapping an episode result opens the episode inside its show',
      (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _StubRouter();
    await tester.pumpWidget(_wrap(router, client));
    await _pump(tester);

    await tester.tap(find.text('Episode 3'));
    await _pump(tester);

    expect(find.text('episode-stub show-1/ep-1'), findsOneWidget);
  });

  testWidgets('tapping a movie result opens the movie page', (tester) async {
    final client = _fakeGraphQL();
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _StubRouter();
    await tester.pumpWidget(_wrap(router, client));
    await _pump(tester);

    await tester.tap(find.text('Dragon Movie'));
    await _pump(tester);

    expect(find.text('movie-stub movie-1'), findsOneWidget);
  });

  testWidgets('search starts on all libraries and offers each one',
      (tester) async {
    final searched = <String?>[];
    final client = _scopedGraphQL(searched);
    ClientManager.testClientBuilder = (_) => _client(client);
    await tester.pumpWidget(_wrap(_SearchRouteRouter(null), client));
    await _pump(tester);

    expect(_chipSelected(tester, 'search-scope-all'), isTrue);
    expect(_chipSelected(tester, 'search-scope-lib-1'), isFalse);
    expect(searched, [null]);

    await tester.tap(find.byKey(const ValueKey('search-scope-lib-2')));
    await _pump(tester);

    expect(_chipSelected(tester, 'search-scope-lib-2'), isTrue);
    expect(searched.last, 'lib-2');
  });

  testWidgets('a library from the route selects its chip', (tester) async {
    final searched = <String?>[];
    final client = _scopedGraphQL(searched);
    ClientManager.testClientBuilder = (_) => _client(client);
    await tester.pumpWidget(_wrap(_SearchRouteRouter('lib-1'), client));
    await _pump(tester);

    expect(_chipSelected(tester, 'search-scope-lib-1'), isTrue);
    expect(searched, ['lib-1']);

    await tester.tap(find.byKey(const ValueKey('search-scope-all')));
    await _pump(tester);
    expect(_chipSelected(tester, 'search-scope-all'), isTrue);
    expect(searched.last, isNull);
  });

  testWidgets('navigating to the mounted page with a library rescopes it',
      (tester) async {
    final searched = <String?>[];
    final client = _scopedGraphQL(searched);
    ClientManager.testClientBuilder = (_) => _client(client);
    final router = _SearchRouteRouter(null);
    await tester.pumpWidget(_wrap(router, client));
    await _pump(tester);
    expect(_chipSelected(tester, 'search-scope-all'), isTrue);

    // What the library page's search button does.
    router.navigate(
        SearchRoute(libraryId: 'lib-2', query: 'dragon'));
    await _pump(tester);

    expect(_chipSelected(tester, 'search-scope-lib-2'), isTrue);
    expect(searched.last, 'lib-2');
  });

  testWidgets('the library search button switches to the mounted search tab',
      (tester) async {
    final searched = <String?>[];
    final client = _scopedGraphQL(searched);
    ClientManager.testClientBuilder = (_) => _client(client);
    await tester.pumpWidget(_wrap(_TabsRouter(), client));
    await _pump(tester);
    expect(_chipSelected(tester, 'search-scope-all'), isTrue);

    AutoTabsRouter.of(tester.element(find.byType(SearchPage))).setActiveIndex(1);
    await _pump(tester);
    await tester.tap(find.text('library-search'));
    await _pump(tester);

    expect(find.byType(SearchPage), findsOneWidget);
    expect(_chipSelected(tester, 'search-scope-lib-2'), isTrue);
  });
}
