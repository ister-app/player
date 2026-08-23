import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/harness.dart';

/// Adds the server through the real UI (exercising WellKnownService discovery)
/// and asserts the home shell renders — the same first-run flow a user walks.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add a server and land on its home shell', (tester) async {
    await bootApp(tester, seedServer: false);

    // First run: the welcome screen with its add-server button.
    await pumpUntilFound(tester, find.widgetWithText(FilledButton, 'Add a server'));
    await tester.tap(find.widgetWithText(FilledButton, 'Add a server'));
    await pumpUntilFound(tester, find.byType(TextField));

    // Type the address and probe it; the page shows what it discovered
    // before anything is saved.
    await tester.enterText(find.byType(TextField), testServer);
    await tester.tap(find.text('Connect'));
    await pumpUntilFound(tester, find.text('Add and sign in'),
        timeout: const Duration(seconds: 30));
    expect(find.textContaining('http://'), findsOneWidget);

    // Confirm: the server is saved and opened; the token seam signs us in.
    await tester.tap(find.text('Add and sign in'));
    await waitForServerShell(tester);
  });
}
