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

  static Fragment$fragmentImages? getImageByType(
      List<Fragment$fragmentImages>? images, ImageTypes backgroundType) {
    if (images != null) {
      var coverImages = images.where((element) =>
      ImageTypes.values.byName(element.type.toLowerCase()) ==
          backgroundType);
      if (coverImages.isNotEmpty) {
        // Local artwork shipped next to the media files wins over scraped
        // provider images. Newer servers label it LOCAL_FILE; older ones
        // leave the source null.
        return coverImages
                .where((i) =>
                    i.source == null ||
                    i.source == Enum$MetadataSource.LOCAL_FILE)
                .firstOrNull ??
            coverImages.first;
      }
    }
    return null;
  }

  static String? buildUrl(Fragment$fragmentImages? image, {String? token}) {
    if (image == null) return null;
    final base = '${image.directory.node.url}/images/${image.id}/download';
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
    return buildMasterUrl(mediaFile.directory.node.url, mediaFile.id,
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
