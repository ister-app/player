import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentSavedView.graphql.dart';
import 'package:player/graphql/savedViews.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import 'LoggerService.dart';
import 'filter/MediaFilterModel.dart';

/// The user's custom views (saved filters) on one server. Thin wrappers over
/// the savedViews query and mutations; errors log and return null so the
/// filter sheet can degrade to "no views" instead of breaking the browse view.
class SavedViewService {
  SavedViewService._();

  static Future<List<Fragment$fragmentSavedView>?> list(
    GraphQLClient client, {
    String? libraryId,
    Enum$FilterKind? kind,
  }) async {
    final result = await client.query(QueryOptions(
      document: documentNodeQuerysavedViews,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: Variables$Query$savedViews(libraryId: libraryId, kind: kind)
          .toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$savedViews.fromJson(result.data!).savedViews;
  }

  static Future<Fragment$fragmentSavedView?> create(
    GraphQLClient client, {
    required String name,
    required Enum$FilterKind kind,
    String? libraryId,
    required MediaFilterModel filter,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationcreateSavedView,
      variables: Variables$Mutation$createSavedView(
        input: Input$SavedViewInput(
          name: name,
          kind: kind,
          libraryId: libraryId,
          filter: filter.toInput(),
          sorting: sorting,
          sortingOrder: sortingOrder,
        ),
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$createSavedView.fromJson(result.data!).createSavedView;
  }

  static Future<bool> delete(GraphQLClient client, String id) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationdeleteSavedView,
      variables: Variables$Mutation$deleteSavedView(id: id).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return false;
    }
    return Mutation$deleteSavedView.fromJson(result.data!).deleteSavedView;
  }

  /// The stored filter tree of a view, back as a builder model. The fragment's
  /// JSON uses the same shape and enum names as the model's own format.
  static MediaFilterModel filterOf(Fragment$fragmentSavedView view) =>
      MediaFilterModel.fromJson(view.filter.toJson());
}
