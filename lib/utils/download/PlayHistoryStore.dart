import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';

/// One track play on this device. Carries the queue-item snapshot so the
/// music cache can download a recently played track without asking the
/// server for it again.
class PlayHistoryEntry {
  const PlayHistoryEntry({
    required this.trackId,
    required this.mediaFileId,
    required this.playedAt,
    required this.itemJson,
  });

  final String trackId;
  final String mediaFileId;
  final DateTime playedAt;
  final Map<String, dynamic> itemJson;

  Fragment$fragmentPlayQueue$playQueueItems get item =>
      Fragment$fragmentPlayQueue$playQueueItems.fromJson(itemJson);

  Map<String, dynamic> toJson() => {
        'trackId': trackId,
        'mediaFileId': mediaFileId,
        'playedAt': playedAt.toIso8601String(),
        'item': itemJson,
      };

  static PlayHistoryEntry fromJson(Map<String, dynamic> j) => PlayHistoryEntry(
        trackId: j['trackId'] as String,
        mediaFileId: j['mediaFileId'] as String,
        playedAt: DateTime.tryParse(j['playedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        itemJson: Map<String, dynamic>.from(j['item'] as Map),
      );
}

/// Recently played tracks per server, newest first, one entry per track
/// (a replay moves it to the front), capped — the cache limit is far below.
class PlayHistoryStore {
  PlayHistoryStore(this._store, {this.capacity = 2000});

  static PlayHistoryStore? _instance;
  static PlayHistoryStore get instance =>
      _instance ??= PlayHistoryStore(DownloadService.instance.store);

  static void resetForTest() => _instance = null;

  static const _fileName = 'play_history.json';
  final DownloadStore _store;
  final int capacity;
  final Map<String, List<PlayHistoryEntry>> _cache = {};

  Future<List<PlayHistoryEntry>> load(String server) async {
    final cached = _cache[server];
    if (cached != null) return cached;
    final list = <PlayHistoryEntry>[];
    final data = await _store.readJson(server, _fileName);
    if (data is List) {
      for (final e in data) {
        try {
          list.add(PlayHistoryEntry.fromJson(Map<String, dynamic>.from(e as Map)));
        } catch (_) {}
      }
    }
    return _cache[server] = list;
  }

  /// Newest first.
  Future<List<PlayHistoryEntry>> recent(String server, {int? limit}) async {
    final list = await load(server);
    return limit == null ? List.unmodifiable(list) : list.take(limit).toList();
  }

  Future<void> record(
      String server, Fragment$fragmentPlayQueue$playQueueItems item) async {
    final track = item.track;
    final mf = track?.mediaFile?.firstOrNull;
    if (track == null || mf == null) return;
    final list = await load(server);
    list.removeWhere((e) => e.trackId == track.id);
    list.insert(
        0,
        PlayHistoryEntry(
          trackId: track.id,
          mediaFileId: mf.id,
          playedAt: DateTime.now(),
          itemJson: item.toJson(),
        ));
    if (list.length > capacity) list.removeRange(capacity, list.length);
    await _save(server);
  }

  Future<void> clear(String server) async {
    _cache[server] = [];
    await _save(server);
  }

  Future<void> _save(String server) => _store.writeJson(
      server, _fileName, _cache[server]!.map((e) => e.toJson()).toList());
}
