import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/ServerNodeBody.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

final _now = DateTime.utc(2026, 9, 6, 12, 0, 0);

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

Fragment$fragmentServerActivityEvent _event({
  Fragment$fragmentNodeInfo? nodeInfo,
  List<Fragment$fragmentServerActivityEvent$processing>? processing,
  DateTime? timestamp,
}) =>
    Fragment$fragmentServerActivityEvent(
      type: Enum$ServerActivityEventType.NODE_ACTIVITY,
      nodeName: 'node-a',
      timestamp: (timestamp ?? _now).toIso8601String(),
      processing: processing ?? [],
      processedCount: 12,
      failedCount: 1,
      nodeInfo: nodeInfo,
    );

Fragment$fragmentNodeInfo _facts({
  List<Fragment$fragmentNodeInfo$directories> directories = const [],
  List<Fragment$fragmentNodeInfo$helperDisks> helperDisks = const [],
  List<String> offloadJobs = const [],
}) =>
    Fragment$fragmentNodeInfo(
      hostname: 'nas.local',
      startedAt: _now.subtract(const Duration(days: 3, hours: 4)).toIso8601String(),
      javaVersion: '25',
      availableProcessors: 8,
      maxMemoryBytes: 4e9,
      directories: directories,
      helperDisks: helperDisks,
      offloadJobs: offloadJobs,
    );

void main() {
  // The body is a ListView; give the test surface room so every section is
  // laid out instead of only the first screenful.
  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1000, 4000);
    view.devicePixelRatio = 1.0;
  });
  tearDown(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('shows disks with free space, a cache disk and an unmounted disk',
      (tester) async {
    await tester.pumpWidget(_app(ServerNodeBody(
      nodeName: 'node-a',
      event: _event(nodeInfo: _facts(directories: [
        Fragment$fragmentNodeInfo$directories(
          name: 'disk1',
          path: '/media/disk1',
          type: 'LIBRARY',
          $library: 'Series',
          totalBytes: 4e12,
          freeBytes: 1e12,
          writable: true,
        ),
        Fragment$fragmentNodeInfo$directories(
          name: 'node-a-cache-directory',
          path: '/cache',
          type: 'CACHE',
          totalBytes: 100e9,
          freeBytes: 5e9,
          writable: false,
        ),
        Fragment$fragmentNodeInfo$directories(
          name: 'disk2',
          path: '/media/disk2',
          type: 'LIBRARY',
          $library: 'Movies',
        ),
      ])),
      info: Query$getServerInfoQuery$getServerInfo$nodes(
          id: 'n', name: 'node-a', url: 'https://node-a.example', version: '3.5.0'),
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('nas.local · https://node-a.example'), findsOneWidget);
    expect(find.text('Up for 3d 4h'), findsOneWidget);
    expect(find.text('8 CPUs'), findsOneWidget);
    expect(find.text('4.0 GB'), findsOneWidget);
    expect(find.text('Series · /media/disk1'), findsOneWidget);
    expect(find.text('1.0 TB free of 4.0 TB'), findsOneWidget);
    // a definite "no" is labelled; writable and unknown (disk2, an older node) are not
    expect(find.text('Cache · /cache · Read-only'), findsOneWidget);
    expect(find.text('5.0 GB free of 100 GB'), findsOneWidget);
    expect(find.text('Not mounted'), findsOneWidget);
    // The nearly-full cache disk is drawn in the error colour.
    final bars = tester
        .widgetList<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
        .toList();
    expect(bars, hasLength(2));
    expect(bars[0].value, closeTo(0.75, 0.001));
    expect(bars[1].value, closeTo(0.95, 0.001));
    expect(find.text('Nothing is running on this node.'), findsOneWidget);
  });

  testWidgets('an older node without facts says so and lists no disks',
      (tester) async {
    await tester.pumpWidget(_app(ServerNodeBody(
      nodeName: 'node-a',
      event: _event(),
      info: null,
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(
        find.text(
            'This node runs an older server version and does not report its details yet.'),
        findsOneWidget);
    expect(find.text('This node reports no disks.'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
  });

  testWidgets('a silent node is offline, an unknown node has no activity',
      (tester) async {
    await tester.pumpWidget(_app(ServerNodeBody(
      nodeName: 'node-a',
      event: _event(timestamp: _now.subtract(const Duration(minutes: 10))),
      info: null,
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));
    expect(find.text('Not heard from'), findsOneWidget);
    expect(find.text('Last seen 10 min ago'), findsOneWidget);

    await tester.pumpWidget(_app(ServerNodeBody(
      nodeName: 'node-z',
      event: null,
      info: null,
      transcodes: const [],
      liveFeedBroken: false,
      now: _now,
    )));
    expect(find.text('No activity received from this node yet.'), findsOneWidget);
  });

  testWidgets('shows helper set-up and the grouped work of this node',
      (tester) async {
    await tester.pumpWidget(_app(ServerNodeBody(
      nodeName: 'node-a',
      event: _event(
        nodeInfo: _facts(helperDisks: [
          Fragment$fragmentNodeInfo$helperDisks(
              name: 'disk9', jobs: const ['SUBTITLE_EXTRACT', 'TRANSCODE']),
        ], offloadJobs: const ['TRANSCODE']),
        processing: [
          Fragment$fragmentServerActivityEvent$processing(
            queue: 'app.ister.server.SubtitleExtractRequested.disk9',
            eventType: 'x',
            startedAt: _now.toIso8601String(),
            subject: 'S06E22 · s06e22.mkv',
            step: 'subtitles',
            context: 'Seinfeld',
            contextType: 'show',
            contextId: 'show-1',
          ),
        ],
      ),
      info: null,
      transcodes: [
        Fragment$fragmentTranscodePass(
          nodeName: 'node-a',
          mediaFileId: 'f',
          title: 'movie.mkv',
          quality: 'video_1080p',
          background: false,
          startedAt: _now.toIso8601String(),
          context: 'Die Hard (1988)',
          contextType: 'movie',
          contextId: 'movie-1',
        ),
      ],
      liveFeedBroken: false,
      now: _now,
    )));

    expect(find.text('Helps other nodes with'), findsOneWidget);
    expect(find.text('disk9: subtitle extract, transcode'), findsOneWidget);
    expect(find.text('Hands off to helpers'), findsOneWidget);
    expect(find.text('Seinfeld'), findsOneWidget);
    // Single node: rows don't name it.
    expect(find.text('Extracting subtitles'), findsOneWidget);
    expect(find.text('Die Hard (1988)'), findsOneWidget);
    expect(find.text('Transcoding · video 1080p'), findsOneWidget);
  });
}
