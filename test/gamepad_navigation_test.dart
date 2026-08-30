import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart';
import 'package:player/utils/GamepadNavigationService.dart';
import 'package:player/utils/TvInputCommands.dart';

/// Pins the gamepad-to-TV-command translation: down-edge-only action buttons,
/// stick hysteresis, and held-direction auto-repeat.
void main() {
  final raw = GamepadEvent(
    gamepadId: '0',
    timestamp: 0,
    type: KeyType.button,
    key: 'test',
    value: 0,
  );

  NormalizedGamepadEvent button(GamepadButton b, double value) =>
      NormalizedGamepadEvent(
        gamepadId: '0',
        timestamp: 0,
        value: value,
        button: b,
        rawEvent: raw,
      );

  NormalizedGamepadEvent axis(GamepadAxis a, double value) =>
      NormalizedGamepadEvent(
        gamepadId: '0',
        timestamp: 0,
        value: value,
        axis: a,
        rawEvent: raw,
      );

  late StreamController<NormalizedGamepadEvent> events;
  late GamepadNavigationService service;
  late List<String> calls;

  GamepadNavigationService build() {
    events = StreamController<NormalizedGamepadEvent>(sync: true);
    calls = [];
    final s = GamepadNavigationService.forTest();
    s.eventSource = () => events.stream;
    s.onDirection = (d) => calls.add('dir:${d.name}');
    s.onActivate = () => calls.add('activate');
    s.onBack = () => calls.add('back');
    s.onPlayPause = () => calls.add('playPause');
    s.onNext = () => calls.add('next');
    s.onPrevious = () => calls.add('previous');
    s.install();
    return s;
  }

  tearDown(() async {
    await service.dispose();
    // Not awaited: close() never completes on a controller that was never
    // listened to (the defaults test).
    unawaited(events.close());
  });

  test('action buttons fire once on the down edge only', () {
    service = build();
    events.add(button(GamepadButton.a, 1));
    events.add(button(GamepadButton.a, 0));
    events.add(button(GamepadButton.b, 1));
    events.add(button(GamepadButton.b, 0));
    events.add(button(GamepadButton.x, 1));
    events.add(button(GamepadButton.leftBumper, 1));
    events.add(button(GamepadButton.rightBumper, 1));
    expect(calls, ['activate', 'back', 'playPause', 'previous', 'next']);
  });

  test('a re-emitted identical button value does not double-fire', () {
    service = build();
    events.add(button(GamepadButton.a, 1));
    events.add(button(GamepadButton.a, 1));
    expect(calls, ['activate']);
  });

  test('stick hysteresis: engage above 0.5, hold between, release below 0.3',
      () {
    fakeAsync((async) {
      service = build();
      events.add(axis(GamepadAxis.leftStickX, 0.4));
      expect(calls, isEmpty);
      events.add(axis(GamepadAxis.leftStickX, 0.6));
      expect(calls, ['dir:right']);
      events.add(axis(GamepadAxis.leftStickX, 0.35));
      expect(calls, ['dir:right'], reason: 'between thresholds stays held');
      events.add(axis(GamepadAxis.leftStickX, 0.2));
      async.elapse(const Duration(seconds: 2));
      expect(calls, ['dir:right'], reason: 'released, so no repeat');
    });
  });

  test('stick Y up (+1) maps to TvDirection.up', () {
    service = build();
    events.add(axis(GamepadAxis.leftStickY, 1));
    expect(calls, ['dir:up']);
  });

  test('held direction auto-repeats after the initial delay', () {
    fakeAsync((async) {
      service = build();
      events.add(button(GamepadButton.dpadRight, 1));
      expect(calls, ['dir:right']);
      async.elapse(const Duration(milliseconds: 399));
      expect(calls.length, 1);
      async.elapse(const Duration(milliseconds: 1));
      expect(calls.length, 2);
      async.elapse(const Duration(milliseconds: 150));
      expect(calls.length, 3);
      events.add(button(GamepadButton.dpadRight, 0));
      async.elapse(const Duration(seconds: 2));
      expect(calls.length, 3, reason: 'release stops the repeat');
    });
  });

  test('an action press cancels a held direction repeat', () {
    fakeAsync((async) {
      service = build();
      events.add(button(GamepadButton.dpadDown, 1));
      events.add(button(GamepadButton.a, 1));
      async.elapse(const Duration(seconds: 2));
      expect(calls, ['dir:down', 'activate']);
    });
  });

  test('unused inputs are ignored without effect', () {
    service = build();
    events.add(axis(GamepadAxis.rightStickX, 1));
    events.add(axis(GamepadAxis.leftTrigger, 1));
    events.add(button(GamepadButton.y, 1));
    events.add(button(GamepadButton.home, 1));
    expect(calls, isEmpty);
  });

  test('defaults point at TvInputCommands', () {
    service = GamepadNavigationService.forTest();
    expect(service.onDirection, TvInputCommands.direction);
    expect(service.onActivate, TvInputCommands.activate);
    expect(service.onBack, TvInputCommands.back);
    expect(service.onPlayPause, TvInputCommands.playPause);
    expect(service.onNext, TvInputCommands.next);
    expect(service.onPrevious, TvInputCommands.previous);
    events = StreamController<NormalizedGamepadEvent>(sync: true);
  });
}
