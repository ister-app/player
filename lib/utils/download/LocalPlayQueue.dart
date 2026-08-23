import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentWatchStatus.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';

/// A play queue that lives only on this device: the downloaded items of one
/// group (album, show, podcast, book) or a single movie, rebuilt from their
/// snapshots. Its id carries the `local:` prefix every server-bound code path
/// in the handler checks for.
class LocalPlayQueue {
  LocalPlayQueue._();

  static const String idPrefix = 'local:';

  static bool isLocal(String? playQueueId) =>
      playQueueId?.startsWith(idPrefix) ?? false;

  static int _counter = 0;

  static Fragment$fragmentPlayQueue build(
    String server,
    List<DownloadEntry> entries, {
    required String startKey,
    OfflineProgressStore? progress,
  }) {
    final sorted = entries.where((e) => e.isComplete && !e.isReading).toList()
      ..sort((a, b) => a.sortKey.compareTo(b.sortKey));
    final items = <Fragment$fragmentPlayQueue$playQueueItems>[];
    for (var i = 0; i < sorted.length; i++) {
      final e = sorted[i];
      var item = e.queueItem.copyWith(position: i.toDouble());
      final local = progress?.get(server, e.key);
      if (local != null) item = _withLocalProgress(item, local);
      items.add(item);
    }
    final start = sorted.indexWhere((e) => e.key == startKey);
    final current = items.isEmpty ? null : items[start < 0 ? 0 : start];
    return Fragment$fragmentPlayQueue(
      id: '$idPrefix$server:${++_counter}',
      currentItemId: current?.id,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: items,
    );
  }

  /// Long-form audio resumes from `watchStatus` — patch the snapshot's with
  /// what was played offline so the handler's resume rule applies.
  static Fragment$fragmentPlayQueue$playQueueItems _withLocalProgress(
      Fragment$fragmentPlayQueue$playQueueItems item,
      OfflineProgressEntry local) {
    final ws = [
      Fragment$fragmentWatchStatus(
        id: 'local',
        playQueueItemId: item.id,
        progressInMilliseconds: local.positionMs,
        watched: local.finished,
      )
    ];
    if (item.chapter != null) {
      return item.copyWith(chapter: item.chapter!.copyWith(watchStatus: ws));
    }
    if (item.podcastEpisode != null) {
      return item.copyWith(
          podcastEpisode: item.podcastEpisode!.copyWith(watchStatus: ws));
    }
    return item;
  }
}
