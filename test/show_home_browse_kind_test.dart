import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/AlbumScroll.dart';
import 'package:player/components/ArtistScroll.dart';
import 'package:player/components/EpisodeScroll.dart';
import 'package:player/components/TrackScroll.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ShowHomePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _server = 'test-server';

Map<String, dynamic> _metadata(String id, String title) => {
      '__typename': 'Metadata',
      'id': id,
      'description': null,
      'language': 'eng',
      'sourceUri': null,
      'source': null,
      'title': title,
      'released': null,
      'genre': null,
      'tagline': null,
    };

Map<String, dynamic> _album(String id, String name) => {
      '__typename': 'Album',
      'id': id,
      'name': name,
      'releaseYear': 2020,
      'artist': {'__typename': 'Person', 'id': 'artist-1', 'name': 'The Band'},
      'images': <dynamic>[],
      'metadata': <dynamic>[],
      'rating': null,
    };

Map<String, dynamic> _track(String id, String title) => {
      '__typename': 'Track',
      'id': id,
      'number': 1,
      'discNumber': 1,
      'artist': {'__typename': 'Person', 'id': 'artist-1', 'name': 'The Band'},
      'metadata': [_metadata('meta-$id', title)],
      'mediaFile': [
        {'__typename': 'MediaFile', 'durationInMilliseconds': 180000}
      ],
      'rating': null,
      'album': _album('album-1', 'First Album'),
    };

Map<String, dynamic> _episode(String id, String title) => {
      '__typename': 'Episode',
      'id': id,
      'number': 2,
      'show': {
        '__typename': 'Show',
        'id': 'show-1',
        'name': 'The Show',
        'images': <dynamic>[],
      },
      'season': {'__typename': 'Season', 'id': 'season-1', 'number': 1},
      'metadata': [_metadata('meta-$id', title)],
      'images': <dynamic>[],
      'watchStatus': <dynamic>[],
      'mediaFile': [
        {'__typename': 'MediaFile', 'durationInMilliseconds': 1200000}
      ],
    };

Map<String, dynamic> _page(String rootField, String pageTypename,
        List<Map<String, dynamic>> content) =>
    {
      '__typename': 'Query',
      rootField: {
        '__typename': pageTypename,
        'content': content,
        'totalPages': 1,
        'totalElements': content.length,
        'number': 0,
        'size': 15,
      },
    };

