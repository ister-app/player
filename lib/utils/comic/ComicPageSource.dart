import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:player/utils/comic/ComicManifest.dart';
import 'package:player/utils/comic/ComicResourceClient.dart';

/// One interface over the two comic formats so the reader is format-blind:
/// cbz pages come straight off the node as images, pdf pages are rendered
/// locally by pdfium. Thumbnails are strip-sized.
abstract class ComicPageSource {
  int get pageCount;

  /// Full-resolution page image, zero-based reading order.
  ImageProvider pageImage(int index);

  /// Strip-sized thumbnail of a page.
  ImageProvider thumbnail(int index);

  void dispose();
}

/// Cbz pages through `/comic/{id}/page/{index}`. The server serves them
/// immutable-cached; the cache key leaves the expiring token out so a token
/// rotation doesn't refetch pages.
class CbzPageSource implements ComicPageSource {
  CbzPageSource({required this.client, required ComicManifest manifest})
      : pageCount = manifest.pageCount ?? manifest.pages.length;

  final ComicResourceClient client;

  /// Width bucket the server downscales thumbnails to.
  static const int thumbnailWidth = 240;

  /// Widget tests swap this out: the cached-image pipeline uses its own
  /// dart:io client, which `http.runWithClient` fixtures can't intercept.
  @visibleForTesting
  static ImageProvider Function(String url, String cacheKey)? providerFactory;

  static ImageProvider _provider(String url, String cacheKey) =>
      providerFactory?.call(url, cacheKey) ??
      CachedNetworkImageProvider(url, cacheKey: cacheKey);

  @override
  final int pageCount;

  @override
  ImageProvider pageImage(int index) => _provider(
        client.pageUrl(index),
        client.pageCacheKey(index),
      );

  @override
  ImageProvider thumbnail(int index) => _provider(
        client.pageUrl(index, width: thumbnailWidth),
        client.pageCacheKey(index, width: thumbnailWidth),
      );

  @override
  void dispose() {}
}
