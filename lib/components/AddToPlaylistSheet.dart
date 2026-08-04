import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlaylist.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/PlaylistService.dart';
import 'PlaylistCoverMosaic.dart';
import 'PlaylistEditSheet.dart';

/// Bottom sheet that adds media to one of the user's own manual playlists.
/// Only playlists that can hold [mediaType] are offered (a playlist holds one
/// item kind, determined by its library type); the server additionally rejects
/// items from another library. [loadItemIds] resolves the ids to add — lazily,
/// so a whole album only fetches its tracks after a playlist was chosen.
Future<void> showAddToPlaylistSheet(
  BuildContext context, {
  required String serverName,
  required Enum$MediaType mediaType,
  required Future<List<String>> Function(GraphQLClient client) loadItemIds,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _AddToPlaylistSheet(
      serverName: serverName,
      mediaType: mediaType,
      loadItemIds: loadItemIds,
    ),
  );
}

/// The one playable item kind a playlist of [libraryType] holds; mirrors the
/// server's mapping (BOOK libraries playlist whole books).
Enum$MediaType? playlistItemTypeFor(Enum$LibraryType libraryType) {
  switch (libraryType) {
    case Enum$LibraryType.MUSIC:
      return Enum$MediaType.TRACK;
    case Enum$LibraryType.MOVIE:
      return Enum$MediaType.MOVIE;
    case Enum$LibraryType.SHOW:
      return Enum$MediaType.EPISODE;
    case Enum$LibraryType.PODCAST:
      return Enum$MediaType.PODCAST_EPISODE;
    case Enum$LibraryType.BOOK:
      return Enum$MediaType.BOOK;
    default:
      return null;
  }
}

class _AddToPlaylistSheet extends StatefulWidget {
  const _AddToPlaylistSheet({
    required this.serverName,
    required this.mediaType,
    required this.loadItemIds,
  });

  final String serverName;
  final Enum$MediaType mediaType;
  final Future<List<String>> Function(GraphQLClient client) loadItemIds;

  @override
  State<_AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<_AddToPlaylistSheet> {
  List<Fragment$fragmentPlaylist>? _playlists;
  bool _busy = false;

  GraphQLClient get _client =>
      ClientManager.getClientForUrl(widget.serverName).value;

  @override
  void initState() {
    super.initState();
    PlaylistService.list(_client).then((playlists) {
      if (!mounted) return;
      setState(() {
        _playlists = (playlists ?? [])
            .where((playlist) =>
                playlist.type == Enum$PlaylistType.MANUAL &&
                playlistItemTypeFor(playlist.libraryType) == widget.mediaType)
            .toList();
      });
    });
  }

  /// Creates a playlist for these items and adds them to it — the way to make
  /// the first one, since the sheet is otherwise a dead end. Always MANUAL: a
  /// smart playlist follows a filter and takes no hand-picked items.
  ///
  /// A playlist belongs to one library and the media item does not carry its
  /// own, so the library is resolved from the libraries that can hold this item
  /// kind: silently when there is only one, otherwise the user picks.
  Future<void> _createAndAdd() async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final libraries = await _candidateLibraries();
    if (!mounted) return;
    if (libraries.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(loc.addToPlaylistFailed)));
      return;
    }
    final library = libraries.length == 1
        ? libraries.first
        : await _pickLibrary(libraries);
    if (library == null || !mounted) return;
    final name = await showPlaylistNameDialog(context, loc.newPlaylist);
    if (name == null || !mounted) return;

    setState(() => _busy = true);
    final playlist = await PlaylistService.create(
      _client,
      name: name,
      libraryId: library.id,
      type: Enum$PlaylistType.MANUAL,
    );
    if (!mounted) return;
    if (playlist == null) {
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(loc.addToPlaylistFailed)));
      return;
    }
    await _add(playlist);
  }

  /// The libraries whose playlists can hold this item kind.
  Future<List<Query$libraries$libraries>> _candidateLibraries() async {
    final result = await _client.query(QueryOptions(
      document: documentNodeQuerylibraries,
      fetchPolicy: FetchPolicy.cacheFirst,
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return [];
    }
    return (Query$libraries.fromJson(result.data!).libraries ?? [])
        .where((library) =>
            playlistItemTypeFor(library.type) == widget.mediaType)
        .toList();
  }

  Future<Query$libraries$libraries?> _pickLibrary(
      List<Query$libraries$libraries> libraries) {
    final loc = AppLocalizations.of(context)!;
    return showDialog<Query$libraries$libraries>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(loc.library),
        children: [
          for (final library in libraries)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(library),
              child: Text(library.name),
            ),
        ],
      ),
    );
  }

  Future<void> _add(Fragment$fragmentPlaylist playlist) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    var success = true;
    try {
      final ids = await widget.loadItemIds(_client);
      if (ids.isEmpty) success = false;
      for (final id in ids) {
        if (!await PlaylistService.addItem(_client,
            playlistId: playlist.id, mediaId: id)) {
          success = false;
          break;
        }
      }
    } catch (e) {
      LoggerService().logger.e(e);
      success = false;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(
        content: Text(success ? loc.addedToPlaylist : loc.addToPlaylistFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final playlists = _playlists;

    Widget body;
    if (_busy || playlists == null) {
      body = const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(loc.addToPlaylist,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          // First, so it is also the answer when there is nothing to pick yet.
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(loc.newPlaylist),
            onTap: _createAndAdd,
          ),
          for (final playlist in playlists)
            ListTile(
              leading: PlaylistCoverMosaic(
                serverName: widget.serverName,
                covers: playlist.coverImages,
                placeholderIcon: Icons.queue_music,
                size: 48,
              ),
              title: Text(playlist.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: playlist.itemCount == null
                  ? null
                  : Text(loc.playlistItemCount(playlist.itemCount!)),
              onTap: () => _add(playlist),
            ),
        ],
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: body,
      ),
    );
  }
}
