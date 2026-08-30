import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/TvBackKeyHandler.dart';

void main() {
  Future<int> pumpAndPress(
    WidgetTester tester,
    LogicalKeyboardKey key, {
    Widget Function(Widget child)? wrapChild,
  }) async {
    var backs = 0;
    Widget child = const Focus(autofocus: true, child: SizedBox.expand());
    if (wrapChild != null) child = wrapChild(child);
    await tester.pumpWidget(
      MaterialApp(
        home: TvBackKeyHandler(onBack: () => backs++, child: child),
      ),
    );
    await tester.pump();
    // TV mode on desktop is keyboard-driven; simulate with the Linux key map
    // (browserBack has no Android mapping).
    await tester.sendKeyEvent(key, platform: 'linux');
    await tester.pump();
    return backs;
  }

  testWidgets('escape triggers back', (tester) async {
    expect(await pumpAndPress(tester, LogicalKeyboardKey.escape), 1);
  });

  // goBack/browserBack share the same code path but have no entry in the
  // test key-event simulator's Linux key maps, so escape stands in for all
  // three.

  testWidgets('other keys are ignored', (tester) async {
    expect(await pumpAndPress(tester, LogicalKeyboardKey.arrowLeft), 0);
  });

  testWidgets('a descendant that consumes the key wins', (tester) async {
    // Mirrors the video controls, which swallow every key while their chrome
    // is hidden: a consumed Escape must not also pop the route.
    expect(
      await pumpAndPress(
        tester,
        LogicalKeyboardKey.escape,
        wrapChild: (child) => Focus(
          onKeyEvent: (node, event) => KeyEventResult.handled,
          child: child,
        ),
      ),
      0,
    );
  });
}
