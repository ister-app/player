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

    // The server overview with the "add server" field.
    await pumpUntilFound(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), testServer);
    await tester.testTextInput.receiveAction(TextInputAction.done);

    // Card appears once /.well-known/ister answered; tap it and wait for the
    // shell (logged in via the token seam).
    await enterServerShell(tester);
  });
}
