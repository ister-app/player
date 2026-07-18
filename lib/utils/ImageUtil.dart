import 'package:flutter/foundation.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

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

  /// Subtitle format requested on the HLS master playlist; keep in sync with
  /// the StreamSettingsInput sent on progress updates (prefetching).
  static const String subtitleFormat = kIsWeb ? 'WEBVTT' : 'SRT';

  static String? buildMediaFileUrl(Fragment$fragmentMediaFiles? mediaFile, {String? token, bool direct = true, bool transcode = true}) {
    if (mediaFile == null) return null;
    final base = '${mediaFile.directory.node.url}/hls/${mediaFile.id}/master.m3u8?direct=$direct&transcode=$transcode&subtitleFormat=$subtitleFormat';
    return token != null ? '$base&token=$token' : base;
  }
}
