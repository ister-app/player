import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:player/components/PlaybackHistorySheet.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ClientManager.dart';

const _server = 'test-server';

Map<String, dynamic> _entry(String id, String updatedAt,
        {bool watched = true, Map<String, dynamic>? chapter}) =>
    {
      '__typename': 'WatchStatus',
      'id': id,
      'watched': watched,
      'progressInMilliseconds': 1000,
      'createdAt': updatedAt,
      'updatedAt': updatedAt,
      'chapter': chapter,
    };

void main() {
  setUp(() {
    ClientManager.clients.clear();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  /// Serves the history from [entries]; markPlayed appends a fresh entry and
  /// deleteWatchStatus removes the matching one, so a reload sees the change.
  void useFakeGraphQL(List<Map<String, dynamic>> entries) {
    final client = MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final variables = body['variables'] as Map<String, dynamic>? ?? {};
      Map<String, dynamic> payload;
      if (query.contains('markPlayed')) {
        entries.insert(0, _entry('new-entry', '2026-08-24T09:30:00Z'));
        payload = {
          'data': {
            '__typename': 'Mutation',
            'markPlayed': {'__typename': 'WatchStatus', 'id': 'new-entry'},
          }
        };
      } else if (query.contains('deleteWatchStatus')) {
        entries.removeWhere((entry) => entry['id'] == variables['id']);
        payload = {
          'data': {'__typename': 'Mutation', 'deleteWatchStatus': true}
        };
      } else {
        payload = {
          'data': {
            '__typename': 'Query',
            'playbackHistory': List.of(entries),
          }
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  Future<void> pumpSheet(WidgetTester tester,
      {Enum$MediaType mediaType = Enum$MediaType.MOVIE,
      VoidCallback? onChanged}) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: PlaybackHistorySheetBody(
          serverName: _server,
          mediaType: mediaType,
          mediaId: 'media-1',
          onChanged: onChanged,
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  String formatted(String instant) => DateFormat.yMMMd('en')
      .add_Hm()
      .format(DateTime.parse(instant).toLocal());

  testWidgets('renders one row per play with its date and time',
      (tester) async {
    useFakeGraphQL([
      _entry('a', '2026-08-20T19:04:00Z'),
      _entry('b', '2026-07-01T08:30:00Z', watched: false),
    ]);

    await pumpSheet(tester);

    expect(find.text('Playback history'), findsOneWidget);
    expect(find.text(formatted('2026-08-20T19:04:00Z')), findsOneWidget);
    expect(find.text(formatted('2026-07-01T08:30:00Z')), findsOneWidget);
    expect(find.text('Not played yet'), findsNothing);
  });

  testWidgets('shows the empty state when the item was never played',
      (tester) async {
    useFakeGraphQL([]);

    await pumpSheet(tester);

    expect(find.text('Not played yet'), findsOneWidget);
  });

  testWidgets('mark as played now adds an entry and reloads', (tester) async {
    var changed = 0;
    useFakeGraphQL([]);

    await pumpSheet(tester, onChanged: () => changed++);
    await tester.tap(find.text('Mark as played just now'));
    await tester.pumpAndSettle();

    expect(changed, 1);
    expect(find.text('Not played yet'), findsNothing);
    expect(find.text(formatted('2026-08-24T09:30:00Z')), findsOneWidget);
  });

  testWidgets('deleting an entry removes it from the list', (tester) async {
    var changed = 0;
    useFakeGraphQL([
      _entry('a', '2026-08-20T19:04:00Z'),
      _entry('b', '2026-07-01T08:30:00Z'),
    ]);

    await pumpSheet(tester, onChanged: () => changed++);
    expect(find.byTooltip('Delete entry'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Delete entry').first);
    await tester.pumpAndSettle();

    expect(changed, 1);
    expect(find.text(formatted('2026-08-20T19:04:00Z')), findsNothing);
    expect(find.text(formatted('2026-07-01T08:30:00Z')), findsOneWidget);
  });

  testWidgets('a book entry carries the reading-progress hint and a chapter '
      'listen its chapter number', (tester) async {
    useFakeGraphQL([
      _entry('book-row', '2026-08-20T19:04:00Z'),
      _entry('chapter-row', '2026-08-19T19:04:00Z',
          chapter: {'__typename': 'Chapter', 'id': 'ch-3', 'number': 3}),
    ]);

    await pumpSheet(tester, mediaType: Enum$MediaType.BOOK);

    expect(find.text('Deleting removes your reading progress.'), findsOneWidget);
    expect(find.text('Chapter 3'), findsOneWidget);
  });
}
