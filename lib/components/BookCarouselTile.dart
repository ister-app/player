import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentBook.graphql.dart';
import '../l10n/app_localizations.dart';
import 'CarouselItemView.dart';

/// A book cover for a carousel or grid: tap opens the book, long-press /
/// secondary tap opens a menu to jump to the author. Shared by [BookSlide] and
/// [BookScroll] so the navigation and context menu stay consistent.
class BookCarouselTile extends StatelessWidget {
  const BookCarouselTile({
    super.key,
    required this.serverName,
    required this.book,
  });

  final String serverName;
  final Fragment$fragmentBook book;

  /// Book covers are portrait, roughly 2:3 — grids and carousels size their
  /// slots with this so the cover isn't cropped into a square.
  static const double coverAspectRatio = 2 / 3;

  @override
  Widget build(BuildContext context) {
    final img = ImageUtil.getImageByType(book.images, ImageTypes.cover);
    final menuController = MenuController();
    return MenuAnchor(
      controller: menuController,
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () => AutoRouter.of(context)
              .push(PersonRoute(personId: book.author.id)),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.goToAuthor),
          ),
        ),
      ],
      child: CarouselItemView(
        serverName: serverName,
        title: MetadataUtil.getTitle(book.metadata) ?? book.name,
        subTitle: book.author.name,
        imageUrl: ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(serverName)),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.menu_book,
        portraitArtwork: true,
        onTap: () => AutoRouter.of(context).push(BookRoute(bookId: book.id)),
        onLongPress: () => menuController.isOpen
            ? menuController.close()
            : menuController.open(),
        onSecondaryTapDown: (TapDownDetails details) => menuController.isOpen
            ? menuController.close()
            : menuController.open(position: details.localPosition),
      ),
    );
  }
}
