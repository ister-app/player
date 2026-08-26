import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/artistsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import 'BrowseListRow.dart';
import 'CarouselItemView.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of all artists in a music library, loaded page by
/// page. Artists are persons server-side; the `artists` operation aliases the
/// `persons` query.
class ArtistScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final Input$MediaFilterInput? filter;
  final void Function(Refetch?)? onRefetch;

  const ArtistScroll({
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
    return PagedContentView<Query$artists$artists$content>(
      document: documentNodeQueryartists,
      rootField: 'artists',
      fromJson: Query$artists$artists$content.fromJson,
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
              final artist = data.itemAt(index);
              if (artist == null) {
                return pagedSkeletonRow(
                  key: ValueKey('artist-list-skeleton-$index'),
                  placeholderIcon: Icons.person,
                  squareThumb: true,
                  subtitleWords: 0,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img =
                  ImageUtil.getImageByType(artist.images, ImageTypes.cover);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.person,
                squareThumb: true,
                title: artist.name,
                onTap: () => AutoRouter.of(context)
                    .push(PersonRoute(personId: artist.id)),
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
            final artist = data.itemAt(index);
            if (artist != null) {
              final img =
                  ImageUtil.getImageByType(artist.images, ImageTypes.cover);
              return CarouselItemView(
                serverName: serverName,
                title: artist.name,
                subTitle: '',
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                blurHash: img?.blurHash,
                placeholderIcon: Icons.person,
                onTap: () => AutoRouter.of(context)
                    .push(PersonRoute(personId: artist.id)),
              );
            }

            return pagedSkeletonSlot(
              key: ValueKey('artist-scroll-skeleton-$index'),
              placeholderIcon: Icons.person,
              subtitleWords: 0,
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
