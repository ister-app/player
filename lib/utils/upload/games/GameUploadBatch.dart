import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:player/utils/LoggerService.dart';

import '../GameFoundProbe.dart';
import '../UploadApi.dart';
import '../UploadModels.dart';
import '../UploadResumeStore.dart';
import '../UploadRunner.dart';
import '../UploadSource.dart';
import 'GameLibraryIndex.dart';
import 'GameSourceMaterialiser.dart';
import 'GameUploadCandidate.dart';

enum GameUploadPhase { queued, preparing, uploading, done, skipped, failed, cancelled }

/// One game of a batch.
class GameUploadItem {
  GameUploadItem(this.candidate, {this.phase = GameUploadPhase.queued});

  final GameUploadCandidate candidate;
  GameUploadPhase phase;

  /// The transfer of this game; kept after it finished for the byte counts
  /// and for "retry failed".
  UploadRunner? runner;

  /// Why the game was skipped or failed, when the server said.
  String? message;

  /// The server's per-file verdicts that kept files out of the session.
  List<UploadPreviewEntry> skipped = const [];

  /// After the batch: the game as the library lists it, when the scan has it.
  FoundGame? found;

  bool get isTerminal =>
      phase == GameUploadPhase.done ||
      phase == GameUploadPhase.skipped ||
      phase == GameUploadPhase.failed ||
      phase == GameUploadPhase.cancelled;

  int get totalBytes => runner?.totalBytes ?? candidate.sizeBytes ?? 0;
  int get sentBytes => runner?.sentBytes ?? 0;
}

typedef GameUploadRunnerFactory = UploadRunner Function({
  required UploadApi api,
  required String nodeUrl,
  required UploadSession session,
  required Map<String, UploadSourceFile> sources,
  required bool partsAddressedByNumber,
});

/// Uploads the ticked games one after the other: each gets its own session
/// (one game is one `Title (year)` folder) and its own [UploadRunner]; a
/// game the server already has is skipped, a failed one does not stop the
/// rest. The store always holds the session in flight plus the queue, so a
/// restart resumes the batch without re-picking anything. When the last game
/// is up, one sweep asks the library which of them the scan has listed.
class GameUploadBatch extends ChangeNotifier {
  GameUploadBatch({
    required this.api,
    required this.directory,
    required List<GameUploadCandidate> candidates,
    required this.overwrite,
    required this.store,
    GameSourceMaterialiser? materialiser,
    GameUploadRunnerFactory? runnerFactory,
    this.indexLoader,
    Future<void> Function(Duration)? sleep,
    this.probeInterval = const Duration(seconds: 5),
    this.probePatience = const Duration(minutes: 2),
    List<String> alreadyDone = const [],
  })  : items = [for (final c in candidates) GameUploadItem(c)],
        doneBefore = alreadyDone,
        _materialiser = materialiser ?? GameSourceMaterialiser(),
        _runnerFactory = runnerFactory ?? _defaultRunner,
        _sleep = sleep ?? Future<void>.delayed;

  final UploadApi api;
  final UploadDirectory directory;
  final bool overwrite;
  final UploadResumeStore store;
  final List<GameUploadItem> items;

  /// Titles finished before a restart (from the store), shown but not re-run.
  final List<String> doneBefore;
  final GameLibraryIndexLoader? indexLoader;
  final Duration probeInterval;
  final Duration probePatience;
  final GameSourceMaterialiser _materialiser;
  final GameUploadRunnerFactory _runnerFactory;
  final Future<void> Function(Duration) _sleep;

  /// A session a restart found still open for [items].first; the runner is
  /// rebuilt from it instead of a new `createSession`.
  UploadSession? _resumeSession;

  bool _running = false;
  bool _pauseRequested = false;
  bool _cancelled = false;
  bool _probing = false;
  Completer<void>? _resumed;
  GameUploadItem? _current;

  static UploadRunner _defaultRunner({
    required UploadApi api,
    required String nodeUrl,
    required UploadSession session,
    required Map<String, UploadSourceFile> sources,
    required bool partsAddressedByNumber,
  }) =>
      UploadRunner(api: api, nodeUrl: nodeUrl, session: session, sources: sources, partsAddressedByNumber: partsAddressedByNumber);

  bool get isRunning => _running;
  bool get isPaused => _pauseRequested;
  bool get isCancelled => _cancelled;
  bool get isFinished => !_running && items.every((i) => i.isTerminal);

