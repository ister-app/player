import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/albumsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import 'AlbumCarouselTile.dart';
import 'BrowseListRow.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of all albums in a music library, loaded page by page.
class AlbumScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final Input$MediaFilterInput? filter;
  final void Function(Refetch?)? onRefetch;

  const AlbumScroll({
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

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentAlbum>(
      document: documentNodeQueryalbums,
      rootField: 'albums',
      fromJson: Fragment$fragmentAlbum.fromJson,
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
              final album = data.itemAt(index);
              if (album == null) {
                return pagedSkeletonRow(
                  key: ValueKey('album-list-skeleton-$index'),
                  placeholderIcon: Icons.music_note,
                  squareThumb: true,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img =
                  ImageUtil.getImageByType(album.images, ImageTypes.cover);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.music_note,
                squareThumb: true,
                title: MetadataUtil.getTitle(album.metadata) ?? album.name,
                subtitle: album.artist.name,
                onTap: () => AutoRouter.of(context)
                    .push(AlbumRoute(albumId: album.id)),
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
            final album = data.itemAt(index);
            if (album != null) {
              return AlbumCarouselTile(serverName: serverName, album: album);
            }

            return pagedSkeletonSlot(
              key: ValueKey('album-scroll-skeleton-$index'),
              placeholderIcon: Icons.music_note,
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
