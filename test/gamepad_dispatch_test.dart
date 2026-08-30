import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/utils/TvInputCommands.dart';

/// Pins that TvInputCommands reaches the same sinks the keyboard path uses:
/// ActivateIntent lands on the focused TvFocusable, DirectionalFocusIntent
/// moves primary focus, and the video-controls interceptor can consume a
/// command before it reaches the focused widget.
void main() {
  Widget app(Widget child) => MaterialApp(home: Scaffold(body: child));

  tearDown(() {
    TvInputCommands.videoControlsInterceptor = null;
    TvInputCommands.videoControlsActivity = null;
    TvInputCommands.onBack = null;
  });

  testWidgets('activate() fires the focused TvFocusable onTap', (tester) async {
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(app(TvFocusable(
      focusNode: node,
      onTap: () => taps++,
      child: const Text('tile'),
    )));
    node.requestFocus();
    await tester.pump();

    TvInputCommands.activate();
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('direction(right) moves primary focus', (tester) async {
    final left = FocusNode(debugLabel: 'left');
    final right = FocusNode(debugLabel: 'right');
    addTearDown(left.dispose);
    addTearDown(right.dispose);
    await tester.pumpWidget(app(Row(children: [
      TvFocusable(focusNode: left, onTap: () {}, child: const Text('L')),
      TvFocusable(focusNode: right, onTap: () {}, child: const Text('R')),
    ])));
    left.requestFocus();
    await tester.pump();

    TvInputCommands.direction(TvDirection.right);
    await tester.pump();
    expect(right.hasFocus, isTrue);
  });

  testWidgets('back() reaches onBack, and a consuming interceptor blocks it',
      (tester) async {
    var backs = 0;
    TvInputCommands.onBack = () => backs++;
    TvInputCommands.back();
    expect(backs, 1);

    TvInputCommands.videoControlsInterceptor = () => true;
    TvInputCommands.back();
    expect(backs, 1, reason: 'consumed by the hidden video controls');
  });

  testWidgets('interceptor consumes activate; pass-through reports activity',
      (tester) async {
    var taps = 0;
    var activity = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(app(TvFocusable(
      focusNode: node,
      onTap: () => taps++,
      child: const Text('tile'),
    )));
    node.requestFocus();
    await tester.pump();

    TvInputCommands.videoControlsInterceptor = () => true;
    TvInputCommands.activate();
    await tester.pump();
    expect(taps, 0, reason: 'hidden controls swallow the revealing press');

    TvInputCommands.videoControlsInterceptor = () => false;
    TvInputCommands.videoControlsActivity = () => activity++;
    TvInputCommands.activate();
    await tester.pump();
    expect(taps, 1);
    expect(activity, 1, reason: 'visible controls restart their hide timer');
  });

  testWidgets('commands without focus are dropped safely', (tester) async {
    await tester.pumpWidget(app(const SizedBox()));
    TvInputCommands.activate();
    TvInputCommands.direction(TvDirection.down);
    // No focus, no interceptor, no onBack — nothing should throw.
    TvInputCommands.back();
  });
}
