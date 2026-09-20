/// Where a freshly started video is on its way from "play pressed" to the
/// first frame. Published by `MediaPlayerHandler.videoLoad` and rendered by
/// `VideoLoadingOverlay`, so a slow start (a cold transcode can take a minute)
/// reads as progress and a failed one as a failure — not as a frozen app.
enum VideoLoadPhase {
  /// The play queue is being created/fetched on the server; nothing is opened
  /// in the player yet.
  preparing,

  /// The stream was handed to the player, which has not started loading it.
  connecting,

  /// The player is loading: the server may still be transcoding the first
  /// segments.
  buffering,

  /// The load failed for good and nothing else in the queue took over.
  failed,
}

class VideoLoadState {
  const VideoLoadState({
    required this.phase,
    required this.startedAt,
    this.attempt = 0,
    this.lastError,
  });

  final VideoLoadPhase phase;

  /// When the user-visible wait began. Survives the phase changes and the
  /// watchdog's re-opens of one start, so "taking longer than usual" counts
  /// from the play press.
  final DateTime startedAt;

  /// 0 for the first open, n for the watchdog's n-th re-open of the stream.
  final int attempt;

  /// The last player error seen while loading (mpv's own wording), shown as
  /// the detail line of a failure.
  final String? lastError;

  bool get failed => phase == VideoLoadPhase.failed;

  VideoLoadState copyWith({
    VideoLoadPhase? phase,
    int? attempt,
    String? lastError,
  }) =>
      VideoLoadState(
        phase: phase ?? this.phase,
        startedAt: startedAt,
        attempt: attempt ?? this.attempt,
        lastError: lastError ?? this.lastError,
      );

  /// The state for a stream handed to the player at [now]. A load that is
  /// already underway — the queue switch that led here, or the watchdog
  /// re-opening the same stream — keeps its clock; anything else starts one.
  static VideoLoadState opened(VideoLoadState? current, DateTime now,
      {required int attempt}) {
    if (current != null && !current.failed) {
      return VideoLoadState(
        phase: VideoLoadPhase.connecting,
        startedAt: current.startedAt,
        attempt: attempt,
      );
    }
    return VideoLoadState(
        phase: VideoLoadPhase.connecting, startedAt: now, attempt: attempt);
  }

  /// [message] fit to show on screen: mpv quotes the full stream URL, stream
  /// token included, and this text ends up in screenshots and bug reports.
  static String redact(String message) => message.replaceAll(
      RegExp(r'token=[^&\s]+', caseSensitive: false), 'token=…');

  /// How long a start may take before the overlay owns up to it being slow.
  static const Duration slowAfter = Duration(seconds: 8);

  bool isSlow(DateTime now) => !failed && now.difference(startedAt) >= slowAfter;

  @override
  bool operator ==(Object other) =>
      other is VideoLoadState &&
      other.phase == phase &&
      other.startedAt == startedAt &&
      other.attempt == attempt &&
      other.lastError == lastError;

  @override
  int get hashCode => Object.hash(phase, startedAt, attempt, lastError);
}
