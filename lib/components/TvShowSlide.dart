import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'CarouselItemView.dart';

/// Horizontal carousel that lazily loads TV‑show items.
class TvShowSlide extends StatefulWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;
  final VoidCallback? onEmptyView;

  const TvShowSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<TvShowSlide> createState() => _TvShowSlideState();
}

class _TvShowSlideState extends State<TvShowSlide> {
  static const int _pageSize = 15;

  // Per-page storage: page 0 comes from the main query, later pages from
  // fetchMore. A single flat list would let a racing page-0 rebuild wipe
  // pages that already arrived.
  final Map<int, List<Query$shows$shows$content>> _pageData = {};
  int? _totalItems;
  DateTime? _lastResultTimestamp;
  final Set<int> _requestedPages = {0};

  List<Query$shows$shows$content> get _orderedItems {
    final out = <Query$shows$shows$content>[];
    for (var page = 0; _pageData.containsKey(page); page++) {
      out.addAll(_pageData[page]!);
    }
    return out;
  }

  void _requestPage(int page, FetchMore fetchMore) {
    if (_requestedPages.contains(page)) return;
    _requestedPages.add(page);

    fetchMore(
      FetchMoreOptions(
        variables: {'page': page, 'size': _pageSize},
        updateQuery: (previous, fetchMoreResult) {
          if (fetchMoreResult == null ||
              fetchMoreResult['shows']?['content'] == null) {
            _requestedPages.remove(page);
            return previous!;
          }

          final fresh =
              (fetchMoreResult['shows']['content'] as List<dynamic>)
                  .map((e) => Query$shows$shows$content.fromJson(
                      e as Map<String, dynamic>))
                  .toList();

          if (mounted) {
            setState(() => _pageData[page] = fresh);
          }

          return previous!;
        },
      ),
    ).then<void>((_) {}, onError: (_) => _requestedPages.remove(page));
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
          if (widget.libraryId != null) 'libraryId': widget.libraryId,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        widget.onRefetch?.call(refetch);

        // Parse every new emission (cache, network, refetch) exactly once —
        // an "initialized" latch would pin the UI to the first (cached)
        // result and make refreshes a no-op.
        if (result.data != null && result.timestamp != _lastResultTimestamp) {
          _lastResultTimestamp = result.timestamp;
          final parsed = Query$shows.fromJson(result.data!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _pageData[0] = parsed.shows?.content ?? [];
              _totalItems = parsed.shows?.totalElements;
            });
            if (_totalItems == 0) widget.onEmptyView?.call();
          });
        }

        final items = _orderedItems;

        if (result.hasException && items.isEmpty) {
          return Center(child: Text(result.exception.toString()));
        }

        final int placeholderCount = _totalItems == null
            ? _pageSize * 2
            : (_totalItems! - items.length).clamp(0, _pageSize);

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemExtent: 300.0,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              final show = items[index];
              final img = ImageUtil.getImageByType(
                show.images,
                ImageTypes.background,
              );
              return CarouselItemView(
                serverName: widget.serverName,
                title: MetadataUtil.getTitle(show.metadata) ?? '',
                subTitle: MetadataUtil.getDescription(show.metadata) ?? '',
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(widget.serverName)),
                blurHash: img?.blurHash,
                onTap: () => AutoRouter.of(context)
                    .push(ShowOverviewRoute(showId: show.id)),
              );
            }

            final page = index ~/ _pageSize;
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
