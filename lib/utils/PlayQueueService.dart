import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/addPlayQueueItem.graphql.dart';
import 'package:player/graphql/createPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/getPlayQueue.graphql.dart';
import 'package:player/graphql/movePlayQueueItem.graphql.dart';
import 'package:player/graphql/removePlayQueueItem.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/sendPlaybackCommand.graphql.dart';
import 'package:player/utils/LoggerService.dart';

import '../graphql/updatePlayQueue.graphql.dart';

class PlayQueueService {
  PlayQueueService._privateConstructor();

  static final PlayQueueService _instance =
      PlayQueueService._privateConstructor();

  factory PlayQueueService() {
    return _instance;
  }

  final StreamController<Fragment$fragmentPlayQueue> playQueueChanges =
      StreamController<Fragment$fragmentPlayQueue>.broadcast();

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueue(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String episodeId,
      String showId,
      int? startTimeInMilliseconds) async {
    if (playQueueId == null) {
      return await _createPlayQueue(graphQLClient, episodeId, showId);
    } else {
      var playQueue = await getPlayQueue(graphQLClient, playQueueId);
      if (playQueue != null) {
        String? currentItemId = getPlayQueueItemId(playQueue, episodeId);
        if (currentItemId != null) {
          final updated = await updateProgress(graphQLClient, playQueue.id,
              currentItemId, Duration(milliseconds: startTimeInMilliseconds ?? 0));
          if (updated != null) playQueue = updated;
        }
      }
      return playQueue;
    }
  }

  String? getPlayQueueItemId(Fragment$fragmentPlayQueue playQueue, String id) {
    return playQueue.playQueueItems
        ?.where((element) => element.episode?.id == id)
        .firstOrNull
        ?.id;
  }

  String? getMoviePlayQueueItemId(Fragment$fragmentPlayQueue playQueue, String movieId) {
    return playQueue.playQueueItems
        ?.where((element) => element.movie?.id == movieId)
        .firstOrNull
        ?.id;
  }

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueueForMovie(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String movieId,
      int? startTimeInMilliseconds) async {
    if (playQueueId == null) {
      return await _createPlayQueueForMovie(graphQLClient, movieId);
    } else {
      var playQueue = await getPlayQueue(graphQLClient, playQueueId);
      if (playQueue != null) {
        String? currentItemId = getMoviePlayQueueItemId(playQueue, movieId);
        if (currentItemId != null) {
          final updated = await updateProgress(graphQLClient, playQueue.id,
              currentItemId, Duration(milliseconds: startTimeInMilliseconds ?? 0));
          if (updated != null) playQueue = updated;
        }
      }
      return playQueue;
    }
  }

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueueForAlbum(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String albumId,
      String trackId) async {
    if (playQueueId == null) {
      return await _createPlayQueueForAlbum(graphQLClient, albumId, trackId);
    } else {
      var playQueue = await getPlayQueue(graphQLClient, playQueueId);
      if (playQueue != null) {
        String? currentItemId = getTrackPlayQueueItemId(playQueue, trackId);
        if (currentItemId != null && currentItemId != playQueue.currentItemId) {
          final updated = await updateProgress(
              graphQLClient, playQueue.id, currentItemId, Duration.zero);
          if (updated != null) playQueue = updated;
        }
      }
      return playQueue;
    }
  }

  String? getTrackPlayQueueItemId(
      Fragment$fragmentPlayQueue playQueue, String trackId) {
    return playQueue.playQueueItems
        ?.where((element) => element.track?.id == trackId)
        .firstOrNull
        ?.id;
  }

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueueForBook(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String bookId,
      String? chapterId) async {
    if (playQueueId == null) {
      return createPlayQueue(
        graphQLClient,
        sourceType: Enum$PlayQueueSourceType.BOOK,
        sourceId: bookId,
        startId: chapterId,
      );
    }
    var playQueue = await getPlayQueue(graphQLClient, playQueueId);
    if (playQueue != null && chapterId != null) {
      String? currentItemId = getChapterPlayQueueItemId(playQueue, chapterId);
      if (currentItemId != null && currentItemId != playQueue.currentItemId) {
        final updated = await updateProgress(
            graphQLClient, playQueue.id, currentItemId, Duration.zero);
        if (updated != null) playQueue = updated;
      }
    }
    return playQueue;
  }

