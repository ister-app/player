import 'package:flutter/foundation.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';

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
        return coverImages.first;
      }
    }
    return null;
  }

  static String? buildUrl(Fragment$fragmentImages? image, {String? token}) {
    if (image == null) return null;
    final base = '${image.directory.node.url}/images/${image.id}/download';
    return token != null ? '$base?token=$token' : base;
  }

  static String? buildMediaFileUrl(Fragment$fragmentMediaFiles? mediaFile, {String? token, bool direct = true, bool transcode = true}) {
    if (mediaFile == null) return null;
    // final subtitleFormat = kIsWeb ? 'WEBVTT' : 'WEBVTT';
    final subtitleFormat = kIsWeb ? 'WEBVTT' : 'SRT';
    final base = '${mediaFile.directory.node.url}/hls/${mediaFile.id}/master.m3u8?direct=$direct&transcode=$transcode&subtitleFormat=$subtitleFormat';
    return token != null ? '$base&token=$token' : base;
  }
}
