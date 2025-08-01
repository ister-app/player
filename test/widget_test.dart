import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:player/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Main());

    // Verify that the MaterialApp is created.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
