import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/moviesQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'CarouselItemView.dart';

class MovieScroll extends StatefulWidget {
  final String serverName;
  final String? libraryId;
  final Function(Refetch?)? onRefetch;
  final VoidCallback? onEmptyView;

  const MovieScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<MovieScroll> createState() => _MovieScrollState();
}

class _MovieScrollState extends State<MovieScroll> {
  static const int _pageSize = 15;

  final List<int> _fetchedPages = [0];
  final Set<int> _loadingPages = {};

  void _requestPage(int page, FetchMore fetchMore) {
    if (_fetchedPages.contains(page) || _loadingPages.contains(page)) return;

    _loadingPages.add(page);

    fetchMore(
      FetchMoreOptions(
        variables: {'page': page, 'size': _pageSize},
        updateQuery: (previous, fetchMoreResult) {
          if (fetchMoreResult == null ||
              fetchMoreResult['movies']?['content'] == null) {
            _loadingPages.remove(page);
            return previous!;
          }

          final prev = previous!['movies']['content'] as List<dynamic>;
          final fresh = fetchMoreResult['movies']['content'] as List<dynamic>;

          previous['movies']['content'] = [...prev, ...fresh];
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
        document: documentNodeQuerymovies,
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

        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        }

        final movies = result.data == null
            ? const <Query$movies$movies$content>[]
            : (Query$movies.fromJson(result.data!).movies?.content ??
                const <Query$movies$movies$content>[]);

        final int? serverTotal = result.data == null
            ? null
            : Query$movies.fromJson(result.data!).movies?.totalElements;

        final int placeholderCount = serverTotal == null
            ? _pageSize * 3
            : (serverTotal - movies.length).clamp(0, serverTotal);

        final int itemsInLastPage =
            serverTotal == null ? _pageSize : serverTotal % _pageSize;

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.65,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: movies.length + placeholderCount,
          itemBuilder: (context, index) {
            final pageForIndex = index ~/ _pageSize;
            final pageFetched = _fetchedPages.contains(pageForIndex);

            int flatIndex = 0;
            for (final fetchedPage in _fetchedPages) {
              if (fetchedPage == pageForIndex) break;
              final isLastPage = serverTotal != null &&
                  fetchedPage == serverTotal ~/ _pageSize;
              flatIndex += isLastPage ? itemsInLastPage : _pageSize;
            }
            flatIndex += index - pageForIndex * _pageSize;

            if (pageFetched && movies.length > flatIndex) {
              final movie = movies[flatIndex];
              final img = ImageUtil.getImageByType(movie.images, ImageTypes.cover);
              return CarouselItemView(
                serverName: widget.serverName,
                title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
                subTitle: MetadataUtil.getDescription(movie.metadata) ?? '',
                imageUrl: ImageUtil.buildUrl(img),
                blurHash: img?.blurHash,
                onTap: () => AutoRouter.of(context)
                    .push(MovieRoute(movieId: movie.id)),
              );
            }

            return VisibilityDetector(
              key: ValueKey('movie-scroll-skeleton-$index'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0 && fetchMore != null) {
                  _requestPage(pageForIndex, fetchMore);
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
