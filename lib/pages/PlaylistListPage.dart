import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentPlaylist.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';

import '../components/PlaylistEditSheet.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/PlaylistService.dart';

/// The user's playlists, optionally scoped to one library — the "show all"
/// page behind the Discover playlists row. Creating is only offered with a
/// library context (a playlist always belongs to one library).
@RoutePage()
class PlaylistListPage extends StatefulWidget {
  const PlaylistListPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam('libraryId') this.libraryId,
    @QueryParam('libraryType') this.libraryTypeName,
  });

  final String serverName;
  final String? libraryId;
  final String? libraryTypeName;

  @override
  State<PlaylistListPage> createState() => _PlaylistListPageState();
}

class _PlaylistListPageState extends State<PlaylistListPage> {
  List<Fragment$fragmentPlaylist>? _playlists;

  Enum$LibraryType? get _libraryType => Enum$LibraryType.values
      .where((type) => type.name == widget.libraryTypeName)
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final client = ClientManager.getClientForUrl(widget.serverName).value;
    final playlists =
        await PlaylistService.list(client, libraryId: widget.libraryId);
    if (mounted) setState(() => _playlists = playlists ?? []);
  }

  void _create() {
    final libraryId = widget.libraryId;
    final libraryType = _libraryType;
    if (libraryId == null || libraryType == null) return;
    showPlaylistCreateSheet(
      context,
      serverName: widget.serverName,
      libraryId: libraryId,
      libraryType: libraryType,
      onCreated: (playlist) {
        _load();
        if (mounted) {
          AutoRouter.of(context)
              .push(PlaylistRoute(playlistId: playlist.id));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final playlists = _playlists;
    final canCreate = widget.libraryId != null && _libraryType != null;
    return Scaffold(
      appBar: AppBar(title: Text(loc.playlists)),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              tooltip: loc.newPlaylist,
              onPressed: _create,
              child: const Icon(Icons.add),
            )
          : null,
      body: playlists == null
          ? const Center(child: CircularProgressIndicator())
          : playlists.isEmpty
              ? Center(child: Text(loc.noPlaylistsYet))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      for (final playlist in playlists)
                        ListTile(
                          leading: Icon(playlist.type ==
                                  Enum$PlaylistType.SMART
                              ? Icons.auto_awesome
                              : Icons.queue_music),
                          title: Text(playlist.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(playlist.type ==
                                  Enum$PlaylistType.SMART
                              ? loc.smartPlaylist
                              : loc.playlistItemCount(
                                  playlist.itemCount ?? 0)),
                          onTap: () async {
                            await AutoRouter.of(context).push(
                                PlaylistRoute(playlistId: playlist.id));
                            _load();
                          },
                        ),
                    ],
                  ),
                ),
    );
  }
}
