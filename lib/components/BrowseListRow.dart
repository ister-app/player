import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'TvFocusable.dart';
import 'package:player/utils/ImageUtil.dart';

/// One row of the browse list layout: thumbnail, title/subtitle lines, an
/// optional watched-progress bar and an optional trailing widget (context
/// menu). The generalized form of SearchPage's result row, shared by every
/// `*Scroll` widget's list mode.
class BrowseListRow extends StatelessWidget {
  const BrowseListRow({
    super.key,
    this.imageUrl,
    required this.placeholderIcon,
    this.squareThumb = false,
    required this.title,
    this.subtitle,
    this.tertiary,
    this.progress,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final String? imageUrl;
  final IconData placeholderIcon;

  /// Square 64x64 thumb for covers/portraits (albums, tracks, artists);
  /// otherwise the 96x64 landscape thumb (episode stills, backdrops).
  final bool squareThumb;
  final String title;
  final String? subtitle;
  final String? tertiary;

  /// Watched/listened fraction (0..1); null hides the progress bar.
  final double? progress;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = Center(
        child: Icon(placeholderIcon, color: theme.colorScheme.onSurfaceVariant));

    return TvFocusable(
      onTap: onTap,
      onLongPress: onLongPress,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: squareThumb ? 64 : 96,
                  height: 64,
                  child: Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: (imageUrl != null && imageUrl != '')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            cacheKey: ImageUtil.cacheKeyFor(imageUrl!),
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            errorBuilder: (_, __, ___) => placeholder,
                          )
                        : placeholder,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((subtitle ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if ((tertiary ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        tertiary!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (progress != null) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress!.clamp(0.0, 1.0),
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
