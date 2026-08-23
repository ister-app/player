import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/QueueItemFactory.dart';

/// Progress made while playing from the local queue (server unreachable),
/// replayed to the server by `OfflineSyncService` once it is back.
class OfflineProgressEntry {
  const OfflineProgressEntry({
    required this.kind,
    required this.mediaId,
    required this.sourceType,
    required this.sourceId,
    required this.positionMs,
    required this.durationMs,
    required this.finished,
    required this.updatedAt,
    required this.synced,
  });

  final DownloadKind kind;
  final String mediaId;
  final Enum$PlayQueueSourceType sourceType;
  final String sourceId;
  final int positionMs;
  final int durationMs;
  final bool finished;
  final DateTime updatedAt;
  final bool synced;

  String get key => DownloadEntry.keyFor(kind, mediaId);

  OfflineProgressEntry copyWith({
    int? positionMs,
    int? durationMs,
    bool? finished,
    DateTime? updatedAt,
    bool? synced,
  }) =>
      OfflineProgressEntry(
        kind: kind,
        mediaId: mediaId,
        sourceType: sourceType,
        sourceId: sourceId,
        positionMs: positionMs ?? this.positionMs,
        durationMs: durationMs ?? this.durationMs,
        finished: finished ?? this.finished,
        updatedAt: updatedAt ?? this.updatedAt,
        synced: synced ?? this.synced,
      );

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'mediaId': mediaId,
        'sourceType': sourceType.name,
        'sourceId': sourceId,
        'positionMs': positionMs,
        'durationMs': durationMs,
        'finished': finished,
        'updatedAt': updatedAt.toIso8601String(),
        'synced': synced,
      };

  static OfflineProgressEntry fromJson(Map<String, dynamic> j) =>
      OfflineProgressEntry(
        kind: DownloadKind.values.byName(j['kind'] as String),
        mediaId: j['mediaId'] as String,
        sourceType:
            Enum$PlayQueueSourceType.values.byName(j['sourceType'] as String),
        sourceId: j['sourceId'] as String,
        positionMs: (j['positionMs'] as num).toInt(),
        durationMs: (j['durationMs'] as num?)?.toInt() ?? 0,
        finished: j['finished'] as bool? ?? false,
        updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? '') ??
            DateTime.now(),
        synced: j['synced'] as bool? ?? false,
      );

  /// The server-side queue source that replays this item: the container the
  /// item belongs to, started at the item.
  static (Enum$PlayQueueSourceType, String)? sourceOf(
      Fragment$fragmentPlayQueue$playQueueItems item) {
    if (item.track != null) {
      return (Enum$PlayQueueSourceType.ALBUM, item.track!.album.id);
    }
    if (item.chapter != null) {
      return (Enum$PlayQueueSourceType.BOOK, item.chapter!.book.id);
    }
    if (item.podcastEpisode != null) {
      return (Enum$PlayQueueSourceType.PODCAST, item.podcastEpisode!.podcast.id);
    }
    if (item.movie != null) {
      return (Enum$PlayQueueSourceType.MOVIE, item.movie!.id);
    }
    final show = item.episode?.$show?.id;
    if (show != null) return (Enum$PlayQueueSourceType.SHOW, show);
    return null;
  }
}

class OfflineProgressStore {
  OfflineProgressStore(this._store);

  static OfflineProgressStore? _instance;
  static OfflineProgressStore get instance =>
      _instance ??= OfflineProgressStore(DownloadService.instance.store);

  static void resetForTest() => _instance = null;

  static const _fileName = 'offline_progress.json';
  final DownloadStore _store;
  final Map<String, Map<String, OfflineProgressEntry>> _cache = {};

  Future<Map<String, OfflineProgressEntry>> load(String server) async {
    final cached = _cache[server];
    if (cached != null) return cached;
    final map = <String, OfflineProgressEntry>{};
    final data = await _store.readJson(server, _fileName);
    if (data is List) {
      for (final e in data) {
        try {
          final entry =
              OfflineProgressEntry.fromJson(Map<String, dynamic>.from(e as Map));
          map[entry.key] = entry;
        } catch (_) {}
      }
    }
    return _cache[server] = map;
  }

  /// Synchronous lookup from the in-memory copy (null until [load] ran).
  OfflineProgressEntry? get(String server, String key) => _cache[server]?[key];

  List<OfflineProgressEntry> unsynced(String server) =>
      (_cache[server]?.values ?? const Iterable<OfflineProgressEntry>.empty())
          .where((e) => !e.synced)
          .toList()
        ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

  Future<void> record(
    String server,
    Fragment$fragmentPlayQueue$playQueueItems item, {
    required int positionMs,
    required int durationMs,
    bool finished = false,
  }) async {
    final source = OfflineProgressEntry.sourceOf(item);
    if (source == null) return;
    final map = await load(server);
    final kind = QueueItemFactory.kindOf(item);
    final mediaId = QueueItemFactory.mediaIdOf(item);
    final key = DownloadEntry.keyFor(kind, mediaId);
    final existing = map[key];
    map[key] = (existing ??
            OfflineProgressEntry(
              kind: kind,
              mediaId: mediaId,
              sourceType: source.$1,
              sourceId: source.$2,
              positionMs: 0,
              durationMs: durationMs,
              finished: false,
              updatedAt: DateTime.now(),
              synced: false,
            ))
        .copyWith(
      positionMs: positionMs,
      durationMs: durationMs,
      finished: finished || (existing?.finished ?? false) && positionMs == 0,
      updatedAt: DateTime.now(),
      synced: false,
    );
    await _save(server);
  }

  Future<void> markSynced(String server, String key) async {
    final map = await load(server);
    final e = map[key];
    if (e == null) return;
    map[key] = e.copyWith(synced: true);
    await _save(server);
  }

  Future<void> _save(String server) => _store.writeJson(
      server, _fileName, _cache[server]!.values.map((e) => e.toJson()).toList());
}
