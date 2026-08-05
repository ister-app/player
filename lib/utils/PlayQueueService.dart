import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/addPlayQueueAlbum.graphql.dart';
import 'package:player/graphql/addPlayQueueItem.graphql.dart';
import 'package:player/graphql/createPlayQueue.graphql.dart';
import 'package:player/graphql/followPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentWatchStatus.graphql.dart';
import 'package:player/graphql/getPlayQueue.graphql.dart';
import 'package:player/graphql/movePlayQueueItem.graphql.dart';
import 'package:player/graphql/removeFollower.graphql.dart';
import 'package:player/graphql/removePlayQueueItem.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/sendPlaybackCommand.graphql.dart';
import 'package:player/graphql/sessionFollowers.graphql.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/SchemaCompat.dart';

import '../graphql/updatePlayQueue.graphql.dart';

/// One device listening along with a session, as its owner sees it.
class SessionFollower {
  const SessionFollower({
    required this.userId,
    required this.userName,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    required this.since,
  });

  final String userId;

  /// Display name of the following user; null on a server that has none for them.
  final String? userName;

  /// The follower's install id — unique per user, not globally.
  final String deviceId;

  /// Registered device name; null when that device never registered itself.
  final String? deviceName;
  final Enum$DevicePlatform? platform;

  /// When this device started listening along.
  final DateTime? since;
}

/// A play-queue change as broadcast to subscribers.
class PlayQueueChange {
  const PlayQueueChange(this.queue, {this.optimistic = false});

  final Fragment$fragmentPlayQueue queue;

  /// True for a local change that the server has not confirmed yet.
  final bool optimistic;
}

class PlayQueueService {
  PlayQueueService._privateConstructor();

  static final PlayQueueService _instance =
      PlayQueueService._privateConstructor();

  factory PlayQueueService() {
    return _instance;
  }

