import 'dart:typed_data';

// The File in flutter_cache_manager's interface is package:file's, not
// dart:io's.
// ignore: depend_on_referenced_packages
import 'package:file/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:player/utils/ImageUtil.dart';

/// The cache audio_service loads notification / MPRIS / Android Auto artwork
/// through.
///
/// audio_service keys its artwork on the full `artUri`, and
/// [MediaPlayerHandler.restampArtToken] rewrites the stream token in that uri
/// on every rotation (the platform re-fetches the art long after the queue was
/// built, so the token there has to stay valid). Keyed on the url, every
/// rotation and every app start therefore stored the same cover again — the
/// store measured 200 entries for 98 distinct images, one of them 21 times.
///
/// This delegates everything to a real [CacheManager] but replaces the key
/// with [ImageUtil.cacheKeyFor], the same token-free key the in-app image
/// widgets use. audio_service does not accept a `cacheManager` after
/// `AudioService.init`, so this is installed there.
class NotificationArtCache implements BaseCacheManager {
  NotificationArtCache._(this._inner);

  factory NotificationArtCache() =>
      NotificationArtCache._(DefaultCacheManager());

  /// Seam for tests.
  NotificationArtCache.withManager(this._inner);

  final BaseCacheManager _inner;

  String _key(String urlOrKey, [String? explicit]) =>
      explicit ?? ImageUtil.cacheKeyFor(urlOrKey) ?? urlOrKey;

  @override
  Future<File> getSingleFile(String url,
          {String? key, Map<String, String>? headers}) =>
      // BaseCacheManager declares `headers` non-nullable, so it can only be
      // forwarded when the caller actually passed one.
      headers == null
          ? _inner.getSingleFile(url, key: _key(url, key))
          : _inner.getSingleFile(url, key: _key(url, key), headers: headers);

  @Deprecated('Prefer to use the new getFileStream method')
  @override
  Stream<FileInfo> getFile(String url,
          {String? key, Map<String, String>? headers}) =>
      headers == null
          // ignore: deprecated_member_use
          ? _inner.getFile(url, key: _key(url, key))
          // ignore: deprecated_member_use
          : _inner.getFile(url, key: _key(url, key), headers: headers);

  @override
  Stream<FileResponse> getFileStream(String url,
          {String? key, Map<String, String>? headers, bool? withProgress}) =>
      _inner.getFileStream(url,
          key: _key(url, key),
          headers: headers,
          withProgress: withProgress ?? false);

  @override
  Future<FileInfo> downloadFile(String url,
          {String? key, Map<String, String>? authHeaders, bool force = false}) =>
      _inner.downloadFile(url,
          key: _key(url, key), authHeaders: authHeaders, force: force);

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) =>
      _inner.getFileFromCache(_key(key), ignoreMemCache: ignoreMemCache);

  @override
  Future<FileInfo?> getFileFromMemory(String key) =>
      _inner.getFileFromMemory(_key(key));

  @override
  Future<File> putFile(String url, Uint8List fileBytes,
          {String? key,
          String? eTag,
          Duration maxAge = const Duration(days: 30),
          String fileExtension = 'file'}) =>
      _inner.putFile(url, fileBytes,
          key: _key(url, key),
          eTag: eTag,
          maxAge: maxAge,
          fileExtension: fileExtension);

  @override
  Future<File> putFileStream(String url, Stream<List<int>> source,
          {String? key,
          String? eTag,
          Duration maxAge = const Duration(days: 30),
          String fileExtension = 'file'}) =>
      _inner.putFileStream(url, source,
          key: _key(url, key),
          eTag: eTag,
          maxAge: maxAge,
          fileExtension: fileExtension);

  @override
  Future<void> removeFile(String key) => _inner.removeFile(_key(key));

  @override
  Future<void> emptyCache() => _inner.emptyCache();

  @override
  Future<void> dispose() => _inner.dispose();
}
