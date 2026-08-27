import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/components/video_controls/SegmentOverlayButtons.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

Fragment$fragmentEpisode _episodeWithSegments() => Fragment$fragmentEpisode(
      id: 'ep-1',
      number: 1,
      mediaFile: [
        Fragment$fragmentMediaFiles(
          id: 'file-1',
          path: '/shows/s01e01.mkv',
          size: 1,
          durationInMilliseconds: 2400000,
          episodes: const [],
          directory: Fragment$fragmentMediaFiles$directory(
              node: Fragment$fragmentMediaFiles$directory$node(
                  url: 'http://node.test')),
          segments: [
            Fragment$fragmentMediaFiles$segments(
              id: 'seg-1',
              type: Enum$MediaSegmentType.INTRO,
              startInMilliseconds: 30000,
              endInMilliseconds: 90000,
            ),
            Fragment$fragmentMediaFiles$segments(
              id: 'seg-2',
              type: Enum$MediaSegmentType.OUTRO,
              startInMilliseconds: 2300000,
              endInMilliseconds: 2390000,
            ),
          ],
        )
      ],
    );

Widget _app(Widget home) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: home),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.testClientBuilder = (_) => throw UnimplementedError();
    handler.serverName = 'test-server';
    handler.episode = _episodeWithSegments();
    handler.mediaItem.add(const MediaItem(id: 'item-1', title: 'Episode 1'));
    handler.queue.add(const [
      MediaItem(id: 'item-1', title: 'Episode 1'),
      MediaItem(id: 'item-2', title: 'Episode 2'),
    ]);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    handler.resetAutoSkipState();
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
    handler.episode = null;
    handler.serverName = null;
    handler.mediaItem.add(null);
    handler.queue.add([]);
    handler.resetAutoSkipState();
  });

  group('maybeAutoSkipIntro', () {
    test('latches after one skip so seeking back never force-skips again', () {
      handler.resetAutoSkipState(autoSkipIntro: true);

      handler.maybeAutoSkipIntro(const Duration(seconds: 45));
      expect(handler.introAutoSkipped, isTrue);

      // Seeking back into the intro: the latch keeps auto-skip quiet.
      handler.resetAutoSkipState(autoSkipIntro: true);
      handler.maybeAutoSkipIntro(const Duration(seconds: 10));
      expect(handler.introAutoSkipped, isFalse,
          reason: 'outside the skippable window nothing may fire');
    });

    test('does nothing with the preference off', () {
      handler.maybeAutoSkipIntro(const Duration(seconds: 45));
      expect(handler.introAutoSkipped, isFalse);
    });

    test('does nothing without detected segments', () {
      handler.episode = Fragment$fragmentEpisode(id: 'ep-2', number: 2);
      handler.resetAutoSkipState(autoSkipIntro: true);
      handler.maybeAutoSkipIntro(const Duration(seconds: 45));
      expect(handler.introAutoSkipped, isFalse);
    });
  });

  group('SegmentOverlayButtons', () {
    testWidgets('shows skip intro during the intro and seeks on tap',
        (tester) async {
      final positions = StreamController<Duration>.broadcast();
      await tester.pumpWidget(
          _app(SegmentOverlayButtons(positionStream: positions.stream)));
      expect(find.text('Skip intro'), findsNothing);

      positions.add(const Duration(seconds: 45));
      await tester.pump();
      expect(find.text('Skip intro'), findsOneWidget);

      // Tapping must not throw under test clients; the real seek is stubbed.
      await tester.tap(find.text('Skip intro'));
      await tester.pump();

      positions.add(const Duration(seconds: 120));
      await tester.pump();
      expect(find.text('Skip intro'), findsNothing);
      await positions.close();
    });

    testWidgets('counts down in the button while auto-skip is armed',
        (tester) async {
      handler.resetAutoSkipState(autoSkipIntro: true);
      final positions = StreamController<Duration>.broadcast();
      await tester.pumpWidget(
          _app(SegmentOverlayButtons(positionStream: positions.stream)));

      // Lead-in: the button is already up, counting down to the auto-skip at
      // intro start + 5 s.
      positions.add(const Duration(milliseconds: 27000));
      await tester.pump();
      expect(find.text('Skip intro (8)'), findsOneWidget);

      positions.add(const Duration(milliseconds: 34500));
      await tester.pump();
      await tester.pump();
      expect(find.text('Skip intro (1)'), findsOneWidget);

      // Past the deadline the countdown is gone; a plain button remains for a
      // viewer who seeked back into the intro.
      handler.maybeAutoSkipIntro(const Duration(milliseconds: 36000));
      positions.add(const Duration(milliseconds: 36000));
      await tester.pump();
      await tester.pump();
      expect(find.text('Skip intro'), findsOneWidget);
      await positions.close();
    });

    testWidgets('shows next episode during the outro only with a next item',
        (tester) async {
      final positions = StreamController<Duration>.broadcast();
      await tester.pumpWidget(
          _app(SegmentOverlayButtons(positionStream: positions.stream)));

      positions.add(const Duration(milliseconds: 2310000));
      await tester.pump();
      expect(find.text('Next episode'), findsOneWidget);

      // Last item of the queue: no next episode to offer.
      handler.queue.add(const [MediaItem(id: 'item-1', title: 'Episode 1')]);
      positions.add(const Duration(milliseconds: 2320000));
      await tester.pump();
      await tester.pump();
      expect(find.text('Next episode'), findsNothing);
      await positions.close();
    });
  });
}
