import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:material_ui/material_ui.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/games/GameLabels.dart';

import '../graphql/fragmentGame.graphql.dart';
import 'BookCarouselTile.dart';
import 'CarouselItemView.dart';

/// A game cover for the library grid and carousels: tap opens the game page,
/// where installing and playing live. The subtitle names the platform so the
/// same title on two systems stays apart.
class GameCarouselTile extends StatelessWidget {
  const GameCarouselTile({
    super.key,
    required this.serverName,
    required this.game,
  });

  final String serverName;
  final Fragment$fragmentGame game;

  @override
  Widget build(BuildContext context) {
    final img = ImageUtil.getImageByType(game.images, ImageTypes.cover);
    return CarouselItemView(
      serverName: serverName,
      title: game.title,
      subTitle: GameLabels.platform(game.platform),
      imageUrl: ImageUtil.buildUrl(
        img,
        token: StreamTokenService.getToken(serverName),
      ),
      blurHash: img?.blurHash,
      placeholderIcon: Icons.sports_esports,
      onTap: () => AutoRouter.of(context).push(GameRoute(gameId: game.id)),
    );
  }

  /// Game covers share the book cover shape (box art is portrait).
  static const double coverAspectRatio = BookCarouselTile.coverAspectRatio;
}
