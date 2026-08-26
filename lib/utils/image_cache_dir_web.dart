import 'package:cached_network_image_ce/cached_network_image.dart';

/// On web the store is IndexedDB and there is no directory to point at — and
/// `CachedNetworkImage` defaults to `ImageRenderMethodForWeb.HtmlImage` there,
/// so the browser cache does this job anyway.
BaseCacheManager createImageCacheManager({
  required Duration stalePeriod,
  required int maxNrOfCacheObjects,
}) =>
    DefaultCacheManager(
      stalePeriod: stalePeriod,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    );
