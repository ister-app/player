import 'package:cached_network_image_ce/cached_network_image.dart' show BaseCacheManager;
// The package exports its cache manager through a conditional export whose
// analyzer-visible fallback is the unsupported-platform stub, and that stub
// does not declare `cacheDirectoryProvider`. Importing the dart:io
// implementation directly is what makes the parameter visible; this file is
// only ever reached on the dart:io platforms it belongs to.
// ignore: implementation_imports
import 'package:cached_network_image_ce/src/cache/default_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

/// A cache manager whose files land in the application *cache* directory —
/// `~/.cache/<app>` on Linux, `Library/Caches` on iOS/macOS, `cacheDir` on
/// Android. Still a cache the system may reclaim, but not the temporary
/// directory the package defaults to, which on Linux is `/tmp` and is emptied
/// on every reboot.
BaseCacheManager createImageCacheManager({
  required Duration stalePeriod,
  required int maxNrOfCacheObjects,
}) =>
    DefaultCacheManager(
      stalePeriod: stalePeriod,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
      cacheDirectoryProvider: getApplicationCacheDirectory,
    );
