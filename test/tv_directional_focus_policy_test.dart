import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/TvDirectionalFocusPolicy.dart';

/// D-pad DOWN on a page with a sticky bottom bar (the mini player) must reach
/// content below the fold: the default directional policy always picks the
/// visible bar because it is geometrically nearer than an off-screen item,
/// which made e.g. the season list on the show page unreachable.
void main() {
  Widget buildPage({required List<Widget> pageChildren}) {
    return MaterialApp(
      builder: (context, child) => FocusTraversalGroup(
        policy: TvDirectionalFocusPolicy(),
        child: child ?? const SizedBox.shrink(),
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: pageChildren),
              ),
            ),
            // Sticky bar below the scrollable — the mini player stand-in.
            SizedBox(
              height: 60,
              child: TextButton(
                key: const Key('bar'),
                onPressed: () {},
                child: const Text('bar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget focusableTile(String key, {double height = 100}) {
    return SizedBox(
      height: height,
      child: TextButton(
        key: Key(key),
        onPressed: () {},
        child: Text(key),
      ),
    );
  }

  bool hasFocus(WidgetTester tester, String key) {
    return Focus.of(tester.element(find.text(key))).hasPrimaryFocus;
  }

  testWidgets('DOWN prefers the below-the-fold item over the sticky bar',
      (tester) async {
    await tester.pumpWidget(buildPage(pageChildren: [
      focusableTile('top'),
      // Tall spacer pushes the next tile below the fold, like the cast row
      // and hero image push the season list off screen on the show page.
      const SizedBox(height: 900),
      focusableTile('below-fold'),
    ]));

    Focus.of(tester.element(find.text('top'))).requestFocus();
    await tester.pump();
    expect(hasFocus(tester, 'top'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    expect(hasFocus(tester, 'below-fold'), isTrue,
        reason: 'the in-scrollable candidate must win over the sticky bar');
  });

  testWidgets('DOWN from the last in-page item still reaches the bar',
      (tester) async {
    await tester.pumpWidget(buildPage(pageChildren: [
      focusableTile('only'),
    ]));

    Focus.of(tester.element(find.text('only'))).requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    expect(hasFocus(tester, 'bar'), isTrue,
        reason: 'with nothing left in the scrollable the bar must stay '
            'reachable');
  });

  testWidgets('UP from the below-the-fold item returns into the page',
      (tester) async {
    await tester.pumpWidget(buildPage(pageChildren: [
      focusableTile('top'),
      const SizedBox(height: 900),
      focusableTile('below-fold'),
    ]));

    Focus.of(tester.element(find.text('top'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(hasFocus(tester, 'below-fold'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();

    expect(hasFocus(tester, 'top'), isTrue);
  });
}
