import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/seriesQuery.graphql.dart';

import '../graphql/fragmentSeries.graphql.dart';
import 'PagedContentView.dart';
import 'SeriesCarouselTile.dart';

/// Horizontal carousel that lazily loads comic series.
class SeriesSlide extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const SeriesSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentSeries>(
      document: documentNodeQueryseries,
      rootField: 'series',
      fromJson: Fragment$fragmentSeries.fromJson,
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
          // The row is 200 tall, so a 2:3 cover needs ~133 of width.
          itemExtent: 200.0 * SeriesCarouselTile.coverAspectRatio,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return SeriesCarouselTile(
                  serverName: serverName, series: items[index]);
            }

            return pagedSkeletonSlot(
              key: ValueKey('series-slide-placeholder-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
