import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/seriesReadingDirection.graphql.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/comic/ComicPreferences.dart';

/// What the comic reader needs on open: the effective reading direction and
/// the series' volume list (for the "next volume" affordance).
class SeriesDirection {
  const SeriesDirection({required this.rightToLeft, this.books});

  final bool rightToLeft;

  /// Volumes in series order; null when the query failed (offline) — the
  /// next-volume affordance is then unavailable.
  final List<Query$seriesReadingDirection$seriesById$books>? books;
}

/// Resolves a series' reading direction from the server
/// (`Series.readingDirection`: user override > detected manga default > LTR).
///
/// The server is the source of truth; the per-series SharedPreferences RTL key
/// in [ComicPreferences] is only an offline cache, written through on every
/// successful fetch and read back when the query fails.
class SeriesDirectionService {
  const SeriesDirectionService._();

  static Future<SeriesDirection> fetch(
      GraphQLClient client, String seriesId) async {
    try {
      final QueryResult result = await client.query(QueryOptions(
        document: documentNodeQueryseriesReadingDirection,
        variables:
            Variables$Query$seriesReadingDirection(id: seriesId).toJson(),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException || result.data == null) {
        throw result.exception ?? Exception('empty seriesReadingDirection');
      }
      final series =
          Query$seriesReadingDirection.fromJson(result.data!).seriesById;
      if (series == null) {
        throw Exception('series $seriesId not found');
      }
      final rtl = series.readingDirection == Enum$ReadingDirection.RTL;
      await ComicPreferences.setRightToLeft(seriesId, rtl);
      return SeriesDirection(rightToLeft: rtl, books: series.books);
    } catch (error) {
      LoggerService()
          .logger
          .w('Falling back to cached reading direction for $seriesId: $error');
      return SeriesDirection(
          rightToLeft: await ComicPreferences.getRightToLeft(seriesId));
    }
  }
}