Map<String, dynamic> _libraries() => {
      '__typename': 'Query',
      'libraries': [
        {
          '__typename': 'Library',
          'id': 'music-lib-1',
          'name': 'music',
          'type': 'MUSIC',
          'sorting': 'NAME',
          'sortingOrder': 'ASCENDING',
        },
        {
          '__typename': 'Library',
          'id': 'show-lib-1',
          'name': 'shows',
          'type': 'SHOW',
          'sorting': 'NAME',
          'sortingOrder': 'ASCENDING',
        },
        {
          '__typename': 'Library',
          'id': 'movie-lib-1',
          'name': 'movies',
          'type': 'MOVIE',
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

/// Routes on the query text; counts requests per root field so the tests can
/// assert what a UI action did (and did not) re-query. Recorded
/// setLibrarySorting variables land in [sortMutations] when given.
MockClient _fakeGraphQL(Map<String, int> queryCounts,
        {List<Map<String, dynamic>>? sortMutations}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      void count(String kind) =>
          queryCounts[kind] = (queryCounts[kind] ?? 0) + 1;
      if (query.contains('setLibrarySorting(')) {
        sortMutations?.add(body['variables'] as Map<String, dynamic>);
        return _json({'__typename': 'Mutation', 'setLibrarySorting': true});
      }
      if (query.contains('tracks(')) {
        count('tracks');
        return _json(_page('tracks', 'TrackPage',
            [_track('track-1', 'Opening Song'), _track('track-2', 'Closer')]));
      }
      if (query.contains('persons(')) {
        count('artists');
        return _json(_page('artists', 'PersonPage', [
          {
            '__typename': 'Person',
            'id': 'artist-1',
            'name': 'The Band',
            'images': <dynamic>[],
          }
        ]));
      }
      if (query.contains('episodes(')) {
        count('episodes');
        return _json(_page(
            'episodes', 'EpisodePage', [_episode('ep-1', 'Pilot Part 2')]));
      }
      if (query.contains('albums(')) {
        count('albums');
        return _json(_page(
            'albums', 'AlbumPage', [_album('album-1', 'First Album')]));
      }
      if (query.contains('shows(')) {
        count('shows');
        return _json(_page('shows', 'ShowPage', <Map<String, dynamic>>[]));
      }
      if (query.contains('movies(')) {
        count('movies');
        return _json(_page('movies', 'MoviePage', <Map<String, dynamic>>[]));
      }
      if (query.contains('libraries {')) {
        return _json(_libraries());
      }
      return _json({'__typename': 'Query'});
    });

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

Future<void> _mountBrowse(WidgetTester tester, http.Client client,
    {required String libraryId}) async {
  await SharedPreferencesAsync()
      .setString('selected_library_id_$_server', libraryId);
  await SharedPreferencesAsync().setString('library_view_$_server', 'browse');
  ClientManager.testClientBuilder = (_) => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      );
  await tester.pumpWidget(_wrap(const ShowHomePage(serverName: _server), client));
  await _pump(tester);
}

void main() {
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

  group('ShowHomePage browse kinds', () {
    testWidgets(
        'a music library offers Albums/Artists/Tracks and switching kinds '
        'queries and remembers the choice', (tester) async {
      final counts = <String, int>{};
      final client = _fakeGraphQL(counts);
      await _mountBrowse(tester, client, libraryId: 'music-lib-1');

      // Default kind: albums, with all three pills present.
      expect(find.byType(AlbumScroll), findsOneWidget);
      expect(find.text('Albums'), findsOneWidget);
      expect(find.text('Artists'), findsOneWidget);
      expect(find.text('Tracks'), findsOneWidget);

      await tester.tap(find.text('Tracks'));
      await _pump(tester);

      // The tracks kind queried the new library-wide tracks query and renders
      // rows with the artist • album context.
      expect(find.byType(TrackScroll), findsOneWidget);
      expect(counts['tracks'], 1);
      expect(find.text('Opening Song'), findsOneWidget);

      // In the list layout the rows carry the artist • album context.
      await tester.tap(find.byIcon(Icons.view_list));
      await _pump(tester);
      expect(find.text('The Band • First Album'), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.grid_view));
      await _pump(tester);

      expect(
          await SharedPreferencesAsync()
              .getString('library_browse_kind_${_server}_music-lib-1'),
          'tracks');

      await tester.tap(find.text('Artists'));
      await _pump(tester);
      expect(find.byType(ArtistScroll), findsOneWidget);
      expect(counts['artists'], 1);
      expect(find.text('The Band'), findsOneWidget);
    });

    testWidgets('a show library can switch to the episode feed',
        (tester) async {
      final counts = <String, int>{};
      final client = _fakeGraphQL(counts);
      await _mountBrowse(tester, client, libraryId: 'show-lib-1');

      expect(find.text('Shows'), findsOneWidget);
      await tester.tap(find.text('Episodes'));
      await _pump(tester);

      expect(find.byType(EpisodeScroll), findsOneWidget);
      expect(counts['episodes'], 1);
      expect(find.text('Pilot Part 2'), findsOneWidget);
      expect(find.text('The Show • S1E2'), findsOneWidget);
      // The episode feed defaults to newest-added first: the trigger shows the
      // field label plus a descending arrow.
      expect(find.text('Date added'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('a movie library shows no kind pills', (tester) async {
      final counts = <String, int>{};
      final client = _fakeGraphQL(counts);
      await _mountBrowse(tester, client, libraryId: 'movie-lib-1');

      expect(find.text('Albums'), findsNothing);
      expect(find.text('Tracks'), findsNothing);
      expect(find.text('Episodes'), findsNothing);
      // The sort control and layout toggle are still there.
      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(find.byIcon(Icons.view_list), findsOneWidget);
    });

    testWidgets(
        'the sort menu lists each field once; a click selects it with its '
        'default order and a second click reverses it', (tester) async {
      final counts = <String, int>{};
      final sortMutations = <Map<String, dynamic>>[];
      final client = _fakeGraphQL(counts, sortMutations: sortMutations);
      await _mountBrowse(tester, client, libraryId: 'music-lib-1');

      // Default sort: name ascending — field label + up arrow on the trigger.
      expect(find.text('Name'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      // One entry per field, no direction variants.
      await tester.tap(find.byIcon(Icons.sort));
      await _pump(tester);
      expect(find.text('Name'), findsNWidgets(2)); // trigger + menu item
      expect(find.text('Date added'), findsOneWidget);
      expect(find.text('Release year'), findsOneWidget);
      expect(find.textContaining('newest first'), findsNothing);
      // The selected menu item carries the direction arrow too.
      expect(find.byIcon(Icons.arrow_upward), findsNWidgets(2));

      // Picking another field sorts by it in that field's default direction.
      await tester.tap(find.text('Date added'));
      await _pump(tester);
      expect(sortMutations.single['sorting'], 'DATE_CREATED');
      expect(sortMutations.single['sortingOrder'], 'DESCENDING');
      expect(find.text('Date added'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);

      // Picking the same field again flips the direction.
      await tester.tap(find.byIcon(Icons.sort));
      await _pump(tester);
      await tester.tap(find.text('Date added').last);
      await _pump(tester);
      expect(sortMutations, hasLength(2));
      expect(sortMutations.last['sorting'], 'DATE_CREATED');
      expect(sortMutations.last['sortingOrder'], 'ASCENDING');
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      // A non-default kind toggles through the device-local preference
      // instead of the server mutation: tracks default to name ascending, so
      // one click on the active field flips it to descending.
      await tester.tap(find.text('Tracks'));
      await _pump(tester);
      await tester.tap(find.byIcon(Icons.sort));
      await _pump(tester);
      await tester.tap(find.text('Name').last);
      await _pump(tester);
      expect(sortMutations, hasLength(2));
      expect(
          await SharedPreferencesAsync().getString(
              'library_kind_sorting_${_server}_music-lib-1_tracks'),
          'NAME:DESCENDING');
    });

    testWidgets(
        'the grid/list toggle keeps loaded pages (no re-query) and persists',
        (tester) async {
      final counts = <String, int>{};
      final client = _fakeGraphQL(counts);
      await _mountBrowse(tester, client, libraryId: 'music-lib-1');

      expect(find.byType(GridView), findsOneWidget);
      final albumQueries = counts['albums'] ?? 0;

      await tester.tap(find.byIcon(Icons.view_list));
      await _pump(tester);

      // Same widget, list layout: the already-loaded pages are kept and no
      // fresh page-0 query is issued by the toggle.
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('First Album'), findsOneWidget);
      expect(counts['albums'] ?? 0, albumQueries);
      expect(
          await SharedPreferencesAsync()
              .getString('library_browse_layout_$_server'),
          'list');

      // And back to the grid.
      await tester.tap(find.byIcon(Icons.grid_view));
      await _pump(tester);
      expect(find.byType(GridView), findsOneWidget);
      expect(
          await SharedPreferencesAsync()
              .getString('library_browse_layout_$_server'),
          'grid');
    });
  });
}
