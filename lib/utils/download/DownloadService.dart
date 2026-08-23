import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/QueueItemDisplay.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadPreferences.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/HlsDownloader.dart';
import 'package:player/utils/download/ComicDownloader.dart';
import 'package:player/utils/download/EpubDownloader.dart';
import 'package:player/utils/download/NetworkPolicy.dart';
import 'package:player/utils/download/QueueItemFactory.dart';

/// What a page asks to download: the play-queue item snapshot plus the
/// grouping the page knows better than the item does (a show's title, an
/// episode's "S2 E5" line).
class DownloadRequest {
  const DownloadRequest({
    required Fragment$fragmentPlayQueue$playQueueItems this.item,
    this.pinned = true,
    this.groupId,
    this.groupTitle,
    this.subtitle,
    this.sortKey,
    this.videoQuality,
    this.audioQuality,
  })  : bookId = null,
        mediaFileId = null,
        nodeUrl = null,
        title = null,
        format = null,
        mediaOverlays = false,
        pageCount = null,
        artworkUrl = null;

  /// An epub/comic file of a book, read rather than played.
  const DownloadRequest.book({
    required String this.bookId,
    required String this.mediaFileId,
    required String this.nodeUrl,
    required String this.title,
    required BookFormat this.format,
    String? author,
    this.artworkUrl,
    this.mediaOverlays = false,
    this.pageCount,
    this.pinned = true,
  })  : item = null,
        groupId = bookId,
        groupTitle = title,
        subtitle = author,
        sortKey = null,
        videoQuality = null,
        audioQuality = null;

  final Fragment$fragmentPlayQueue$playQueueItems? item;
  final String? bookId;
  final String? mediaFileId;
  final String? nodeUrl;
  final String? title;
  final BookFormat? format;
  final bool mediaOverlays;
  final int? pageCount;
  final String? artworkUrl;
  final bool pinned;
  final String? groupId;
  final String? groupTitle;
  final String? subtitle;
  final int? sortKey;
  final DownloadVideoQuality? videoQuality;
  final DownloadAudioQuality? audioQuality;
}

/// Owns the download queue: persists entries through [DownloadStore], runs
/// them through [HlsDownloader] a few at a time, and answers the playback
/// hot path's "is this media file on disk?" synchronously.
class DownloadService {
  DownloadService({
    DownloadStore? store,
    HlsDownloader? downloader,
    EpubDownloader? epubDownloader,
    ComicDownloader? comicDownloader,
    Future<bool> Function()? isUnmetered,
  })  : store = store ?? DownloadStore(),
        downloader = downloader ?? HlsDownloader(),
        epubDownloader = epubDownloader ?? EpubDownloader(),
        comicDownloader = comicDownloader ?? ComicDownloader(),
        _isUnmetered = isUnmetered ?? NetworkPolicy.isUnmetered;

  static DownloadService _instance = DownloadService();
  static DownloadService get instance => _instance;

  @visibleForTesting
  static set instance(DownloadService s) => _instance = s;

  final DownloadStore store;
  final HlsDownloader downloader;
  final EpubDownloader epubDownloader;
  final ComicDownloader comicDownloader;
  final Future<bool> Function() _isUnmetered;

  /// Bumped on every manifest change; list UIs rebuild on it.
  final ValueNotifier<int> revision = ValueNotifier(0);
  final ValueNotifier<bool> paused = ValueNotifier(false);

  /// Servers with at least one running download (for global indicators).
  final ValueNotifier<int> runningCount = ValueNotifier(0);

  final Map<String, DownloadCancelToken> _running = {};

  /// mediaFileId per running key: one file is never mirrored twice at once,
  /// however many episode entries share it.
  final Map<String, String> _runningFiles = {};
  final Map<String, ValueNotifier<DownloadProgress?>> _progress = {};
  Future<void>? _starting;
  bool _pumping = false;

  static String _runKey(String server, String key) => '$server|$key';

  /// Loads every manifest and resumes whatever was queued. Idempotent; a
  /// no-op on web.
  Future<void> ensureStarted() {
    if (kIsWeb) return Future.value();
    return _starting ??= () async {
      try {
        final servers = await store.loadAll();
        for (final server in servers) {
          for (final e in store.entries(server)) {
            if (e.status == DownloadStatus.downloading) {
              await store.put(server, e.copyWith(status: DownloadStatus.queued));
            }
          }
        }
        revision.value++;
        unawaited(_pump());
      } catch (e) {
        LoggerService().logger.e('download store failed to start: $e');
      }
    }();
  }

