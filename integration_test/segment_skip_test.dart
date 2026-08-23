import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/components/video_controls/SegmentOverlayButtons.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// End-to-end intro/outro skip against the Cicada fixture show: the server's
/// season-wide audio-fingerprint detection must produce an INTRO (~0-35s) and
/// OUTRO (~275-300s) for every episode, and the player's overlay must offer
/// "Skip intro" inside the intro (tapping seeks past it) and "Next episode"
/// during the credits.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('skip-intro button appears from detected segments and seeks',
      (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    // Cicada s01e01 is the segment-detection fixture: three episodes sharing
    // a 35s audio intro and a 25s audio outro (testdata create_mkv.sh).
    final episodes = await gqlRaw(
        '{ episodes(size: 200) { content { id number show { id name } season { number } } } }');
    final episode = (episodes['episodes']['content'] as List).firstWhere(
      (e) =>
          e['show']?['name'] == 'Cicada' &&
          e['season']?['number'] == 1 &&
          e['number'] == 1,
    );
    final showId = episode['show']['id'] as String;
    final episodeId = episode['id'] as String;

    // Detection runs asynchronously after per-file analysis (season-wide
    // DETECT_SEGMENTS event); poll the API until both segments exist.
    List<dynamic> segments = const [];
    await pumpUntil(
      tester,
      () {
        gqlRaw('{ episodeById(id: "$episodeId") { mediaFile { segments { '
                'type startInMilliseconds endInMilliseconds } } } }')
            .then((data) {
          final files = (data['episodeById']?['mediaFile'] as List?) ?? const [];
          segments = files.isEmpty
              ? const []
              : (files.first['segments'] as List? ?? const []);
        }).catchError((_) {});
        return segments.any((s) => s['type'] == 'INTRO') &&
            segments.any((s) => s['type'] == 'OUTRO');
      },
      timeout: const Duration(minutes: 5),
      description: 'segment detection to produce INTRO and OUTRO',
    );

    final intro = segments.firstWhere((s) => s['type'] == 'INTRO');
    final outro = segments.firstWhere((s) => s['type'] == 'OUTRO');
    final introStartMs = (intro['startInMilliseconds'] as num).toInt();
    final introEndMs = (intro['endInMilliseconds'] as num).toInt();
    final outroStartMs = (outro['startInMilliseconds'] as num).toInt();
    final outroEndMs = (outro['endInMilliseconds'] as num).toInt();
    expect(introStartMs, 0, reason: 'the intro starts at the cold open');
    expect((introEndMs - 35000).abs(), lessThan(5000),
        reason: 'the intro is 35s of shared audio, detected $introEndMs');
    expect((outroStartMs - 275000).abs(), lessThan(5000),
        reason: 'the outro starts at 275s, detected $outroStartMs');
    expect((outroEndMs - 300000).abs(), lessThan(5000),
        reason: 'the outro runs to EOF, detected $outroEndMs');

    // Play the episode; the show queue continues with s01e02/e03, so the
    // next-episode prompt has a target.
    await pushRoute(
        tester,
        ShowOverviewRoute(showId: showId, children: [
          ShowEpisodeRoute(showId: showId, episodeId: episodeId),
        ]));
    await tapVideoPlay(tester);

    final handler = MediaPlayerHandler.instance;
    final player = handler.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 3),
      description: 'playback to start',
    );

    // Fresh playback starts inside the intro; the overlay button must appear
    // without any interaction (it lives outside the auto-hiding chrome).
    // Locale-proof finder: the label is localized (en/nl), the widget is not.
    final overlayButton = find.descendant(
        of: find.byType(SegmentOverlayButtons),
        matching: find.byType(FilledButton));
    // A previous run's watch progress makes playback resume mid-episode; put
    // the position firmly inside the intro when it isn't already.
    if (player.state.position.inMilliseconds >= introEndMs - 9000) {
      await handler.seek(Duration(milliseconds: introStartMs + 3000));
      await pumpUntil(
        tester,
        () => player.state.position.inMilliseconds < introEndMs - 9000,
        timeout: const Duration(minutes: 2),
        description: 'the seek into the intro to land',
      );
    }
    await pumpUntilFound(tester, overlayButton,
        timeout: const Duration(minutes: 1));

    await tester.tap(overlayButton);
    await pumpUntil(
      tester,
      () => player.state.position.inMilliseconds >= introEndMs - 8000,
      timeout: const Duration(minutes: 2),
      description: 'the skip-intro seek to land past the intro',
    );
    // An HLS seek can land a couple of seconds short of the target (keyframe
    // grid); wait for the button to retire rather than asserting instantly.
    await pumpUntil(
      tester,
      () => overlayButton.evaluate().isEmpty,
      timeout: const Duration(seconds: 30),
      description: 'the skip-intro button to retire past the intro',
    );

    // Seek into the credits: the next-episode prompt appears (not tapped —
    // opening a second HLS stream is out of scope for this test).
    await handler.seek(Duration(milliseconds: outroStartMs + 3000));
    await pumpUntilFound(tester, overlayButton,
        timeout: const Duration(minutes: 1));

    await handler.stop();
  });
}
