import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/ServerActivityBody.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 8, 16, 12, 0, 0);

Widget _app(Widget body) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: body),
    );

Fragment$fragmentServerActivityEvent _node(
  String name, {
  List<Fragment$fragmentServerActivityEvent$processing>? processing,
  DateTime? timestamp,
}) =>
    Fragment$fragmentServerActivityEvent(
      type: Enum$ServerActivityEventType.NODE_ACTIVITY,
      nodeName: name,
      timestamp: (timestamp ?? _now).toIso8601String(),
      processing: processing ?? [],
      processedCount: 12,
      failedCount: 1,
    );

Fragment$fragmentQueueStat _queue(String queue, int depth) =>
    Fragment$fragmentQueueStat(queue: queue, depth: depth, consumers: 3);

void main() {
  testWidgets('shows the idle hero when nothing runs and queues are empty',
      (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [_node('node-a')],
      queueStats: [_queue('app.ister.server.MediaFileFound.disk1', 0)],
      failures: const [],
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('The server is idle'), findsOneWidget);
    expect(find.text('Working on now'), findsNothing);
  });

  testWidgets('renders subject and step label for in-flight work',
      (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [
        _node('node-a', processing: [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.MediaFileFound.disk1',
            eventType: 'MediaFileFoundData',
            startedAt:
                _now.subtract(const Duration(minutes: 2)).toIso8601String(),
            subject: 'iCarly.s02e07.mkv',
            step: 'crop',
          ),
        ]),
      ],
      queueStats: [_queue('app.ister.server.MediaFileFound.disk1', 812)],
      failures: const [],
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Working on now'), findsOneWidget);
    expect(find.text('iCarly.s02e07.mkv'), findsOneWidget);
    expect(find.text('Detecting black bars'), findsOneWidget);
    expect(find.text('2m 00s'), findsOneWidget);
    // Aggregated queue line instead of the raw queue name.
    expect(find.text('812 files to analyze'), findsOneWidget);
    // Raw queue detail stays behind the collapsed expansion tile.
    expect(find.text('app.ister.server.MediaFileFound.disk1'), findsNothing);
    await tester.tap(find.text('Queue details'));
    await tester.pumpAndSettle();
    expect(find.text('app.ister.server.MediaFileFound.disk1'), findsOneWidget);
  });

  testWidgets('falls back to the kind label when no subject is reported',
      (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [
        _node('node-a', processing: [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.SearchIndexRequested',
            eventType: 'SearchIndexRequestedData',
            startedAt: _now.toIso8601String(),
          ),
        ]),
      ],
      queueStats: const [],
      failures: const [],
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Updating search index'), findsOneWidget);
  });

  testWidgets('shows transcode passes with quality and background tag',
      (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [_node('node-a')],
      queueStats: const [],
      failures: const [],
      transcodes: [
        Fragment$fragmentTranscodePass(
          nodeName: 'node-a',
          mediaFileId: 'id-1',
          title: 'Big Movie (2020).mkv',
          quality: 'video_720p',
          background: true,
          startedAt:
              _now.subtract(const Duration(seconds: 42)).toIso8601String(),
        ),
      ],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Big Movie (2020).mkv'), findsOneWidget);
    expect(find.textContaining('video 720p'), findsOneWidget);
    expect(find.textContaining('background'), findsOneWidget);
    expect(find.text('42s'), findsOneWidget);
  });

  testWidgets('marks a silent node as stale with last-seen text',
      (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [
        _node('node-dead',
            timestamp: _now.subtract(const Duration(minutes: 10))),
      ],
      queueStats: const [],
      failures: const [],
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Last seen 10 min ago'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off), findsOneWidget);
  });

  testWidgets('failure rows use kind label and relative time', (tester) async {
    await tester.pumpWidget(_app(ServerActivityBody(
      nodes: [_node('node-a')],
      queueStats: const [],
      failures: [
        Fragment$fragmentEventFailure(
          nodeName: 'node-a',
          queue: 'app.ister.server.MovieFound',
          eventType: 'MovieFoundData',
          errorMessage: 'boom',
          occurredAt:
              _now.subtract(const Duration(hours: 2)).toIso8601String(),
        ),
      ],
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Fetching metadata'), findsOneWidget);
    expect(find.textContaining('2 hr ago'), findsOneWidget);
    expect(find.textContaining('boom'), findsOneWidget);
  });
}
