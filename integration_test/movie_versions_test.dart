import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/components/VideoVersionPicker.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// A movie with two media files (testdata's `Tiger (2011).mkv` and the
/// quarter-size `Tiger (2011)-alt.mkv`): the default is the best version
/// whatever order the server lists them in, a switch mid-playback lands on the
/// other file at the same position without the streams overlapping, and the
/// server learns which file plays.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pick the best version, switch to the other one', (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    trace('looking up the movie with two media files');
    final movies = await gqlRaw('{ movies(size: 50) { content { id name '
        'mediaFile { id size durationInMilliseconds } } } }');
    final movie = (movies['movies']['content'] as List).firstWhere(
      (m) => ((m['mediaFile'] as List?) ?? []).length > 1,
      orElse: () => fail('no movie with several media files — the testdata '
          'pin predates create_movie_version_fixture'),
    );
    final movieId = movie['id'] as String;
    // The app's rule (MediaVersions.pickDefault): the highest bitrate, size
    // over running time — not the most pixels.
    double bitrateOf(dynamic file) {
      final ms = (file['durationInMilliseconds'] as num?) ?? 0;
      return ms <= 0 ? 0 : (file['size'] as num) * 8000 / ms;
    }

    final files = List.of(movie['mediaFile'] as List)
      ..sort((a, b) => bitrateOf(b).compareTo(bitrateOf(a)));
    final bestId = files.first['id'] as String;
    final otherId = files.last['id'] as String;
    expect(bitrateOf(files.first), greaterThan(bitrateOf(files.last)),
        reason: 'the fixture versions must differ in bitrate');

    trace('opening ${movie['name']}');
    await pushRoute(tester, MovieRoute(movieId: movieId));
    // Only an item with several files shows the chip.
    await pumpUntilFound(tester, find.byKey(VideoVersionChip.chipKey));
    await tapVideoPlay(tester);

    final handler = MediaPlayerHandler.instance;
    final player = handler.player;
    trace('waiting for the default version to play');
    await pumpUntil(
      tester,
      () => player.state.playing && handler.videoStreamReady.value,
      timeout: const Duration(minutes: 3),
      description: 'playback of the default version to start',
    );
    expect(handler.currentMediaFileId.value, bestId,
        reason: 'the default is the highest bitrate, not the first listed');
    expect(handler.currentMediaUrl, contains('/hls/$bestId/'));

    // Far enough in that "same position" is distinguishable from a restart.
    await handler.seek(const Duration(seconds: 60));
    await pumpUntil(
      tester,
      () => player.state.position >= const Duration(seconds: 62),
      timeout: const Duration(minutes: 3),
      description: 'playback to run on after the seek to 1:00',
    );

    trace('switching to the other version');
    await handler.switchMediaFile(otherId);
    await pumpUntil(
      tester,
      () => handler.videoStreamReady.value && player.state.playing,
      timeout: const Duration(minutes: 3),
      description: 'the other version to play',
    );
    expect(handler.currentMediaFileId.value, otherId);
    expect(handler.currentMediaUrl, contains('/hls/$otherId/'));
    expect(player.state.position, greaterThan(const Duration(seconds: 55)),
        reason: 'a switch within the same cut keeps the position');

    trace('waiting for the server to learn which file plays');
    final queueId = handler.playQueue!.id;
    String? recorded;
    await pumpUntil(
      tester,
      () {
        gqlRaw('{ getPlayQueue(id: "$queueId") { currentMediaFileId } }')
            .then((data) => recorded =
                data['getPlayQueue']?['currentMediaFileId'] as String?);
        return recorded == otherId;
      },
      timeout: const Duration(minutes: 3),
      description: 'the queue to record the switched-to media file',
    );

    await handler.stop();
  });
}
