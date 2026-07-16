import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// Subscribes to the in-cluster test feed (if not already subscribed by the
/// chart e2e), waits for a downloaded episode and plays it.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('subscribe to a podcast and play an episode', (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    var podcasts =
        await gqlRaw('{ podcasts(size: 10) { content { id title } } }');
    var content = podcasts['podcasts']['content'] as List;
    if (content.isEmpty) {
      await gqlRaw(
          'mutation { subscribePodcast(feedUrl: "http://podcast-feed:8080/feed.xml") { id } }');
      await gqlRaw('mutation { refreshPodcasts }');
      podcasts =
          await gqlRaw('{ podcasts(size: 10) { content { id title } } }');
      content = podcasts['podcasts']['content'] as List;
    }
    expect(content, isNotEmpty, reason: 'a podcast subscription should exist');
    final podcastId = content.first['id'] as String;

    // Wait until at least one episode is downloaded into the server cache.
    String? episodeId;
    final deadline = DateTime.now().add(const Duration(minutes: 3));
    while (DateTime.now().isBefore(deadline)) {
      final eps = await gqlRaw(
          '{ podcastEpisodes(podcastId: "$podcastId", size: 10) { content { id downloaded } } }');
      final downloaded = (eps['podcastEpisodes']['content'] as List)
          .where((e) => e['downloaded'] == true);
      if (downloaded.isNotEmpty) {
        episodeId = downloaded.first['id'] as String;
        break;
      }
      await tester.pump(const Duration(seconds: 5));
    }
    expect(episodeId, isNotNull, reason: 'an episode should be downloaded');

    final client = await appClient();
    final handler = MediaPlayerHandler.instance;
    await handler.startPlayQueueForPodcast(
        client, null, podcastId, episodeId, testServer);

    final player = handler.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 2),
      description: 'podcast playback to start',
    );

    final startPosition = player.state.position;
    await pumpUntil(
      tester,
      () => player.state.position - startPosition >= const Duration(seconds: 3),
      timeout: const Duration(minutes: 1),
      description: 'the podcast position to advance 3 seconds',
    );

    await handler.stop();
  });
}
