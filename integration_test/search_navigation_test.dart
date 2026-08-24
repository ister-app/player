// Search results must actually navigate. Regression test for the episode row:
// ShowEpisodeRoute is a nested child of ShowOverviewRoute, and a direct push
// from the search page failed silently — the row rippled but nothing opened.
// Rows are found by their locale-independent ValueKey ('search-<kind>-<id>'),
// so the test runs the same under any system language.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/pages/ShowEpisodePage.dart';
import 'package:player/routes/AppRouter.gr.dart';

import 'support/harness.dart';

Finder _resultRow(String kind) => find.byWidgetPredicate((w) {
      final key = w.key;
      return key is ValueKey<String> && key.value.startsWith('search-$kind-');
    });

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('an episode search result opens the episode page',
      (tester) async {
    await bootApp(tester);
    await enterServerShell(tester);
    await pushRoute(tester, SearchRoute());
    await pumpUntilFound(tester, find.byType(TextField));
    // The fixture library has the show "Dragonfly"; its episodes rank in the
    // results too.
    await tester.enterText(find.byType(TextField).first, 'dragon');

    await pumpUntilFound(tester, _resultRow('episode'),
        timeout: const Duration(seconds: 30));
    await tester.tap(_resultRow('episode').first, warnIfMissed: false);

    await pumpUntil(
      tester,
      () => find.byType(ShowEpisodePage).evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
      description: 'ShowEpisodePage after tapping an episode result',
    );
  });
}
