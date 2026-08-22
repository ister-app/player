import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// Backward seeking with an active subtitle track must be a plain in-player
/// seek (no stream re-open): the position lands quickly and the selected
/// subtitle track survives. Guards the seekAware/sid-cycle rework.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('backward seek keeps the subtitle track without a reload',
      (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    // Dragonfly s01e08 is the testdata's subtitle fixture: DVD bitmap subs
    // plus their OCR'd SRTs, so the HLS master carries subtitle renditions.
    final episodes = await gqlRaw(
        '{ episodes(size: 200) { content { id number show { id name } season { number } } } }');
    final episode = (episodes['episodes']['content'] as List).firstWhere(
      (e) =>
          e['show']?['name'] == 'Dragonfly' &&
          e['season']?['number'] == 1 &&
          e['number'] == 8,
    );
    final showId = episode['show']['id'] as String;

    // The episode entity exists from metadata alone; playback needs its media
    // file. Fail loud when the fixture file was not generated/scanned — the
    // episode page silently skips auto-start then, and the playback wait below
    // would burn its full timeout on a misleading message.
    final withFile = await gqlRaw(
        '{ episodeById(id: "${episode['id']}") { mediaFile { id } } }');
    expect((withFile['episodeById']?['mediaFile'] as List?) ?? const [],
        isNotEmpty,
        reason: 'Dragonfly s01e08 has no media file: the subtitle fixture '
            '(testdata create_mkv.sh create_subtitle_fixture) is missing from '
            'this deployment or has not been scanned');

    // ShowEpisodeRoute is nested under the show's overview route.
    await pushRoute(
        tester,
        ShowOverviewRoute(showId: showId, children: [
          ShowEpisodeRoute(showId: showId, episodeId: episode['id'] as String),
        ]));

    final handler = MediaPlayerHandler.instance;
    final player = handler.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 3),
      description: 'playback to start',
    );

    // Wait for a real subtitle rendition (HLS can deliver the list late).
    await pumpUntil(
      tester,
      () => player.state.tracks.subtitle
          .any((t) => t.id != 'no' && t.id != 'auto'),
      timeout: const Duration(minutes: 1),
      description: 'a real subtitle track to appear',
    );
    final sub = player.state.tracks.subtitle
        .firstWhere((t) => t.id != 'no' && t.id != 'auto');

    await handler.switchSubtitleTrack(sub);
    await pumpUntil(
      tester,
      () => player.state.track.subtitle.id == sub.id,
      timeout: const Duration(seconds: 30),
      description: 'the subtitle track to become active',
    );

    // Get far enough in that a backward seek stays after the stream-open
    // position.
    await handler.seek(const Duration(seconds: 90));
    await pumpUntil(
      tester,
      () => (player.state.position - const Duration(seconds: 90)).abs() <
          const Duration(seconds: 8),
      timeout: const Duration(minutes: 2),
      description: 'the forward seek to land',
    );

    // A long forward seek flushes mpv's demuxer cache, so let it play on for a
    // bit: the back buffer the scrub-back relies on only exists for what was
    // actually demuxed since. Without this the backward seek targets data the
    // demuxer never held and mpv re-opens the stream no matter what the app
    // does — which is not what this test is about.
    await pumpUntil(
      tester,
      () => player.state.position > const Duration(seconds: 105),
      timeout: const Duration(minutes: 1),
      description: 'a back buffer to build up after the forward seek',
    );

    // The backward seek under test: must be a plain seek and keep the
    // subtitle selection. A stream re-open is directly observable: mpv
    // rebuilds the track list, emitting a placeholders-only (auto/no)
    // `tracks` event — a plain seek never does that.
    var sawTrackListReset = false;
    final tracksSub = player.stream.tracks.listen((tracks) {
      if (tracks.subtitle.every((t) => t.id == 'auto' || t.id == 'no')) {
        sawTrackListReset = true;
      }
    });
    await handler.seek(const Duration(seconds: 95));
    await pumpUntil(
      tester,
      () => (player.state.position - const Duration(seconds: 95)).abs() <
          const Duration(seconds: 8),
      timeout: const Duration(minutes: 1),
      description: 'the backward seek to land',
    );
    await tracksSub.cancel();
    expect(sawTrackListReset, isFalse,
        reason: 'backward seek should not re-open the stream '
            '(a re-open resets the track list to placeholders)');

    // The sid cycle must have restored the same subtitle selection.
    await pumpUntil(
      tester,
      () => player.state.track.subtitle.id != 'no',
      timeout: const Duration(seconds: 15),
      description: 'the subtitle track to survive the backward seek',
    );

    await handler.stop();
  });
}
