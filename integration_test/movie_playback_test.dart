import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// Watches a movie: opening the movie page starts a play queue and HLS
/// playback through media_kit; the position must actually advance and the
/// heartbeat must land in recentlyWatched on the server.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('play a movie and record watch progress', (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    final movies = await gqlRaw('{ movies(size: 1) { content { id name } } }');
    final movie = (movies['movies']['content'] as List).first;
    final movieId = movie['id'] as String;

    await pushRoute(tester, MovieRoute(movieId: movieId));
    await tapVideoPlay(tester);

    final player = MediaPlayerHandler.instance.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 3),
      description: 'playback to start (first HLS segment transcoded)',
    );

    final startPosition = player.state.position;
    await pumpUntil(
      tester,
      () => player.state.position - startPosition >= const Duration(seconds: 5),
      timeout: const Duration(minutes: 2),
      description: 'the playback position to advance 5 seconds',
    );

    // The server only records watch status beyond 60s of progress, so seek to
    // mid-movie (the fixtures are 3 minutes) and wait for a heartbeat to land.
    // Assert on the movie's own watchStatus: recentlyWatched drops fully
    // watched movies by design, so it would be a flaky signal here.
    await MediaPlayerHandler.instance.seek(const Duration(seconds: 90));
    var seen = false;
    try {
      await pumpUntil(
        tester,
        () {
          gqlRaw('{ movieById(id: "$movieId") { watchStatus { id } } }')
              .then((data) {
            seen = seen ||
                ((data['movieById']?['watchStatus'] as List?) ?? []).isNotEmpty;
          });
          return seen;
        },
        // Generous window: the seek kicks off a fresh mid-file transcode, and
        // on a starved CI node the write side of the server can lag well
        // behind reads (a 60s window flaked exactly there).
        timeout: const Duration(minutes: 3),
        description: 'the heartbeat recording a watch status for the movie',
      );
    } on Object {
      // The heartbeats were sent and acked but no watch status appeared —
      // dump the server's view of the queue so the CI log shows whether the
      // progress write landed (row exists, progress advanced) or the write
      // path silently no-opped (item missing / wrong type / zero progress).
      final queueId = MediaPlayerHandler.instance.playQueue?.id;
      final itemId = MediaPlayerHandler.instance.currentPlayQueueItem?.id;
      // ignore: avoid_print
      print('[DIAG] client queue=$queueId item=$itemId movie=$movieId');
      try {
        final q = await gqlRaw(
            '{ getPlayQueue(id: "$queueId") { id currentItemId '
            'progressInMilliseconds playQueueItems { id type accessible '
            'movie { id } } } }');
        // ignore: avoid_print
        print('[DIAG] server queue: ${q['getPlayQueue']}');
      } catch (e) {
        // ignore: avoid_print
        print('[DIAG] server queue fetch failed: $e');
      }
      rethrow;
    }

    await MediaPlayerHandler.instance.stop();
  });
}