  /// True while the end-of-batch look-up of the games in the library runs.
  bool get isProbing => _probing;
  GameUploadItem? get current => _current;
  int get doneCount => items.where((i) => i.phase == GameUploadPhase.done).length + doneBefore.length;
  int get skippedCount => items.where((i) => i.phase == GameUploadPhase.skipped).length;
  int get failedCount => items.where((i) => i.phase == GameUploadPhase.failed).length;
  int get totalBytes => items.fold(0, (sum, i) => sum + i.totalBytes);
  int get sentBytes => items.fold(0, (sum, i) => sum + i.sentBytes);

  /// Continues a batch the store remembered: [session] is the open session
  /// of the first candidate.
  void resumeWith(UploadSession session) => _resumeSession = session;

  String get _nodeUrl => directory.nodeUrl!;
  bool get _s3 => directory.storageKind == 'S3';

  /// Runs until every game is terminal, or until [pause]/[cancel].
  Future<void> start() async {
    if (_running) return;
    _running = true;
    _pauseRequested = false;
    notifyListeners();
    try {
      for (final item in items) {
        if (_cancelled) break;
        if (item.isTerminal) continue;
        if (item.phase == GameUploadPhase.uploading && item.runner != null) {
          // Resumed after a pause: the runner picks up its open files.
          await _run(item, item.runner!);
          continue;
        }
        _current = item;
        await _upload(item);
      }
    } finally {
      _running = false;
      if (!_cancelled && !_pauseRequested && items.every((i) => i.isTerminal)) {
        _current = null;
        await store.clear();
        notifyListeners();
        unawaited(_probeFound());
      } else {
        notifyListeners();
      }
    }
  }

  Future<void> _upload(GameUploadItem item) async {
    item.phase = GameUploadPhase.preparing;
    item.message = null;
    notifyListeners();
    final candidate = item.candidate;
    final UploadSourceFolder folder;
    try {
      folder = await _materialiser.folder(candidate);
    } catch (e) {
      LoggerService().logger.w('Listing ${candidate.sourcePath} failed: $e');
      _finish(item, GameUploadPhase.failed, e.toString());
      return;
    }
    if (_cancelled) {
      _finish(item, GameUploadPhase.cancelled, null);
      return;
    }
    UploadSession? session = _resumeSession;
    _resumeSession = null;
    if (session == null) {
      session = await _createSession(item, folder);
      if (session == null) return; // skipped or failed inside
    }
    final active = session.files.where((f) => f.isActive).toList();
    if (active.isEmpty) {
      item.skipped = session.skipped;
      _finish(item, GameUploadPhase.skipped, _skipSummary(session.skipped));
      return;
    }
    await _remember(session, candidate);
    final runner = _runnerFactory(
      api: api,
      nodeUrl: _nodeUrl,
      session: session,
      sources: {
        for (final f in folder.files)
          if (session.files.any((s) => s.relativePath == f.relativePath && s.size == f.size)) f.relativePath: f
      },
      partsAddressedByNumber: _s3,
    );
    item
      ..runner = runner
      ..skipped = session.skipped
      ..phase = GameUploadPhase.uploading;
    runner.addListener(notifyListeners);
    notifyListeners();
    await _run(item, runner);
  }

  /// Drives one runner to the end, honouring pause and cancel in between.
  Future<void> _run(GameUploadItem item, UploadRunner runner) async {
    while (true) {
      if (_pauseRequested) {
        // Paused (possibly while this game was still being listed): wait for resume.
        final resumed = _resumed ??= Completer<void>();
        await resumed.future;
      }
      if (_cancelled) {
        _finish(item, GameUploadPhase.cancelled, null);
        return;
      }
      await runner.start();
      if (_cancelled) {
        _finish(item, GameUploadPhase.cancelled, null);
        return;
      }
      if (runner.isFinished) break;
      // The runner stopped short of the end: a pause; the loop waits above.
    }
    if (runner.failedCount == 0) {
      _finish(item, GameUploadPhase.done, null);
    } else {
      _finish(item, GameUploadPhase.failed, null);
    }
  }

