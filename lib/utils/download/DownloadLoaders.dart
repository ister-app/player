import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/graphql/albumForDownload.graphql.dart';
import 'package:player/graphql/bookForDownload.graphql.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/fragmentPodcast.graphql.dart';
import 'package:player/graphql/fragmentPodcastEpisode.graphql.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:player/graphql/trackForDownload.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/QueueItemFactory.dart';

/// A download the app refuses (for now) rather than one that failed.
class DownloadUnsupported implements Exception {
  const DownloadUnsupported.multiPart() : multiPart = true;
  final bool multiPart;
}

/// Turns what the pages have (ids, page fragments) into the full play-queue
/// item snapshots a download stores — fetching the *ForDownload shapes where
/// the page's own fragment is too thin (tracks, chapters lack the node url).
class DownloadLoaders {
  DownloadLoaders._();

  static Future<List<DownloadRequest>> track(
      GraphQLClient client, String trackId) async {
    final r = await client.query(QueryOptions(
        document: documentNodeQuerytrackForDownload,
        variables: {'id': trackId},
        fetchPolicy: FetchPolicy.networkOnly));
    if (r.hasException) throw r.exception!;
    final t = Query$trackForDownload.fromJson(r.data!).trackById;
    if (t == null || (t.mediaFile?.isEmpty ?? true)) return const [];
    return [
      DownloadRequest(
          item: QueueItemFactory.fromJsonParts(
              kind: DownloadKind.track, mediaId: t.id, json: t.toJson()))
    ];
  }

  static Future<List<DownloadRequest>> album(
      GraphQLClient client, String albumId) async {
    final r = await client.query(QueryOptions(
        document: documentNodeQueryalbumForDownload,
        variables: {'id': albumId},
        fetchPolicy: FetchPolicy.networkOnly));
    if (r.hasException) throw r.exception!;
    final album = Query$albumForDownload.fromJson(r.data!).albumById;
    if (album == null) return const [];
    return [
      for (final t in album.tracks ?? const [])
        if (t.mediaFile?.isNotEmpty ?? false)
          DownloadRequest(
              item: QueueItemFactory.fromJsonParts(
                  kind: DownloadKind.track, mediaId: t.id, json: t.toJson()))
    ];
  }

  static Future<List<DownloadRequest>> book(
      GraphQLClient client, String bookId) async {
    final r = await client.query(QueryOptions(
        document: documentNodeQuerybookForDownload,
        variables: {'id': bookId},
        fetchPolicy: FetchPolicy.networkOnly));
    if (r.hasException) throw r.exception!;
    final book = Query$bookForDownload.fromJson(r.data!).bookById;
    if (book == null) return const [];
    return [
      for (final c in book.chapters ?? const [])
        if (c.mediaFile?.isNotEmpty ?? false)
          DownloadRequest(
              item: QueueItemFactory.fromJsonParts(
                  kind: DownloadKind.chapter, mediaId: c.id, json: c.toJson()))
    ];
  }

  /// The show's display name, for grouping episodes on the downloads page.
  static Future<String?> showTitle(GraphQLClient client, String showId) async {
    final r = await client.query(QueryOptions(
        document: documentNodeQueryshowById, variables: {'id': showId}));
    if (r.hasException) return null;
    return Query$showById.fromJson(r.data!).showById?.name;
  }

  static Future<List<DownloadRequest>> episode(
      GraphQLClient client, String episodeId,
      {String? groupTitle}) async {
    final r = await client.query(QueryOptions(
        document: documentNodeQueryepisodeById,
        variables: {'id': episodeId},
        fetchPolicy: FetchPolicy.networkOnly));
    if (r.hasException) throw r.exception!;
    final ep = Query$episodeById.fromJson(r.data!).episodeById;
    if (ep == null || (ep.mediaFile?.isEmpty ?? true)) return const [];
    return [episodeRequest(ep.toJson(), ep.id, ep.number, groupTitle: groupTitle)];
  }

  /// From a page's own `fragmentEpisode` (same shape as the queue item's).
  static DownloadRequest episodeRequest(
      Map<String, dynamic> episodeJson, String episodeId, int number,
      {String? groupTitle}) {
    final item = QueueItemFactory.fromJsonParts(
        kind: DownloadKind.episode, mediaId: episodeId, json: episodeJson);
    final ep = item.episode!;
    // An episode inside a multi-episode file would need the whole file plus
    // the part bounds; refused until that is supported.
    if ((ep.mediaFile?.firstOrNull?.episodes?.length ?? 0) > 1) {
      throw const DownloadUnsupported.multiPart();
    }
    return DownloadRequest(
      item: item,
      groupTitle: groupTitle,
      subtitle: IsterMediaService.loc.episode(number),
      sortKey: number,
    );
  }

  /// A podcast episode from the page's fragments: the queue-item shape also
  /// carries the podcast, which the episode fragment does not.
  static DownloadRequest podcastEpisode(
      Fragment$fragmentPodcastEpisode episode, Fragment$fragmentPodcast podcast) {
    final json = {
      ...episode.toJson(),
      'podcast': {
        '__typename': 'Podcast',
        'id': podcast.id,
        'title': podcast.title,
        'author': podcast.author,
        'images': podcast.images?.map((i) => i.toJson()).toList(),
      },
    };
    final publishedAt = episode.publishedAt ?? '';
    return DownloadRequest(
      item: QueueItemFactory.fromJsonParts(
          kind: DownloadKind.podcastEpisode, mediaId: episode.id, json: json),
      subtitle: publishedAt.split('T').firstOrNull,
      // Newest first is how the podcast page lists them.
      sortKey: -(DateTime.tryParse(publishedAt)?.millisecondsSinceEpoch ?? 0) ~/ 1000,
    );
  }
}
