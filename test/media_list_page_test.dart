import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/MovieScroll.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/MediaListPage.dart';
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

Map<String, dynamic> _rankedMoviesPage(
        int page, List<Map<String, dynamic>> movies, int total) =>
    {
      '__typename': 'Query',
      'libraryById': {
        '__typename': 'Library',
        'id': 'movie-lib-1',
        'rankedMovies': {
          '__typename': 'MoviePage',
          'content': movies,
          'totalPages': (total / 15).ceil(),
          'totalElements': total,
          'number': page,
          'size': 15,
        },
      },
    };

http.Response _json(Map<String, dynamic> data) => http.Response(
      json.encode({'data': data}),
      200,
      headers: {'content-type': 'application/json'},
    );

/// Routes on the query text; records the ranked variables it saw.
MockClient _fakeGraphQL(List<Map<String, dynamic>> rankedVariables) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final vars = (body['variables'] as Map<String, dynamic>?) ?? {};
      if (query.contains('rankedMovies')) {
        rankedVariables.add(vars);
        final page = (vars['page'] as int?) ?? 0;
        final movies = List.generate(
            page == 0 ? 15 : 2, (i) => _movie('m$page-$i', 'Movie ${page * 15 + i}'));
        return _json(_rankedMoviesPage(page, movies, 17));
      }
      if (query.contains('movies(')) {
        return _json({
          '__typename': 'Query',
          'movies': {
            '__typename': 'MoviePage',
            'content': [_movie('new-1', 'Newly Added Movie')],
            'totalPages': 1,
            'totalElements': 1,
            'number': 0,
            'size': 15,
          },
        });
      }
      if (query.contains('rankedBooks')) {
        rankedVariables.add(vars);
        return _json({
          '__typename': 'Query',
          'libraryById': {
            '__typename': 'Library',
            'id': 'book-lib-1',
            'rankedBooks': {
              '__typename': 'BookPage',
              'content': <dynamic>[],
              'totalPages': 0,
              'totalElements': 0,
              'number': 0,
              'size': 15,
            },
          },
        });
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
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('ranked list titles, renders the grid and pages on scroll',
      (tester) async {
    final seenVars = <Map<String, dynamic>>[];
    await tester.pumpWidget(_wrap(
      const MediaListPage(
        serverName: _server,
        kind: MediaListKind.recentlyPlayed,
        libraryId: 'movie-lib-1',
        libraryType: Enum$LibraryType.MOVIE,
      ),
      _fakeGraphQL(seenVars),
    ));
    await _pump(tester);

    expect(find.text('Last played'), findsOneWidget);
    expect(find.text('Movie 0'), findsOneWidget);
    expect(seenVars.first['kind'], 'RECENTLY_PLAYED');
    expect(seenVars.first['libraryId'], 'movie-lib-1');

    // Scroll the page-1 skeletons into view: their visibility triggers the
    // second fetch.
    await tester.drag(find.byType(GridView), const Offset(0, -4000));
    await _pump(tester);
    await tester.drag(find.byType(GridView), const Offset(0, -4000));
    await _pump(tester);

    expect(seenVars.any((v) => v['page'] == 1), isTrue);
    expect(find.text('Movie 15'), findsOneWidget);
  });

  testWidgets('recently added reuses the Browse grid sorted by date added',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const MediaListPage(
        serverName: _server,
        kind: MediaListKind.recentlyAdded,
        libraryId: 'movie-lib-1',
        libraryType: Enum$LibraryType.MOVIE,
      ),
      _fakeGraphQL([]),
    ));
    await _pump(tester);

    expect(find.text('Recently added'), findsOneWidget);
    final scroll = tester.widget<MovieScroll>(find.byType(MovieScroll));
    expect(scroll.sorting, Enum$SortingEnum.DATE_CREATED);
    expect(scroll.sortingOrder, Enum$SortingOrder.DESCENDING);
    expect(find.text('Newly Added Movie'), findsOneWidget);
  });

  testWidgets('a book library titles last-played as recently read',
      (tester) async {
    final seenVars = <Map<String, dynamic>>[];
    await tester.pumpWidget(_wrap(
      const MediaListPage(
        serverName: _server,
        kind: MediaListKind.recentlyPlayed,
        libraryId: 'book-lib-1',
        libraryType: Enum$LibraryType.BOOK,
      ),
      _fakeGraphQL(seenVars),
    ));
    await _pump(tester);

    expect(find.text('Recently read'), findsOneWidget);
    expect(seenVars.first['kind'], 'RECENTLY_PLAYED');
  });
}
