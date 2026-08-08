import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:player/dto/IsterMediaService.dart';

import 'AppMessenger.dart';
import 'SleepTimerPreferences.dart';

/// Stops playback after a chosen duration, or after a number of media items
/// have finished — the two modes are mutually exclusive, arming one clears
/// the other. The countdown lives here rather than in [MediaPlayerHandler] so
/// the arming/window logic stays testable — constructing the handler boots
/// mpv. The handler wires [onExpire] to its own `stop()` in its constructor
/// and reports session boundaries via
/// [notifyPlaybackStarted]/[notifyPlaybackStopped] and end-of-item via
/// [notifyItemFinished].
class SleepTimerService {
  static final SleepTimerService instance = SleepTimerService._();
  SleepTimerService._();

  @visibleForTesting
  SleepTimerService.forTest();

  /// Called once when the timer runs out; wired to MediaPlayerHandler.suspendPlayback().
  Future<void> Function()? onExpire;

  /// Injectable clock for tests.
  DateTime Function() now = DateTime.now;

  /// User-facing notifications; injectable so tests don't need a messenger.
  void Function(String message) showMessage = showAppSnackBar;

  /// Time left on the timer, ticking once per second; null when inactive or
  /// when the timer counts items instead of time.
  final ValueNotifier<Duration?> remaining = ValueNotifier(null);

  /// Media items still to play, the current one included; null unless the
  /// item-counting mode is armed.
  final ValueNotifier<int?> remainingItems = ValueNotifier(null);

  Timer? _ticker;
  DateTime? _deadline;

  /// Set when the user cancels a timer, so pausing and resuming (or picking
  /// another album) doesn't re-arm the auto timer they just dismissed.
  bool _autoStartSuppressed = false;

  bool get isActive => _deadline != null || remainingItems.value != null;

  void start(Duration duration) {
    _reset();
    // Anchor on a deadline instead of counting ticks: timers don't fire while
    // the OS suspends the isolate, and the missed time must still count.
    _deadline = now().add(duration);
    remaining.value = duration;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    showMessage(
        IsterMediaService.loc.sleepTimerStartedMessage(duration.inMinutes));
  }

  /// Arms the item-counting mode: playback stops once [count] media items —
  /// the one playing now included — have finished.
  void startItems(int count) {
    if (count <= 0) return;
    _reset();
    remainingItems.value = count;
    showMessage(IsterMediaService.loc.sleepTimerItemsStartedMessage(count));
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

  /// Called from MediaPlayerHandler.suspendPlayback(): a stopped session makes the
  /// countdown moot and ends the suppression window.
  void notifyPlaybackStopped() {
    _autoStartSuppressed = false;
    _reset();
  }

  /// Called by the handler when an item played to its end, *before* it
  /// auto-advances. Returns true when this was the last item the timer allows
  /// — the timer is then already disarmed and announced, but stopping is left
  /// to the caller: the handler suspends playback and *then* parks the queue
  /// on the next item (so a later resume doesn't replay the item the listener
  /// fell asleep to), which has to happen in that order. [onExpire] is not
  /// fired here; it belongs to the countdown mode.
  bool notifyItemFinished() {
    final left = remainingItems.value;
    if (left == null) return false;
    if (left > 1) {
      remainingItems.value = left - 1;
      return false;
    }
    _reset();
    showMessage(IsterMediaService.loc.sleepTimerExpiredMessage);
    return true;
  }

  void _tick() {
    final deadline = _deadline;
    if (deadline == null) return;
    final left = deadline.difference(now());
    if (left > Duration.zero) {
      remaining.value = left;
      return;
    }
    _expire();
  }

  void _expire() {
    // Reset before invoking stop(): stop() calls notifyPlaybackStopped(),
    // which must find the timer already gone.
    _reset();
    showMessage(IsterMediaService.loc.sleepTimerExpiredMessage);
    unawaited(onExpire?.call());
  }

  void _reset() {
    _ticker?.cancel();
    _ticker = null;
    _deadline = null;
    remaining.value = null;
    remainingItems.value = null;
  }
}
