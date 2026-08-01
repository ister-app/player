import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/LibraryDiscoverView.dart';
import 'package:player/components/MovieScroll.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/MediaListPage.dart';
import 'package:player/pages/ShowHomePage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Map<String, dynamic> _movie(String id, String name) => {
      '__typename': 'Movie',
      'id': id,
      'name': name,
      'releaseYear': 2020,
      'images': <dynamic>[],
      'metadata': <dynamic>[],
    };

Map<String, dynamic> _moviesPage(List<Map<String, dynamic>> movies) => {
      '__typename': 'Query',
      'movies': {
        '__typename': 'MoviePage',
        'content': movies,
        'totalPages': 1,
        'totalElements': movies.length,
        'number': 0,
        'size': 15,
      },
    };

Map<String, dynamic> _discoverMovies({
  List<Map<String, dynamic>> recentlyPlayed = const [],
  List<Map<String, dynamic>> mostPlayed = const [],
  List<Map<String, dynamic>> highestRated = const [],
}) =>
    {
      '__typename': 'Query',
      'libraryById': {
        '__typename': 'Library',
        'id': 'movie-lib-1',
        'recentlyPlayedMovies': recentlyPlayed,
        'mostPlayedMovies': mostPlayed,
        'highestRatedMovies': highestRated,
      },
    };

