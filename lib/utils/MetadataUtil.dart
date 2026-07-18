import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

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

  /// Get the release date/year string from the metadata.
  static String? getReleased(List<Fragment$fragmentMetadata>? metadataList) {
    try {
      return getMetadata(metadataList)
          ?.firstWhere((element) => (element.released ?? "") != "")
          .released;
    } on StateError catch (_) {
      return null;
    }
  }

  /// Appends a release/birth year in parentheses to [title], e.g.
  /// "Blade Runner (1982)". A year of 0 or null counts as unknown and is
  /// dropped, so the bare title is returned unchanged.
  static String titleWithYear(String title, int? year) =>
      (year != null && year > 0) ? '$title ($year)' : title;

  /// Get the genre from the metadata.
  static String? getGenre(List<Fragment$fragmentMetadata>? metadataList) {
    try {
      return getMetadata(metadataList)
          ?.firstWhere((element) => (element.genre ?? "") != "")
          .genre;
    } on StateError catch (_) {
      return null;
    }
  }

  /// A short "released • genre" subtitle, omitting whichever part is missing.
  /// Returns null when neither is available.
  static String? getMetaLine(List<Fragment$fragmentMetadata>? metadataList) {
    final released = getReleased(metadataList);
    final genre = getGenre(metadataList);
    final parts = [
      if ((released ?? "").isNotEmpty) released!,
      if ((genre ?? "").isNotEmpty) genre!,
    ];
    return parts.isEmpty ? null : parts.join(' • ');
  }

  /// Distinct attribution sources of the (language-filtered) metadata rows.
  static List<Enum$MetadataSource> getSources(
      List<Fragment$fragmentMetadata>? metadataList) {
    return (getMetadata(metadataList) ?? [])
        .map((element) => element.source)
        .whereType<Enum$MetadataSource>()
        .toSet()
        .toList();
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
