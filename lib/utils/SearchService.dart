import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/search.graphql.dart';

import 'LoggerService.dart';

/// Thin wrapper around the `search` query. The server ranks results across
/// movies, shows, episodes, persons, albums and tracks and returns them as a
/// [SearchResult] union — surfaced here as [Query$search$search] subtypes.
class SearchService {
  SearchService._privateConstructor();

  static final SearchService _instance = SearchService._privateConstructor();

  factory SearchService() => _instance;

  /// The results for [term], or `const []` when the search failed — for
  /// callers that only want something to show.
  Future<List<Query$search$search>> search(
    GraphQLClient client,
    String term, {
    int? size,
    String? libraryId,
  }) async =>
      await searchOrNull(client, term, size: size, libraryId: libraryId) ??
      const [];

  /// Like [search], but null when the search itself failed, so a page can
  /// tell "the server did not answer" from "nothing matches".
  Future<List<Query$search$search>?> searchOrNull(
    GraphQLClient client,
    String term, {
    int? size,
    String? libraryId,
  }) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return const [];

    final result = await client.query(QueryOptions(
      document: documentNodeQuerysearch,
      variables: Variables$Query$search(
        term: trimmed,
        size: size,
        libraryId: libraryId,
      ).toJson(),
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    if (result.data == null) return null;
    return Query$search.fromJson(result.data!).search;
  }
}
