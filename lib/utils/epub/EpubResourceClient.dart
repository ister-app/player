import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:player/utils/StreamTokenService.dart';
import 'package:xml/xml.dart';

/// Fetches individual files out of an epub through the server's
/// `/epub/{mediaFileId}/resource/{entry}` endpoint, exactly like the old web
/// reader did: the epub is never downloaded as a whole, and every request is
/// authenticated with the stream token.
///
/// Text and XML entries are kept in a small in-memory LRU cache for the
/// duration of a reading session; audio is never fetched here (the player
/// streams it straight from [url], relying on the endpoint's Range support).
class EpubResourceClient {
  EpubResourceClient({
    required String nodeUrl,
    required this.mediaFileId,
    required this.serverName,
    http.Client? httpClient,
    Future<String?> Function(String serverName)? tokenProvider,
  })  : _base = nodeUrl.endsWith('/')
            ? nodeUrl.substring(0, nodeUrl.length - 1)
            : nodeUrl,
        _http = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider ?? StreamTokenService.ensureToken;

  final String mediaFileId;
  final String serverName;
  final String _base;
  final http.Client _http;
  final Future<String?> Function(String serverName) _tokenProvider;

  static const int _cacheCapacityBytes = 32 * 1024 * 1024;
  final LinkedHashMap<String, Uint8List> _cache = LinkedHashMap();
  int _cacheSize = 0;

  /// The absolute, tokenized URL of an entry — for images and audio, which are
  /// loaded by widgets/players rather than through [bytes].
  String url(String entryPath) {
    final token = StreamTokenService.getToken(serverName);
    final encoded = _encodeEntryPath(entryPath);
    return '$_base/epub/$mediaFileId/resource/$encoded'
        '${token != null ? '?token=${Uri.encodeQueryComponent(token)}' : ''}';
  }

  Future<Uint8List> bytes(String entryPath) async {
    final cached = _cache.remove(entryPath);
    if (cached != null) {
      _cache[entryPath] = cached; // re-insert as most recently used
      return cached;
    }
    // A failed token fetch shouldn't kill the read: the request goes out
    // without one and the server decides (bearer auth may still apply).
    String? token;
    try {
      token = await _tokenProvider(serverName);
    } catch (_) {
      token = null;
    }
    final uri = Uri.parse(
        '$_base/epub/$mediaFileId/resource/${_encodeEntryPath(entryPath)}'
        '${token != null ? '?token=${Uri.encodeQueryComponent(token)}' : ''}');
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      throw EpubResourceException(entryPath, response.statusCode);
    }
    final body = response.bodyBytes;
    _store(entryPath, body);
    return body;
  }

  Future<String> text(String entryPath) async =>
      utf8.decode(await bytes(entryPath), allowMalformed: true);

  Future<XmlDocument> xml(String entryPath) async =>
      XmlDocument.parse(await text(entryPath));

  void _store(String entryPath, Uint8List body) {
    if (body.length > _cacheCapacityBytes) return;
    _cache[entryPath] = body;
    _cacheSize += body.length;
    while (_cacheSize > _cacheCapacityBytes && _cache.isNotEmpty) {
      final evicted = _cache.remove(_cache.keys.first)!;
      _cacheSize -= evicted.length;
    }
  }

  /// Entry paths come from OPF/SMIL hrefs and may contain spaces or already be
  /// percent-encoded; normalize to decoded segments, then encode each one.
  static String _encodeEntryPath(String entryPath) => entryPath
      .split('/')
      .map((segment) => Uri.encodeComponent(_tryDecode(segment)))
      .join('/');

  static String _tryDecode(String segment) {
    try {
      return Uri.decodeComponent(segment);
    } on ArgumentError {
      return segment;
    }
  }

  void dispose() {
    _cache.clear();
    _cacheSize = 0;
    _http.close();
  }
}

class EpubResourceException implements Exception {
  EpubResourceException(this.entryPath, this.statusCode);

  final String entryPath;
  final int statusCode;

  @override
  String toString() => 'Fetching epub entry "$entryPath" failed: $statusCode';
}
