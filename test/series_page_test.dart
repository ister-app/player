import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/SeriesPage.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Map<String, dynamic> _series({
  String readingDirection = 'LTR',
  String? userReadingDirection,
}) =>
    {
      '__typename': 'Series',
      'id': 'series-1',
      'name': 'Naruto',
      'startYear': 1999,
      'readingDirection': readingDirection,
      'userReadingDirection': userReadingDirection,
      'cover': null,
      'images': [],
      'metadata': [
        {
          '__typename': 'Metadata',
          'id': 'meta-1',
          'description': 'A young ninja seeks recognition.',
          'language': 'eng',
          'sourceUri': null,
          'title': null,
          'released': null,
          'genre': null,
        }
      ],
      'books': [
        {
          '__typename': 'Book',
          'id': 'book-1',
          'name': 'Volume 1',
          'title': 'Volume 1',
          'releaseYear': 0,
          'seriesIndex': 1.0,
          'author': null,
          'series': {'__typename': 'Series', 'id': 'series-1', 'name': 'Naruto'},
          'images': [],
          'metadata': [],
          'rating': null,
          'epubFiles': [],
          'watchStatus': [
            {
              '__typename': 'WatchStatus',
              'id': 'ws-1',
              'watched': false,
              'readingLocation': 'ister-comic:v1;page=3;pct=0.4',
              'readingProgress': 0.4,
            }
          ],
        },
        {
          '__typename': 'Book',
          'id': 'book-2',
          'name': 'Volume 2',
          'title': 'Volume 2',
          'releaseYear': 0,
          'seriesIndex': 2.0,
          'author': null,
          'series': {'__typename': 'Series', 'id': 'series-1', 'name': 'Naruto'},
          'images': [],
          'metadata': [],
          'rating': null,
          'epubFiles': [],
          'watchStatus': [],
        },
      ],
    };

MockClient _fakeGraphQL({
  String readingDirection = 'LTR',
  String? userReadingDirection,
  List<Map<String, dynamic>>? mutations,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      if ((body['query'] as String).contains('setSeriesReadingDirection')) {
        mutations?.add(body['variables'] as Map<String, dynamic>);
        return http.Response(
          json.encode({
            'data': {'__typename': 'Mutation', 'setSeriesReadingDirection': true}
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response(
        json.encode({
          'data': {
            '__typename': 'Query',
            'seriesById': _series(
              readingDirection: readingDirection,
              userReadingDirection: userReadingDirection,
            )
          }
        }),
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
        home: SeriesPage(serverName: 'test-server', seriesId: 'series-1'),
      ),
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('renders the series with description and its volumes in order',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    expect(find.text('Naruto (1999)'), findsOneWidget);
    expect(find.text('A young ninja seeks recognition.'), findsOneWidget);
    expect(find.text('Volumes'), findsOneWidget);
    expect(find.text('Volume 1'), findsOneWidget);
    expect(find.text('Volume 2'), findsOneWidget);
    expect(find.text('#1'), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);

    // Volume 1 carries a reading-progress bar; volume 2 has none.
    expect(
      find.descendant(
        of: find.byType(GridView),
        matching: find.byType(LinearProgressIndicator),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the default segment names the detected direction of a manga',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(readingDirection: 'RTL')));
    await tester.pumpAndSettle();

    expect(find.text('Reading direction'), findsOneWidget);
    expect(find.text('Default (RTL)'), findsOneWidget);
    // No override: the default segment is the selected one.
    final segmented = tester.widget<SegmentedButton<Enum$ReadingDirection?>>(
        find.byType(SegmentedButton<Enum$ReadingDirection?>));
    expect(segmented.selected, {null});
  });

  testWidgets('picking a direction sends the mutation', (tester) async {
    final mutations = <Map<String, dynamic>>[];
    await tester.pumpWidget(_app(_fakeGraphQL(mutations: mutations)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Right-to-left'));
    await tester.pumpAndSettle();

    expect(mutations, hasLength(1));
    expect(mutations.single['seriesId'], 'series-1');
    expect(mutations.single['direction'], 'RTL');
  });

  testWidgets('picking the default clears the override with a null direction',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    await tester.pumpWidget(_app(_fakeGraphQL(
      readingDirection: 'RTL',
      userReadingDirection: 'RTL',
      mutations: mutations,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Default'));
    await tester.pumpAndSettle();

    expect(mutations, hasLength(1));
    expect(mutations.single['seriesId'], 'series-1');
    expect(mutations.single['direction'], isNull);
  });
}
