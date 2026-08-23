import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';

/// Builds the synthetic play-queue items that downloads store as their
/// metadata snapshot. The kind-specific sub-objects come from the typed query
/// results of the pages (episode/movie fragments, the *ForDownload queries),
/// converted through JSON so the generated classes do the shape check.
class QueueItemFactory {
  QueueItemFactory._();

  static String itemId(DownloadKind kind, String mediaId) =>
      'local:${kind.name}:$mediaId';

  static Fragment$fragmentPlayQueue$playQueueItems fromJsonParts({
    required DownloadKind kind,
    required String mediaId,
    required Map<String, dynamic> json,
    double position = 0,
  }) {
    final field = switch (kind) {
      DownloadKind.track => 'track',
      DownloadKind.chapter => 'chapter',
      DownloadKind.podcastEpisode => 'podcastEpisode',
      DownloadKind.movie => 'movie',
      DownloadKind.episode => 'episode',
    };
    return Fragment$fragmentPlayQueue$playQueueItems.fromJson({
      '__typename': 'PlayQueueItem',
      'id': itemId(kind, mediaId),
      'position': position,
      'accessible': true,
      field: json,
    });
  }

  static DownloadKind kindOf(Fragment$fragmentPlayQueue$playQueueItems item) {
    if (item.track != null) return DownloadKind.track;
    if (item.chapter != null) return DownloadKind.chapter;
    if (item.podcastEpisode != null) return DownloadKind.podcastEpisode;
    if (item.movie != null) return DownloadKind.movie;
    return DownloadKind.episode;
  }

  static String mediaIdOf(Fragment$fragmentPlayQueue$playQueueItems item) =>
      item.track?.id ??
      item.chapter?.id ??
      item.podcastEpisode?.id ??
      item.movie?.id ??
      item.episode?.id ??
      '';

  static Fragment$fragmentMediaFiles? mediaFileOf(
          Fragment$fragmentPlayQueue$playQueueItems item) =>
      item.track?.mediaFile?.firstOrNull ??
      item.chapter?.mediaFile?.firstOrNull ??
      item.podcastEpisode?.mediaFile?.firstOrNull ??
      item.movie?.mediaFile?.firstOrNull ??
      item.episode?.mediaFile?.firstOrNull;
}
