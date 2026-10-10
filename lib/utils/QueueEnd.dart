import 'package:audio_service/audio_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../graphql/schema.graphql.dart';

/// What kind of thing a play queue was, for the ended state's wording and
/// its "what next" suggestions.
enum QueueEndKind { episode, movie, album, book, podcast, playlist, other }

/// The snapshot [MediaPlayerHandler] keeps when a queue plays out: enough to
/// show what just finished, to replay it from the start, and to look up what
/// could follow it. Playback itself is torn down by then (nothing loaded, no
/// heartbeat, no notification); this is the only thing left of the queue.
class QueueEndedInfo {
  const QueueEndedInfo({
    required this.serverName,
    required this.client,
    required this.playQueue,
    required this.lastItem,
    required this.lastMediaItem,
    this.episode,
    this.movie,
    this.album,
  });

  final String serverName;

  /// Null for a queue that lived only on this device (offline playback).
  final GraphQLClient? client;

  /// The queue as it was when its last item ended.
  final Fragment$fragmentPlayQueue playQueue;

  /// The item that ended.
  final Fragment$fragmentPlayQueue$playQueueItems lastItem;

  /// Title/artist/artwork of what ended, for surfaces that only have the
  /// handler's queue metadata (the mini player).
  final MediaItem lastMediaItem;

  final Fragment$fragmentEpisode? episode;
  final Fragment$fragmentMovie? movie;
  final Fragment$fragmentAlbum? album;

  bool get isLocal => client == null;

  QueueEndKind get kind => queueEndKindOf(playQueue, lastItem);

  bool get isVideo =>
      kind == QueueEndKind.episode || kind == QueueEndKind.movie;
}

/// The kind of a queue: its source type when the server set one, else what
/// its last item is (a queue built from downloads carries no source type).
/// A library, artist or filter queue counts as an album queue when it played
/// tracks — the "more from this artist" suggestion fits it just as well.
QueueEndKind queueEndKindOf(Fragment$fragmentPlayQueue pq,
    Fragment$fragmentPlayQueue$playQueueItems item) {
  switch (pq.sourceType) {
    case Enum$PlayQueueSourceType.SHOW:
      return QueueEndKind.episode;
    case Enum$PlayQueueSourceType.MOVIE:
      return QueueEndKind.movie;
    case Enum$PlayQueueSourceType.ALBUM:
      return QueueEndKind.album;
    case Enum$PlayQueueSourceType.BOOK:
      return QueueEndKind.book;
    case Enum$PlayQueueSourceType.PODCAST:
      return QueueEndKind.podcast;
    case Enum$PlayQueueSourceType.PLAYLIST:
      return QueueEndKind.playlist;
    case Enum$PlayQueueSourceType.LIBRARY:
    case Enum$PlayQueueSourceType.ARTIST:
    case Enum$PlayQueueSourceType.FILTER:
    case Enum$PlayQueueSourceType.$unknown:
    case null:
      break;
  }
  if (item.episode != null) return QueueEndKind.episode;
  if (item.movie != null) return QueueEndKind.movie;
  if (item.track != null) return QueueEndKind.album;
  if (item.chapter != null) return QueueEndKind.book;
  if (item.podcastEpisode != null) return QueueEndKind.podcast;
  return QueueEndKind.other;
}