  // ---- queries -----------------------------------------------------------

  List<DownloadEntry> entriesFor(String server) => store.entries(server);

  DownloadEntry? entryFor(String server, String key) => store.get(server, key);

  /// The entry that best represents a media file on disk: a complete one
  /// wins over a downloading one over the rest (siblings share the files).
  DownloadEntry? entryForMediaFile(String server, String mediaFileId) {
    final siblings = _siblings(server, mediaFileId).toList();
    if (siblings.isEmpty) return null;
    int rank(DownloadEntry e) => switch (e.status) {
          DownloadStatus.complete => 0,
          DownloadStatus.downloading => 1,
          _ => 2,
        };
    siblings.sort((a, b) => rank(a).compareTo(rank(b)));
    return siblings.first;
  }

  Iterable<DownloadEntry> _siblings(String server, String mediaFileId,
          {String? except}) =>
      store
          .entries(server)
          .where((e) => e.mediaFileId == mediaFileId && e.key != except);

  /// Entries currently being downloaded, with their server.
  List<(String, DownloadEntry)> runningEntries() => [
        for (final runKey in _running.keys)
          () {
            final sep = runKey.indexOf('|');
            final server = runKey.substring(0, sep);
            final entry = store.get(server, runKey.substring(sep + 1));
            return entry == null ? null : (server, entry);
          }()
      ].whereType<(String, DownloadEntry)>().toList();

  /// Absolute path of the local master playlist — only for a complete
  /// download, and only once the store has started.
  String? localMasterFor(String server, String mediaFileId) {
    if (kIsWeb) return null;
    final entry = entryForMediaFile(server, mediaFileId);
    if (entry == null || !entry.isComplete || entry.isReading) return null;
    final dir = store.itemDirPathSync(server, mediaFileId);
    return dir == null ? null : '$dir/master.m3u8';
  }

  /// [localReadingDirFor] with the server's manifest loaded. Never waits for
  /// the store to come up: main() starts it at launch, and a reader opened
  /// before that (or under flutter test, where the platform directory lookup
  /// never completes) simply streams from the node.
  Future<String?> localReadingDir(String server, String mediaFileId) async {
    if (kIsWeb) return null;
    if (store.rootPathSync == null) {
      unawaited(ensureStarted());
      return null;
    }
    try {
      await store.load(server);
      return localReadingDirFor(server, mediaFileId);
    } catch (e) {
      LoggerService().logger.w('download store unavailable: $e');
      return null;
    }
  }

  /// Directory of a complete epub/comic mirror, for the readers.
  String? localReadingDirFor(String server, String mediaFileId) {
    if (kIsWeb) return null;
    final entry = entryForMediaFile(server, mediaFileId);
    if (entry == null || !entry.isReading || !entry.isComplete) return null;
    return store.itemDirPathSync(server, mediaFileId);
  }

  String? localArtworkFor(String server, String mediaFileId) {
    final entry = entryForMediaFile(server, mediaFileId);
    final dir = store.itemDirPathSync(server, mediaFileId);
    if (entry?.artworkFile == null || dir == null) return null;
    return '$dir/${entry!.artworkFile}';
  }

  /// `(streamId, absolute path)` of the mirrored SRT sidecars.
  List<(String, String)> localSubtitleFiles(String server, String mediaFileId) {
    final entry = entryForMediaFile(server, mediaFileId);
    final dir = store.itemDirPathSync(server, mediaFileId);
    if (entry == null || dir == null) return const [];
    return entry.subtitleStreamIds
        .map((id) => (id, '$dir/sub_$id.srt'))
        .toList();
  }

  ValueNotifier<DownloadProgress?> progressOf(String server, String key) =>
      _progress.putIfAbsent(_runKey(server, key), () => ValueNotifier(null));

  bool isRunning(String server, String key) =>
      _running.containsKey(_runKey(server, key));

  int bytesFor(String server, {bool? pinned}) => sumUniqueBytes(store
      .entries(server)
      .where((e) => pinned == null || e.pinned == pinned));

  // ---- mutations ---------------------------------------------------------

  Future<void> enqueue(String server, DownloadRequest request) =>
      enqueueAll(server, [request]);

