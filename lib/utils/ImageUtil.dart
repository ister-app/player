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
  /// WEBVTT everywhere. ffmpeg's HLS demuxer (mpv's backend on native) only
  /// truly supports WebVTT subtitle renditions: `.srt` segments fail its
  /// allowed_segment_extensions check (ffmpeg ≥ 7.1), and even with
  /// `extension_picky=0` the segments are demuxed as WebVTT and yield no
  /// cues (verified with tool/sub_stack_probe.dart). hls.js on web wants
  /// WebVTT anyway.
  static const String subtitleFormat = 'WEBVTT';

  static String? buildMediaFileUrl(Fragment$fragmentMediaFiles? mediaFile, {String? token, bool direct = true, bool transcode = true}) {
    if (mediaFile == null) return null;
    final base = '${mediaFile.directory.node.url}/hls/${mediaFile.id}/master.m3u8?direct=$direct&transcode=$transcode&subtitleFormat=$subtitleFormat';
    return token != null ? '$base&token=$token' : base;
  }
}
