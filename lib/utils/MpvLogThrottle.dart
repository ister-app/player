/// Decides which mpv log lines reach the exported app log.
///
/// mpv repeats itself under trouble (an underrun or a failing segment logs the
/// same line many times a second), and the exported log is a small rotating
/// file: unthrottled, one bad stream would push everything else out of it.
/// A line is dropped when the same text was let through within [repeatWindow],
/// or when [maxPerWindow] lines already passed in the current [window]; the
/// number dropped is handed back with the next line that does pass.
class MpvLogThrottle {
  MpvLogThrottle({
    this.repeatWindow = const Duration(seconds: 30),
    this.window = const Duration(minutes: 1),
    this.maxPerWindow = 20,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration repeatWindow;
  final Duration window;
  final int maxPerWindow;
  final DateTime Function() _now;

  final Map<String, DateTime> _lastPassed = {};
  DateTime? _windowStart;
  int _passedInWindow = 0;
  int _suppressed = 0;

  /// The line to write for [line], or null when it is dropped.
  String? admit(String line) {
    final now = _now();
    final start = _windowStart;
    if (start == null || now.difference(start) >= window) {
      _windowStart = now;
      _passedInWindow = 0;
      _lastPassed.removeWhere((_, at) => now.difference(at) >= repeatWindow);
    }
    final last = _lastPassed[line];
    final repeated = last != null && now.difference(last) < repeatWindow;
    if (repeated || _passedInWindow >= maxPerWindow) {
      _suppressed++;
      return null;
    }
    _lastPassed[line] = now;
    _passedInWindow++;
    final suppressed = _suppressed;
    _suppressed = 0;
    return suppressed == 0 ? line : '$line (+$suppressed suppressed)';
  }
}
