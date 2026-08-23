import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';
import 'package:player/utils/download/ReadingProgressOutbox.dart';

/// Replays progress made offline to the server: one play queue per item
/// (created at the item, like a normal start) plus one progress update. One
/// queue per offline play keeps the server's play counts honest — it counts
/// distinct queue items.
class OfflineSyncService {
  OfflineSyncService._();

  static final Set<String> _syncedThisRun = {};

  /// Syncs [server]'s pending entries; returns how many were replayed.
  /// Without [force] each server is attempted once per app run (the shell
  /// calls it on every successful connect).
  static Future<int> trySync(String server,
      {bool force = false, GraphQLClient? client}) async {
    if (kIsWeb) return 0;
    if (!force && _syncedThisRun.contains(server)) return 0;
    _syncedThisRun.add(server);
    final store = OfflineProgressStore.instance;
    await store.load(server);
    var synced = await ReadingProgressOutbox.instance.replay(server);
    final pending = store.unsynced(server);
    if (pending.isEmpty) return synced;
    final gql = client ?? ClientManager.getClientForUrl(server).value;
    final service = PlayQueueService();
    for (final e in pending) {
      try {
        final pq = await service.createPlayQueue(gql,
            sourceType: e.sourceType, sourceId: e.sourceId, startId: e.mediaId);
        // createPlayQueue swallows transport errors into null.
        if (pq == null) throw StateError('createPlayQueue failed');
        final item = PlayQueueService.itemForMedia(
            PlayQueueService.sortedItems(pq), e.mediaId);
        if (item == null) {
          // The server no longer has the item; nothing to report.
          await store.markSynced(server, e.key);
          continue;
        }
        // A finished item reports its full length so the server marks it
        // watched; otherwise the resume position.
        final position = e.finished && e.durationMs > 0
            ? e.durationMs
            : e.positionMs;
        await service.updateProgress(
            gql, pq.id, item.id, Duration(milliseconds: position),
            playState: Enum$PlayState.PAUSED);
        await store.markSynced(server, e.key);
        synced++;
      } catch (err) {
        LoggerService().logger.w('offline sync stopped at ${e.key}: $err');
        _syncedThisRun.remove(server);
        break;
      }
    }
    return synced;
  }

  @visibleForTesting
  static void resetForTest() => _syncedThisRun.clear();
}
