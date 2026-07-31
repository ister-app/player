import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:player/components/TvFocusable.dart';
class CarouselItemView extends StatelessWidget {
  const CarouselItemView(
      {super.key,
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
      this.autofocus = false});

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

  /// Grabs D-pad/keyboard focus when first shown. Set on the first tile of a
  /// landing screen so a TV remote has somewhere to start.
  final bool autofocus;

  /// Below this tile height the caption drops to the smaller text styles.
  /// Height, not width: within one carousel row the tile widths differ per
  /// artwork shape but the height is uniform, so keying on height keeps the
  /// text the same size across a row. The home carousels are 200 tall and
  /// stay large; the narrow grid cells of a phone-sized "show all" page
  /// (maxCrossAxisExtent 300, aspect 1.5) fall below it and shrink.
  static const double _compactHeight = 180;

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = placeholderIcon != null
        ? Center(
            child: Icon(placeholderIcon,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant))
        : Container();
    final Widget image = (imageUrl != null && imageUrl != '')
        ? CachedNetworkImage(
            placeholder: (context, url) => blurHash != null
                ? BlurHash(
                    hash: blurHash!,
                    optimizationMode: BlurHashOptimizationMode.standard,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    duration: Duration.zero,
                  )
                : Container(),
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            fadeOutDuration: Duration.zero,
            fadeInDuration: Duration.zero,
            errorBuilder: (_, __, ___) => placeholder,
          )
        : placeholder;
    return LayoutBuilder(builder: (context, constraints) {
      final bool compact = constraints.maxHeight < _compactHeight;
      final TextStyle? titleStyle = compact
          ? Theme.of(context).textTheme.titleMedium
          : Theme.of(context).textTheme.headlineMedium;
      final TextStyle? subTitleStyle = compact
          ? Theme.of(context).textTheme.bodySmall
          : Theme.of(context).textTheme.bodyMedium;
      return Padding(
          padding: EdgeInsets.all(5.0),
          child: TvFocusable(
            onTap: onTap,
            onLongPress: onLongPress,
            autofocus: autofocus,
            scale: 1.06,
            borderRadius: BorderRadius.circular(25.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest),
                      child: image,
                    ),
                  ),
                  Opacity(
                      opacity: 0.8,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(compact ? 8 : 10),
                        color: Theme.of(context).colorScheme.surface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: titleStyle,
                            ),
                            SizedBox(height: compact ? 2 : 5),
                            Text(
                              subTitle,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: subTitleStyle,
                            ),
                          ],
                        ),
                      )),
                  progress != null
                      ? Positioned(
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            value: progress,
                          ))
                      : Container(),
                  Material(
                      color: Colors.transparent,
                      child: InkWell(
                          // Focus lives on the surrounding TvFocusable so
                          // there's a single D-pad target; the InkWell only
                          // handles pointer tap / long-press / secondary tap.
                          canRequestFocus: false,
                          borderRadius: BorderRadius.circular(25.0),
                          onLongPress: onLongPress,
                          onSecondaryTapDown: onSecondaryTapDown,
                          onTap: onTap))
                ],
              ),
            ),
          ));
    });
  }
}
