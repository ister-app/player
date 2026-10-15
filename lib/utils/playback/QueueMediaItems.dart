// The audio_service [MediaItem]s MediaPlayerHandler publishes for a play
// queue, and the artwork-token upkeep on them. Pure functions of the queue and
// the stream token — no player state — shared by every queue-start path.
import 'package:audio_service/audio_service.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:player/utils/QueueItemDisplay.dart';
import 'package:player/utils/StreamTokenService.dart';

/// Artwork width published in [MediaItem.artUri]: wide enough for a tablet
/// lock screen and a car head unit. These uris reach the Android
/// notification, the lock screen and CarPlay, where a 3840x2160 episode
/// still used to be fetched to fill an icon; the in-app surfaces re-size per
/// surface through ArtworkImage anyway.
const int publishedArtworkWidth = 640;

/// Builds the [MediaItem] list for [pq] in playback order. What each item
/// looks like is [QueueItemDisplay]'s job — shared with the remote control,
/// which renders the same queues without playing them.
List<MediaItem> buildQueueMediaItems(
    Fragment$fragmentPlayQueue pq, String serverName) {
  final token = StreamTokenService.getToken(serverName);
  return PlayQueueService.sortedItems(pq).map((e) {
    final display = QueueItemDisplay.of(e,
        token: token, artworkWidth: publishedArtworkWidth);
    return MediaItem(
      id: MediaItemId(serverName, display.mediaType, e.id).toString(),
      title: display.title,
      artist: display.artist,
      album: display.album,
      duration: display.duration,
      artUri: display.artUrl == null ? null : Uri.tryParse(display.artUrl!),
      // Book covers are portrait — flag it so the player shows the cover in
      // its true 2:3 aspect ratio instead of cropping it square.
      extras: display.portraitArtwork ? const {'portraitArtwork': true} : null,
    );
  }).toList();
}

/// Replaces the stream token embedded in [item]'s artUri with [token].
/// Returns [item] unchanged when there is no artwork or the token already
/// matches.
MediaItem restampArtToken(MediaItem item, String token) {
  final art = item.artUri;
  if (art == null ||
      art.scheme == 'file' ||
      art.queryParameters['token'] == token) {
    return item;
  }
  return item.copyWith(
    artUri: art.replace(
        queryParameters: {...art.queryParameters, 'token': token}),
  );
}

/// [restampArtToken] with the current token of the server [item] belongs to
/// (read from its [MediaItemId]); [item] itself when that cannot be resolved.
MediaItem restampArtForItemServer(MediaItem item) {
  final String serverName;
  try {
    serverName = MediaItemId.byStringId(item.id).serverName;
  } catch (_) {
    return item;
  }
  final token = StreamTokenService.getToken(serverName);
  return token == null ? item : restampArtToken(item, token);
}
