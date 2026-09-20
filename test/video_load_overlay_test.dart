import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/VideoCoverView.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/VideoLoadState.dart';

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: SizedBox(
          width: 600,
          height: 340,
          child: Stack(fit: StackFit.expand, children: [home]),
        ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Same seam as the other handler tests: no video output plugin here.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  tearDown(() {
    handler.videoStreamReady.value = false;
    handler.videoLoad.value = null;
  });

  group('VideoLoadState', () {
    final t0 = DateTime(2026, 9, 20, 12);

    test('an open inside a running start keeps the clock', () {
      final preparing =
          VideoLoadState(phase: VideoLoadPhase.preparing, startedAt: t0);
      final opened = VideoLoadState.opened(
          preparing, t0.add(const Duration(seconds: 3)),
          attempt: 0);
      expect(opened.phase, VideoLoadPhase.connecting);
      expect(opened.startedAt, t0);
    });

    test('a retry after a failure starts a new clock', () {
      final failed = VideoLoadState(phase: VideoLoadPhase.failed, startedAt: t0);
      final later = t0.add(const Duration(minutes: 2));
      final opened = VideoLoadState.opened(failed, later, attempt: 0);
      expect(opened.startedAt, later);
      expect(opened.failed, isFalse);
    });

    test('redacts the stream token from a player error', () {
      expect(
          VideoLoadState.redact(
              'Failed to open https://n.test/hls/1/master.m3u8?token=abc.def&x=1'),
          'Failed to open https://n.test/hls/1/master.m3u8?token=…&x=1');
    });

    test('turns slow after the threshold, never once failed', () {
      final load =
          VideoLoadState(phase: VideoLoadPhase.buffering, startedAt: t0);
      expect(load.isSlow(t0.add(const Duration(seconds: 7))), isFalse);
      expect(load.isSlow(t0.add(VideoLoadState.slowAfter)), isTrue);
      expect(
          load
              .copyWith(phase: VideoLoadPhase.failed)
              .isSlow(t0.add(const Duration(minutes: 1))),
          isFalse);
    });
  });

  testWidgets('loading shows the spinner with its step, then owns up to a '
      'slow start', (tester) async {
    handler.videoLoad.value = VideoLoadState(
        phase: VideoLoadPhase.connecting, startedAt: DateTime.now());
    await tester.pumpWidget(_app(const VideoLoadingOverlay()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(VideoLoadingOverlay.stepKey), findsOneWidget);
    expect(find.byKey(VideoLoadingOverlay.slowKey), findsNothing);

    handler.videoLoad.value = VideoLoadState(
        phase: VideoLoadPhase.buffering,
        startedAt: DateTime.now().subtract(const Duration(seconds: 30)));
    await tester.pump();
    expect(find.byKey(VideoLoadingOverlay.slowKey), findsOneWidget);

    // Playing: the overlay is gone altogether.
    handler.videoStreamReady.value = true;
    handler.videoLoad.value = null;
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('a failed load swaps the spinner for the failure and a retry',
      (tester) async {
    handler.videoLoad.value = VideoLoadState(
      phase: VideoLoadPhase.failed,
      startedAt: DateTime.now(),
      lastError: 'Failed to open https://node.test/master.m3u8',
    );
    await tester.pumpWidget(_app(const Stack(fit: StackFit.expand, children: [
      VideoLoadingOverlay(),
      VideoLoadFailedPanel(),
    ])));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(VideoLoadFailedPanel.panelKey), findsOneWidget);
    expect(find.textContaining('master.m3u8'), findsOneWidget);
    expect(find.byKey(VideoLoadFailedPanel.retryKey), findsOneWidget);
    // Nothing to retry in this test; the tap must simply not throw.
    await tester.tap(find.byKey(VideoLoadFailedPanel.retryKey));
    await tester.pump();
  });

  testWidgets('no failure panel while loading', (tester) async {
    handler.videoLoad.value = VideoLoadState(
        phase: VideoLoadPhase.buffering, startedAt: DateTime.now());
    await tester.pumpWidget(_app(const VideoLoadFailedPanel()));
    expect(find.byKey(VideoLoadFailedPanel.panelKey), findsNothing);
  });
}
