import 'package:player/utils/Throughput.dart';

import 'GameInstallStore.dart';

/// Progress of one install, for the game page and the downloads page.
class GameInstallProgress {
  const GameInstallProgress({
    required this.status,
    required this.doneBytes,
    required this.totalBytes,
    required this.filesDone,
    required this.filesTotal,
    this.bytesPerSecond,
    this.remaining,
    this.currentFile,
    this.queuePosition,
    this.error,
  });

  final GameInstallStatus status;

  /// Finished files plus what is in flight inside the open ones.
  final int doneBytes;
  final int totalBytes;
  final int filesDone;
  final int filesTotal;

  /// Null until the throughput window has enough samples.
  final double? bytesPerSecond;
  final Duration? remaining;
  final String? currentFile;

  /// 1-based place in the queue while [status] is `queued`.
  final int? queuePosition;
  final String? error;

  double? get fraction => totalBytes <= 0 ? null : (doneBytes / totalBytes).clamp(0.0, 1.0);

  bool get isActive =>
      status == GameInstallStatus.queued || status == GameInstallStatus.downloading || status == GameInstallStatus.extracting;
}

/// The arithmetic behind [GameInstallProgress]: finished files, the bytes in
/// flight per open file (three download at once), and a throughput window
/// over their sum. Pure, so the numbers can be tested without a server.
class InstallProgressTracker {
  InstallProgressTracker({
    required this.totalBytes,
    required this.filesTotal,
    Throughput? throughput,
  }) : throughput = throughput ?? Throughput();

  final int totalBytes;
  final int filesTotal;
  final Throughput throughput;

  int _finishedBytes = 0;
  int _filesDone = 0;
  final Map<String, int> _inFlight = {};
  String? _currentFile;

  int get doneBytes => _finishedBytes + _inFlight.values.fold(0, (a, b) => a + b);
  int get filesDone => _filesDone;
  String? get currentFile => _currentFile;

  /// [bytes] of [path] are on disk so far.
  void fileProgress(String path, int bytes) {
    _inFlight[path] = bytes;
    _currentFile = path;
  }

  /// [path] is complete at [size] bytes (whether just downloaded or found
  /// on disk from an earlier attempt).
  void fileDone(String path, int size) {
    _inFlight.remove(path);
    _finishedBytes += size;
    _filesDone++;
    if (_currentFile == path) _currentFile = _inFlight.keys.lastOrNull;
  }

  /// Feeds the throughput window; call it on every change and once a second
  /// so a stalled download drifts towards zero instead of freezing.
  void tick(DateTime now) => throughput.sample(doneBytes, now);

  /// Stops the clock without forgetting what is on disk.
  void pause(DateTime now) => throughput.pause(now);

  GameInstallProgress snapshot(GameInstallStatus status, {String? error, int? queuePosition}) {
    final done = doneBytes;
    return GameInstallProgress(
      status: status,
      doneBytes: done,
      totalBytes: totalBytes,
      filesDone: _filesDone,
      filesTotal: filesTotal,
      bytesPerSecond: status == GameInstallStatus.downloading ? throughput.bytesPerSecond : null,
      remaining: status == GameInstallStatus.downloading ? throughput.remaining(totalBytes, done) : null,
      currentFile: _currentFile,
      queuePosition: queuePosition,
      error: error,
    );
  }
}
