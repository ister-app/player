import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/podcastsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentPodcast.graphql.dart';
import 'PagedContentView.dart';
import 'PodcastCarouselTile.dart';

/// Scrollable grid of all podcast subscriptions, loaded page by page.
class PodcastScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final void Function(Refetch?)? onRefetch;

  const PodcastScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.NAME,
    this.sortingOrder = Enum$SortingOrder.ASCENDING,
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
