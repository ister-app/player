import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// Listens to an audiobook chapter through the same MediaPlayerHandler entry
/// point the book page uses; audio must actually play and advance.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('play an audiobook chapter', (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    final books = await gqlRaw(
        '{ books(size: 50) { content { id name chapters { id } } } }');
    final audiobook = (books['books']['content'] as List).firstWhere(
        (b) => (b['chapters'] as List? ?? []).isNotEmpty,
        orElse: () => fail('no audiobook (book with chapters) found'));
    final bookId = audiobook['id'] as String;

    final client = await appClient();
    final handler = MediaPlayerHandler.instance;
    await handler.startPlayQueueForBook(client, null, bookId, null, testServer);

    final player = handler.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 2),
      description: 'audiobook playback to start',
    );

    final startPosition = player.state.position;
    await pumpUntil(
      tester,
      () => player.state.position - startPosition >= const Duration(seconds: 3),
      // Audio goes through an HLS transcode too; a cold pass on a busy 2-core CI
      // cluster can take minutes before the first segment plays.
      timeout: const Duration(minutes: 3),
      description: 'the audiobook position to advance 3 seconds',
    );

    await handler.stop();
  });
}
