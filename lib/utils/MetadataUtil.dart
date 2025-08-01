import 'package:player/graphql/fragmentMetadata.graphql.dart';

class MetadataUtil {
  /// Get the description from te metadata.
  /// Use a try catch block for if for all selected lang the description is null
  static String? getDescription(List<Fragment$fragmentMetadata>? metadataList) {
    try {
      return getMetadata(metadataList)
          ?.firstWhere((element) => (element.description ?? "") != "")
          .description;
    } on StateError catch (_) {
      return null;
    }
  }

  /// Get the title from te metadata.
  /// Use a try catch block for if for all selected lang the title is null
  static String? getTitle(List<Fragment$fragmentMetadata>? metadataList) {
    try {
      return getMetadata(metadataList)
          ?.firstWhere((element) => (element.title ?? "") != "")
          .title;
    } on StateError catch (_) {
      return null;
    }
  }

  /// Return a list with only the metadata for selected lang
  static List<Fragment$fragmentMetadata>? getMetadata(
      List<Fragment$fragmentMetadata>? metadataList) {
    if (metadataList != null) {
      var langCodes = ["nld", "eng", ""];
      var list = metadataList.where((element) {
        return langCodes.contains(element.language ?? "");
      }).toList();
      list.sort((a, b) {
        return langCodes.indexOf(a.language ?? "") -
            langCodes.indexOf(b.language ?? "");
      });
      return list;
    }
    return null;
  }
}
