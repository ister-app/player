// Keeps playback moving when mpv does not: re-opens a stream that was opened
// but never started (a background HLS load Android throttled), skips it after
// bounded retries, and advances past a near-end stall that never fires
// `completed`. Owns the "did the position move" bookkeeping the handler's
// listeners feed it, and the auto-advance debounce shared with the completion
// listener and the segment boundaries.
import 'dart:async';

import 'package:player/utils/LoggerService.dart';

import 'PlaybackCore.dart';

class StallWatchdog {
  StallWatchdog(this.core);

  final PlaybackCore core;

  Timer? _timer;
  DateTime? _openedAt;
  Duration _lastObservedPosition = Duration.zero;
  DateTime _lastPositionAdvance = DateTime.now();
  DateTime? _lastAutoAdvance;
  // Guards the skip-on-failed-load path so the watchdog doesn't re-open the
  // failing stream while the skip to the next item is still in flight.
  bool _handlingFailedLoad = false;
  int _retries = 0;
  // Set by the player error stream while the current load never advanced;
  // switches the load watchdog to its fast-fail regime (3s, 1 retry).
  bool _loadErrorSeen = false;

  /// When the current stream was opened; null while nothing is open or a
  /// queue switch has silenced the previous stream ([silence]).
  DateTime? get openedAt => _openedAt;

  /// Re-opens of the current item so far (shown as the load attempt).
  int get retries => _retries;
  void clearRetries() => _retries = 0;

  /// A stream was just opened at [startMs]: tracking starts afresh.
  void noteOpened(int startMs) {
    _openedAt = DateTime.now();
    _loadErrorSeen = false;
    _lastObservedPosition = Duration(milliseconds: startMs);
    _lastPositionAdvance = DateTime.now();
  }

  /// Tracks real forward progress so the watchdog can tell "still playing"
  /// from "frozen near the end".
  void notePosition(Duration pos) {
    if ((pos - _lastObservedPosition).inMilliseconds.abs() > 250) {
      _lastObservedPosition = pos;
      _lastPositionAdvance = DateTime.now();
    }
  }

  /// mpv reported a load error before the stream advanced.
  void noteLoadError() => _loadErrorSeen = true;

  /// A queue switch is in flight: the previous stream no longer counts as
  /// open, so a slow next load is not mistaken for a hang of the old one.
  void silence() => _openedAt = null;

  /// Teardown.
  void reset() {
    _openedAt = null;
    _loadErrorSeen = false;
    _retries = 0;
  }

  /// Something advanced the queue (completion, a segment boundary, this
  /// watchdog): the others hold off for a few seconds.
  void markAutoAdvance() => _lastAutoAdvance = DateTime.now();
  bool get recentlyAutoAdvanced {
    final last = _lastAutoAdvance;
    return last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 8);
  }

  Future<void> _skipFailedLoad() async {
    if (_handlingFailedLoad) return;
    _handlingFailedLoad = true;
    try {
      await core.skipFailedLoad();
    } finally {
      _handlingFailedLoad = false;
    }
  }

  /// Watchdog for streams that stall just before the end without ever firing
  /// `completed`. This is common with transcoded/HLS audio on Android: the
  /// final segment that signals EOF never arrives (especially while the app is
  /// backgrounded and Doze throttles the network), so mpv sits buffering near
  /// the end and `skipToNext()` is never reached. When we detect that playback
  /// is supposed to be running but the position has frozen within a few seconds
  /// of the end, we advance manually.
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Nothing can stall when we don't intend to be playing — skip the work so
      // the timer doesn't poke the player every 2s for the app's whole life.
      if (!core.intendsToPlay) return;
      _maybeRecoverStalledLoad();
      _maybeAutoAdvanceOnStall();
    });
  }

  /// Recovers a stream that was opened but never started playing — typically a
  /// background HLS load that stalled because Android throttled the network at
  /// the moment of a track change. Without this the next track only starts once
  /// the app is reopened. We re-open the same stream a bounded number of times;
  /// the mpv reconnect options handle softer drops, this handles a full hang.
  void _maybeRecoverStalledLoad() {
    if (!core.intendsToPlay) return;
    // A skip is already in flight for a failed load — don't re-open the old
    // (failing) stream in the window before the next item takes over.
    if (_handlingFailedLoad) return;
    if (core.player.state.playing) return;
    final openedAt = _openedAt;
    if (openedAt == null) return;
    // Give a normal background load plenty of time before intervening — but
    // fail fast when mpv already reported a load error (e.g. a 404/denied
    // stream): those never recover, only the retry-then-skip path helps.
    final stallThreshold = _loadErrorSeen
        ? const Duration(seconds: 3)
        : const Duration(seconds: 12);
    if (DateTime.now().difference(openedAt) < stallThreshold) {
      return;
    }
    // A stream with known duration that isn't buffering did load — it is
    // paused by something outside pause() (which would have cleared
    // core.intendsToPlay), e.g. mpv itself or a platform interruption — not hung.
    if (!core.player.state.buffering &&
        core.player.state.duration > Duration.zero) {
      return;
    }
    // Only a stream that essentially never advanced past its open position
    // counts as a failed load. (Resumed content opens mid-stream, so compare
    // against the open position rather than 0.)
    final openPosition = Duration(milliseconds: core.streamOpenPositionMs);
    if (core.player.state.position - openPosition >
        const Duration(seconds: 1)) {
      return;
    }
    final url = core.currentMediaUrl;
    if (url == null || core.serverName == null) return;
    // Re-opening the same stream never got it playing — the load has
    // definitively failed (commonly a server-side transcode that emits a valid
    // manifest but never delivers segments). Skip the item and tell the user
    // instead of buffering forever. A hard player error needs only one retry.
    final maxRetries = _loadErrorSeen ? 1 : 5;
    if (_retries >= maxRetries) {
      _retries = 0;
      unawaited(_skipFailedLoad());
      return;
    }
    _retries++;
    LoggerService().logger.w(
      '[LOADSTALL] Stream not playing 12s+ after open — re-opening (retry $_retries)',
    );
    unawaited(core.reopenCurrentStream());
  }

  void _maybeAutoAdvanceOnStall() {
    // A follower never advances on its own; the leader's item change arrives
    // over the now-playing fan-out.
    if (core.followMode) return;
    if (!core.player.state.playing) return;
    final dur = core.player.state.duration;
    final pos = core.player.state.position;
    if (dur <= Duration.zero) return;

    // Only act near the very end — a mid-track buffering hiccup should recover
    // on its own, not skip the track.
    if (dur - pos > const Duration(seconds: 3)) return;

    final stalledFor = DateTime.now().difference(_lastPositionAdvance);
    if (stalledFor < const Duration(seconds: 4)) return;

    // Debounce against a real `completed` event firing around the same time.
    final last = _lastAutoAdvance;
    if (last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 8)) {
      return;
    }
    _lastAutoAdvance = DateTime.now();
    LoggerService().logger.w(
      '[STALL] Near-end stall detected (remaining=${dur - pos}, stalledFor=$stalledFor) — advancing to next',
    );
    core.advanceAfterItemEnd();
  }
}
