import 'package:flutter/foundation.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';

import 'ImageTypes.dart';

class ImageUtil {
  static String? getImageIdByType(
      List<Fragment$fragmentImages>? images, ImageTypes backgroundType) {
    return getImageByType(images, backgroundType)?.id;
  }

  /// The artwork of [backgroundType] to show for an entity.
  ///
  /// Order-independent on purpose: the server returns image lists without an
  /// ORDER BY, and the same show reaches the client through several queries
  /// (`showById`, the shows list, `related`, `recentlyWatched`), each of which
  /// can hand the list back in a different order. All of them write the same
  /// normalized `Show` entity, so a list that comes back reordered is
  /// rebroadcast to every widget showing that show — and picking "the first"
  /// then swaps the tile to another image for a moment, which the user sees as
  /// a grey flash. Ties are therefore broken on the image id, which is stable.
  static Fragment$fragmentImages? getImageByType(
      List<Fragment$fragmentImages>? images, ImageTypes backgroundType) {
    if (images == null) return null;
    final candidates = images.where((element) =>
        ImageTypes.values.byName(element.type.toLowerCase()) ==
        backgroundType);
    if (candidates.isEmpty) return null;
    // Local artwork shipped next to the media files wins over scraped
    // provider images. Newer servers label it LOCAL_FILE; older ones leave
    // the source null.
    bool isLocal(Fragment$fragmentImages i) =>
        i.source == null || i.source == Enum$MetadataSource.LOCAL_FILE;
    Fragment$fragmentImages? best;
    for (final image in candidates) {
      if (best == null) {
        best = image;
        continue;
      }
      final localWins = isLocal(image) && !isLocal(best);
      final localLoses = !isLocal(image) && isLocal(best);
      if (localWins || (!localLoses && image.id.compareTo(best.id) < 0)) {
        best = image;
      }
    }
    return best;
  }

  /// Cache key for an artwork URL: the same URL without the expiring `token`
  /// parameter. A token is minted per app start and rotates within one, so
  /// keying the image cache on the full URL stored the same picture once per
  /// token and lost the lot on every restart. Mirrors
  /// [ComicResourceClient.pageCacheKey], which builds the same string by
  /// construction. Null or empty in, null out — it feeds `cacheKey:` directly;
  /// `file:` URIs, local paths and third-party URLs come back unchanged.
  static String? cacheKeyFor(String? url) {
    if (url == null || url.isEmpty) return null;
    final int q = url.indexOf('?');
    if (q < 0) return url;
    // Split on the parameters rather than replacing a `token=…` pattern, so an
    // `auth_token=` is left alone and the other parameters keep their order.
    final kept = url
        .substring(q + 1)
        .split('&')
        .where((p) => p != 'token' && !p.startsWith('token='))
        .join('&');
    final base = url.substring(0, q);
    return kept.isEmpty ? base : '$base?$kept';
  }

  static String? buildUrl(Fragment$fragmentImages? image, {String? token}) {
    if (image == null) return null;
    final base = '${image.directory.servingNode.url}/images/${image.id}/download';
    return token != null ? '$base?token=$token' : base;
  }

  /// Download URL for an image known only by id (playback sessions carry an
  /// `artworkImageId`, not the whole image), served by [serverName] itself.
  /// Null until the server's well-known data has been fetched.
  static String? buildUrlById(String serverName, String? imageId) {
    if (imageId == null) return null;
    final serverUrl = WellKnownService.getCached(serverName)?.serverUrl;
    if (serverUrl == null) return null;
    final base = '$serverUrl/images/$imageId/download';
    final token = StreamTokenService.getToken(serverName);
    return token != null ? '$base?token=$token' : base;
  }

  /// Subtitle format requested on the HLS master playlist; keep in sync with
  /// the StreamSettingsInput sent on progress updates (prefetching).
  ///
  /// Web (hls.js) uses the in-manifest WEBVTT renditions. Native does NOT use
  /// in-manifest subtitles at all: mpv side-loads whole-file SRTs as external
  /// tracks (MediaPlayerHandler._loadExternalSubtitleTracks) — in-manifest
  /// subtitles through ffmpeg's HLS demuxer re-deliver cues on every segment
  /// refetch/reconnect, stacking duplicates on screen. Requesting SRT here
  /// makes ffmpeg drop the renditions (its segment-extension check), so no
  /// dead in-manifest tracks show up next to the external ones.
  static const String subtitleFormat = kIsWeb ? 'WEBVTT' : 'SRT';

  static String? buildMediaFileUrl(Fragment$fragmentMediaFiles? mediaFile, {String? token, bool direct = true, bool transcode = true}) {
    if (mediaFile == null) return null;
    return buildMasterUrl(mediaFile.directory.servingNode.url, mediaFile.id,
        token: token, direct: direct, transcode: transcode);
  }

  /// The HLS master URL for a media file known by node and id (downloads
  /// resume without the fragment object).
  static String buildMasterUrl(String nodeUrl, String mediaFileId,
      {String? token, bool direct = true, bool transcode = true}) {
    final base = '$nodeUrl/hls/$mediaFileId/master.m3u8?direct=$direct&transcode=$transcode&subtitleFormat=$subtitleFormat';
    return token != null ? '$base&token=$token' : base;
  }
}
