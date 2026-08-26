import 'dart:typed_data';

// The File in flutter_cache_manager's interface is package:file's, not dart:io's.
// ignore: depend_on_referenced_packages
import 'package:file/file.dart';
// ignore: depend_on_referenced_packages
import 'package:file/memory.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/NotificationArtCache.dart';

/// Records the keys the wrapper hands down.
class _RecordingManager implements BaseCacheManager {
  final List<String> keys = [];
  final List<String> urls = [];
  final File _file = MemoryFileSystem().file('art.jpg')..createSync();

  @override
  Future<File> getSingleFile(String url,
      {String? key, Map<String, String>? headers}) async {
    urls.add(url);
    keys.add(key!);
    return _file;
  }

  @override
  Future<FileInfo?> getFileFromMemory(String key) async {
    keys.add(key);
    return null;
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not used by this test');
}

void main() {
  late _RecordingManager inner;
  late NotificationArtCache cache;

  setUp(() {
    inner = _RecordingManager();
    cache = NotificationArtCache.withManager(inner);
  });

  test('the stream token is dropped from the key, not from the request', () async {
    await cache.getSingleFile('http://node/images/img-1/download?token=tok-1');

    // The download still needs the token...
    expect(inner.urls.single, 'http://node/images/img-1/download?token=tok-1');
    // ...but the cache entry must not be keyed on it.
    expect(inner.keys.single, 'http://node/images/img-1/download');
  });

  test('a rotated token hits the same entry', () async {
    await cache.getSingleFile('http://node/images/img-1/download?token=tok-1');
    await cache.getSingleFile('http://node/images/img-1/download?token=tok-2');

    expect(inner.keys.toSet(), hasLength(1));
  });

  test('the memory lookup audio_service does uses the same key', () async {
    await cache.getFileFromMemory('http://node/images/img-1/download?token=t');

    expect(inner.keys.single, 'http://node/images/img-1/download');
  });

  test('an explicit key wins over the derived one', () async {
    await cache.getSingleFile('http://node/images/img-1/download?token=t',
        key: 'explicit');

    expect(inner.keys.single, 'explicit');
  });

  test('urls without a token pass through unchanged', () async {
    await cache.getSingleFile('file:///home/u/art.jpg');

    expect(inner.keys.single, 'file:///home/u/art.jpg');
  });
}
