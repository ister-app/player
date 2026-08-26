import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';

import '../utils/ImageUtil.dart';
import '../utils/StreamTokenService.dart';

/// A playlist's artwork: a 2x2 mosaic of the covers of its first entries.
///
/// The server hands back up to four *distinct* covers; fewer are repeated so
/// the grid is always filled — one cover fills all four cells, two are placed
/// diagonally (A B / B A), three repeat the first in the last cell. Without any
/// cover the whole tile is the placeholder icon, so a playlist never renders as
/// an empty hole next to album art.
class PlaylistCoverMosaic extends StatelessWidget {
  const PlaylistCoverMosaic({
    super.key,
    required this.serverName,
    required this.covers,
    required this.placeholderIcon,
    this.size,
    this.borderRadius = 8,
  });

  final String serverName;
  final List<Fragment$fragmentImages> covers;
  final IconData placeholderIcon;

  /// Side of the (square) tile; null fills whatever the parent gives it.
  final double? size;
  final double borderRadius;

  /// The four cells, repeating what few covers there are.
  static List<T> layout<T>(List<T> covers) {
    switch (covers.length) {
      case 0:
        return const [];
      case 1:
        return [covers[0], covers[0], covers[0], covers[0]];
      case 2:
        // Diagonal, so both covers touch both rows and columns.
        return [covers[0], covers[1], covers[1], covers[0]];
      case 3:
        return [covers[0], covers[1], covers[2], covers[0]];
      default:
        return covers.take(4).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cells = layout(covers);
    final Widget content = cells.isEmpty
        ? Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Center(
                child: Icon(placeholderIcon,
                    color: theme.colorScheme.onSurfaceVariant)),
          )
        : Column(
            children: [
              Expanded(child: Row(children: [_cell(cells[0]), _cell(cells[1])])),
              Expanded(child: Row(children: [_cell(cells[2]), _cell(cells[3])])),
            ],
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      // Without a size the mosaic fills its parent (a carousel tile); with one
      // it is the square thumb of a list row.
      child: size == null
          ? content
          : SizedBox(width: size, height: size, child: content),
    );
  }

  Widget _cell(Fragment$fragmentImages image) {
    final url =
        ImageUtil.buildUrl(image, token: StreamTokenService.getToken(serverName));
    return Expanded(
      child: SizedBox.expand(
        child: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            final placeholder = Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                  child: Icon(placeholderIcon,
                      color: theme.colorScheme.onSurfaceVariant)),
            );
            if (url == null || url.isEmpty) return placeholder;
            return CachedNetworkImage(
              imageUrl: url,
              cacheKey: ImageUtil.cacheKeyFor(url),
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              errorBuilder: (_, __, ___) => placeholder,
            );
          },
        ),
      ),
    );
  }
}
