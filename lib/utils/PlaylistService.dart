import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlaylist.graphql.dart';
import 'package:player/graphql/playlists.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import 'LoggerService.dart';
import 'filter/MediaFilterModel.dart';

/// The user's playlists on one server: manual item lists and smart
/// (filter-backed) playlists, always scoped to one library. Thin wrappers over
/// the playlist query/mutations; errors log and return null so callers can
/// degrade (an older server without the schema just shows no playlists).
class PlaylistService {
  PlaylistService._();

  static Future<List<Fragment$fragmentPlaylist>?> list(
    GraphQLClient client, {
    String? libraryId,
  }) async {
    final result = await client.query(QueryOptions(
      document: documentNodeQueryplaylists,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: Variables$Query$playlists(libraryId: libraryId).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$playlists.fromJson(result.data!).playlists;
  }

  static Future<Query$playlistById$playlistById?> byId(
      GraphQLClient client, String id) async {
    final result = await client.query(QueryOptions(
      document: documentNodeQueryplaylistById,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: Variables$Query$playlistById(id: id).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$playlistById.fromJson(result.data!).playlistById;
  }

  static Future<Fragment$fragmentPlaylist?> create(
    GraphQLClient client, {
    required String name,
    required String libraryId,
    required Enum$PlaylistType type,
    MediaFilterModel? filter,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationcreatePlaylist,
      variables: Variables$Mutation$createPlaylist(
        input: Input$PlaylistInput(
          name: name,
          libraryId: libraryId,
          type: type,
          filter: filter?.toInput(),
          filterKind: filterKind,
          sorting: sorting,
          sortingOrder: sortingOrder,
        ),
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$createPlaylist.fromJson(result.data!).createPlaylist;
  }

  /// The library and type are immutable server-side; pass the playlist's own.
  static Future<Fragment$fragmentPlaylist?> update(
    GraphQLClient client,
    String id, {
    required String name,
    required String libraryId,
    required Enum$PlaylistType type,
    MediaFilterModel? filter,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationupdatePlaylist,
      variables: Variables$Mutation$updatePlaylist(
        id: id,
        input: Input$PlaylistInput(
          name: name,
          libraryId: libraryId,
          type: type,
          filter: filter?.toInput(),
          filterKind: filterKind,
          sorting: sorting,
          sortingOrder: sortingOrder,
        ),
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$updatePlaylist.fromJson(result.data!).updatePlaylist;
  }

  static Future<bool> delete(GraphQLClient client, String id) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationdeletePlaylist,
      variables: Variables$Mutation$deletePlaylist(id: id).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return false;
    }
    return Mutation$deletePlaylist.fromJson(result.data!).deletePlaylist;
  }

  static Future<bool> addItem(
    GraphQLClient client, {
    required String playlistId,
    required String mediaId,
    String? afterPlaylistItemId,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationaddPlaylistItem,
      variables: Variables$Mutation$addPlaylistItem(
        playlistId: playlistId,
        mediaId: mediaId,
        afterPlaylistItemId: afterPlaylistItemId,
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return false;
    }
    return true;
  }

  static Future<Mutation$movePlaylistItem$movePlaylistItem?> moveItem(
    GraphQLClient client, {
    required String playlistId,
    required String playlistItemId,
    String? afterPlaylistItemId,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationmovePlaylistItem,
      variables: Variables$Mutation$movePlaylistItem(
        playlistId: playlistId,
        playlistItemId: playlistItemId,
        afterPlaylistItemId: afterPlaylistItemId,
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$movePlaylistItem.fromJson(result.data!).movePlaylistItem;
  }

  static Future<Mutation$removePlaylistItem$removePlaylistItem?> removeItem(
    GraphQLClient client, {
    required String playlistId,
    required String playlistItemId,
  }) async {
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationremovePlaylistItem,
      variables: Variables$Mutation$removePlaylistItem(
        playlistId: playlistId,
        playlistItemId: playlistItemId,
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Mutation$removePlaylistItem.fromJson(result.data!).removePlaylistItem;
  }

  /// The stored filter tree of a smart playlist, back as a builder model; null
  /// for manual playlists. The fragment's JSON uses the model's own format.
  static MediaFilterModel? filterOf(Fragment$fragmentPlaylist playlist) =>
      playlist.filter == null
          ? null
          : MediaFilterModel.fromJson(playlist.filter!.toJson());
}
