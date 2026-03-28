import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';

import '../graphql/episodesRecentWatchedQuery.graphql.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';
import '../utils/StreamTokenService.dart';
import '../utils/MetadataUtil.dart';

class IsterMediaService {
  Future<List<IsterMediaItem>> getItemsByParentId(String id) async {
    MediaItemId mediaItemId = MediaItemId.byStringId(id);

    return switch(mediaItemId.isterMediaType) {
      IsterMediaTypes.episode => getEpisode(mediaItemId),
      IsterMediaTypes.show => List.empty(),
      IsterMediaTypes.list => getList(mediaItemId),
      IsterMediaTypes.movie => List.empty(),
    };
  }

  Future<List<IsterMediaItem>> getList(MediaItemId mediaItemId) async {
    if (mediaItemId.id == "recent") {
      return getRecent(mediaItemId);
    } else {
      LoggerService().logger.w('getList: unsupported list type "${mediaItemId.id}" for ${mediaItemId.serverName}');
      return List.empty();
    }
  }

  Future<List<IsterMediaItem>> getRecent(MediaItemId mediaItemId) async {
    GraphQLClient client = await getClient(mediaItemId.serverName);

    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryrecentlyWatched,
    ));

    LoggerService().logger.e(result);
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return List.empty();
    }
    final items = Query$recentlyWatched
        .fromJson(result.data!)
        .recentlyWatched;
    if (items == null) return List.empty();

    return items.map((e) {
      if (e.type == Enum$MediaType.EPISODE && e.episode != null) {
        final ep = e.episode!;
        return IsterMediaItem(
          id: ep.id,
          title: MetadataUtil.getTitle(ep.metadata) ?? "unknown",
          duration: Duration(
              milliseconds: ep.mediaFile?.first.durationInMilliseconds ?? 0),
          serverName: mediaItemId.serverName,
          isterMediaType: IsterMediaTypes.episode,
          stubTitle: 'Ister',
          artUri: artUriFromImages(ep.images, mediaItemId.serverName),
        );
      } else {
        final mv = e.movie!;
        return IsterMediaItem(
          id: mv.id,
          title: mv.name,
          duration: Duration(
              milliseconds: mv.mediaFile?.first.durationInMilliseconds ?? 0),
          serverName: mediaItemId.serverName,
          isterMediaType: IsterMediaTypes.movie,
          stubTitle: 'Ister',
          artUri: artUriFromImages(mv.images, mediaItemId.serverName),
        );
      }
    }).toList();
  }

  Future<Fragment$fragmentEpisode?> getEpisodeFragmentById(
      MediaItemId mediaItemId) async {
    GraphQLClient client = await getClient(mediaItemId.serverName);

    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryepisodeById,
      variables: {'id': mediaItemId.id},
    ));

    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$episodeById.fromJson(result.data!).episodeById;
  }

  Future<List<IsterMediaItem>> getEpisode(MediaItemId mediaItemId) async {
    final data = await getEpisodeFragmentById(mediaItemId);
    if (data == null) return List.empty();
    IsterMediaItem isterMediaItem = IsterMediaItem(
      id: data.id,
      title: MetadataUtil.getTitle(data.metadata) ?? "unknown",
      duration: Duration(
          milliseconds: data.mediaFile?.first.durationInMilliseconds ?? 0),
      serverName: mediaItemId.serverName,
      isterMediaType: mediaItemId.isterMediaType,
      stubTitle: 'Ister',
      artUri: artUriFromImages(data.images, mediaItemId.serverName),
    );
    return {isterMediaItem}.toList();
  }

  static Uri? artUriFromImages(List<Fragment$fragmentImages>? images,
      String serverName) {
    final imageByType = ImageUtil.getImageByType(images, ImageTypes.background);
    final url = ImageUtil.buildUrl(imageByType, token: StreamTokenService.getToken(serverName));
    return url != null ? Uri.parse(url) : null;
  }

  // Keep old name as alias for compatibility
  static Uri? artUriFromEpisode(List<Fragment$fragmentImages>? images,
      String serverName) => artUriFromImages(images, serverName);

  static Future<GraphQLClient> getClient(String serverName) async {
    await LoginManager.waitForToken(serverName);
    return ClientManager
        .getClientForUrl(serverName)
        .value;
  }
}
