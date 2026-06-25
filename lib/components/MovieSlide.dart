import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/moviesQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import 'CarouselItemView.dart';
import 'PagedContentView.dart';

/// Horizontal carousel that lazily loads movie items.
class MovieSlide extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const MovieSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Query$movies$movies$content>(
      document: documentNodeQuerymovies,
      rootField: 'movies',
      fromJson: Query$movies$movies$content.fromJson,
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
          itemExtent: 300.0,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              final movie = items[index];
              final img =
                  ImageUtil.getImageByType(movie.images, ImageTypes.background);
              return CarouselItemView(
                serverName: serverName,
                title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
                subTitle: MetadataUtil.getDescription(movie.metadata) ?? '',
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                blurHash: img?.blurHash,
                onTap: () =>
                    AutoRouter.of(context).push(MovieRoute(movieId: movie.id)),
              );
            }

            return pagedSkeletonSlot(
              key: ValueKey('movie-slide-placeholder-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
