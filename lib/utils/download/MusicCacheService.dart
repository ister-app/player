import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/MusicCachePreferences.dart';
import 'package:player/utils/download/PlayHistoryStore.dart';

class MusicCachePlan {
  const MusicCachePlan({required this.toDownload, required this.toEvict});

  /// History entries to fetch, newest first.
  final List<PlayHistoryEntry> toDownload;

  /// Cache entries to delete, least recently played first.
  final List<DownloadEntry> toEvict;

  bool get isEmpty => toDownload.isEmpty && toEvict.isEmpty;
}

/// Decides what the cache should hold given the play history and what is on
/// disk. Pure, so the rules are unit-tested without files:
///
/// * keep = the [maxTracks] most recently played tracks;
/// * every non-pinned track outside keep is evicted (oldest play first), and
///   more are evicted while the pinned + cached bytes exceed [maxBytes];
/// * the rest of keep is downloaded, newest first, while the projected size
///   stays under [maxBytes] — so the lower of the two limits wins.
///
/// Pinned (manual) downloads, the file currently playing and running
/// downloads are never evicted.
MusicCachePlan planMusicCache({
  required List<PlayHistoryEntry> history,
  required List<DownloadEntry> entries,
  required int maxTracks,
  required int maxBytes,
  int avgTrackBytesEstimate = 8 * 1000 * 1000,
  Set<String> protectedMediaFileIds = const {},
}) {
  final keep = <String>{};
  final keepOrder = <PlayHistoryEntry>[];
  for (final h in history) {
    if (keep.length >= maxTracks) break;
    if (keep.add(h.mediaFileId)) keepOrder.add(h);
  }

  final cached = entries
      .where((e) => e.kind == DownloadKind.track && !e.pinned)
      .toList();
  final lastPlayed = {
    for (final h in history) h.mediaFileId: h.playedAt,
  };
  DateTime playedAt(DownloadEntry e) =>
      e.lastPlayedAt ?? lastPlayed[e.mediaFileId] ?? e.createdAt;
  bool evictable(DownloadEntry e) =>
      !protectedMediaFileIds.contains(e.mediaFileId) &&
      e.status != DownloadStatus.downloading;

  final toEvict = <DownloadEntry>[];
  // 1. Out of the keep set.
  final outside = cached
      .where((e) => !keep.contains(e.mediaFileId) && evictable(e))
      .toList()
    ..sort((a, b) => playedAt(a).compareTo(playedAt(b)));
  toEvict.addAll(outside);

  // 2. Over the byte budget (pinned bytes count, they are just untouchable).
  var bytes = entries.fold(0, (s, e) => s + e.bytes) -
      toEvict.fold(0, (s, e) => s + e.bytes);
  final inside = cached
      .where((e) => keep.contains(e.mediaFileId) && evictable(e))
      .toList()
    ..sort((a, b) => playedAt(a).compareTo(playedAt(b)));
  for (final e in inside) {
    if (bytes <= maxBytes) break;
    toEvict.add(e);
    bytes -= e.bytes;
  }
  final evicted = toEvict.map((e) => e.mediaFileId).toSet();

  // 3. Fill, newest first, within the remaining budget.
  final present = {
    for (final e in entries)
      if (!evicted.contains(e.mediaFileId)) e.mediaFileId
  };
  final known = cached.where((e) => e.bytes > 0).toList();
  final estimate = known.isEmpty
      ? avgTrackBytesEstimate
      : known.fold(0, (s, e) => s + e.bytes) ~/ known.length;
  final toDownload = <PlayHistoryEntry>[];
  for (final h in keepOrder) {
    if (present.contains(h.mediaFileId)) continue;
    if (bytes + estimate > maxBytes) break;
    toDownload.add(h);
    bytes += estimate;
  }
  return MusicCachePlan(toDownload: toDownload, toEvict: toEvict);
}

/// Keeps the per-server music cache in line with its settings: runs the
/// planner after plays, on settings changes, at start and periodically, and
/// turns the plan into removals and (unpinned) download requests.
class MusicCacheService {
  MusicCacheService({DownloadService? downloads, PlayHistoryStore? history})
      : _downloads = downloads,
        _history = history;

  static MusicCacheService instance = MusicCacheService();

  final DownloadService? _downloads;
  final PlayHistoryStore? _history;
  DownloadService get downloads => _downloads ?? DownloadService.instance;
  PlayHistoryStore get history => _history ?? PlayHistoryStore.instance;

  final Map<String, Timer> _debounce = {};
  final Set<String> _running = {};
  final Set<String> _rerun = {};
  Timer? _periodic;

  /// Schedules a run shortly (coalescing bursts, e.g. a queue skipping on).
  void schedule(String server, {Duration delay = const Duration(seconds: 5)}) {
    if (kIsWeb) return;
    _debounce[server]?.cancel();
    _debounce[server] = Timer(delay, () => unawaited(run(server)));
  }

  /// Starts the periodic sweep once (every 6 hours, for every loaded server).
  void ensurePeriodic() {
    if (kIsWeb) return;
    _periodic ??= Timer.periodic(const Duration(hours: 6), (_) {
      for (final server in downloads.store.loadedServers.toList()) {
        schedule(server, delay: Duration.zero);
      }
    });
  }

  /// Brings [server]'s cache in line with its settings now. Serialized per
  /// server; a call during a run queues one more run.
  Future<void> run(String server, {String? playingMediaFileId}) async {
    if (kIsWeb) return;
    if (_running.contains(server)) {
      _rerun.add(server);
      return;
    }
    _running.add(server);
    try {
      final settings = await MusicCachePreferences.get(server);
      if (!settings.enabled) return;
      await downloads.ensureStarted();
      await downloads.store.load(server);
      final plan = planMusicCache(
        history: await history.recent(server),
        entries: downloads.entriesFor(server),
        maxTracks: settings.maxTracks,
        maxBytes: settings.maxBytes,
        protectedMediaFileIds: {
          if (playingMediaFileId != null) playingMediaFileId,
        },
      );
      for (final e in plan.toEvict) {
        await downloads.remove(server, e.key);
      }
      if (plan.toDownload.isNotEmpty) {
        await downloads.enqueueAll(server, [
          for (final h in plan.toDownload)
            DownloadRequest(
                item: h.item, pinned: false, audioQuality: settings.quality),
        ]);
      }
    } catch (e) {
      LoggerService().logger.w('music cache run failed for $server: $e');
    } finally {
      _running.remove(server);
      if (_rerun.remove(server)) unawaited(run(server));
    }
  }

  /// Drops every cached (non-pinned) track of [server].
  Future<void> clear(String server) =>
      downloads.removeAll(server, onlyCache: true);
}
