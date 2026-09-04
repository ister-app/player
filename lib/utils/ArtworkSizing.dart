import 'dart:math' as math;

/// Picks the size artwork is fetched and decoded at.
///
/// Everything here is pure so it can be unit-tested without a `BuildContext`;
/// [ArtworkImage] is the widget that applies it, and is the only place that
/// reads the device pixel ratio.
///
/// Why this exists: the app used to request the stored original for every
/// surface. One home screen measured 55 MB on the wire and 872 MiB of decoded
/// pixels — 3840x2160 episode stills and 3000x3000 covers painted 150 dp wide.
/// Native platforms absorbed that; the browser's WebGL context did not, and
/// CanvasKit silently uploaded empty textures ("Resource has no data (yet?)"),
/// which is what turned tiles grey.
class ArtworkSizing {
  ArtworkSizing._();

  /// Widths the server will downscale to. Keep in sync with `WIDTH_BUCKETS` in
  /// the server's `FileController`: a width off this ladder is bucketed there
  /// anyway, but sending an unbucketed one would key a second cache entry for
  /// the same picture on both sides.
  static const List<int> widthBuckets = [160, 240, 320, 480, 640, 960, 1280];

  /// Physical pixels needed to paint [logicalWidth] logical pixels.
  ///
  /// The device pixel ratio is capped at 3: beyond that the extra detail is
  /// past what the eye resolves on the phone-sized surfaces this covers, while
  /// the decode cost keeps growing with the square of it.
  static int physicalWidth(double logicalWidth, double devicePixelRatio) {
    if (logicalWidth <= 0 || !logicalWidth.isFinite) return 0;
    final dpr = devicePixelRatio.isFinite && devicePixelRatio > 0
        ? math.min(devicePixelRatio, 3.0)
        : 1.0;
    return (logicalWidth * dpr).ceil();
  }

  /// The bucket to request for [physicalWidth], or null to take the original.
  ///
  /// Null above the top bucket — there the re-encode saves little and costs a
  /// decode — and null for a width we could not measure, where guessing small
  /// would show a blurry picture.
  static int? bucketFor(int physicalWidth) {
    if (physicalWidth <= 0 || physicalWidth > widthBuckets.last) return null;
    return widthBuckets.firstWhere((b) => b >= physicalWidth);
  }

  /// [url] asking for the [bucket]-wide variant, or unchanged when [bucket] is
  /// null or [url] is not a server artwork download.
  ///
  /// Only `…/images/{id}/download` urls are touched. Everything else —
  /// downloaded artwork (`file:`), third-party podcast art, comic pages and
  /// epub resources — passes through untouched, which is what keeps the
  /// offline paths and their manifests out of this entirely.
  ///
  /// `width` is placed *before* any other parameter on purpose:
  /// `ImageUtil.cacheKeyFor` drops only `token` and keeps the order of the
  /// rest, so the cache key becomes `…/download?width=320` — one stable key per
  /// bucket, with no change to `cacheKeyFor` itself. Same trick as
  /// `ComicResourceClient.pageUrl` / `pageCacheKey`.
  static String? sizedUrl(String? url, int? bucket) {
    if (url == null || url.isEmpty) return url;
    final int q = url.indexOf('?');
    final String base = q < 0 ? url : url.substring(0, q);
    if (!_artworkDownload.hasMatch(base)) return url;
    final params = q < 0
        ? <String>[]
        : url
            .substring(q + 1)
            .split('&')
            .where((p) =>
                p.isNotEmpty && p != 'width' && !p.startsWith('width='))
            .toList();
    if (bucket != null) params.insert(0, 'width=$bucket');
    return params.isEmpty ? base : '$base?${params.join('&')}';
  }

  static final RegExp _artworkDownload = RegExp(r'/images/[^/]+/download$');
}