  /// Null when the game was skipped or failed here. A 400 "Nothing to
  /// upload" means every file already exists; 429 is the server's queue.
  Future<UploadSession?> _createSession(GameUploadItem item, UploadSourceFolder folder) async {
    final candidate = item.candidate;
    final entries = [for (final f in folder.files) (relativePath: f.relativePath, size: f.size)];
    for (var attempt = 0;; attempt++) {
      try {
        return await api.createSession(_nodeUrl,
            directoryId: directory.id,
            targetParent: candidate.platformFolder,
            rootName: candidate.rootName,
            overwrite: overwrite,
            entries: entries);
      } on UploadApiException catch (e) {
        if (e.statusCode == 400 && e.message.toLowerCase().contains('nothing to upload')) {
          _finish(item, GameUploadPhase.skipped, e.message);
          return null;
        }
        if (e.statusCode == 429 && attempt < 20 && !_cancelled) {
          item.message = e.message;
          notifyListeners();
          await _sleep(e.retryAfter ?? const Duration(seconds: 30));
          continue;
        }
        _finish(item, GameUploadPhase.failed, e.message);
        return null;
      } catch (e) {
        _finish(item, GameUploadPhase.failed, e.toString());
        return null;
      }
    }
  }

  static String? _skipSummary(List<UploadPreviewEntry> skipped) {
    if (skipped.isEmpty) return null;
    final reasons = skipped.map((e) => e.ignoreReason ?? e.status.name).toSet();
    return reasons.join(', ');
  }

  void _finish(GameUploadItem item, GameUploadPhase phase, String? message) {
    item.phase = phase;
    if (message != null) item.message = message;
    if (_current == item && phase != GameUploadPhase.uploading) _current = null;
    notifyListeners();
  }

  Future<void> _remember(UploadSession session, GameUploadCandidate current) async {
    final index = items.indexWhere((i) => i.candidate.id == current.id);
    await store.save(StoredUpload(
      sessionId: session.sessionId,
      nodeUrl: _nodeUrl,
      s3: _s3,
      batch: StoredBatch(
        directoryId: directory.id,
        libraryId: directory.libraryId,
        overwrite: overwrite,
        current: current,
        queue: [for (final i in items.skip(index + 1)) if (!i.isTerminal) i.candidate],
        done: [...doneBefore, for (final i in items) if (i.phase == GameUploadPhase.done) i.candidate.title],
      ),
    ));
  }

  void pause() {
    _pauseRequested = true;
    _current?.runner?.pause();
    notifyListeners();
  }

  void resume() {
    if (!_pauseRequested) return;
    _pauseRequested = false;
    final completer = _resumed;
    _resumed = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    } else if (!_running) {
      unawaited(start());
    }
    notifyListeners();
  }

  /// Aborts the game in flight, drops the rest and forgets the batch.
  Future<void> cancel() async {
    _cancelled = true;
    final runner = _current?.runner;
    for (final item in items) {
      if (!item.isTerminal && item != _current) item.phase = GameUploadPhase.cancelled;
    }
    notifyListeners();
    if (runner != null) {
      try {
        await runner.cancel();
      } catch (e) {
        LoggerService().logger.w('Batch cancel failed: $e');
      }
    }
    final completer = _resumed;
    _resumed = null;
    if (completer != null && !completer.isCompleted) completer.complete();
    await store.clear();
    notifyListeners();
  }

  /// Failed games (and failed files of a game) go back into the queue.
  void retryFailed() {
    for (final item in items.where((i) => i.phase == GameUploadPhase.failed)) {
      final runner = item.runner;
      if (runner != null) {
        runner.retryFailed();
        item.phase = GameUploadPhase.uploading;
      } else {
        item.phase = GameUploadPhase.queued;
      }
      item.message = null;
    }
    notifyListeners();
    unawaited(start());
  }

  /// One look-up loop for every uploaded game: the scan runs once a
  /// session completes, and the library lists the games some seconds later.
  /// Counted in attempts ([probePatience] / [probeInterval]) rather than by
  /// the clock, so a test's fake time ends it too.
  Future<void> _probeFound() async {
    final loader = indexLoader;
    final wanted = items.where((i) => i.phase == GameUploadPhase.done).toList();
    if (loader == null || wanted.isEmpty) return;
    _probing = true;
    notifyListeners();
    final attempts = probeInterval <= Duration.zero
        ? 1
        : (probePatience.inMilliseconds / probeInterval.inMilliseconds).ceil().clamp(1, 1000);
    try {
      for (var attempt = 0; attempt < attempts && !_cancelled && !_disposed; attempt++) {
        try {
          final index = await loader(directory.libraryId);
          for (final item in wanted) {
            item.found ??= index.find(item.candidate.platform, item.candidate.title);
          }
        } catch (e) {
          LoggerService().logger.w('Game look-up failed: $e');
        }
        notifyListeners();
        if (wanted.every((i) => i.found != null) || attempt == attempts - 1) break;
        await _sleep(probeInterval);
      }
    } finally {
      _probing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    for (final item in items) {
      item.runner?.removeListener(notifyListeners);
    }
    super.dispose();
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
