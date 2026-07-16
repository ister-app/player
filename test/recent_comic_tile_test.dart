import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/RecentCarouselView.dart';
import 'package:player/l10n/app_localizations.dart';

Map<String, dynamic> _comicEntry() => {
      '__typename': 'RecentlyWatched',
      'type': 'COMIC',
      'episode': null,
      'movie': null,
      'chapter': null,
      'podcastEpisode': null,
      'book': {
        '__typename': 'Book',
        'id': 'book-2',
        'name': 'Naruto - Volume 2',
        'title': 'Volume 2',
        'series': {'__typename': 'Series', 'id': 'series-1', 'name': 'Naruto'},
        'images': [],
        'metadata': [],
        'watchStatus': [
          {
            '__typename': 'WatchStatus',
            'id': 'ws-2',
            'watched': false,
            'readingLocation': 'ister-comic:v1;page=4;pct=0.25',
            'readingProgress': 0.25,
          }
        ],
        'epubFiles': [
          {
            '__typename': 'MediaFile',
            'id': 'file-2',
            'path': '/comics/Naruto (1999)/Volume 2.cbz',
            'format': 'CBZ',
            'mediaOverlays': null,
            'directory': {
              '__typename': 'Directory',
              'node': {'__typename': 'Node', 'url': 'https://node.example'}
            },
          }
        ],
      },
    };

MockClient _fakeGraphQL() => MockClient((request) async => http.Response(
      json.encode({
        'data': {
          '__typename': 'Query',
          'recentlyWatched': [_comicEntry()],
        }
      }),
      200,
      headers: {'content-type': 'application/json'},
    ));

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
        home: Scaffold(
          body: SizedBox(
            height: 260,
            child: RecentCarouselView(serverName: 'test-server'),
          ),
        ),
      ),
    );

void main() {
  testWidgets(
      'a COMIC continue-watching entry renders as a series tile with progress',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    // Series name over the volume title.
    expect(find.text('Naruto'), findsOneWidget);
    expect(find.text('Volume 2'), findsOneWidget);

    final progressBar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator));
    expect(progressBar.value, closeTo(0.25, 1e-6));
  });
}
