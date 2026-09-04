import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/ServerStore.dart';

/// Disk-backed [Store]s for the per-server GraphQL caches, so a restart opens
/// on the content that was on screen last time instead of a row of spinners.
///
/// One Hive box per server: cache keys are normalised ids (`Movie:12`) and two
/// servers hand out the same ids, so a shared box would cross-contaminate.
/// Everything is opened up front ([ensureInitialized]) because
/// `ClientManager.createClient` is synchronous; a server whose box is not open
/// (a test, a failed open, one added after boot but before its first
/// [openFor]) silently falls back to an in-memory store — the cache is an
/// optimisation, never a correctness requirement.
class GraphQLCacheStore {
  GraphQLCacheStore._();

  /// Bumped through the app version: a new build may select different fields,
  /// and a half-populated entity from the old build would otherwise answer a
  /// cache read with a `CacheMissException` on every page it appears on.
  static const String _versionKey = '__isterCacheVersion';

  /// A box that grew past this is dropped wholesale on the next boot. Nothing
  /// evicts normalised entities otherwise — browsing a big library long enough
  /// would keep every poster, episode and track on disk forever.
  static const int _maxEntries = 20000;

  static final Map<String, HiveStore> _stores = {};
  static bool _initialized = false;
  static String _version = 'dev';

  /// Prepares Hive and opens a box for every configured server. Safe to call
  /// when there is no platform to store on (widget tests): it logs and leaves
  /// every server on an in-memory store.
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    try {
      _version = await _appVersion();
      if (!kIsWeb) {
        // Not `initHiveForFlutter`: that stores under the *documents*
        // directory, which on Linux is the user's own ~/Documents. This is
        // throw-away app state, so it belongs next to the downloads in the
        // application support directory. (On web Hive needs no path — it
        // stores in IndexedDB.)
        final dir = Directory(
            '${(await getApplicationSupportDirectory()).path}/graphql_cache');
        await dir.create(recursive: true);
        HiveStore.init(onPath: dir.path);
      }
      for (final server in await ServerStore.list()) {
        await openFor(server);
      }
    } catch (e, s) {
      LoggerService().logger.w('GraphQL cache not persisted',
          error: e, stackTrace: s);
    }
  }

  /// Opens (and version-checks) the box backing [server]'s cache. A no-op
  /// before [ensureInitialized] and after the box is already open.
  static Future<void> openFor(String server) async {
    if (!_initialized || _stores.containsKey(server)) return;
    try {
      final store = await HiveStore.open(boxName: boxNameFor(server));
      final stamp = store.box.get(_versionKey);
      final stale = stamp is! Map || stamp['version'] != _version;
      if (stale || store.box.length > _maxEntries) {
        await store.box.clear();
        LoggerService().logger.i(
            'GraphQL cache for $server reset (${stale ? 'new app version' : 'size cap'})');
      }
      await store.box.put(_versionKey, {'version': _version});
      _stores[server] = store;
    } catch (e, s) {
      LoggerService().logger.w('GraphQL cache for $server not persisted',
          error: e, stackTrace: s);
    }
  }

  /// The store to hand [GraphQLCache] for [server]. Synchronous by design —
  /// client creation happens inside `initState`.
  static Store storeFor(String server) => _stores[server] ?? InMemoryStore();

  /// Drops [server]'s cached data from disk (server removed from the app).
  static Future<void> removeFor(String server) async {
    final store = _stores.remove(server);
    try {
      await (store?.box.deleteFromDisk() ?? Future.value());
    } catch (e, s) {
      LoggerService().logger.w('Could not delete GraphQL cache for $server',
          error: e, stackTrace: s);
    }
  }

  /// Hive box names end up as file names, so the server identifier — which
  /// carries dots, colons and slashes — is reduced to a safe slug plus a hash
  /// of the full string to keep two servers that slug alike apart.
  @visibleForTesting
  static String boxNameFor(String server) {
    final slug = server
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    // FNV-1a: a stable hash across runs and releases, unlike String.hashCode.
    var hash = 0x811c9dc5;
    for (final unit in server.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    final short = slug.length > 40 ? slug.substring(0, 40) : slug;
    return 'gql_${short}_${hash.toRadixString(16)}';
  }

  /// Test seam: initialise against [path] instead of the app documents
  /// directory (path_provider has no test implementation) and stamp the boxes
  /// with [version], so a version change can be exercised.
  @visibleForTesting
  static void initForTest({required String path, String version = 'dev'}) {
    HiveStore.init(onPath: path);
    _version = version;
    _initialized = true;
  }

  /// Test seam: close every open box — the closest thing to an app restart,
  /// since Hive hands back the same instance for a box that is still open.
  @visibleForTesting
  static Future<void> resetForTest() async {
    for (final store in _stores.values) {
      await store.box.close();
    }
    _stores.clear();
    _initialized = false;
    _version = 'dev';
  }

  static Future<String> _appVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return 'dev';
    }
  }
}
