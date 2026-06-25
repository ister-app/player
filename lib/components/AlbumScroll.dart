import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/albumsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import 'AlbumCarouselTile.dart';
import 'PagedContentView.dart';

/// Scrollable grid of all albums in a music library, loaded page by page.
class AlbumScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const AlbumScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentAlbum>(
      document: documentNodeQueryalbums,
      rootField: 'albums',
      fromJson: Fragment$fragmentAlbum.fromJson,
      sorting: Enum$SortingEnum.NAME,
      sortingOrder: Enum$SortingOrder.ASCENDING,
      libraryId: libraryId,
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final itemCount = data.totalItems ?? (_pageSize * 2);

        return GridView.builder(
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
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
