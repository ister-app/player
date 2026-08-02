import 'package:player/graphql/schema.graphql.dart';

import '../BrowseKind.dart';

/// How a filter field's value is entered and encoded. Mirrors the server's
/// validation: string/number/date/boolean each allow their own operators.
enum FilterValueKind { text, number, date, boolean }

/// Which filter kind a library browse view maps to, which fields that kind
/// supports and which operators fit each field. This is the client-side twin
/// of the server's FilterQueryService tables — keep the two in step.
class FilterCatalog {
  FilterCatalog._();

  /// The filter kind of the current browse view; null = no filter support
  /// (books, comics, podcasts).
  static Enum$FilterKind? kindFor(
      Enum$LibraryType? libraryType, BrowseKind? browseKind) {
    switch (libraryType) {
      case Enum$LibraryType.MOVIE:
        return Enum$FilterKind.MOVIE;
      case Enum$LibraryType.SHOW:
        return browseKind == BrowseKind.episodes
            ? Enum$FilterKind.EPISODE
            : Enum$FilterKind.SHOW;
      case Enum$LibraryType.MUSIC:
        switch (browseKind) {
          case BrowseKind.artists:
            return Enum$FilterKind.ARTIST;
          case BrowseKind.tracks:
            return Enum$FilterKind.TRACK;
          default:
            return Enum$FilterKind.ALBUM;
        }
      default:
        return null;
    }
  }

  /// Kinds whose filter results can be played as a queue (server restriction).
  static bool isPlayable(Enum$FilterKind kind) =>
      kind == Enum$FilterKind.TRACK ||
      kind == Enum$FilterKind.MOVIE ||
      kind == Enum$FilterKind.EPISODE;

  /// The fields the server supports per kind, in menu order.
  static List<Enum$FilterField> fieldsFor(Enum$FilterKind kind) {
    switch (kind) {
      case Enum$FilterKind.ARTIST:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.BIRTH_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.ALBUM:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.ARTIST_NAME,
          Enum$FilterField.RELEASE_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.RATING,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.TRACK:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.ARTIST_NAME,
          Enum$FilterField.ALBUM_NAME,
          Enum$FilterField.RELEASE_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.RATING,
          Enum$FilterField.PLAY_COUNT,
          Enum$FilterField.LAST_PLAYED_AT,
          Enum$FilterField.DURATION,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.MOVIE:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.RELEASE_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.RATING,
          Enum$FilterField.DURATION,
          Enum$FilterField.WATCHED,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.SHOW:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.RELEASE_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.RATING,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.EPISODE:
        return const [
          Enum$FilterField.TITLE,
          Enum$FilterField.RELEASE_YEAR,
          Enum$FilterField.GENRE,
          Enum$FilterField.RATING,
          Enum$FilterField.DURATION,
          Enum$FilterField.WATCHED,
          Enum$FilterField.DATE_ADDED,
        ];
      case Enum$FilterKind.$unknown:
        return const [];
    }
  }

  static FilterValueKind valueKindOf(Enum$FilterField field) {
    switch (field) {
      case Enum$FilterField.TITLE:
      case Enum$FilterField.ARTIST_NAME:
      case Enum$FilterField.ALBUM_NAME:
      case Enum$FilterField.GENRE:
        return FilterValueKind.text;
      case Enum$FilterField.RELEASE_YEAR:
      case Enum$FilterField.BIRTH_YEAR:
      case Enum$FilterField.RATING:
      case Enum$FilterField.PLAY_COUNT:
      case Enum$FilterField.DURATION:
        return FilterValueKind.number;
      case Enum$FilterField.LAST_PLAYED_AT:
      case Enum$FilterField.DATE_ADDED:
        return FilterValueKind.date;
      case Enum$FilterField.WATCHED:
        return FilterValueKind.boolean;
      case Enum$FilterField.$unknown:
        return FilterValueKind.text;
    }
  }

  /// The operators the server accepts for a field's value kind, in menu order.
  static List<Enum$FilterOperator> operatorsFor(Enum$FilterField field) {
    switch (valueKindOf(field)) {
      case FilterValueKind.text:
        return const [
          Enum$FilterOperator.CONTAINS,
          Enum$FilterOperator.NOT_CONTAINS,
          Enum$FilterOperator.EQUALS,
          Enum$FilterOperator.NOT_EQUALS,
          Enum$FilterOperator.IS_SET,
          Enum$FilterOperator.IS_NOT_SET,
        ];
      case FilterValueKind.number:
        return const [
          Enum$FilterOperator.EQUALS,
          Enum$FilterOperator.NOT_EQUALS,
          Enum$FilterOperator.LESS_THAN,
          Enum$FilterOperator.GREATER_THAN,
          Enum$FilterOperator.IS_SET,
          Enum$FilterOperator.IS_NOT_SET,
        ];
      case FilterValueKind.date:
        return const [
          Enum$FilterOperator.IN_LAST_DAYS,
          Enum$FilterOperator.BEFORE,
          Enum$FilterOperator.AFTER,
          Enum$FilterOperator.IS_SET,
          Enum$FilterOperator.IS_NOT_SET,
        ];
      case FilterValueKind.boolean:
        return const [Enum$FilterOperator.EQUALS];
    }
  }

  static bool operatorNeedsValue(Enum$FilterOperator operator) =>
      operator != Enum$FilterOperator.IS_SET &&
      operator != Enum$FilterOperator.IS_NOT_SET;

  /// DURATION travels as milliseconds but is entered in minutes; everything
  /// else passes through unchanged. IN_LAST_DAYS always takes a day count.
  static String encodeValue(
      Enum$FilterField field, Enum$FilterOperator operator, String uiValue) {
    final trimmed = uiValue.trim();
    if (field == Enum$FilterField.DURATION &&
        operator != Enum$FilterOperator.IN_LAST_DAYS) {
      final minutes = int.tryParse(trimmed);
      if (minutes != null) return (minutes * 60000).toString();
    }
    return trimmed;
  }

  static String decodeValue(
      Enum$FilterField field, Enum$FilterOperator operator, String? wireValue) {
    if (wireValue == null) return '';
    if (field == Enum$FilterField.DURATION &&
        operator != Enum$FilterOperator.IN_LAST_DAYS) {
      final ms = int.tryParse(wireValue);
      if (ms != null) return (ms ~/ 60000).toString();
    }
    return wireValue;
  }
}
