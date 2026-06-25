/// Formatting helpers for media durations, shared across the music UI so the
/// seek bar, track lists and album/artist pages all render times identically.
class DurationUtil {
  /// `M:SS` for sub-hour durations, `H:MM:SS` once there's at least one hour.
  static String format(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }
}
