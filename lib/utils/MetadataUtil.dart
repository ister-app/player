import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

class MetadataUtil {
  /// The first non-empty [field] among the rows in the preferred languages,
  /// best language first — so a row that lacks the field (a Dutch row
  /// without a description) falls through to the next language.
  static String? _first(List<Fragment$fragmentMetadata>? metadataList,
      String? Function(Fragment$fragmentMetadata row) field) {
    for (final row in getMetadata(metadataList) ?? const []) {
      final value = field(row);
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  /// The description, in the best available language.
  static String? getDescription(List<Fragment$fragmentMetadata>? metadataList) =>
      _first(metadataList, (row) => row.description);

  /// The title, in the best available language.
  static String? getTitle(List<Fragment$fragmentMetadata>? metadataList) =>
      _first(metadataList, (row) => row.title);

  /// The release date/year string.
  static String? getReleased(List<Fragment$fragmentMetadata>? metadataList) =>
      _first(metadataList, (row) => row.released);

  /// Appends a release/birth year in parentheses to [title], e.g.
  /// "Blade Runner (1982)". A year of 0 or null counts as unknown and is
  /// dropped, so the bare title is returned unchanged.
  static String titleWithYear(String title, int? year) =>
      (year != null && year > 0) ? '$title ($year)' : title;

  /// The tagline, in the best available language.
  static String? getTagline(List<Fragment$fragmentMetadata>? metadataList) =>
      _first(metadataList, (row) => row.tagline);

  /// The genre.
  static String? getGenre(List<Fragment$fragmentMetadata>? metadataList) =>
      _first(metadataList, (row) => row.genre);

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

  /// Overrides the UI language in tests; null follows the platform locale.
  @visibleForTesting
  static String? debugLanguageCode;

  /// The metadata languages the app can show, best first: the language the
  /// UI is in, then the other one, then rows without a language. The app
  /// follows the platform locale (en/nl), so a Dutch UI prefers Dutch
  /// descriptions and every other locale English ones.
  static List<String> preferredLanguages() {
    final code =
        debugLanguageCode ?? PlatformDispatcher.instance.locale.languageCode;
    return code == 'nl' ? const ["nld", "eng", ""] : const ["eng", "nld", ""];
  }

  /// Return a list with only the metadata for selected lang
  static List<Fragment$fragmentMetadata>? getMetadata(
      List<Fragment$fragmentMetadata>? metadataList) {
    if (metadataList != null) {
      final langCodes = preferredLanguages();
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
