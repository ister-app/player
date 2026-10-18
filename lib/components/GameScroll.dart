import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:material_ui/material_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/games.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/games/GameLabels.dart';

import '../graphql/fragmentGame.graphql.dart';
import 'BrowseListRow.dart';
import 'GameCarouselTile.dart';
import 'MediaGrid.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of all games in a GAME library, loaded page by page.
class GameScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final void Function(Refetch?)? onRefetch;

  const GameScroll({
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
    return PagedContentView<Fragment$fragmentGame>(
      document: documentNodeQuerygames,
      rootField: 'games',
      fromJson: Fragment$fragmentGame.fromJson,
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
              final game = data.itemAt(index);
              if (game == null) {
                return pagedSkeletonRow(
                  key: ValueKey('game-list-skeleton-$index'),
                  placeholderIcon: Icons.sports_esports,
                  squareThumb: true,
                  subtitleWords: 1,
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img = ImageUtil.getImageByType(game.images, ImageTypes.cover);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(
                  img,
                  token: StreamTokenService.getToken(serverName),
                ),
                placeholderIcon: Icons.sports_esports,
                squareThumb: true,
                title: game.title,
                subtitle: GameLabels.platform(game.platform),
                onTap: () =>
                    AutoRouter.of(context).push(GameRoute(gameId: game.id)),
              );
            },
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              // Attach to ShowHomePage's NestedScrollView so the view-selector
              // header scrolls away with the grid.
              primary: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: mediaGridDelegate(
                context,
                constraints.maxWidth,
                artAspectRatio: GameCarouselTile.coverAspectRatio,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final game = data.itemAt(index);
                if (game != null) {
                  return GameCarouselTile(serverName: serverName, game: game);
                }
                return pagedSkeletonSlot(
                  key: ValueKey('game-scroll-skeleton-$index'),
                  placeholderIcon: Icons.sports_esports,
                  subtitleWords: 1,
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
