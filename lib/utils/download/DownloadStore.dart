import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player/utils/download/DownloadModels.dart';

/// On-disk home of everything downloaded: one directory per server under
/// `<app support>/downloads/`, holding a `manifest.json` and one directory per
/// media file that mirrors the server's HLS file names exactly, so the
/// rewritten master's relative URIs resolve in place.
///
/// Manifest writes are atomic (temp file + rename) and serialized, so a
/// progress update can never interleave with a removal. Entries are kept in
/// memory after the first load; [DownloadService] owns the mutations.
class DownloadStore {
  DownloadStore({Directory? rootOverride}) : _rootOverride = rootOverride;

  final Directory? _rootOverride;
  Directory? _root;
  final Map<String, List<DownloadEntry>> _entries = {};
  Future<void> _writeChain = Future.value();

  /// The server identifier as a directory name (`localhost:8080/api` has
  /// characters no filesystem likes).
  static String slug(String serverName) =>
      serverName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');

  Future<Directory> root() async {
    final cached = _root;
    if (cached != null) return cached;
    // Callers must not block on this (under flutter test the platform lookup
    // never completes): see DownloadService.localReadingDir.
    final dir = _rootOverride ??
        Directory('${(await getApplicationSupportDirectory()).path}/downloads');
    await dir.create(recursive: true);
    return _root = dir;
  }

  /// The root path once [root] has resolved — the playback hot path needs
  /// a synchronous lookup.
  String? get rootPathSync => _root?.path ?? _rootOverride?.path;

  Future<Directory> serverDir(String serverName) async =>
      Directory('${(await root()).path}/${slug(serverName)}');

  String? itemDirPathSync(String serverName, String mediaFileId) {
    final root = rootPathSync;
    if (root == null) return null;
    return '$root/${slug(serverName)}/$mediaFileId';
  }

  Future<Directory> itemDir(String serverName, String mediaFileId) async {
    final dir = Directory('${(await serverDir(serverName)).path}/$mediaFileId');
    await dir.create(recursive: true);
    return dir;
  }

  Future<void> deleteItemDir(String serverName, String mediaFileId) async {
    final dir = Directory('${(await serverDir(serverName)).path}/$mediaFileId');
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  /// Loads every manifest on disk (start-up resume); returns the server
  /// names they belong to.
  Future<List<String>> loadAll() async {
    final r = await root();
    final servers = <String>[];
    await for (final e in r.list()) {
      if (e is! Directory) continue;
      final f = File('${e.path}/manifest.json');
      if (!await f.exists()) continue;
      try {
        final data = jsonDecode(await f.readAsString());
        final server = data is Map ? data['server'] as String? : null;
        if (server == null) continue;
        await load(server);
        servers.add(server);
      } catch (err) {
        debugPrint('unreadable manifest at ${f.path}: $err');
      }
    }
    return servers;
  }

  Future<List<DownloadEntry>> load(String serverName) async {
    await root();
    final cached = _entries[serverName];
    if (cached != null) return cached;
    final data = await readJson(serverName, 'manifest.json');
    final list = <DownloadEntry>[];
    if (data is Map && data['entries'] is List) {
      for (final e in data['entries'] as List) {
        try {
          list.add(DownloadEntry.fromJson(Map<String, dynamic>.from(e as Map)));
        } catch (err) {
          debugPrint('skipping unreadable download entry: $err');
        }
      }
    }
    return _entries[serverName] = list;
  }

  List<DownloadEntry> entries(String serverName) =>
      List.unmodifiable(_entries[serverName] ?? const []);

  /// Servers whose manifests are loaded in memory.
  Iterable<String> get loadedServers => _entries.keys;

  DownloadEntry? get(String serverName, String key) =>
      _entries[serverName]?.where((e) => e.key == key).firstOrNull;

  Future<void> put(String serverName, DownloadEntry entry) async {
    final list = await load(serverName);
    final i = list.indexWhere((e) => e.key == entry.key);
    if (i >= 0) {
      list[i] = entry;
    } else {
      list.add(entry);
    }
    await _saveManifest(serverName);
  }

  Future<void> remove(String serverName, String key) async {
    final list = await load(serverName);
    list.removeWhere((e) => e.key == key);
    await _saveManifest(serverName);
  }

  Future<void> _saveManifest(String serverName) => writeJson(
        serverName,
        'manifest.json',
        {
          'version': 1,
          'server': serverName,
          'entries': (_entries[serverName] ?? const [])
              .map((e) => e.toJson())
              .toList(),
        },
      );

  /// Reads a JSON file in the server directory; null when absent/unreadable.
  Future<Object?> readJson(String serverName, String fileName) async {
    final f = File('${(await serverDir(serverName)).path}/$fileName');
    if (!await f.exists()) return null;
    try {
      return jsonDecode(await f.readAsString());
    } catch (e) {
      debugPrint('unreadable $fileName for $serverName: $e');
      return null;
    }
  }

  /// Atomic, serialized JSON write in the server directory.
  Future<void> writeJson(String serverName, String fileName, Object data) {
    final next = _writeChain.then((_) async {
      final dir = await serverDir(serverName);
      await dir.create(recursive: true);
      final tmp = File('${dir.path}/$fileName.tmp');
      await tmp.writeAsString(jsonEncode(data), flush: true);
      await tmp.rename('${dir.path}/$fileName');
    });
    // Keep the chain alive even when a write fails.
    _writeChain = next.catchError((_) {});
    return next;
  }

  /// Bytes used by the files under an item directory.
  static Future<int> dirSize(Directory dir) async {
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final e in dir.list(recursive: true, followLinks: false)) {
      if (e is File) total += await e.length();
    }
    return total;
  }

  @visibleForTesting
  void resetForTest() {
    _entries.clear();
    _root = null;
  }
}
