import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'ChunkSender.dart';
import 'UploadApi.dart';
import 'UploadModels.dart';
import 'UploadSource.dart';

enum UploadItemPhase { queued, uploading, completing, done, skipped, failed }

/// One file of a running upload, as the page shows it.
class UploadItem {
  UploadItem(this.state, this.source)
      : sentBytes = state.receivedBytes,
        received = state.receivedBytes,
        haveParts = state.completedParts.toSet(),
        phase = switch (state.status) {
          'COMPLETED' => UploadItemPhase.done,
          'SKIPPED' => UploadItemPhase.skipped,
          'FAILED' => UploadItemPhase.failed,
          _ => UploadItemPhase.queued,
        };

  final UploadFileState state;

  /// Null after a restart until the admin picked the folder again.
  final UploadSourceFile? source;
  int sentBytes;

  /// What the server is known to have: kept here, not in the transfer loop, so
  /// that a paused file continues where it was instead of where it started.
  int received;
  final Set<int> haveParts;
  UploadItemPhase phase;
  String? error;

  bool get isOpen => phase == UploadItemPhase.queued || phase == UploadItemPhase.uploading;
}

/// Sends the files of one upload session: a few files in parallel, each in
/// chunks, surviving what an hours-long transfer runs into — a dropped
/// connection (retry with backoff), a lost response (the server answers 409
/// with where the file really continues), a busy server (429), a pause.
///
/// Nothing here holds more than one chunk per parallel file in memory.
class UploadRunner extends ChangeNotifier {
  UploadRunner({
    required this.api,
    required this.nodeUrl,
    required UploadSession session,
    required Map<String, UploadSourceFile> sources,
    required this.partsAddressedByNumber,
    ChunkSender? chunkSender,
    this.parallelFiles = 2,
    this.maxAttempts = 8,
    Duration Function(int attempt)? backoff,
    Future<void> Function(Duration)? sleep,
  })  : sessionId = session.sessionId,
        items = [for (final f in session.files) UploadItem(f, sources[f.relativePath])],
        _chunks = chunkSender ?? ChunkSender.forApi(api),
        _backoff = backoff ?? _defaultBackoff,
        _sleep = sleep ?? Future<void>.delayed;

  final UploadApi api;

  /// Moves the bytes; off the UI isolate on desktop (see `IsolateChunkSender`).
  final ChunkSender _chunks;
  final String nodeUrl;
  final String sessionId;
  final List<UploadItem> items;

  /// True for S3 directories: a chunk is a numbered part there and the server
  /// reports which parts it has; for local directories a file is a plain
  /// append and `receivedBytes` says it all.
  final bool partsAddressedByNumber;
  final int parallelFiles;
  final int maxAttempts;
  final Duration Function(int attempt) _backoff;
  final Future<void> Function(Duration) _sleep;

  bool _paused = false;
  bool _cancelled = false;
  bool _running = false;

  bool get isPaused => _paused;
  bool get isRunning => _running;
  bool get isFinished => items.every((i) => !i.isOpen && i.phase != UploadItemPhase.completing);
  int get totalBytes => items.fold(0, (sum, i) => sum + i.state.size);
  int get sentBytes => items.fold(0, (sum, i) => sum + i.sentBytes);
  int get failedCount => items.where((i) => i.phase == UploadItemPhase.failed).length;

  static final Random _random = Random();

  static Duration _defaultBackoff(int attempt) {
    const steps = [2, 4, 8, 16, 32, 60, 60, 60];
    final base = steps[attempt.clamp(0, steps.length - 1)] * 1000;
    return Duration(milliseconds: base + (base * 0.2 * (_random.nextDouble() * 2 - 1)).round());
  }

  /// Completions in flight: a file whose bytes are all sent is completed in
  /// the background while its worker already streams the next one. `complete`
  /// is where a local directory fsyncs the whole file, seconds per gigabyte on
  /// a disk, and with equal-sized files every worker used to hit it at once —
  /// the link sat idle a third of the time.
  final Set<Future<void>> _completing = {};

  /// Runs until every file is done, failed or skipped, or until [pause].
  Future<void> start() async {
    if (_running) return;
    _running = true;
    _paused = false;
    notifyListeners();
    try {
      final queue = items.where((i) => i.isOpen && i.source != null).toList();
      var next = 0;
      Future<void> worker() async {
        while (!_paused && !_cancelled && next < queue.length) {
          // Each worker runs at most one file ahead of its completions: a server
          // that is slow to complete should slow the upload down, not pile up requests.
          while (_completing.length > parallelFiles) {
            await Future.any(_completing);
          }
          final finish = await _upload(queue[next++]);
          if (finish == null) continue;
          late final Future<void> tracked;
          tracked = finish().whenComplete(() => _completing.remove(tracked));
          _completing.add(tracked);
        }
      }

      await Future.wait([for (var i = 0; i < min(parallelFiles, queue.length); i++) worker()]);
      await Future.wait(_completing.toList());
    } finally {
      await _chunks.dispose();
      _running = false;
      notifyListeners();
    }
  }

