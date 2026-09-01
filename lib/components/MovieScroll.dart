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

import 'BrowseListRow.dart';
import 'CarouselItemView.dart';
import 'MediaGrid.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of all movies in a library, loaded page by page.
class MovieScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final Input$MediaFilterInput? filter;
  final void Function(Refetch?)? onRefetch;

  const MovieScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.NAME,
    this.sortingOrder = Enum$SortingOrder.ASCENDING,
    this.listLayout = false,
    this.filter,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Query$movies$movies$content>(
      document: documentNodeQuerymovies,
      rootField: 'movies',
      fromJson: Query$movies$movies$content.fromJson,
      sorting: sorting,
      sortingOrder: sortingOrder,
      libraryId: libraryId,
      extraVariables: filter == null ? null : {'filter': filter!.toJson()},
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
              final movie = data.itemAt(index);
              if (movie == null) {
                return pagedSkeletonRow(
                  key: ValueKey('movie-list-skeleton-$index'),
                  placeholderIcon: Icons.movie,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img = ImageUtil.getImageByType(
                movie.images,
                ImageTypes.cover,
              );
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(
                  img,
                  token: StreamTokenService.getToken(serverName),
                ),
                placeholderIcon: Icons.movie,
                title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
                subtitle: MetadataUtil.getDescription(movie.metadata) ?? '',
                onTap: () =>
                    AutoRouter.of(context).push(MovieRoute(movieId: movie.id)),
              );
            },
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              // Attach to ShowHomePage's NestedScrollView so the view-selector header
              // scrolls away with the grid (desktop does not inherit it implicitly).
              primary: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: mediaGridDelegate(
                context,
                constraints.maxWidth,
                artAspectRatio: 0.65,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final movie = data.itemAt(index);
                if (movie != null) {
                  final img = ImageUtil.getImageByType(
                    movie.images,
                    ImageTypes.cover,
                  );
                  return CarouselItemView(
                    serverName: serverName,
                    title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
                    subTitle: MetadataUtil.getDescription(movie.metadata) ?? '',
                    imageUrl: ImageUtil.buildUrl(
                      img,
                      token: StreamTokenService.getToken(serverName),
                    ),
                    blurHash: img?.blurHash,
                    onTap: () =>
                        AutoRouter.of(context)
                            .push(MovieRoute(movieId: movie.id)),
                  );
                }

                return pagedSkeletonSlot(
                  key: ValueKey('movie-scroll-skeleton-$index'),
                  subtitleWords: 4,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              },
            );
          },
        );
      },
    );
  }
}
