import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/routes/AppRouter.gr.dart';

import 'support/harness.dart';

/// Opens the media-overlay ("Spring Walk") epub and starts read-aloud: the
/// toggle must flip to its active (pause) icon, proving the SMIL overlay was
/// detected server-side and the embedded audio plays.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('read aloud in a media-overlay epub', (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);

    final books = await gqlRaw(
        '{ books(size: 50) { content { id name epubFiles { id mediaOverlays directory { node { url } } } } } }');
    final book = (books['books']['content'] as List).firstWhere(
        (b) =>
            (b['epubFiles'] as List? ?? []).any((f) => f['mediaOverlays'] == true),
        orElse: () => fail('no media-overlay epub found — '
            'the scanner should have flagged "Spring Walk"'));
    final bookId = book['id'] as String;
    final epubFile = (book['epubFiles'] as List)
        .firstWhere((f) => f['mediaOverlays'] == true);
    final mediaFileId = epubFile['id'] as String;
    final nodeUrl = epubFile['directory']['node']['url'] as String;

    await pushRoute(
        tester,
        ReaderRoute(
            bookId: bookId, mediaFileId: mediaFileId, nodeUrl: nodeUrl));

    await pumpUntil(
      tester,
      () => find
          .textContaining('first sentence', findRichText: true)
          .evaluate()
          .isNotEmpty,
      timeout: const Duration(minutes: 1),
      description: 'the chapter text to render',
    );

    // The read-aloud toggle shows a voice icon when idle...
    await pumpUntilFound(tester, find.byIcon(Icons.record_voice_over));
    await tester.tap(find.byIcon(Icons.record_voice_over));

    // ...and flips to a pause icon once the overlay audio actually plays.
    await pumpUntilFound(tester, find.byIcon(Icons.pause_circle_outline),
        timeout: const Duration(minutes: 1));
  });
}