  String? getChapterPlayQueueItemId(
      Fragment$fragmentPlayQueue playQueue, String chapterId) {
    return playQueue.playQueueItems
        ?.where((element) => element.chapter?.id == chapterId)
        .firstOrNull
        ?.id;
  }

  Future<Fragment$fragmentPlayQueue?> getOrCreatePlayQueueForPodcast(
      GraphQLClient graphQLClient,
      String? playQueueId,
      String podcastId,
      String? episodeId) async {
    if (playQueueId == null) {
      return createPlayQueue(
        graphQLClient,
        sourceType: Enum$PlayQueueSourceType.PODCAST,
        sourceId: podcastId,
        startId: episodeId,
      );
    }
    var playQueue = await getPlayQueue(graphQLClient, playQueueId);
    if (playQueue != null && episodeId != null) {
      String? currentItemId =
          getPodcastEpisodePlayQueueItemId(playQueue, episodeId);
      if (currentItemId != null && currentItemId != playQueue.currentItemId) {
        final updated = await updateProgress(
            graphQLClient, playQueue.id, currentItemId, Duration.zero);
        if (updated != null) playQueue = updated;
      }
    }
    return playQueue;
  }

  String? getPodcastEpisodePlayQueueItemId(
      Fragment$fragmentPlayQueue playQueue, String episodeId) {
    return playQueue.playQueueItems
        ?.where((element) => element.podcastEpisode?.id == episodeId)
        .firstOrNull
        ?.id;
  }

  Future<Fragment$fragmentPlayQueue?> _createPlayQueueForAlbum(
      GraphQLClient graphQLClient, String albumId, String trackId) async {
    return createPlayQueue(
      graphQLClient,
      sourceType: Enum$PlayQueueSourceType.ALBUM,
      sourceId: albumId,
      startId: trackId,
    );
  }

  Future<Fragment$fragmentPlayQueue?> _createPlayQueueForMovie(
      GraphQLClient graphQLClient, String movieId) async {
    return createPlayQueue(
      graphQLClient,
      sourceType: Enum$PlayQueueSourceType.MOVIE,
      sourceId: movieId,
    );
  }

  Future<Fragment$fragmentPlayQueue?> _createPlayQueue(
      GraphQLClient graphQLClient, String episodeId, String showId) async {
    return createPlayQueue(
      graphQLClient,
      sourceType: Enum$PlayQueueSourceType.SHOW,
      sourceId: showId,
      startId: episodeId,
    );
  }

