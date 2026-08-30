import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gamepads/gamepads.dart';
import 'package:player/utils/TvInputCommands.dart';

/// Translates native gamepad input into the TV-mode command layer.
///
/// Runs only in desktop TV mode (see the gate in `main.dart`): D-pad and left
/// stick move focus, A activates, B goes back, X toggles play/pause, LB/RB
/// skip. Events come from the `gamepads` plugin's normalized stream, which
/// maps every controller onto the standard Xbox layout via the SDL controller
/// database — so no per-platform key tables are needed here. Set
/// `ISTER_GAMEPAD=0` to disable (e.g. when keeping an old Steam Input
/// keyboard-style layout that would otherwise double every press).
class GamepadNavigationService {
  GamepadNavigationService._();

  static final GamepadNavigationService instance = GamepadNavigationService._();

  @visibleForTesting
  GamepadNavigationService.forTest();

  /// Injectable seams (defaults are the production wiring).
  Stream<NormalizedGamepadEvent> Function() eventSource =
      () => Gamepads.normalizedEvents;
  void Function(TvDirection) onDirection = TvInputCommands.direction;
  VoidCallback onActivate = TvInputCommands.activate;
  VoidCallback onBack = TvInputCommands.back;
  VoidCallback onPlayPause = TvInputCommands.playPause;
  VoidCallback onNext = TvInputCommands.next;
  VoidCallback onPrevious = TvInputCommands.previous;

  /// Stick-to-direction hysteresis: engage past [pressThreshold], release
  /// below [releaseThreshold], so a stick hovering around one threshold can't
  /// machine-gun press/release pairs.
  double pressThreshold = 0.5;
  double releaseThreshold = 0.3;

  /// Held-direction auto-repeat, tuned to feel like a D-pad key repeat.
  Duration repeatDelay = const Duration(milliseconds: 400);
  Duration repeatInterval = const Duration(milliseconds: 150);

  StreamSubscription<NormalizedGamepadEvent>? _sub;

  /// Logical -1/0/1 state per stick axis, for the hysteresis edge detection.
  final Map<GamepadAxis, int> _axisState = {};

  /// Pressed-state per button so a backend re-emitting the same value can't
  /// double-fire a down edge.
  final Map<GamepadButton, bool> _buttonState = {};

  TvDirection? _held;
  Timer? _repeatTimer;

  void install() {
    if (_sub != null) return;
    if (!kIsWeb && Platform.environment['ISTER_GAMEPAD'] == '0') return;
    _sub = eventSource().listen(_onEvent);
  }

  Future<void> dispose() async {
    _cancelRepeat();
    await _sub?.cancel();
    _sub = null;
  }

  void _onEvent(NormalizedGamepadEvent event) {
    final button = event.button;
    if (button != null) {
      _onButton(button, pressed: event.value >= 0.5);
      return;
    }
    switch (event.axis) {
      // Stick Y is +1 up / -1 down (see GamepadAxis), so up on the stick must
      // become TvDirection.up.
      case GamepadAxis.leftStickX:
        _onAxis(GamepadAxis.leftStickX, event.value, TvDirection.left,
            TvDirection.right);
      case GamepadAxis.leftStickY:
        _onAxis(GamepadAxis.leftStickY, event.value, TvDirection.down,
            TvDirection.up);
      default:
        break; // Right stick and triggers are unused for navigation.
    }
  }

  void _onButton(GamepadButton button, {required bool pressed}) {
    if (_buttonState[button] == pressed) return;
    _buttonState[button] = pressed;

    final direction = switch (button) {
      GamepadButton.dpadUp => TvDirection.up,
      GamepadButton.dpadDown => TvDirection.down,
      GamepadButton.dpadLeft => TvDirection.left,
      GamepadButton.dpadRight => TvDirection.right,
      _ => null,
    };
    if (direction != null) {
      pressed ? _pressDirection(direction) : _releaseDirection(direction);
      return;
    }

    // Action buttons fire on the down edge only.
    if (!pressed) return;
    // Any action press ends a held direction's repeat.
    _cancelRepeat();
    switch (button) {
      case GamepadButton.a:
        onActivate();
      case GamepadButton.b:
        onBack();
      case GamepadButton.x:
        onPlayPause();
      case GamepadButton.leftBumper:
        onPrevious();
      case GamepadButton.rightBumper:
        onNext();
      default:
        break;
    }
  }

  void _onAxis(
    GamepadAxis axis,
    double value,
    TvDirection negative,
    TvDirection positive,
  ) {
    final current = _axisState[axis] ?? 0;
    var next = current;
    if (current == 0) {
      if (value >= pressThreshold) next = 1;
      if (value <= -pressThreshold) next = -1;
    } else if (value.abs() < releaseThreshold ||
        (value > 0) != (current > 0)) {
      next = 0;
    }
    if (next == current) return;
    if (current != 0) _releaseDirection(current > 0 ? positive : negative);
    _axisState[axis] = next;
    if (next != 0) _pressDirection(next > 0 ? positive : negative);
  }

  void _pressDirection(TvDirection direction) {
    onDirection(direction);
    _held = direction;
    _repeatTimer?.cancel();
    _repeatTimer = Timer(repeatDelay, () {
      onDirection(direction);
      _repeatTimer = Timer.periodic(repeatInterval, (_) {
        onDirection(direction);
      });
    });
  }

  void _releaseDirection(TvDirection direction) {
    if (_held == direction) _cancelRepeat();
  }

  void _cancelRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    _held = null;
  }
}