  Future<void> enqueueAll(String server, List<DownloadRequest> requests) async {
    if (kIsWeb) return;
    await ensureStarted();
    await store.load(server);
    for (final req in requests) {
      final entry = _entryFrom(req);
      if (entry == null) continue;
      final existing = store.get(server, entry.key);
      if (existing == null) {
        await store.put(server, entry);
      } else if (existing.status == DownloadStatus.failed) {
        await store.put(
            server,
            existing.copyWith(
                status: DownloadStatus.queued,
                clearError: true,
                pinned: existing.pinned || req.pinned));
      } else if (req.pinned && !existing.pinned) {
        await store.put(server, existing.copyWith(pinned: true));
      }
    }
    revision.value++;
    unawaited(_pump());
  }

  /// Cancels a running/queued download and deletes whatever it wrote; also
  /// removes a complete one.
  Future<void> remove(String server, String key) async {
    final entry = store.get(server, key);
    if (entry == null) return;
    _running[_runKey(server, key)]?.cancel();
    await store.remove(server, key);
    // The files stay while another episode of the same media file needs them.
    if (_siblings(server, entry.mediaFileId).isEmpty) {
      await store.deleteItemDir(server, entry.mediaFileId);
    }
    _progress.remove(_runKey(server, key))?.value = null;
    revision.value++;
    unawaited(_pump());
  }

  Future<void> retry(String server, String key) async {
    final entry = store.get(server, key);
    if (entry == null || entry.status != DownloadStatus.failed) return;
    await store.put(server,
        entry.copyWith(status: DownloadStatus.queued, clearError: true));
    revision.value++;
    unawaited(_pump());
  }

  Future<void> pauseAll() async {
    paused.value = true;
    for (final t in _running.values) {
      t.cancel();
    }
  }

  Future<void> resumeAll() async {
    paused.value = false;
    unawaited(_pump());
  }

  /// Records that the local copy was played (cache eviction order).
  Future<void> touch(String server, String mediaFileId) async {
    final siblings = _siblings(server, mediaFileId).toList();
    if (siblings.isEmpty) return;
    try {
      final now = DateTime.now();
      for (final entry in siblings) {
        await store.put(server, entry.copyWith(lastPlayedAt: now));
      }
    } catch (e) {
      // Fire-and-forget from the playback hot path; a failed stamp is harmless.
      LoggerService().logger.w('could not stamp lastPlayedAt: $e');
    }
  }

  /// Drops cache (non-pinned) entries or everything for a server.
  Future<void> removeAll(String server, {bool onlyCache = false}) async {
    for (final e in store.entries(server)) {
      if (onlyCache && e.pinned) continue;
      await remove(server, e.key);
    }
  }

  // ---- internals ---------------------------------------------------------

  DownloadEntry? _entryFrom(DownloadRequest req) {
    final item = req.item;
    if (item == null) return _bookEntryFrom(req);
    final mf = QueueItemFactory.mediaFileOf(item);
    if (mf == null) return null;
    final kind = QueueItemFactory.kindOf(item);
    final mediaId = QueueItemFactory.mediaIdOf(item);
    final display = QueueItemDisplay.of(item);
    String groupId;
    String groupTitle;
    String? subtitle = req.subtitle ?? display.artist;
    var sortKey = req.sortKey ?? 0;
    switch (kind) {
      case DownloadKind.track:
        final t = item.track!;
        groupId = t.album.id;
        groupTitle = t.album.name;
        sortKey = req.sortKey ?? (t.discNumber * 1000 + t.number);
      case DownloadKind.chapter:
        final c = item.chapter!;
        groupId = c.book.id;
        groupTitle = display.album ?? c.book.title;
        sortKey = req.sortKey ?? c.number;
      case DownloadKind.podcastEpisode:
        final pe = item.podcastEpisode!;
        groupId = pe.podcast.id;
        groupTitle = pe.podcast.title;
        subtitle = req.subtitle ?? pe.publishedAt;
      case DownloadKind.movie:
        groupId = item.movie!.id;
        groupTitle = item.movie!.name;
        subtitle = req.subtitle;
      case DownloadKind.book:
        return _bookEntryFrom(req);
      case DownloadKind.episode:
        final ep = item.episode!;
        groupId = ep.$show?.id ?? ep.id;
        groupTitle = req.groupTitle ?? display.title;
        subtitle = req.subtitle;
    }
    return DownloadEntry(
      kind: kind,
      mediaId: mediaId,
      mediaFileId: mf.id,
      nodeUrl: mf.directory.node.url,
      groupId: req.groupId ?? groupId,
      groupTitle: req.groupTitle ?? groupTitle,
      title: display.title,
      subtitle: subtitle,
      sortKey: sortKey,
      durationMs: display.duration.inMilliseconds,
      queueItemJson: item.toJson(),
      createdAt: DateTime.now(),
      pinned: req.pinned,
      videoQuality: req.videoQuality,
      audioQuality: req.audioQuality ?? DownloadAudioQuality.original,
    );
  }