Map<String, dynamic> _libraries({bool withMusic = false}) => {
      '__typename': 'Query',
      'libraries': [
        {
          '__typename': 'Library',
          'id': 'movie-lib-1',
          'name': 'movies',
          'type': 'MOVIE',
          'sorting': 'NAME',
          'sortingOrder': 'ASCENDING',
        },
        if (withMusic)
          {
            '__typename': 'Library',
            'id': 'music-lib-1',
            'name': 'music',
            'type': 'MUSIC',
            'sorting': 'NAME',
            'sortingOrder': 'ASCENDING',
          },
      ],
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

/// Routes on the query text; graphql_flutter sends no operationName.
MockClient _fakeGraphQL({
  Map<String, dynamic>? discover,
  bool discoverErrors = false,
  bool withMusicLibrary = false,
}) =>
    MockClient((request) async {
      final query = json.decode(request.body)['query'] as String? ?? '';
      if (query.contains('libraryById')) {
        if (discoverErrors) {
          // An old server without the discover schema rejects the query.
          return http.Response(
            json.encode({
              'errors': [
                {'message': "Validation error: unknown field 'libraryById'"}
              ]
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return _json(discover ?? _discoverMovies());
      }
      if (query.contains('movies(')) {
        return _json(_moviesPage([_movie('new-1', 'Newly Added Movie')]));
      }
      if (query.contains('libraries {')) {
        return _json(_libraries(withMusic: withMusicLibrary));
      }
      // recentlyWatched et al.: empty.
      return _json({'__typename': 'Query'});
    });

/// Minimal router: the discover view at '/', a stub in place of the real
/// MediaListPage that records the args it was pushed with.
class _NavRouter extends RootStackRouter {
  MediaListRouteArgs? pushedArgs;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('DiscoverHostRoute',
              builder: (data) => const Scaffold(
                    body: LibraryDiscoverView(
                      serverName: _server,
                      libraryId: 'movie-lib-1',
                      libraryType: Enum$LibraryType.MOVIE,
                    ),
                  )),
        ),
        AutoRoute(
          path: '/list',
          page: PageInfo(MediaListRoute.name, builder: (data) {
            pushedArgs = data.argsAs<MediaListRouteArgs>();
            return const Scaffold(body: Text('media-list-stub'));
          }),
        ),
      ];
}

Widget _wrap(Widget child, http.Client client) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
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

Future<void> _pump(WidgetTester tester) async {
  // Avoid pumpAndSettle: token/queue services run self-refreshing timers.
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  // Set the platform instance once and clear it per test: ShowHomePage holds
  // a static SharedPreferencesAsync, which binds the platform instance at
  // first construction — swapping in a fresh instance per test would leave the
  // page writing to the old one.
  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await SharedPreferencesAsync().clear();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  group('LibraryDiscoverView', () {
    testWidgets('renders the ranked rows and hides empty ones',
        (tester) async {
      final client = _fakeGraphQL(
        discover: _discoverMovies(
          recentlyPlayed: [_movie('played-1', 'Played Movie')],
          highestRated: [_movie('rated-1', 'Rated Movie')],
        ),
      );
      await tester.pumpWidget(_wrap(
        const LibraryDiscoverView(
          serverName: _server,
          libraryId: 'movie-lib-1',
          libraryType: Enum$LibraryType.MOVIE,
        ),
        client,
      ));
      await _pump(tester);

      expect(find.text('Recently added:'), findsOneWidget);
      expect(find.text('Newly Added Movie'), findsOneWidget);
      expect(find.text('Last played:'), findsOneWidget);
      expect(find.text('Played Movie'), findsOneWidget);
      expect(find.text('Highest rated:'), findsOneWidget);
      expect(find.text('Rated Movie'), findsOneWidget);
      // No plays counted yet: the most-played row hides itself.
      expect(find.text('Most played:'), findsNothing);
      // The continue-watching row is empty and hides itself too.
      expect(find.text('Continue watching:'), findsNothing);
    });

    testWidgets('a ranked header opens the media list with its kind',
        (tester) async {
      final client = _fakeGraphQL(
        discover: _discoverMovies(
          recentlyPlayed: [_movie('played-1', 'Played Movie')],
        ),
      );
      final router = _NavRouter();
      await tester.pumpWidget(GraphQLProvider(
        client: ValueNotifier(GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        )),
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
      ));
      await _pump(tester);

      await tester.tap(find.text('Last played:'));
      await _pump(tester);

      expect(find.text('media-list-stub'), findsOneWidget);
      expect(router.pushedArgs?.kindName,
          MediaListKind.recentlyPlayed.urlValue);
      expect(router.pushedArgs?.libraryId, 'movie-lib-1');
      expect(router.pushedArgs?.libraryTypeName, 'MOVIE');
    });

    testWidgets('degrades to the recently-added row on an old server',
        (tester) async {
      final client = _fakeGraphQL(discoverErrors: true);
      await tester.pumpWidget(_wrap(
        const LibraryDiscoverView(
          serverName: _server,
          libraryId: 'movie-lib-1',
          libraryType: Enum$LibraryType.MOVIE,
        ),
        client,
      ));
      await _pump(tester);

      expect(find.text('Recently added:'), findsOneWidget);
      expect(find.text('Newly Added Movie'), findsOneWidget);
      expect(find.text('Last played:'), findsNothing);
      expect(find.textContaining('Validation error'), findsNothing);
    });
  });

  group('ShowHomePage view switch', () {
    testWidgets(
        'opens in Discover, switches to Browse with the sort control and persists',
        (tester) async {
      final client = _fakeGraphQL(
        discover: _discoverMovies(
          recentlyPlayed: [_movie('played-1', 'Played Movie')],
        ),
      );
      // PermissionsService resolves its client through ClientManager.
      ClientManager.testClientBuilder = (_) => GraphQLClient(
            link: HttpLink('https://api.example/graphql', httpClient: client),
            cache: GraphQLCache(),
          );
      await tester.pumpWidget(
          _wrap(const ShowHomePage(serverName: _server), client));
      await _pump(tester);

      // Discover is the default: ranked rows visible, no sort control.
      expect(find.byType(LibraryDiscoverView), findsOneWidget);
      expect(find.text('Played Movie'), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsNothing);

      await tester.tap(find.text('Browse'));
      await _pump(tester);

      // Browse: the grid plus the sort control under the switch.
      expect(find.byType(LibraryDiscoverView), findsNothing);
      expect(find.byType(MovieScroll), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(await SharedPreferencesAsync().getString('library_view_$_server'),
          'browse');

      await tester.tap(find.text('Discover'));
      await _pump(tester);

      expect(find.byType(LibraryDiscoverView), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsNothing);
      expect(await SharedPreferencesAsync().getString('library_view_$_server'),
          'discover');
    });

    testWidgets(
        'the app-bar title is the library switcher: name, type icons and check',
        (tester) async {
      final client = _fakeGraphQL(
        discover: _discoverMovies(
          recentlyPlayed: [_movie('played-1', 'Played Movie')],
        ),
        withMusicLibrary: true,
      );
      ClientManager.testClientBuilder = (_) => GraphQLClient(
            link: HttpLink('https://api.example/graphql', httpClient: client),
            cache: GraphQLCache(),
          );
      await tester.pumpWidget(
          _wrap(const ShowHomePage(serverName: _server), client));
      await _pump(tester);

      // The title is the selected library's name with a dropdown arrow; the
      // static "Library" title is gone once the list has loaded.
      final appBar = find.byType(AppBar);
      expect(find.descendant(of: appBar, matching: find.text('movies')),
          findsOneWidget);
      expect(
          find.descendant(
              of: appBar, matching: find.byIcon(Icons.arrow_drop_down)),
          findsOneWidget);
      expect(find.descendant(of: appBar, matching: find.text('Library')),
          findsNothing);

      // The menu lists every library with its type icon, checking the active one.
      await tester.tap(find.descendant(
          of: appBar, matching: find.byIcon(Icons.arrow_drop_down)));
      await _pump(tester);
      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.byIcon(Icons.library_music), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('music'), findsOneWidget);
      // Wide enough that short library names don't wrap mid-word.
      expect(tester.getSize(find.byType(MenuItemButton).first).width,
          greaterThanOrEqualTo(220));

      // Switching selects the other library: it becomes the title and is
      // persisted per server.
      await tester.tap(find.text('music'));
      await _pump(tester);
      expect(find.descendant(of: appBar, matching: find.text('music')),
          findsOneWidget);
      expect(find.descendant(of: appBar, matching: find.text('movies')),
          findsNothing);
      expect(
          await SharedPreferencesAsync()
              .getString('selected_library_id_$_server'),
          'music-lib-1');
    });
  });
}
