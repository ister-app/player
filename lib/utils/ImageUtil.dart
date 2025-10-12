import 'package:player/graphql/fragmentImages.graphql.dart';

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
}
