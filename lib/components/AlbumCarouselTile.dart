import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../l10n/app_localizations.dart';
import 'CarouselItemView.dart';

/// An album cover for a carousel or grid: tap opens the album, long-press /
/// secondary tap opens a menu to jump to the artist. Shared by [AlbumSlide] and
/// [AlbumScroll] so the navigation and context menu stay consistent.
class AlbumCarouselTile extends StatelessWidget {
  const AlbumCarouselTile({
    super.key,
    required this.serverName,
    required this.album,
  });

  final String serverName;
  final Fragment$fragmentAlbum album;

  @override
  Widget build(BuildContext context) {
    final img = ImageUtil.getImageByType(album.images, ImageTypes.cover);
    final menuController = MenuController();
    return MenuAnchor(
      controller: menuController,
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () => AutoRouter.of(context)
              .push(ArtistRoute(artistId: album.artist.id)),
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.goToArtist),
          ),
        ),
      ],
      child: CarouselItemView(
        serverName: serverName,
        title: MetadataUtil.getTitle(album.metadata) ?? album.name,
        subTitle: album.artist.name,
        imageUrl: ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(serverName)),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.music_note,
        onTap: () => AutoRouter.of(context).push(AlbumRoute(albumId: album.id)),
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
