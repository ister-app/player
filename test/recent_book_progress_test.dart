import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/RecentCarouselView.dart';
import 'package:player/l10n/app_localizations.dart';

/// The chapter that is playing: a third of the way into an hour-long chapter.
Map<String, dynamic> _chapter() => {
      '__typename': 'Chapter',
      'id': 'chapter-12',
      'number': 12,
      'book': {
        '__typename': 'Book',
        'id': 'book-1',
        'name': 'De wolven van Arazan',
        'title': 'De wolven van Arazan',
        'images': [],
        'metadata': [],
        'progress': null,
      },
      'metadata': [],
      'watchStatus': [
        {
          '__typename': 'WatchStatus',
          'id': 'ws-c12',
          'playQueueItemId': 'chapter-12',
          'progressInMilliseconds': 1200000,
          'watched': false,
        }
      ],
      'mediaFile': [
        {
          '__typename': 'MediaFile',
          'id': 'file-12',
          'durationInMilliseconds': 3600000,
        }
      ],
    };

Map<String, dynamic> _bookEntry({Map<String, dynamic>? progress}) => {
      '__typename': 'RecentlyWatched',
      'type': 'BOOK',
      'episode': null,
      'movie': null,
      'podcastEpisode': null,
      'chapter': _chapter(),
      'book': {
        '__typename': 'Book',
        'id': 'book-1',
        'name': 'De wolven van Arazan',
        'title': 'De wolven van Arazan',
        'series': null,
        'images': [],
        'metadata': [],
        'watchStatus': [],
        'progress': progress,
        'epubFiles': [],
      },
    };

Map<String, dynamic> _listening(double progress, {bool finished = false}) => {
      '__typename': 'BookProgress',
      'mode': 'LISTENING',
      'progress': progress,
      'finished': finished,
      'durationInMilliseconds': 43200000,
      'positionInMilliseconds': (43200000 * progress).round(),
    };

MockClient _fakeGraphQL(Map<String, dynamic> entry) =>
    MockClient((request) async => http.Response(
          json.encode({
            'data': {
              '__typename': 'Query',
              'recentlyWatched': [entry],
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

double? _barValue(WidgetTester tester) {
  final bars = find.byType(LinearProgressIndicator);
  if (bars.evaluate().isEmpty) return null;
  return tester.widget<LinearProgressIndicator>(bars).value;
}

void main() {
  testWidgets('an audiobook shows how far it is in the whole book',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(_bookEntry(
      progress: _listening(0.4),
    ))));
    await tester.pumpAndSettle();

    // Not the third of the current chapter, but 40% of the book.
    expect(_barValue(tester), closeTo(0.4, 1e-6));
    // The chapter still names what is playing.
    expect(find.text('Chapter 12'), findsOneWidget);
  });

  testWidgets('a finished book gets no progress bar', (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(_bookEntry(
      progress: _listening(1.0, finished: true),
    ))));
    await tester.pumpAndSettle();

    expect(_barValue(tester), isNull);
  });

  testWidgets('an epub position is shown as the book-wide fraction',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(_bookEntry(progress: {
      '__typename': 'BookProgress',
      'mode': 'READING',
      'progress': 0.62,
      'finished': false,
      'durationInMilliseconds': null,
      'positionInMilliseconds': null,
    }))));
    await tester.pumpAndSettle();

    expect(_barValue(tester), closeTo(0.62, 1e-6));
  });

  /// Servers without Book.progress keep the old chapter-relative bar.
  testWidgets('falls back to the chapter fraction on an older server',
      (tester) async {
    await tester.pumpWidget(_app(_fakeGraphQL(_bookEntry(progress: null))));
    await tester.pumpAndSettle();

    expect(_barValue(tester), closeTo(1200000 / 3600000, 1e-6));
  });
}