  final StreamController<PlayQueueChange> playQueueChanges =
      StreamController<PlayQueueChange>.broadcast();

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
      final item = _chapterPlayQueueItem(playQueue, chapterId);
      if (item != null && item.id != playQueue.currentItemId) {
        // Moving the queue's current item goes through updateProgress, so re-send the chapter's
        // own saved position: writing zero here would wipe the very spot we came to resume.
        final updated = await updateProgress(graphQLClient, playQueue.id, item.id,
            _chapterProgress(item.chapter?.watchStatus?.firstOrNull));
        if (updated != null) playQueue = updated;
      }
    }
    return playQueue;
  }

  Duration _chapterProgress(Fragment$fragmentWatchStatus? status) =>
      status == null || status.watched
          ? Duration.zero
          : Duration(milliseconds: status.progressInMilliseconds);

  Fragment$fragmentPlayQueue$playQueueItems? _chapterPlayQueueItem(
      Fragment$fragmentPlayQueue playQueue, String chapterId) {
    return playQueue.playQueueItems
        ?.where((element) => element.chapter?.id == chapterId)
        .firstOrNull;
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
  /// [sourceType] selects MOVIE/SHOW/ALBUM/LIBRARY/ARTIST/FILTER; [startId] is
  /// the episode or track to start at (ignored for MOVIE/LIBRARY sources).
  /// [rankKind] selects which ranked track list an ARTIST source plays.
  /// FILTER sources take either a saved view as [sourceId] or an inline
  /// [filter] + [filterKind], optionally scoped to [libraryId] and ordered by
  /// [sorting]/[sortingOrder].
  Future<Fragment$fragmentPlayQueue?> createPlayQueue(
    GraphQLClient graphQLClient, {
    required Enum$PlayQueueSourceType sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
    Enum$RankKind? rankKind,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationcreatePlayQueue,
        variables: Variables$Mutation$createPlayQueue(
          input: Input$CreatePlayQueueInput(
            sourceType: sourceType,
            sourceId: sourceId,
            startId: startId,
            shuffle: shuffle,
            rankKind: rankKind,
            filter: filter,
            filterKind: filterKind,
            libraryId: libraryId,
            sorting: sorting,
            sortingOrder: sortingOrder,
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
    Enum$RepeatMode? repeatMode,
  }) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationsendPlaybackCommand,
        variables: Variables$Mutation$sendPlaybackCommand(
          playQueueId: playQueueId,
          command: command,
          positionInMilliseconds: position?.inMilliseconds,
          playQueueItemId: playQueueItemId,
          repeatMode: repeatMode,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$sendPlaybackCommand.fromJson(result.data!)
        .sendPlaybackCommand;
  }

  /// Registers ([active] true) or deregisters this device as a follower of
  /// [playQueueId]'s live session ("listen along"). Also the follow heartbeat:
  /// call every ~20s while following or the registration expires server-side.
  /// Returns null when the mutation itself failed (network); the caller should
  /// keep following and retry on the next heartbeat tick.
  Future<Enum$FollowResult?> followPlayQueue(
    GraphQLClient graphQLClient,
    String playQueueId,
    String deviceId,
    bool active,
  ) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationfollowPlayQueue,
        variables: Variables$Mutation$followPlayQueue(
          playQueueId: playQueueId,
          deviceId: deviceId,
          active: active,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$followPlayQueue.fromJson(result.data!).followPlayQueue;
  }

  /// The devices listening along with [playQueueId], for its owner. Empty for a session the
  /// caller does not own; null on a server that predates the query, so the UI can hide itself.
  /// Throws on any other failure.
  Future<List<SessionFollower>?> sessionFollowers(
    GraphQLClient graphQLClient,
    String playQueueId,
  ) async {
    final QueryResult result = await graphQLClient.query(QueryOptions(
      document: documentNodeQuerysessionFollowers,
      variables:
          Variables$Query$sessionFollowers(playQueueId: playQueueId).toJson(),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException || result.data == null) {
      final exception = result.exception;
      if (exception != null && isUnknownFieldError(exception)) return null;
      throw exception ?? Exception('empty sessionFollowers response');
    }
    return Query$sessionFollowers.fromJson(result.data!)
        .sessionFollowers
        .map((follower) => SessionFollower(
              userId: follower.userId,
              userName: follower.userName,
              deviceId: follower.deviceId,
              deviceName: follower.deviceName,
              platform: follower.platform,
              since: DateTime.tryParse(follower.since),
            ))
        .toList();
  }

  /// Kicks a follower off the caller's own session: [deviceId] null removes every device of
  /// [userId]. Returns whether anything was following.
  Future<bool> removeFollower(
    GraphQLClient graphQLClient, {
    required String playQueueId,
    required String userId,
    String? deviceId,
  }) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationremoveFollower,
        variables: Variables$Mutation$removeFollower(
          playQueueId: playQueueId,
          userId: userId,
          deviceId: deviceId,
        ).toJson()));

    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return false;
    }
    return Mutation$removeFollower.fromJson(result.data!).removeFollower;
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

  /// Appends all tracks of [albumId] to the end of the queue in one server
  /// call, in natural play order (disc number, track number).
  Future<Fragment$fragmentPlayQueue?> addPlayQueueAlbum(
    GraphQLClient graphQLClient,
    String playQueueId,
    String albumId,
  ) async {
    final QueryResult result = await graphQLClient.mutate(MutationOptions(
        document: documentNodeMutationaddPlayQueueAlbum,
        variables: Variables$Mutation$addPlayQueueAlbum(
          playQueueId: playQueueId,
          albumId: albumId,
        ).toJson()));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$addPlayQueueAlbum.fromJson(result.data!).addPlayQueueAlbum;
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

  /// The queue item holding [mediaId] — a track, episode, movie, chapter or
  /// podcast episode id — or null when the queue does not (yet) contain it.
  static Fragment$fragmentPlayQueue$playQueueItems? itemForMedia(
      List<Fragment$fragmentPlayQueue$playQueueItems> items, String mediaId) {
    return items
        .where((item) =>
            item.track?.id == mediaId ||
            item.episode?.id == mediaId ||
            item.movie?.id == mediaId ||
            item.chapter?.id == mediaId ||
            item.podcastEpisode?.id == mediaId)
        .firstOrNull;
  }

  /// [streamSettings] tells the server what format the client is playing
  /// with, so it can prefetch the next queue item in the same format.
  /// [playState] marks the update as PLAYING (also when null) or PAUSED; the
  /// server treats this mutation as the playback heartbeat and considers the
  /// session stopped when no update arrives for 60s.
  /// [anchorPositionMs]/[anchorServerTimeMs]: optional tight-sync timeline
  /// anchor ("this position at that server-clock instant"); followers
  /// extrapolate the leader position from it locally.
  /// [repeatMode] is relayed onto the session so remote controls show the same
  /// repeat state as this device.
  Future<Fragment$fragmentPlayQueue?> updateProgress(
      GraphQLClient graphQLClient,
      String playQueueId,
      String playQueueItemId,
      Duration duration,
      {Input$StreamSettingsInput? streamSettings,
      Enum$PlayState? playState,
      String? deviceId,
      int? anchorPositionMs,
      double? anchorServerTimeMs,
      Enum$RepeatMode? repeatMode}) async {
    final MutationOptions options = MutationOptions(
        document: documentNodeMutationupdatePlayQueue,
        variables: Variables$Mutation$updatePlayQueue(
          id: playQueueId,
          playQueueItemId: playQueueItemId,
          progressInMilliseconds: duration.inMilliseconds,
          streamSettings: streamSettings,
          playState: playState,
          deviceId: deviceId,
          anchorPositionMs: anchorPositionMs,
          anchorServerTimeMs: anchorServerTimeMs,
          repeatMode: repeatMode,
        ).toJson());
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    } else {
      return Mutation$updatePlayQueue.fromJson(result.data!).updatePlayQueue;
    }
  }

  /// Publishes [item] to the queue-change subscribers. Set [optimistic] for a
  /// local state change that has not been confirmed by the server yet — those
  /// emissions are meant for UI that renders the handler's own state, not for
  /// subscribers that answer by re-querying the server (they would read data
  /// from before the sync landed).
  void playQueueChanged(Fragment$fragmentPlayQueue item,
      {bool optimistic = false}) {
    playQueueChanges.sink.add(PlayQueueChange(item, optimistic: optimistic));
  }

  /// Queue changes. Pass `includeOptimistic: false` to only see server-confirmed
  /// changes — an item switch emits twice (locally first, then after the
  /// updatePlayQueue round trip), so a server refetch driven by every emission
  /// runs twice and visibly settles on two different results.
  Stream<Fragment$fragmentPlayQueue> getPlayQueueChangedStream(
      {bool includeOptimistic = true}) {
    return playQueueChanges.stream
        .where((change) => includeOptimistic || !change.optimistic)
        .map((change) => change.queue);
  }

  static Fragment$fragmentPlayQueue$playQueueItems? getCurrentPlayQueueItem(Fragment$fragmentPlayQueue? playQueue) {
    return playQueue?.playQueueItems?.where((element) => element.id == playQueue.currentItemId).firstOrNull;
  }

  void dispose() {
    playQueueChanges.close();
  }
}
