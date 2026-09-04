import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/components/TvFocusable.dart';

class CarouselItemView extends StatelessWidget {
  const CarouselItemView({
    super.key,
    required this.serverName,
    required this.title,
    required this.subTitle,
    this.imageUrl,
    this.blurHash,
    this.progress,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTapDown,
    this.placeholderIcon,
    this.artwork,
    this.autofocus = false,
  });

  final String serverName;
  final String title;
  final String subTitle;
  final String? imageUrl;
  final String? blurHash;
  final double? progress;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onSecondaryTapDown;

  /// Icon shown when there is no (loadable) image, e.g. an album without
  /// cover art. When null the tile keeps its plain tinted background.
  final IconData? placeholderIcon;

  /// Artwork built by the caller instead of a single [imageUrl] — a playlist
  /// hands in its cover mosaic here. Takes precedence over [imageUrl].
  final Widget? artwork;

  /// Grabs D-pad/keyboard focus when first shown. Set on the first tile of a
  /// landing screen so a TV remote has somewhere to start.
  final bool autofocus;

  /// Height of the caption (title + subtitle) below the artwork, following
  /// the user's text scale. The text portion (titleMedium 24 + 2 gap +
  /// bodyMedium ~20, plus slack) scales; the 8 of fixed padding does not.
  /// Grid extents, carousel row heights and skeletons all add this to the
  /// artwork height so the art keeps its aspect ratio.
  static double captionHeightOf(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(48) + 8;

  /// Below this tile width the caption drops to the smaller text styles.
  /// Width, not height: the caption sits under the artwork, so its available
  /// horizontal space — a narrow phone grid cell versus a 300dp desktop
  /// tile — is what determines how much text fits.
  static const double _compactWidth = 190;

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = placeholderIcon != null
        ? Center(
            child: Icon(
              placeholderIcon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        : Container();
    // No logicalWidth: the artwork fills the tile's art box, so its own
    // constraints are the painted width — anything from a three-column phone
    // grid cell to a 300dp desktop tile.
    final Widget image =
        artwork ??
        ((imageUrl != null && imageUrl != '')
            ? ArtworkImage(
                url: imageUrl,
                placeholder: (context) => blurHash != null
                    ? BlurHash(
                        hash: blurHash!,
                        optimizationMode: BlurHashOptimizationMode.standard,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        duration: Duration.zero,
                      )
                    : Container(),
                errorBuilder: (_) => placeholder,
              )
            : placeholder);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < _compactWidth;
        final TextStyle? titleStyle = compact
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.titleMedium;
        // Muted like BrowseListRow's subtitle, so the title carries the tile.
        final Color subTitleColor = Theme.of(context)
            .colorScheme
            .onSurfaceVariant;
        final TextStyle? subTitleStyle = compact
            ? Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: subTitleColor)
            : Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: subTitleColor);
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: TvFocusable(
            onTap: onTap,
            onLongPress: onLongPress,
            autofocus: autofocus,
            scale: 1.06,
            borderRadius: BorderRadius.circular(25.0),
            // One rounded card: the outer clip rounds the tile, the art keeps
            // square bottom corners so it sits flush on the caption strip —
            // art and text read as a single tile instead of a floating label.
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          key: const ValueKey('carousel-item-art'),
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                ),
                                child: image,
                              ),
                            ),
                            if (progress != null)
                              Positioned(
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: LinearProgressIndicator(value: progress),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: captionHeightOf(context),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 6.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: titleStyle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                subTitle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: subTitleStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // Focus lives on the surrounding TvFocusable so
                        // there's a single D-pad target; the InkWell only
                        // handles pointer tap / long-press / secondary tap.
                        canRequestFocus: false,
                        borderRadius: BorderRadius.circular(25.0),
                        onLongPress: onLongPress,
                        onSecondaryTapDown: onSecondaryTapDown,
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