  DownloadEntry _bookEntryFrom(DownloadRequest req) => DownloadEntry(
        kind: DownloadKind.book,
        mediaId: req.mediaFileId!,
        mediaFileId: req.mediaFileId!,
        nodeUrl: req.nodeUrl!,
        groupId: req.bookId!,
        groupTitle: req.title!,
        title: req.title!,
        subtitle: req.subtitle,
        // Files sort after a book's chapters.
        sortKey: 1000000 + req.format!.index,
        createdAt: DateTime.now(),
        pinned: req.pinned,
        format: req.format,
        mediaOverlays: req.mediaOverlays,
        pageCount: req.pageCount,
        artworkUrl: req.artworkUrl,
      );

  Future<void> _pump() async {
    if (_pumping || paused.value) return;
    _pumping = true;
    try {
      for (final server in store.loadedServers.toList()) {
        final limit = await DownloadPreferences.getConcurrent(server);
        final unmeteredOnly = await DownloadPreferences.getUnmeteredOnly(server);
        bool? unmetered;
        final queued = store
            .entries(server)
            .where((e) => e.status == DownloadStatus.queued)
            .toList()
          ..sort((a, b) {
            if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
            return a.createdAt.compareTo(b.createdAt);
          });
        for (final entry in queued) {
          if (paused.value) return;
          if (_running.length >= limit) return;
          if (_runningFiles.values.contains(entry.mediaFileId)) continue;
          if (!entry.pinned && unmeteredOnly) {
            unmetered ??= await _isUnmetered();
            if (!unmetered) continue;
          }
          unawaited(_run(server, entry));
        }
      }
    } finally {
      _pumping = false;
    }
  }

  Future<void> _run(String server, DownloadEntry entry) async {
    final runKey = _runKey(server, entry.key);
    if (_running.containsKey(runKey)) return;
    final cancel = DownloadCancelToken();
    _running[runKey] = cancel;
    _runningFiles[runKey] = entry.mediaFileId;
    runningCount.value = _running.length;
    final progress = progressOf(server, entry.key);
    try {
      // Another episode of the same file already mirrored it: adopt its result.
      final done = _siblings(server, entry.mediaFileId, except: entry.key)
          .where((e) => e.isComplete)
          .firstOrNull;
      if (done != null) {
        await store.put(server, _adoptResult(entry, done));
        return;
      }
      await store.put(server, entry.copyWith(status: DownloadStatus.downloading, clearError: true));
      revision.value++;
      if (entry.isReading) {
        await _runReading(server, entry, cancel, progress);
        return;
      }
      final item = entry.queueItem;
      final mf = QueueItemFactory.mediaFileOf(item);
      final videoQuality = entry.videoQuality ??
          await DownloadPreferences.getVideoQuality(server);
      List<String> spoken = const [];
      try {
        spoken = await LanguagePreferences.getSpokenLanguages(serverName: server);
      } catch (_) {}
      final selection = DownloadSelection(
        videoQuality: videoQuality,
        audioQuality: entry.audioQuality,
        spokenLanguages: spoken,
        downloadSubtitles: await DownloadPreferences.getDownloadSubtitles(server),
      );
      final dir = await store.itemDir(server, entry.mediaFileId);
      final result = await downloader.download(
        serverName: server,
        dir: dir,
        nodeUrl: entry.nodeUrl,
        mediaFileId: entry.mediaFileId,
        streams: mf?.mediaFileStreams,
        selection: selection,
        artworkUrl: QueueItemDisplay.of(item).artUrl,
        cancel: cancel,
        onProgress: (p) {
          progress.value = p;
        },
      );
      final current = store.get(server, entry.key);
      if (current == null) return; // removed meanwhile
      final completed = current.copyWith(
        status: DownloadStatus.complete,
        bytes: result.bytes,
        segmentsDone: result.segmentsDone,
        segmentsTotal: result.segmentsTotal,
        audioStreamIndexes: result.audioStreamIndexes,
        subtitleStreamIds: result.subtitleStreamIds,
        artworkFile: result.artworkFile,
        downloadedAt: DateTime.now(),
        videoQuality: videoQuality,
        clearError: true,
      );
      await store.put(server, completed);
      // Siblings waiting on the same file are done too.
      for (final s in _siblings(server, entry.mediaFileId, except: entry.key)
          .where((e) => !e.isComplete && e.status != DownloadStatus.downloading)
          .toList()) {
        await store.put(server, _adoptResult(s, completed));
      }
    } on DownloadCancelled {
      final current = store.get(server, entry.key);
      if (current != null) {
        await store.put(server, current.copyWith(
            status: DownloadStatus.queued,
            bytes: await _bytesOnDisk(server, entry.mediaFileId),
            segmentsDone: progress.value?.segmentsDone,
            segmentsTotal: progress.value?.segmentsTotal));
      }
    } catch (e) {
      final current = store.get(server, entry.key);
      if (current != null) {
        final message = e is DownloadFailure
            ? (e.noSpace ? 'no-space' : e.message)
            : e.toString();
        LoggerService().logger.w('download failed for ${entry.key}: $e');
        await store.put(server, current.copyWith(
            status: DownloadStatus.failed,
            error: message,
            bytes: await _bytesOnDisk(server, entry.mediaFileId),
            segmentsDone: progress.value?.segmentsDone,
            segmentsTotal: progress.value?.segmentsTotal));
      }
    } finally {
      _running.remove(runKey);
      _runningFiles.remove(runKey);
      runningCount.value = _running.length;
      progress.value = null;
      revision.value++;
      unawaited(_pump());
    }
  }