  /// Unified play-queue creation against the new `createPlayQueue` mutation.
  /// [sourceType] selects MOVIE/SHOW/ALBUM/LIBRARY; [startId] is the episode or
  /// track to start at (ignored for MOVIE/LIBRARY sources).
  Future<Fragment$fragmentPlayQueue?> createPlayQueue(
    GraphQLClient graphQLClient, {
    required Enum$PlayQueueSourceType sourceType,
    required String sourceId,
    String? startId,
    bool? shuffle,
  }) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationcreatePlayQueue,
        variables: Variables$Mutation$createPlayQueue(
          input: Input$CreatePlayQueueInput(
            sourceType: sourceType,
            sourceId: sourceId,
            startId: startId,
            shuffle: shuffle,
          ),
        ).toJson());
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$createPlayQueue.fromJson(result.data!).createPlayQueue;
  }

  /// Fetches a play queue by id; also used for queues owned by another user
  /// (remote control), which the server allows for any authenticated user.
  Future<Fragment$fragmentPlayQueue?> getPlayQueue(
      GraphQLClient graphQLClient, String playQueueId) async {
    final QueryResult result = await graphQLClient.query(QueryOptions(
        document: documentNodeQuerygetPlayQueue,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: Map.of({
          "id": playQueueId,
        })));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$getPlayQueue.fromJson(result.data!).getPlayQueue;
  }

  /// Sends a remote-control command to the client playing [playQueueId].
  /// Returns whether the server knew an active session for the queue, or null
  /// when the mutation itself failed.
  Future<bool?> sendPlaybackCommand(
    GraphQLClient graphQLClient,
    String playQueueId,
    Enum$PlaybackCommandType command, {
    Duration? position,
    String? playQueueItemId,
  }) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationsendPlaybackCommand,
        variables: Variables$Mutation$sendPlaybackCommand(
          playQueueId: playQueueId,
          command: command,
          positionInMilliseconds: position?.inMilliseconds,
          playQueueItemId: playQueueItemId,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$sendPlaybackCommand.fromJson(result.data!)
        .sendPlaybackCommand;
  }

  /// Appends [mediaId] to the queue, optionally right after
  /// [afterPlayQueueItemId] (defaults to the end).
  Future<Fragment$fragmentPlayQueue?> addPlayQueueItem(
    GraphQLClient graphQLClient,
    String playQueueId,
    Enum$MediaType mediaType,
    String mediaId, {
    String? afterPlayQueueItemId,
  }) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationaddPlayQueueItem,
        variables: Variables$Mutation$addPlayQueueItem(
          playQueueId: playQueueId,
          mediaType: mediaType,
          mediaId: mediaId,
          afterPlayQueueItemId: afterPlayQueueItemId,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$addPlayQueueItem.fromJson(result.data!).addPlayQueueItem;
  }

  Future<Fragment$fragmentPlayQueue?> removePlayQueueItem(
    GraphQLClient graphQLClient,
    String playQueueId,
    String playQueueItemId,
  ) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationremovePlayQueueItem,
        variables: Variables$Mutation$removePlayQueueItem(
          playQueueId: playQueueId,
          playQueueItemId: playQueueItemId,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$removePlayQueueItem.fromJson(result.data!)
        .removePlayQueueItem;
  }

  /// Moves [playQueueItemId] to sit right after [afterPlayQueueItemId]
  /// (null = move to the front).
  Future<Fragment$fragmentPlayQueue?> movePlayQueueItem(
    GraphQLClient graphQLClient,
    String playQueueId,
    String playQueueItemId,
    String? afterPlayQueueItemId,
  ) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationmovePlayQueueItem,
        variables: Variables$Mutation$movePlayQueueItem(
          playQueueId: playQueueId,
          playQueueItemId: playQueueItemId,
          afterPlayQueueItemId: afterPlayQueueItemId,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$movePlayQueueItem.fromJson(result.data!).movePlayQueueItem;
  }

  /// Play-queue items in playback order. [position] is an opaque, possibly
  /// fractional sort key that changes after a reorder, so never rely on the
  /// raw list order — always sort by it.
  static List<Fragment$fragmentPlayQueue$playQueueItems> sortedItems(
      Fragment$fragmentPlayQueue? playQueue) {
    final items = playQueue?.playQueueItems;
    if (items == null) return const [];
    final sorted = List.of(items);
    sorted.sort((a, b) => a.position.compareTo(b.position));
    return sorted;
  }

  /// [streamSettings] tells the server what format the client is playing
  /// with, so it can prefetch the next queue item in the same format.
  /// [playState] marks the update as PLAYING (also when null) or PAUSED; the
  /// server treats this mutation as the playback heartbeat and considers the
  /// session stopped when no update arrives for 60s.
  Future<Fragment$fragmentPlayQueue?> updateProgress(
      GraphQLClient graphQLClient,
      String playQueueId,
      String playQueueItemId,
      Duration duration,
      {Input$StreamSettingsInput? streamSettings,
      Enum$PlayState? playState}) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationupdatePlayQueue,
        variables: Variables$Mutation$updatePlayQueue(
          id: playQueueId,
          playQueueItemId: playQueueItemId,
          progressInMilliseconds: duration.inMilliseconds,
          streamSettings: streamSettings,
          playState: playState,
        ).toJson());
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    } else {
      return Mutation$updatePlayQueue.fromJson(result.data!).updatePlayQueue;
    }
  }

  void playQueueChanged(Fragment$fragmentPlayQueue item) {
    playQueueChanges.sink.add(item);
  }

  Stream<Fragment$fragmentPlayQueue> getPlayQueueChangedStream() {
    return playQueueChanges.stream;
  }

  static Fragment$fragmentPlayQueue$playQueueItems? getCurrentPlayQueueItem(Fragment$fragmentPlayQueue? playQueue) {
    return playQueue?.playQueueItems?.where((element) => element.id == playQueue.currentItemId).firstOrNull;
  }

  void dispose() {
    playQueueChanges.close();
  }
}
