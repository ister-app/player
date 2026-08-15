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
    // position (the fixtures are 3 minutes).
    await handler.seek(const Duration(seconds: 90));
    await pumpUntil(
      tester,
      () => (player.state.position - const Duration(seconds: 90)).abs() <
          const Duration(seconds: 8),
      timeout: const Duration(minutes: 2),
      description: 'the forward seek to land',
    );

    // The backward seek under test: must land quickly (plain seek, the
    // demuxer back-buffer serves it) and keep the subtitle selection.
    final before = DateTime.now();
    await handler.seek(const Duration(seconds: 60));
    await pumpUntil(
      tester,
      () => (player.state.position - const Duration(seconds: 60)).abs() <
          const Duration(seconds: 8),
      timeout: const Duration(seconds: 30),
      description: 'the backward seek to land',
    );
    final elapsed = DateTime.now().difference(before);
    // A full stream re-open on this stack takes well over 10s (fresh HLS
    // manifest + first segment transcode); a plain seek is near-instant.
    expect(elapsed, lessThan(const Duration(seconds: 10)),
        reason: 'backward seek should not re-open the stream');

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
