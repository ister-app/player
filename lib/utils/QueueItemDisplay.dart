import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';

/// How one play-queue item presents itself: the same title/artist/album/artwork
/// derivation for every consumer of a queue.
///
/// A queue item holds exactly one of five kinds (track, chapter, podcast
/// episode, movie, episode) and each has its own idea of what the "artist" and
/// "album" line are. Both the audio handler (which turns a queue into
/// audio_service [MediaItem]s) and the remote control (which renders someone
/// else's queue without ever playing it) need that mapping, so it lives here
/// instead of in either of them.
class QueueItemDisplay {
  const QueueItemDisplay({
    required this.title,
    required this.artist,
    required this.album,
    required this.artUrl,
    required this.duration,
    required this.mediaType,
    this.portraitArtwork = false,
  });

  final String title;

  /// Second line: performing artist, author or podcast — null when the kind has
  /// no meaningful one.
  final String? artist;
  final String? album;
  final String? artUrl;

  /// Duration of the item's first media file; zero when it was never analyzed.
  final Duration duration;

  /// The kind as the rest of the app addresses it (a chapter and a podcast
  /// episode are both played as a track).
  final IsterMediaTypes mediaType;

  /// Book covers are 2:3 — the player shows them uncropped.
  final bool portraitArtwork;

  /// Derives the display of [item]. [token] is the server's stream token, which
  /// the image endpoints require; pass null to build unauthenticated URLs.
  static QueueItemDisplay of(
    Fragment$fragmentPlayQueue$playQueueItems item, {
    String? token,
  }) {
    String? artFor(List<Fragment$fragmentImages>? images, ImageTypes type) =>
        ImageUtil.buildUrl(ImageUtil.getImageByType(images, type),
            token: token);

    if (item.track != null) {
      final t = item.track!;
      return QueueItemDisplay(
        title: MetadataUtil.getTitle(t.metadata) ?? '${t.number}',
        artist: t.artist.name,
        album: t.album.name,
        artUrl: artFor(t.album.images, ImageTypes.cover),
        duration: _durationOf(t.mediaFile?.firstOrNull?.durationInMilliseconds),
        mediaType: IsterMediaTypes.track,
      );
    }
    if (item.chapter != null) {
      final c = item.chapter!;
      return QueueItemDisplay(
        title: MetadataUtil.getTitle(c.metadata) ??
            '${IsterMediaService.loc.chapter} ${c.number}',
        artist: c.author.name,
        // The clean display title, not the raw file/directory name.
        album: MetadataUtil.getTitle(c.book.metadata) ?? c.book.title,
        artUrl: artFor(c.book.images, ImageTypes.cover),
        duration: _durationOf(c.mediaFile?.firstOrNull?.durationInMilliseconds),
        mediaType: IsterMediaTypes.track,
        portraitArtwork: true,
      );
    }
    if (item.podcastEpisode != null) {
      final pe = item.podcastEpisode!;
      return QueueItemDisplay(
        title: MetadataUtil.getTitle(pe.metadata) ?? pe.podcast.title,
        artist: pe.podcast.author ?? pe.podcast.title,
        album: pe.podcast.title,
        artUrl: artFor(pe.podcast.images, ImageTypes.cover),
        duration: _durationOf(pe.mediaFile?.firstOrNull?.durationInMilliseconds),
        mediaType: IsterMediaTypes.track,
      );
    }
    if (item.movie != null) {
      final m = item.movie!;
      return QueueItemDisplay(
        title: m.name,
        artist: 'ister',
        album: null,
        artUrl: artFor(m.images, ImageTypes.background),
        duration: _durationOf(m.mediaFile?.firstOrNull?.durationInMilliseconds),
        mediaType: IsterMediaTypes.movie,
      );
    }
    final ep = item.episode;
    return QueueItemDisplay(
      title: MetadataUtil.getTitle(ep?.metadata) ?? 'unknown',
      artist: 'ister',
      album: null,
      artUrl: ep == null ? null : artFor(ep.images, ImageTypes.background),
      duration: _durationOf(ep?.mediaFile?.firstOrNull?.durationInMilliseconds),
      mediaType: IsterMediaTypes.episode,
    );
  }

  static Duration _durationOf(int? milliseconds) =>
      Duration(milliseconds: milliseconds ?? 0);
}
