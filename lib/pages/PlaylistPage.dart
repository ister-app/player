import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentPlaylistItem.graphql.dart';
import 'package:player/graphql/playlists.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import 'package:player/graphql/fragmentImages.graphql.dart';

import '../components/filter/FilterSheet.dart';
import '../components/BrowseListRow.dart';
import '../components/EpisodeScroll.dart';
import '../components/MovieScroll.dart';
import '../components/TrackScroll.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PlaylistService.dart';
import '../utils/StreamTokenService.dart';
import '../utils/filter/MediaFilterModel.dart';

/// One playlist: header with play/shuffle, then either the reorderable manual
/// item list or — for smart playlists — the live filter result (the same
/// paged browse the filter sheet feeds) plus a filter-edit action.
@RoutePage()
class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('playlistId') required this.playlistId,
  });

  final String serverName;
  final String playlistId;

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Query$playlistById$playlistById? _playlist;
  bool _loaded = false;

  get _client => ClientManager.getClientForUrl(widget.serverName).value;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final playlist = await PlaylistService.byId(_client, widget.playlistId);
    if (mounted) {
      setState(() {
        _playlist = playlist;
        _loaded = true;
      });
    }
  }

  bool get _isSmart => _playlist?.type == Enum$PlaylistType.SMART;

  /// Book playlists play chapters in book order; shuffle is meaningless there.
  bool get _canShuffle =>
      _playlist?.libraryType != Enum$LibraryType.BOOK;

  /// Plays the playlist itself, at [startId] when given.
  void _play({String? startId, bool shuffle = false}) {
    MediaPlayerHandler.instance.startPlaylistPlay(
      _client,
      widget.serverName,
      widget.playlistId,
      startId: startId,
      shuffle: shuffle,
    );
  }

  Future<void> _rename() async {
    final playlist = _playlist;
    if (playlist == null) return;
    final loc = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: playlist.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.editPlaylist),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: loc.playlistName),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || name == playlist.name) return;
    await _update(name: name);
  }

  Future<void> _editFilter() async {
    final playlist = _playlist;
    final kind = playlist?.filterKind;
    if (playlist == null || kind == null) return;
    await showFilterSheet(
      context,
      kind: kind,
      libraryId: playlist.libraryId,
      initial: PlaylistService.filterOf(playlist),
      onApply: (filter) async {
        if (filter == null || filter.isEmpty) return;
        await _update(filter: filter);
      },
    );
  }

  /// Updates the playlist keeping everything not passed; library and type are
  /// immutable server-side and always sent as-is.
  Future<void> _update({String? name, MediaFilterModel? filter}) async {
    final playlist = _playlist;
    if (playlist == null) return;
    await PlaylistService.update(
      _client,
      playlist.id,
      name: name ?? playlist.name,
      libraryId: playlist.libraryId,
      type: playlist.type,
      filter: filter ?? PlaylistService.filterOf(playlist),
      filterKind: playlist.filterKind,
      sorting: playlist.sorting,
      sortingOrder: playlist.sortingOrder,
    );
    await _load();
  }

  Future<void> _delete() async {
    final playlist = _playlist;
    if (playlist == null) return;
    final loc = AppLocalizations.of(context)!;
    final router = AutoRouter.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deletePlaylist),
        content: Text(loc.deletePlaylistConfirm(playlist.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.deletePlaylist),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (await PlaylistService.delete(_client, playlist.id)) {
      router.maybePop();
    }
  }

  Future<void> _removeItem(String itemId) async {
    await PlaylistService.removeItem(_client,
        playlistId: widget.playlistId, playlistItemId: itemId);
    await _load();
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    final playlist = _playlist;
    if (playlist == null) return;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex == oldIndex) return;
    final items = List.of(playlist.items);
    final moving = items.removeAt(oldIndex);
    items.insert(newIndex, moving);
    final afterId = newIndex == 0 ? null : items[newIndex - 1].id;
    // Optimistic: show the new order immediately, reconcile with a reload.
    setState(() => _playlist = playlist.copyWith(items: items));
    await PlaylistService.moveItem(_client,
        playlistId: widget.playlistId,
        playlistItemId: moving.id,
        afterPlaylistItemId: afterId);
    await _load();
  }

  /// One manual entry as a browse row, so the hand-picked list reads like the
  /// filter result a smart playlist shows: artwork, title/subtitle and the
  /// media id to start playback at. [square] picks the cover thumb over the
  /// landscape one, matching the `*Scroll` list layouts per media kind.
  _ItemRow _itemRow(Fragment$fragmentPlaylistItem item) {
    final track = item.track;
    if (track != null) {
      return _ItemRow(
        title: MetadataUtil.getTitle(track.metadata) ?? '',
        subtitle: '${track.artist.name} • ${track.album.name}',
        mediaId: track.id,
        image: ImageUtil.getImageByType(track.album.images, ImageTypes.cover),
        icon: Icons.music_note,
      );
    }
    final movie = item.movie;
    if (movie != null) {
      return _ItemRow(
        title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
        subtitle: movie.releaseYear.toString(),
        mediaId: movie.id,
        image: ImageUtil.getImageByType(movie.images, ImageTypes.cover),
        icon: Icons.movie,
      );
    }
    final episode = item.episode;
    if (episode != null) {
      return _ItemRow(
        title: MetadataUtil.getTitle(episode.metadata) ?? 'E${episode.number}',
        subtitle: 'E${episode.number}',
        mediaId: episode.id,
        // The playlist's episode selection carries no show, so its own still is
        // all there is to show.
        image: ImageUtil.getImageByType(episode.images, ImageTypes.background) ??
            ImageUtil.getImageByType(episode.images, ImageTypes.cover),
        icon: Icons.tv,
        square: false,
      );
    }
    final book = item.book;
    if (book != null) {
      return _ItemRow(
        title: book.title,
        subtitle: book.author?.name ?? book.series?.name,
        mediaId: book.id,
        image: ImageUtil.getImageByType(book.images, ImageTypes.cover),
        icon: Icons.menu_book,
      );
    }
    final podcastEpisode = item.podcastEpisode;
    if (podcastEpisode != null) {
      return _ItemRow(
        title: MetadataUtil.getTitle(podcastEpisode.metadata) ?? '',
        subtitle: podcastEpisode.podcast.title,
        mediaId: podcastEpisode.id,
        image: ImageUtil.getImageByType(
            podcastEpisode.podcast.images, ImageTypes.cover),
        icon: Icons.podcasts,
      );
    }
    return const _ItemRow(title: '', icon: Icons.play_circle_outline);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final playlist = _playlist;
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist?.name ?? ''),
        actions: [
          if (playlist != null) ...[
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: loc.filterPlayResults,
              onPressed: () => _play(),
            ),
            if (_canShuffle)
              IconButton(
                icon: const Icon(Icons.shuffle),
                tooltip: loc.shufflePlay,
                onPressed: () => _play(shuffle: true),
              ),
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: _rename,
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(loc.editPlaylist),
                  ),
                ),
                if (_isSmart)
                  MenuItemButton(
                    onPressed: _editFilter,
                    child: ListTile(
                      leading: const Icon(Icons.filter_alt),
                      title: Text(loc.editFilter),
                    ),
                  ),
                MenuItemButton(
                  onPressed: _delete,
                  child: ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: Text(loc.deletePlaylist),
                  ),
                ),
              ],
              builder: (_, MenuController controller, __) => IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
          ],
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : playlist == null
              ? Center(child: Text(loc.noPlaylistsYet))
              : _isSmart
                  ? _smartBody(playlist)
                  : _manualBody(loc, playlist),
    );
  }

  /// The live result of the smart playlist's filter — the same paged browse
  /// widgets the library filter uses, so sorting and tiles match.
  Widget _smartBody(Query$playlistById$playlistById playlist) {
    final filter = PlaylistService.filterOf(playlist)?.toInput();
    final sorting = playlist.sorting ?? Enum$SortingEnum.NAME;
    final sortingOrder = playlist.sortingOrder ?? Enum$SortingOrder.ASCENDING;
    switch (playlist.filterKind) {
      case Enum$FilterKind.MOVIE:
        return MovieScroll(
          serverName: widget.serverName,
          libraryId: playlist.libraryId,
          sorting: sorting,
          sortingOrder: sortingOrder,
          filter: filter,
          listLayout: true,
        );
      case Enum$FilterKind.EPISODE:
        return EpisodeScroll(
          serverName: widget.serverName,
          libraryId: playlist.libraryId,
          sorting: sorting,
          sortingOrder: sortingOrder,
          filter: filter,
          listLayout: true,
        );
      default:
        return TrackScroll(
          serverName: widget.serverName,
          libraryId: playlist.libraryId,
          sorting: sorting,
          sortingOrder: sortingOrder,
          filter: filter,
          listLayout: true,
          // Tapping a track plays the playlist from there, not its album.
          onTrackTap: (trackId) => _play(startId: trackId),
        );
    }
  }

  Widget _manualBody(
      AppLocalizations loc, Query$playlistById$playlistById playlist) {
    final items = playlist.items;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.playlistEmpty)),
      );
    }
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final item = items[index];
        final row = _itemRow(item);
        return BrowseListRow(
          key: ValueKey(item.id),
          imageUrl: ImageUtil.buildUrl(row.image,
              token: StreamTokenService.getToken(widget.serverName)),
          placeholderIcon: row.icon,
          squareThumb: row.square,
          title: row.title,
          subtitle: row.subtitle,
          onTap: row.mediaId == null
              ? null
              : () => _play(startId: row.mediaId),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: loc.removeFromPlaylist,
                onPressed: () => _removeItem(item.id),
              ),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The display shape of one manual playlist entry, whatever media kind it holds.
class _ItemRow {
  const _ItemRow({
    required this.title,
    required this.icon,
    this.subtitle,
    this.mediaId,
    this.image,
    this.square = true,
  });

  final String title;
  final String? subtitle;
  final String? mediaId;
  final Fragment$fragmentImages? image;
  final IconData icon;
  final bool square;
}
