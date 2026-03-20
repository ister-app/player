import 'package:audio_service/audio_service.dart';
import 'package:graphql/src/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/showById.graphql.dart';

import '../graphql/episodesRecentWatchedQuery.graphql.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';
import '../utils/MetadataUtil.dart';

class IsterMediaService {
  Future<List<IsterMediaItem>> getItemsByParentId(String id) async {
    MediaItemId mediaItemId = MediaItemId.byStringId(id);

    return switch(mediaItemId.isterMediaType) {
      IsterMediaTypes.episode => getEpisode(mediaItemId),
      IsterMediaTypes.show => List.empty(),
      IsterMediaTypes.list => getList(mediaItemId),
    };
  }

  Future<List<IsterMediaItem>> getList(MediaItemId mediaItemId) async {
    if (mediaItemId.id == "recent") {
      return getRecent(mediaItemId);
    } else {
      return getRecent(mediaItemId);
    }
  }

  Future<List<IsterMediaItem>> getRecent(MediaItemId mediaItemId) async {
    GraphQLClient client = await getClient(mediaItemId.serverName);

    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryepisodesRecentWatchedQuery,
    ));

    LoggerService().logger.e(result);
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return List.empty();
    }
    return Query$episodesRecentWatchedQuery
        .fromJson(result.data!)
        .episodesRecentWatched!
        .map(
          (e) {
        return IsterMediaItem(
          id: e.id,
          title: MetadataUtil.getTitle(e.metadata) ?? "unknown",
          duration: Duration(
              milliseconds: e.mediaFile?.first.durationInMilliseconds ?? 0),
          serverName: mediaItemId.serverName,
          isterMediaType: mediaItemId.isterMediaType,
          stubTitle: 'Ister',
          artUri: artUriFromEpisode(e.images, mediaItemId.serverName),
        );
      },
    )
        .toList();
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
      artUri: artUriFromEpisode(data.images, mediaItemId.serverName),
    );
    return {isterMediaItem}.toList();
  }

  static Uri? artUriFromEpisode(List<Fragment$fragmentImages>? images,
      String serverName) {
    final imageByType = ImageUtil.getImageByType(images, ImageTypes.background);
    final url = ImageUtil.buildUrl(imageByType);
    return url != null ? Uri.parse(url) : null;
  }

  static Future<GraphQLClient> getClient(String serverName) async {
    await LoginManager.waitForToken(serverName);
    return ClientManager
        .getClientForUrl(serverName)
        .value;
  }
}
