import 'package:material_ui/material_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/games.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentGame.graphql.dart';
import 'GameCarouselTile.dart';
import 'PagedContentView.dart';

/// Horizontal carousel that lazily loads the newest games of a library.
class GameSlide extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const GameSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentGame>(
      document: documentNodeQuerygames,
      rootField: 'games',
      fromJson: Fragment$fragmentGame.fromJson,
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
          itemExtent: 200.0 * GameCarouselTile.coverAspectRatio,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return GameCarouselTile(serverName: serverName, game: items[index]);
            }
            return pagedSkeletonSlot(
              key: ValueKey('game-slide-placeholder-$index'),
              placeholderIcon: Icons.sports_esports,
              subtitleWords: 1,
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
