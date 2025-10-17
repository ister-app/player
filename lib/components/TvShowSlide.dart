import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'CarouselItemView.dart';

/// Horizontal carousel that lazily loads TV‑show items.
class TvShowSlide extends StatefulWidget {
  final String serverName;
  final void Function(Refetch?)? onRefetch;
  final VoidCallback? onEmptyView;

  const TvShowSlide({
    super.key,
    required this.serverName,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<TvShowSlide> createState() => _TvShowSlideState();
}

class _TvShowSlideState extends State<TvShowSlide> {
  static const int _pageSize = 15;

  /// Pages that have already been loaded.
  final List<int> _fetchedPages = [0];

  /// Pages that are currently being requested.
  final Set<int> _loadingPages = {};

  /// Request a page from the server if it hasn't been loaded yet.
  void _requestPage(int page, FetchMore fetchMore) {
    if (_fetchedPages.contains(page) || _loadingPages.contains(page)) return;

    _loadingPages.add(page);

    fetchMore(
      FetchMoreOptions(
        variables: {'page': page, 'size': _pageSize},
        updateQuery: (previous, fetchMoreResult) {
          // Bail out on error / empty result.
          if (fetchMoreResult == null ||
              fetchMoreResult['shows']?['content'] == null) {
            _loadingPages.remove(page);
            return previous!;
          }

          final prev = previous!['shows']['content'] as List<dynamic>;
          final fresh = fetchMoreResult['shows']['content'] as List<dynamic>;

          previous['shows']['content'] = [...prev, ...fresh];
          _fetchedPages.add(page);
          _loadingPages.remove(page);
          return previous;
        },
      ),
    ).catchError((_) => _loadingPages.remove(page));
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryshows,
        variables: {
          'page': 0,
          'size': _pageSize,
          'sorting': Enum$SortingEnum.DATE_CREATED,
          'sortingOrder': Enum$SortingOrder.DESCENDING,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        widget.onRefetch?.call(refetch);

        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        }

        // Current data we already have (may be empty on first load)
        final shows = result.data == null
            ? const <Query$shows$shows$content>[]
            : (Query$shows.fromJson(result.data!).shows?.content ??
                const <Query$shows$shows$content>[]);

        // Server‑side total number of items (if the query returns it)
        final serverTotal = result.data == null
            ? null
            : Query$shows.fromJson(result.data!).shows?.totalElements;

        // How many placeholder slots we need to keep the carousel length
        final placeholderCount = serverTotal == null
            ? _pageSize * 3 // fallback when total is unknown
            : (serverTotal - shows.length).clamp(0, serverTotal);

        // Build the horizontal list
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemExtent: 300.0,
          itemCount: shows.length + placeholderCount,
          itemBuilder: (context, index) {
            // Determine which page this index belongs to
            final page = index ~/ _pageSize;
            final pageFetched = _fetchedPages.contains(page);

            // Resolve the flat list index for a fetched page
            int flatIndex = 0;
            for (final fetchedPage in _fetchedPages) {
              if (fetchedPage == page) break;

              final isLastPage = serverTotal != null &&
                  fetchedPage == serverTotal ~/ _pageSize;
              flatIndex += isLastPage
                  ? (serverTotal! % _pageSize == 0
                      ? _pageSize
                      : serverTotal! % _pageSize)
                  : _pageSize;
            }
            flatIndex += index - page * _pageSize;

            // Real item – we have data for this page
            if (pageFetched && shows.length > flatIndex) {
              final show = shows[flatIndex];
              final img = ImageUtil.getImageByType(
                show.images,
                ImageTypes.background,
              );

              return CarouselItemView(
                serverName: widget.serverName,
                title: MetadataUtil.getTitle(show.metadata) ?? '',
                subTitle: MetadataUtil.getDescription(show.metadata) ?? '',
                imageUrl: img?.id,
                blurHash: img?.blurHash,
                onTap: () => AutoRouter.of(context).push(
                  ShowOverviewRoute(showId: show.id),
                ),
              );
            }

            // Placeholder – trigger a fetch when it becomes visible
            return VisibilityDetector(
              key: ValueKey('tvshow-placeholder-$index'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0 && fetchMore != null) {
                  _requestPage(page, fetchMore);
                }
              },
              child: Skeletonizer(
                enabled: true,
                child: CarouselItemView(
                  serverName: '',
                  title: BoneMock.name,
                  subTitle: BoneMock.words(10),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
