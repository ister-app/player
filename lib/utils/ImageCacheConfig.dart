import 'package:cached_network_image_ce/cached_network_image.dart';

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

  /// Installs [manager] as the app-wide default. Must run before the first
  /// image resolves, so before the audio handler can publish any artwork.
  static void install() =>
      CachedNetworkImageProvider.defaultCacheManager = manager;
}