  /// Stops after the chunks in flight; [start] continues from there.
  void pause() {
    _paused = true;
    notifyListeners();
  }

  /// Files that failed are tried again on the next [start].
  void retryFailed() {
    for (final item in items.where((i) => i.phase == UploadItemPhase.failed && i.source != null)) {
      item
        ..phase = UploadItemPhase.queued
        ..error = null;
    }
    notifyListeners();
  }

  /// Cancels the upload on the server, which removes what it staged.
  Future<void> cancel() async {
    _cancelled = true;
    _paused = true;
    notifyListeners();
    await api.abort(nodeUrl, sessionId);
    for (final item in items.where((i) => i.isOpen)) {
      item.phase = UploadItemPhase.failed;
    }
    notifyListeners();
  }

  /// Sends the file's chunks. Returns the completion to start and await — or
  /// null when paused, cancelled or failed before the last chunk went out.
  Future<Future<void> Function()?> _upload(UploadItem item) async {
    item.phase = UploadItemPhase.uploading;
    notifyListeners();
    try {
      await _sendChunks(item);
    } catch (e) {
      _fail(item, e);
      return null;
    }
    if (_paused || _cancelled) {
      item.phase = UploadItemPhase.queued;
      notifyListeners();
      return null;
    }
    item.phase = UploadItemPhase.completing;
    notifyListeners();
    return () => _finish(item);
  }

  Future<void> _finish(UploadItem item) async {
    try {
      // One resync is enough: it happens when a response got lost, not in a loop.
      for (var pass = 0; pass < 2; pass++) {
        try {
          final result = await _retrying(() => api.complete(nodeUrl, sessionId, item.state.fileId));
          item
            ..sentBytes = item.state.size
            ..phase = result.status == 'SKIPPED' ? UploadItemPhase.skipped : UploadItemPhase.done;
          return;
        } on UploadApiException catch (e) {
          if (e.statusCode != 409 || e.continueAt == null || pass == 1) rethrow;
          // "incomplete": the server has less than we think — send the rest again
          item.received = e.continueAt!;
          item.haveParts.clear();
          item.phase = UploadItemPhase.uploading;
          notifyListeners();
          await _sendChunks(item);
          if (_paused || _cancelled) {
            item.phase = UploadItemPhase.queued;
            return;
          }
          item.phase = UploadItemPhase.completing;
          notifyListeners();
        }
      }
    } catch (e) {
      _fail(item, e);
    } finally {
      notifyListeners();
    }
  }

  void _fail(UploadItem item, Object e) {
    item
      ..phase = UploadItemPhase.failed
      ..error = e is UploadApiException ? e.message : e.toString();
    notifyListeners();
  }

  /// Walks the chunk grid and sends what the server does not have yet.
  Future<void> _sendChunks(UploadItem item) async {
    final size = item.state.size;
    final chunkSize = item.state.chunkSize;
    var offset = 0;
    while (offset < size && !_paused && !_cancelled) {
      final end = min(offset + chunkSize, size);
      final part = offset ~/ chunkSize + 1;
      final alreadyThere = partsAddressedByNumber ? item.haveParts.contains(part) : end <= item.received;
      if (!alreadyThere) {
        try {
          final at = offset;
          final result = await _retrying(
              () => _chunks.send(nodeUrl, sessionId, item.state.fileId, offset: at, end: end, source: item.source!));
          item.received = result.receivedBytes;
          item.haveParts.add(part);
        } on UploadApiException catch (e) {
          if (e.statusCode != 409 || e.continueAt == null) rethrow;
          // Our idea of the offset was wrong (a lost response): continue where the server is.
          item.received = e.continueAt!;
          offset = item.received - item.received % chunkSize;
          item.sentBytes = item.received;
          notifyListeners();
          continue;
        }
      }
      offset = end;
      item.sentBytes = partsAddressedByNumber
          ? max(item.sentBytes, min(item.haveParts.length * chunkSize, size))
          : max(item.received, end);
      notifyListeners();
    }
  }

  /// Retries what is worth retrying: transport errors, 5xx, and 429 (after
  /// the pause the server asked for). Everything else goes to the caller.
  Future<T> _retrying<T>(Future<T> Function() call) async {
    for (var attempt = 0;; attempt++) {
      try {
        return await call();
      } on UploadApiException catch (e) {
        if (!e.isTransient || attempt + 1 >= maxAttempts || _cancelled) rethrow;
        await _sleep(e.retryAfter ?? _backoff(attempt));
      } on Exception catch (e) {
        // socket closed, timeout, DNS: the http client's own exception types
        if (attempt + 1 >= maxAttempts || _cancelled) {
          throw UploadApiException(0, e.toString());
        }
        await _sleep(_backoff(attempt));
      }
    }
  }
}
