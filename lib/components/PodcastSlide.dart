import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/podcastsQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentPodcast.graphql.dart';
import 'PagedContentView.dart';
import 'PodcastCarouselTile.dart';

/// Horizontal carousel that lazily loads podcast subscriptions.
class PodcastSlide extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const PodcastSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentPodcast>(
      document: documentNodeQuerypodcasts,
      rootField: 'podcasts',
      fromJson: Fragment$fragmentPodcast.fromJson,
      sorting: Enum$SortingEnum.DATE_CREATED,
      sortingOrder: Enum$SortingOrder.DESCENDING,
      libraryId: libraryId,
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final items = data.orderedItems;
        final placeholderCount = data.totalItems == null
            ? _pageSize * 2
            : (data.totalItems! - items.length).clamp(0, _pageSize);

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemExtent: 200.0,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return PodcastCarouselTile(
                  serverName: serverName, podcast: items[index]);
            }

            return pagedSkeletonSlot(
              key: ValueKey('podcast-slide-placeholder-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
