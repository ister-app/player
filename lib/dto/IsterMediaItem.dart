import 'package:audio_service/audio_service.dart';
import 'package:player/dto/MediaItemId.dart';

class IsterMediaItem {
  /// A unique id.
  final String id;

  final String serverName;

  final IsterMediaTypes isterMediaType;

  /// The title of this media item.
  final String title;

  /// The artist shown as subtitle (tracks, albums).
  final String? artist;

  /// The album a track belongs to.
  final String? album;

  /// The duration of this media item.
  final Duration? duration;

  final Uri? artUri;

  /// Whether this item can be played directly. Non-playable items are shown
  /// as browsable folders in Android Auto.
  final bool playable;

  /// Extra hints for the media browser (e.g. content-style grid/list hints).
  final Map<String, dynamic>? extras;

  IsterMediaItem({
    required this.id,
    required this.serverName,
    required this.isterMediaType,
    required this.title,
    this.artist,
    this.album,
    this.duration,
    this.artUri,
    this.playable = false,
    this.extras,
  });

  MediaItem get mediaItem => MediaItem(
        id: MediaItemId(serverName, isterMediaType, id).toString(),
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        artUri: artUri,
        playable: playable,
        extras: extras,
      );
}

enum IsterMediaTypes {
  episode,
  show,
  list, // I.E. Recent or last added
  movie,
  track,
  album,
  artist,
  book, // audiobook (browsable → chapters)
  chapter, // audiobook chapter (playable); id is "bookId~chapterId"
  podcast, // podcast (browsable → episodes)
  podcastEpisode, // podcast episode (playable); id is "podcastId~episodeId"
}
