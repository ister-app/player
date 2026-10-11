/// Speed and time-left estimate for a running upload, from the byte count the
/// runner reports after every chunk.
///
/// The speed is the average over a sliding [window]: a chunk lands as one jump
/// in `sentBytes`, so an instantaneous number would flap between zero and a
/// burst. Pauses are cut out — [pause] drops the samples and the clock, so a
/// resume starts estimating afresh instead of averaging in the gap.
class UploadThroughput {
  UploadThroughput({this.window = const Duration(seconds: 20), this.minSpan = const Duration(seconds: 3)});

  /// How far back the speed average looks.
  final Duration window;

  /// A speed is only reported once the window holds at least this much time;
  /// before that the estimate would be dominated by one chunk.
  final Duration minSpan;

  final List<({DateTime at, int bytes})> _samples = [];
  Duration _elapsedBefore = Duration.zero;
  DateTime? _runningSince;

  /// Time spent uploading, pauses excluded.
  Duration elapsed(DateTime now) =>
      _elapsedBefore + (_runningSince == null ? Duration.zero : now.difference(_runningSince!));

  bool get isRunning => _runningSince != null;

  /// Records what has been sent so far. Call it from the runner's listener and
  /// from a ticker: a stalled upload must drift towards zero, not freeze.
  void sample(int sentBytes, DateTime now) {
    _runningSince ??= now;
    if (_samples.isNotEmpty && _samples.last.bytes == sentBytes && _samples.last.at == now) return;
    _samples.add((at: now, bytes: sentBytes));
    final cutoff = now.subtract(window);
    // Keep one sample older than the cutoff so the window spans its full width.
    while (_samples.length > 1 && _samples[1].at.isBefore(cutoff)) {
      _samples.removeAt(0);
    }
  }

  /// The upload stopped moving on purpose: freeze the clock, forget the speed.
  void pause(DateTime now) {
    if (_runningSince != null) {
      _elapsedBefore += now.difference(_runningSince!);
      _runningSince = null;
    }
    _samples.clear();
  }

  /// Bytes per second over the window, or null while there is not enough to say.
  double? get bytesPerSecond {
    if (_samples.length < 2) return null;
    final first = _samples.first;
    final last = _samples.last;
    final span = last.at.difference(first.at);
    if (span < minSpan) return null;
    return (last.bytes - first.bytes) / (span.inMilliseconds / 1000);
  }

  /// Time left at the current speed, rounded so it does not tick nervously;
  /// null when the speed is unknown or zero.
  Duration? remaining(int totalBytes, int sentBytes) {
    final speed = bytesPerSecond;
    if (speed == null || speed <= 0) return null;
    final left = totalBytes - sentBytes;
    if (left <= 0) return Duration.zero;
    return roundRemaining(Duration(milliseconds: (left / speed * 1000).round()));
  }

  /// Coarser the further away: 5 minutes beyond an hour, whole minutes beyond
  /// one, 10 seconds below that.
  static Duration roundRemaining(Duration d) {
    if (d >= const Duration(hours: 1)) return _ceilTo(d, const Duration(minutes: 5));
    if (d >= const Duration(minutes: 1)) return _ceilTo(d, const Duration(minutes: 1));
    return _ceilTo(d, const Duration(seconds: 10));
  }

  static Duration _ceilTo(Duration d, Duration step) =>
      Duration(microseconds: ((d.inMicroseconds + step.inMicroseconds - 1) ~/ step.inMicroseconds) * step.inMicroseconds);
}
