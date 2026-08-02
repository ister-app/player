import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/tracksQuery.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../l10n/app_localizations.dart';
import 'BrowseListRow.dart';
import 'CarouselItemView.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of every track in a music library, loaded page by
/// page. Tapping a track starts playback in its album's context (the same path
/// as tapping it on the album page); the context menu jumps to the album or
/// artist instead.
class TrackScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final Input$MediaFilterInput? filter;
  final void Function(Refetch?)? onRefetch;

  const TrackScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.NAME,
    this.sortingOrder = Enum$SortingOrder.ASCENDING,
    this.listLayout = false,
    this.filter,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  void _playTrack(BuildContext context, Query$tracks$tracks$content track) {
    MediaPlayerHandler.instance.startPlayQueueForAlbum(
      GraphQLProvider.of(context).value,
      null,
      track.album,
      track.id,
      serverName,
    );
  }

  Future<void> _addToQueue(BuildContext context, String trackId) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final added = await MediaPlayerHandler.instance
        .addToQueue(serverName, Enum$MediaType.TRACK, trackId);
    if (added) {
      messenger.showSnackBar(SnackBar(content: Text(loc.addToQueue)));
    }
  }

  List<Widget> _menuItems(
      BuildContext context, Query$tracks$tracks$content track) {
    final loc = AppLocalizations.of(context)!;
    final hasFile = track.mediaFile?.isNotEmpty ?? false;
    return [
      MenuItemButton(
        onPressed: hasFile ? () => _addToQueue(context, track.id) : null,
        child: ListTile(
          leading: const Icon(Icons.playlist_add),
          title: Text(loc.addToQueue),
        ),
      ),
      MenuItemButton(
        onPressed: () => AutoRouter.of(context)
            .push(AlbumRoute(albumId: track.album.id, trackId: track.id)),
        child: ListTile(
          leading: const Icon(Icons.album),
          title: Text(loc.goToAlbum),
        ),
      ),
      MenuItemButton(
        onPressed: () => AutoRouter.of(context)
            .push(PersonRoute(personId: track.artist.id)),
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(loc.goToArtist),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Query$tracks$tracks$content>(
      document: documentNodeQuerytracks,
      rootField: 'tracks',
      fromJson: Query$tracks$tracks$content.fromJson,
      sorting: sorting,
      sortingOrder: sortingOrder,
      libraryId: libraryId,
      extraVariables:
          filter == null ? null : {'filter': filter!.toJson()},
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final itemCount = data.totalItems ?? (_pageSize * 2);

        if (listLayout) {
          return ListView.builder(
            primary: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final track = data.itemAt(index);
              if (track == null) {
                return pagedSkeletonRow(
                  key: ValueKey('track-list-skeleton-$index'),
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img = ImageUtil.getImageByType(
                  track.album.images, ImageTypes.cover);
              final menuController = MenuController();
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.music_note,
                squareThumb: true,
                title: MetadataUtil.getTitle(track.metadata) ?? '',
                subtitle: '${track.artist.name} • ${track.album.name}',
                trailing: MenuAnchor(
                  controller: menuController,
                  menuChildren: _menuItems(context, track),
                  builder: (_, MenuController controller, Widget? child) {
                    return IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                    );
                  },
                ),
                onTap: () => _playTrack(context, track),
                onLongPress: () => menuController.isOpen
                    ? menuController.close()
                    : menuController.open(),
              );
            },
          );
        }

        return GridView.builder(
          // Attach to ShowHomePage's NestedScrollView so the view-selector header
          // scrolls away with the grid (desktop does not inherit it implicitly).
          primary: true,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.0,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final track = data.itemAt(index);
            if (track != null) {
              final img = ImageUtil.getImageByType(
                  track.album.images, ImageTypes.cover);
              final menuController = MenuController();
              return MenuAnchor(
                controller: menuController,
                menuChildren: _menuItems(context, track),
                child: CarouselItemView(
                  serverName: serverName,
                  title: MetadataUtil.getTitle(track.metadata) ?? '',
                  subTitle: track.artist.name,
                  imageUrl: ImageUtil.buildUrl(img,
                      token: StreamTokenService.getToken(serverName)),
                  blurHash: img?.blurHash,
                  placeholderIcon: Icons.music_note,
                  onTap: () => _playTrack(context, track),
                  onLongPress: () => menuController.isOpen
                      ? menuController.close()
                      : menuController.open(),
                  onSecondaryTapDown: (TapDownDetails details) =>
                      menuController.isOpen
                          ? menuController.close()
                          : menuController.open(
                              position: details.localPosition),
                ),
              );
            }

            return pagedSkeletonSlot(
              key: ValueKey('track-scroll-skeleton-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
