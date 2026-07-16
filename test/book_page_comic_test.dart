import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/BookPage.dart';

/// A comic volume: no author, no chapters, one cbz file.
Map<String, dynamic> _comicVolume() => {
      '__typename': 'Book',
      'id': 'book-1',
      'name': 'Volume 1',
      'title': 'Volume 1',
      'releaseYear': 0,
      'seriesIndex': 1.0,
      'author': null,
      'series': {'__typename': 'Series', 'id': 'series-1', 'name': 'Falcon'},
      'images': [],
      'metadata': [],
      'rating': null,
      'chapters': [],
      'resumeChapter': null,
      'epubFiles': [
        {
          '__typename': 'MediaFile',
          'id': 'file-1',
          'path': '/comics/Falcon (1998)/Volume 1.cbz',
          'format': 'CBZ',
          'pageCount': 5,
          'mediaOverlays': null,
          'directory': {
            '__typename': 'Directory',
            'node': {'__typename': 'Node', 'url': 'https://node.example'}
          },
        }
      ],
      'watchStatus': [],
    };

MockClient _fakeGraphQL() => MockClient((request) async => http.Response(
      json.encode({
        'data': {'__typename': 'Query', 'bookById': _comicVolume()}
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
        home: BookPage(serverName: 'test-server', bookId: 'book-1'),
      ),
    );

void main() {
  testWidgets('a cbz-only comic volume gets a read button', (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL()));
    await tester.pumpAndSettle();

    expect(find.text('Volume 1'), findsWidgets);
    // No author: the subtitle falls back to the series name.
    expect(find.text('Falcon'), findsOneWidget);
    expect(find.text('Start reading'), findsOneWidget);
  });
}
