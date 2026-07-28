import 'dart:async';

import 'package:flutter/foundation.dart';

import 'SleepTimerPreferences.dart';

/// Stops playback after a chosen duration. The countdown lives here rather
/// than in [MediaPlayerHandler] so the arming/window logic stays testable —
/// constructing the handler boots mpv. The handler wires [onExpire] to its
/// own `stop()` in its constructor and reports session boundaries via
/// [notifyPlaybackStarted]/[notifyPlaybackStopped].
class SleepTimerService {
  static final SleepTimerService instance = SleepTimerService._();
  SleepTimerService._();

  @visibleForTesting
  SleepTimerService.forTest();

  /// Called once when the timer runs out; wired to MediaPlayerHandler.stop().
  Future<void> Function()? onExpire;

  /// Injectable clock for tests.
  DateTime Function() now = DateTime.now;

  /// Time left on the timer, ticking once per second; null when inactive.
  final ValueNotifier<Duration?> remaining = ValueNotifier(null);

  Timer? _ticker;
  DateTime? _deadline;

  /// Set when the user cancels a timer, so pausing and resuming (or picking
  /// another album) doesn't re-arm the auto timer they just dismissed.
  bool _autoStartSuppressed = false;

  bool get isActive => _deadline != null;

  void start(Duration duration) {
    // Anchor on a deadline instead of counting ticks: timers don't fire while
    // the OS suspends the isolate, and the missed time must still count.
    _deadline = now().add(duration);
    remaining.value = duration;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void extend(Duration duration) {
    final deadline = _deadline;
    if (deadline == null) return;
    _deadline = deadline.add(duration);
    _tick();
  }

  /// User-initiated cancel: also suppresses auto-start for the rest of the
  /// playback session.
  void cancel() {
    _autoStartSuppressed = true;
    _reset();
  }

  /// Auto-start hook, called whenever a playback session starts or resumes.
  Future<void> notifyPlaybackStarted() async {
    if (isActive || _autoStartSuppressed) return;
    final schedule = await SleepTimerPreferences.getSchedule();
    if (!schedule.enabled) return;
    final current = now();
    final nowMinutes = current.hour * 60 + current.minute;
    if (!isWithinSleepWindow(
        nowMinutes, schedule.startMinutes, schedule.endMinutes)) {
      return;
    }
    // Re-check: playback may have started/armed while the prefs read awaited.
    if (isActive || _autoStartSuppressed) return;
    start(Duration(minutes: schedule.durationMinutes));
  }

  /// Called from MediaPlayerHandler.stop(): a stopped session makes the
  /// countdown moot and ends the suppression window.
  void notifyPlaybackStopped() {
    _autoStartSuppressed = false;
    _reset();
  }

  void _tick() {
    final deadline = _deadline;
    if (deadline == null) return;
    final left = deadline.difference(now());
    if (left > Duration.zero) {
      remaining.value = left;
      return;
    }
    // Reset before invoking stop(): stop() calls notifyPlaybackStopped(),
    // which must find the timer already gone.
    _reset();
    unawaited(onExpire?.call());
  }

  void _reset() {
    _ticker?.cancel();
    _ticker = null;
    _deadline = null;
    remaining.value = null;
  }
}
