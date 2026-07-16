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
      timeout: const Duration(seconds: 60),
      description: 'the heartbeat recording a watch status for the movie',
    );

    await MediaPlayerHandler.instance.stop();
  });
}
