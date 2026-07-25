import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/TvFocusable.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

BoxDecoration _highlightBox(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find
        .ancestor(
          of: find.byType(ListTile),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  setUp(() {
    // Desktop-like focus behaviour: focus highlights are always eligible, the
    // situation where a clicked menu button used to light up its whole row.
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  testWidgets('a focused descendant (menu button) does not light the row',
      (tester) async {
    final buttonNode = FocusNode();
    addTearDown(buttonNode.dispose);

    await tester.pumpWidget(_app(TvFocusable(
      onTap: () {},
      child: ListTile(
        title: const Text('Row'),
        trailing: IconButton(
          focusNode: buttonNode,
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    )));

    // Focus lands on the inner button — what happens after clicking it, or
    // when a closing MenuAnchor restores focus to its anchor.
    buttonNode.requestFocus();
    await tester.pumpAndSettle();

    expect(_highlightBox(tester).color, Colors.transparent);
  });

  testWidgets('primary focus on the row itself does light it', (tester) async {
    final rowNode = FocusNode();
    addTearDown(rowNode.dispose);

    await tester.pumpWidget(_app(TvFocusable(
      onTap: () {},
      focusNode: rowNode,
      child: const ListTile(title: Text('Row')),
    )));

    rowNode.requestFocus();
    await tester.pumpAndSettle();

    expect(_highlightBox(tester).color, isNot(Colors.transparent));
  });
}
