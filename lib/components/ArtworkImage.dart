import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/utils/ArtworkSizing.dart';
import 'package:player/utils/ImageUtil.dart';

/// Every network artwork in the app, fetched and decoded at the size it is
/// painted rather than at the size it is stored.
///
/// Two ways to keep an image small, and the platforms do not agree on them:
///
/// * `?width=` asks the server for a smaller variant. Platform-independent,
///   and the only lever that works on web — an older server ignores it and
///   hands back the original, which is the pre-existing behaviour.
/// * `memCacheWidth` caps the decode. It works on native, where the io loader
///   hands the decoder no target size of its own so `ResizeImage` gets to set
///   one. On web it does **nothing**: the default `HtmlImage` loader calls
///   `ui_web.createImageCodecFromUrl` and drops the decode callback entirely.
///
/// The `HttpGet` web loader *would* honour a decode cap (through
/// `maxWidthDiskCache`, not `memCacheWidth` — and combining the two trips
/// `ResizeImage`'s `getTargetSize == null` assert). It is not worth it: routing
/// web images through the cache manager instead of the browser's own `<img>`
/// left tiles blank, and with the server sizing the bytes there is nothing
/// left for a client-side cap to save.
class ArtworkImage extends StatelessWidget {
  const ArtworkImage({
    super.key,
    required this.url,
    this.logicalWidth,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorBuilder,
    this.fadeInDuration = Duration.zero,
    this.fadeOutDuration = Duration.zero,
  });

  /// The artwork url, token and all. Null or empty renders [errorBuilder].
  final String? url;

  /// How wide the artwork is painted, in logical pixels. Null measures the
  /// incoming constraints instead — for the tiles and backdrops whose size
  /// genuinely comes from layout. Prefer passing it: a constant costs no extra
  /// layout pass in a long list.
  final double? logicalWidth;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  /// Shown while loading (a blurhash, usually).
  final WidgetBuilder? placeholder;

  /// Shown when the url is missing or the image fails.
  final WidgetBuilder? errorBuilder;

  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  @override
  Widget build(BuildContext context) {
    if (logicalWidth != null) {
      return _build(context, logicalWidth!);
    }
    return LayoutBuilder(
      builder: (context, constraints) => _build(
        context,
        constraints.hasBoundedWidth ? constraints.maxWidth : 0,
      ),
    );
  }

  Widget _build(BuildContext context, double paintedWidth) {
    final error = errorBuilder?.call(context) ?? const SizedBox.shrink();
    if (url == null || url!.isEmpty) return error;
    final px = ArtworkSizing.physicalWidth(
        paintedWidth, MediaQuery.devicePixelRatioOf(context));
    final sized = ArtworkSizing.sizedUrl(url, ArtworkSizing.bucketFor(px))!;
    // A width we could not measure means "decode as stored"; capping it to a
    // guess would show a blurry picture on a surface we know nothing about.
    final decodeWidth = px > 0 ? px : null;
    return CachedNetworkImage(
      imageUrl: sized,
      cacheKey: ImageUtil.cacheKeyFor(sized),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: placeholder == null
          ? null
          : (context, _) => placeholder!(context),
      errorBuilder: (context, _, _) => error,
      // Null on web, where it is a no-op — see the class doc.
      memCacheWidth: kIsWeb ? null : decodeWidth,
    );
  }

  /// An [ImageProvider] for the callers that cannot use the widget — the
  /// blurred player backdrop, epub inline images. [physicalWidth] is the
  /// decode target in device pixels; the caller picks it, because these have no
  /// layout to measure.
  static ImageProvider? providerFor(String? url, {required int physicalWidth}) {
    if (url == null || url.isEmpty) return null;
    final sized = ArtworkSizing.sizedUrl(url, ArtworkSizing.bucketFor(physicalWidth))!;
    final provider = CachedNetworkImageProvider(
      sized,
      cacheKey: ImageUtil.cacheKeyFor(sized),
    );
    // No ResizeImage on web: the default loader ignores the target size it
    // would set, and wrapping it only hides that. The url carries the size.
    if (kIsWeb) return provider;
    return ResizeImage(provider, width: physicalWidth, allowUpscaling: false);
  }

  /// What [_build] would hand to `CachedNetworkImage` for these inputs. The
  /// decode knobs disappear inside `OctoImage`, so a widget test cannot see
  /// them — this is the seam the sizing regression test asserts on.
  @visibleForTesting
  static ArtworkImageDescription describeFor({
    required String url,
    required double logicalWidth,
    required double devicePixelRatio,
    required bool isWeb,
  }) {
    final px = ArtworkSizing.physicalWidth(logicalWidth, devicePixelRatio);
    final sized = ArtworkSizing.sizedUrl(url, ArtworkSizing.bucketFor(px))!;
    final decodeWidth = px > 0 ? px : null;
    return ArtworkImageDescription(
      imageUrl: sized,
      cacheKey: ImageUtil.cacheKeyFor(sized)!,
      memCacheWidth: isWeb ? null : decodeWidth,
    );
  }
}

@visibleForTesting
class ArtworkImageDescription {
  const ArtworkImageDescription({
    required this.imageUrl,
    required this.cacheKey,
    required this.memCacheWidth,
  });

  final String imageUrl;
  final String cacheKey;
  final int? memCacheWidth;
}
