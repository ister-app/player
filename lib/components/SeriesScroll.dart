import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/seriesQuery.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentSeries.graphql.dart';
import 'BrowseListRow.dart';
import 'PagedContentView.dart';
import 'SeriesCarouselTile.dart';

/// Scrollable grid or list of all series in a comic library, loaded page by page.
class SeriesScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final void Function(Refetch?)? onRefetch;

  const SeriesScroll({
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
    return PagedContentView<Fragment$fragmentSeries>(
      document: documentNodeQueryseries,
      rootField: 'series',
      fromJson: Fragment$fragmentSeries.fromJson,
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
              final series = data.itemAt(index);
              if (series == null) {
                return pagedSkeletonRow(
                  key: ValueKey('series-list-skeleton-$index'),
                  placeholderIcon: Icons.auto_stories,
                  squareThumb: true,
                  subtitleWords: 1,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img = series.cover ??
                  ImageUtil.getImageByType(series.images, ImageTypes.cover);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.auto_stories,
                squareThumb: true,
                title: series.name,
                subtitle: series.startYear > 0 ? '${series.startYear}' : '',
                onTap: () => AutoRouter.of(context)
                    .push(SeriesRoute(seriesId: series.id)),
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
            childAspectRatio: SeriesCarouselTile.coverAspectRatio,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final series = data.itemAt(index);
            if (series != null) {
              return SeriesCarouselTile(serverName: serverName, series: series);
            }

            return pagedSkeletonSlot(
              key: ValueKey('series-scroll-skeleton-$index'),
              placeholderIcon: Icons.auto_stories,
              subtitleWords: 1,
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
