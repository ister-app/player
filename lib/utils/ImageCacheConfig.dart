import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'image_cache_dir_stub.dart'
    if (dart.library.js_interop) 'image_cache_dir_web.dart';

/// The single disk cache behind every [CachedNetworkImage] and
/// [CachedNetworkImageProvider] in the app — artwork, comic pages and epub
/// images all share it. The package default is 200 objects in the temporary
/// directory, while one browse session alone runs to several hundred covers.
///
/// The fork swaps its manager through one static, so no call site needs a
/// `cacheManager:` argument of its own.
class ImageCacheConfig {
  ImageCacheConfig._();

  static final BaseCacheManager manager = createImageCacheManager(
    maxNrOfCacheObjects: 1000,
    // A hard TTL, not a staleness hint: the package stores the response ETag
    // but never sends an `If-None-Match`, so an entry cannot be revalidated —
    // it is either fresh or downloaded again.
    stalePeriod: const Duration(days: 7),
  );

  /// Decoded-image budget.
  ///
  /// This belongs *after* the sizing in [ArtworkImage], not instead of it:
  /// raising the cache alone was never the fix. With artwork fetched at the
  /// width it is painted, a tile decodes to well under a megabyte and a full
  /// grid is tens of megabytes rather than the 872 MiB one home screen used to
  /// be. 200 MB then holds several screens, so back-navigation is instant; the
  /// entry count matters as much as the bytes when a screen is hundreds of
  /// small avatars.
  ///
  /// Web caches nothing, and that is the fix for a real bug rather than a
  /// tuning choice.
  ///
  /// CanvasKit on a GPU does not upload an image when it decodes it: it builds
  /// a *lazy* SkImage holding the `<img>` element it came from and uploads the
  /// texture at paint time (`MakeLazyImageFromTextureSourceWithInfo`). Firefox
  /// reclaims the decoded data of an `<img>` that is not in the document, and
  /// the next upload then yields "Resource has no data (yet?). Uploading
  /// zeros" — a blank tile. Feeding it bytes instead does not help: without
  /// WebCodecs' ImageDecoder the engine wraps those in a blob `<img>` and ends
  /// up on the same path.
  ///
  /// The cache is what makes that reachable: it keeps the stale `ui.Image`
  /// alive across a navigation, so coming back to a page repaints from an
  /// image whose source the browser has already thrown away. Evicting on the
  /// last listener means a return decodes afresh. It is cheap now that artwork
  /// arrives at the size it is painted — a tile is ~18 kB and comes from the
  /// browser's own HTTP cache. Images currently on screen are unaffected;
  /// Flutter tracks those separately as live images.
  static const int _maxBytesNative = 200 << 20;

  /// Android TV boxes commonly cap the app heap around 256 MB.
  static const int maxBytesTv = 96 << 20;

  /// Installs [manager] as the app-wide default. Must run before the first
  /// image resolves, so before the audio handler can publish any artwork.
  static void install() {
    CachedNetworkImageProvider.defaultCacheManager = manager;
    if (kIsWeb) {
      PaintingBinding.instance.imageCache.maximumSize = 0;
    } else {
      PaintingBinding.instance.imageCache
        ..maximumSizeBytes = _maxBytesNative
        ..maximumSize = 600;
    }
  }
}