  Future<void> _runReading(String server, DownloadEntry entry,
      DownloadCancelToken cancel, ValueNotifier<DownloadProgress?> progress) async {
    final dir = await store.itemDir(server, entry.mediaFileId);
    final ReadingDownloadResult result;
    switch (entry.format) {
      case BookFormat.epub:
        result = await epubDownloader.download(
          serverName: server,
          dir: dir,
          nodeUrl: entry.nodeUrl,
          mediaFileId: entry.mediaFileId,
          artworkUrl: entry.artworkUrl,
          cancel: cancel,
          onProgress: (p) => progress.value = p,
        );
      case BookFormat.cbz:
      case BookFormat.pdf:
        result = await comicDownloader.download(
          serverName: server,
          dir: dir,
          nodeUrl: entry.nodeUrl,
          mediaFileId: entry.mediaFileId,
          artworkUrl: entry.artworkUrl,
          cancel: cancel,
          onProgress: (p) => progress.value = p,
        );
      case null:
        throw DownloadFailure('reading entry without a format');
    }
    final current = store.get(server, entry.key);
    if (current == null) return;
    await store.put(
        server,
        current.copyWith(
          status: DownloadStatus.complete,
          bytes: result.bytes,
          segmentsDone: result.itemsDone,
          segmentsTotal: result.itemsTotal,
          artworkFile: result.artworkFile,
          pageCount: current.pageCount ?? (current.format == BookFormat.epub ? null : result.itemsTotal),
          downloadedAt: DateTime.now(),
          clearError: true,
        ));
  }

  /// [entry] marked complete with the on-disk result of [done], which
  /// mirrored the same media file.
  static DownloadEntry _adoptResult(DownloadEntry entry, DownloadEntry done) =>
      entry.copyWith(
        status: DownloadStatus.complete,
        bytes: done.bytes,
        segmentsDone: done.segmentsDone,
        segmentsTotal: done.segmentsTotal,
        audioStreamIndexes: done.audioStreamIndexes,
        subtitleStreamIds: done.subtitleStreamIds,
        artworkFile: done.artworkFile,
        downloadedAt: DateTime.now(),
        videoQuality: done.videoQuality,
        clearError: true,
      );

  /// Pretends a download is (not) running — for tests of the notifiers.
  @visibleForTesting
  void debugSetRunning(String server, String key, bool running) {
    final runKey = _runKey(server, key);
    if (running) {
      _running[runKey] = DownloadCancelToken();
      _runningFiles[runKey] = store.get(server, key)?.mediaFileId ?? '';
    } else {
      _running.remove(runKey);
      _runningFiles.remove(runKey);
    }
    runningCount.value = _running.length;
  }

  Future<int> _bytesOnDisk(String server, String mediaFileId) async {
    final path = store.itemDirPathSync(server, mediaFileId);
    if (path == null) return 0;
    return DownloadStore.dirSize(Directory(path));
  }
}
