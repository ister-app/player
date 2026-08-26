import 'dart:ui';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// SliverAppBar background shared by the album and artist detail pages: a
/// blurred cover/background image with a dark overlay, a fade into the page
/// surface, and a cover card next to a title/subtitle/meta line.
class MusicDetailHero extends StatelessWidget {
  const MusicDetailHero({
    super.key,
    required this.imageUrl,
    required this.blurHash,
    required this.title,
    this.subtitle,
    this.metaLine,
    this.onSubtitleTap,
    this.backgroundAlignment = Alignment.center,
    this.placeholderIcon = Icons.music_note,
    this.coverAspectRatio = 1.0,
    this.coverHeight = 110,
    this.skeleton = false,
  });

  final String? imageUrl;
  final String? blurHash;

  /// Icon shown on the cover card when there is no (loadable) image.
  final IconData placeholderIcon;

  /// When null the foreground content (cover card + text) is hidden. Pages that
  /// skeletonize their content pass [skeleton] instead of relying on this: a
  /// hidden foreground turned the hero into a flat grey rectangle that grew a
  /// cover and two lines of text out of nowhere once the data landed.
  final String? title;
  final String? subtitle;

  /// Optional third line under the subtitle: a muted summary such as
  /// "Jazz · 20 songs · 1:12:30". Callers that pass nothing keep the two-line
  /// layout unchanged.
  final String? metaLine;

  /// When set, the subtitle becomes tappable (e.g. an album's artist name links
  /// to that person's page).
  final VoidCallback? onSubtitleTap;

  /// Alignment for the blurred backdrop image (artist pages anchor to the top).
  final Alignment backgroundAlignment;

  /// Width/height of the cover card. Square for albums and podcasts, 2:3 for
  /// book covers.
  final double coverAspectRatio;

  /// Height of the cover card. Raise it together with the page's
  /// `SliverAppBar.expandedHeight`, or the card runs out of room.
  final double coverHeight;

  /// Renders the cover card and mock text lines while the page loads. Set it
  /// from inside a [Skeletonizer] — the mock text is meant to be boned.
  final bool skeleton;

  Widget _coverPlaceholder() => Container(
        color: Colors.grey[900],
        child: Center(
          child: Icon(placeholderIcon, size: 44, color: Colors.white54),
        ),
      );

  Widget _blurHashOr(Widget fallback) => blurHash != null
      ? BlurHash(
          hash: blurHash!,
          optimizationMode: BlurHashOptimizationMode.standard,
          color: Colors.grey[900]!,
          duration: Duration.zero,
        )
      : fallback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background
        if (imageUrl != null)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              alignment: backgroundAlignment,
              placeholder: (context, url) =>
                  _blurHashOr(ColoredBox(color: Colors.grey[900]!)),
              fadeOutDuration: Duration.zero,
              fadeInDuration: Duration.zero,
            ),
          )
        else
          ColoredBox(color: Colors.grey[900]!),
        // Dark overlay
        const ColoredBox(color: Color(0x66000000)),
        // Bottom fade into page surface
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, colorScheme.surface],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
        // Content: cover card left, text right
        if (title != null || skeleton)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: coverHeight * coverAspectRatio,
                    height: coverHeight,
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _blurHashOr(Container(color: Colors.grey[900])),
                            errorBuilder: (_, __, ___) => _coverPlaceholder(),
                            fadeOutDuration: Duration.zero,
                            fadeInDuration: Duration.zero,
                          )
                        : _coverPlaceholder(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? BoneMock.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null || skeleton) ...[
                        const SizedBox(height: 8),
                        if (onSubtitleTap != null)
                          InkWell(
                            onTap: onSubtitleTap,
                            child: Text(
                              subtitle ?? BoneMock.words(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          Text(
                            subtitle ?? BoneMock.words(2),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                      if (metaLine != null || skeleton) ...[
                        const SizedBox(height: 6),
                        Text(
                          metaLine ?? BoneMock.words(3),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
