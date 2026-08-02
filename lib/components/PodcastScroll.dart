import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/podcastsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentPodcast.graphql.dart';
import 'BrowseListRow.dart';
import 'PagedContentView.dart';
import 'PodcastCarouselTile.dart';

/// Scrollable grid or list of all podcast subscriptions, loaded page by page.
class PodcastScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final void Function(Refetch?)? onRefetch;

  const PodcastScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.NAME,
    this.sortingOrder = Enum$SortingOrder.ASCENDING,
    this.listLayout = false,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentPodcast>(
      document: documentNodeQuerypodcasts,
      rootField: 'podcasts',
      fromJson: Fragment$fragmentPodcast.fromJson,
      sorting: sorting,
      sortingOrder: sortingOrder,
      libraryId: libraryId,
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
              final podcast = data.itemAt(index);
              if (podcast == null) {
                return pagedSkeletonRow(
                  key: ValueKey('podcast-list-skeleton-$index'),
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img =
                  ImageUtil.getImageByType(podcast.images, ImageTypes.cover);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.podcasts,
                squareThumb: true,
                title: MetadataUtil.getTitle(podcast.metadata) ?? podcast.title,
                subtitle: podcast.author ?? '',
                onTap: () => AutoRouter.of(context)
                    .push(PodcastRoute(podcastId: podcast.id)),
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
            final podcast = data.itemAt(index);
            if (podcast != null) {
              return PodcastCarouselTile(
                  serverName: serverName, podcast: podcast);
            }

            return pagedSkeletonSlot(
              key: ValueKey('podcast-scroll-skeleton-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
