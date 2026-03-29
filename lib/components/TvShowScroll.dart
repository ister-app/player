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

class TvShowScroll extends StatefulWidget {
  final String serverName;
  final String? libraryId;
  final Function(Refetch?)? onRefetch;
  final VoidCallback? onEmptyView;

  const TvShowScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<TvShowScroll> createState() => _TvShowScrollState();
}

class _TvShowScrollState extends State<TvShowScroll> {
  static const int _pageSize = 15;

  final Map<int, List<Query$shows$shows$content>> _pageData = {};
  int? _totalItems;
  bool _initialized = false;
  final Set<int> _requestedPages = {0};

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
          'sorting': Enum$SortingEnum.NAME,
          'sortingOrder': Enum$SortingOrder.ASCENDING,
          if (widget.libraryId != null) 'libraryId': widget.libraryId,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        widget.onRefetch?.call(refetch);

        if (!_initialized && result.data != null) {
          _initialized = true;
          final parsed = Query$shows.fromJson(result.data!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _pageData[0] = parsed.shows?.content ?? [];
              _totalItems = parsed.shows?.totalElements;
            });
          });
        }

        if (result.hasException && _pageData.isEmpty) {
          return Center(child: Text(result.exception.toString()));
        }

        final int itemCount = _totalItems ?? (_pageSize * 2);

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.65,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final page = index ~/ _pageSize;
            final itemIndex = index % _pageSize;
            final pageItems = _pageData[page];

            if (pageItems != null && itemIndex < pageItems.length) {
              final show = pageItems[itemIndex];
              final img =
                  ImageUtil.getImageByType(show.images, ImageTypes.cover);
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

            return VisibilityDetector(
              key: ValueKey('tvshow-skeleton-$index'),
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
