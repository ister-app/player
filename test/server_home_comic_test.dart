import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/MovieSlide.dart';
import 'package:player/components/SeriesSlide.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerHomeContentPage.dart';
import 'package:visibility_detector/visibility_detector.dart';

// One COMIC library — the case that used to fall through to MovieSlide.
Map<String, dynamic> _libraries() => {
      '__typename': 'Query',
      'libraries': [
        {
          '__typename': 'Library',
          'id': 'comic-lib-1',
          'name': 'comics',
          'type': 'COMIC',
          'sorting': 'NAME',
          'sortingOrder': 'ASCENDING',
        }
      ],
    };

Map<String, dynamic> _seriesPage() => {
      '__typename': 'Query',
      'series': {
        '__typename': 'SeriesPage',
        'content': [
          {
            '__typename': 'Series',
            'id': 'series-1',
            'name': 'Rick and Morty',
            'startYear': 2015,
            'readingDirection': 'LTR',
            'userReadingDirection': null,
            'cover': null,
            'images': [],
            'metadata': [],
          }
        ],
        'totalPages': 1,
        'totalElements': 1,
        'number': 0,
        'size': 15,
      },
    };

// Routes each GraphQL request by operation name so the libraries, series and
// recently-watched queries on the page all get an answer.
MockClient _fakeGraphQL() => MockClient((request) async {
      // graphql_flutter doesn't send operationName, so route on the query text.
      final query = json.decode(request.body)['query'] as String? ?? '';
      final data = query.contains('series(')
          ? _seriesPage()
          : query.contains('libraries {')
              ? _libraries()
              : {'__typename': 'Query'}; // recentlyWatched et al.: empty
      return http.Response(
        json.encode({'data': data}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

Widget _app(http.Client client) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: client),
        cache: GraphQLCache(),
      )),
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: ServerHomeContentPage(serverName: 'test-server'),
      ),
    );

void main() {
  setUp(() =>
      VisibilityDetectorController.instance.updateInterval = Duration.zero);

  testWidgets('a COMIC library renders a SeriesSlide, not a MovieSlide',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    // Let the libraries + series http futures resolve and the post-frame
    // setState settle (avoid pumpAndSettle: the token/queue services run
    // self-refreshing timers that never quiesce).
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(find.byType(SeriesSlide), findsOneWidget);
    expect(find.byType(MovieSlide), findsNothing);
    expect(find.text('Rick and Morty'), findsOneWidget);
  });
}
