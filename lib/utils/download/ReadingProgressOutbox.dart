import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';

/// The server's REST pair for reading progress, shared by the epub and comic
/// sync services and the outbox.
class BookProgressApi {
  BookProgressApi._();

  static String apiBase(String serverName) {
    final url = WellKnownService.getCached(serverName)?.serverUrl ?? '';
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// A failed token fetch shouldn't kill the sync: the request goes out
  /// without one and the server decides (bearer auth may still apply).
  static Future<Uri> endpoint(String serverName, String path,
      [Map<String, String>? query]) async {
    String? token;
    try {
      token = await StreamTokenService.ensureToken(serverName);
    } catch (_) {
      token = null;
    }
    return Uri.parse('${apiBase(serverName)}$path').replace(queryParameters: {
      ...?query,
      if (token != null) 'token': token,
    });
  }
}

/// A reading position the server has not accepted yet. Doubles as the last
/// known position when `/book-progress` cannot be fetched.
class PendingReadingProgress {
  const PendingReadingProgress({
    required this.bookId,
    required this.payload,
    required this.updatedAt,
  });

  final String bookId;

  /// The `/reading-progress` POST body.
  final Map<String, dynamic> payload;
  final DateTime updatedAt;

  String? get location => payload['location'] as String?;
  String? get mediaFileId => payload['readingLocationMediaFileId'] as String?;
  double get progress => (payload['progress'] as num?)?.toDouble() ?? 0;

  Map<String, dynamic> toJson() =>
      {'bookId': bookId, 'payload': payload, 'updatedAt': updatedAt.toIso8601String()};

  static PendingReadingProgress fromJson(Map<String, dynamic> j) =>
      PendingReadingProgress(
        bookId: j['bookId'] as String,
        payload: Map<String, dynamic>.from(j['payload'] as Map),
        updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );
}

/// Reading positions written while the server was unreachable: one per book
/// (newest wins), replayed when the shell connects again.
class ReadingProgressOutbox {
  ReadingProgressOutbox(this._store);

  static ReadingProgressOutbox? _instance;
  static ReadingProgressOutbox get instance =>
      _instance ??= ReadingProgressOutbox(DownloadService.instance.store);

  @visibleForTesting
  static void resetForTest() => _instance = null;

  static const _fileName = 'reading_outbox.json';
  final DownloadStore _store;
  final Map<String, Map<String, PendingReadingProgress>> _cache = {};

  Future<Map<String, PendingReadingProgress>> load(String server) async {
    final cached = _cache[server];
    if (cached != null) return cached;
    final map = <String, PendingReadingProgress>{};
    // Like DownloadService.localReadingDir: never wait for the store to come
    // up (it is started at launch; under flutter test it never does).
    final usable = !kIsWeb && _store.rootPathSync != null;
    if (usable) {
      Object? data;
      try {
        data = await _store.readJson(server, _fileName);
      } catch (e) {
        // No usable store (tests, restricted platform): behave as empty.
        LoggerService().logger.w('reading outbox unavailable: $e');
      }
      if (data is List) {
        for (final e in data) {
          try {
            final p = PendingReadingProgress.fromJson(Map<String, dynamic>.from(e as Map));
            map[p.bookId] = p;
          } catch (_) {}
        }
      }
    }
    return _cache[server] = map;
  }

  /// The pending position of [bookId] (null until [load] ran or when none).
  PendingReadingProgress? lastFor(String server, String bookId) =>
      _cache[server]?[bookId];

  Future<void> put(String server, String bookId, Map<String, dynamic> payload) async {
    if (kIsWeb) return;
    final map = await load(server);
    map[bookId] = PendingReadingProgress(
        bookId: bookId, payload: payload, updatedAt: DateTime.now());
    await _save(server);
  }

  Future<void> clear(String server, String bookId) async {
    if (kIsWeb) return;
    final map = await load(server);
    if (map.remove(bookId) != null) await _save(server);
  }

  Future<void> _save(String server) async {
    if (_store.rootPathSync == null) return;
    try {
      await _store.writeJson(server, _fileName,
          _cache[server]!.values.map((e) => e.toJson()).toList());
    } catch (e) {
      LoggerService().logger.w('reading outbox not saved: $e');
    }
  }

  /// POSTs every pending position; stops at the first failure. Returns how
  /// many the server accepted.
  Future<int> replay(String server, {http.Client? httpClient}) async {
    if (kIsWeb) return 0;
    final map = await load(server);
    if (map.isEmpty) return 0;
    final client = httpClient ?? http.Client();
    var n = 0;
    try {
      for (final p in map.values.toList()
        ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt))) {
        final response = await client.post(
          await BookProgressApi.endpoint(server, '/reading-progress'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(p.payload),
        );
        if (response.statusCode >= 400) {
          throw Exception('status ${response.statusCode}');
        }
        map.remove(p.bookId);
        n++;
      }
    } catch (e) {
      LoggerService().logger.w('reading progress replay stopped: $e');
    } finally {
      if (httpClient == null) client.close();
      await _save(server);
    }
    return n;
  }

}
