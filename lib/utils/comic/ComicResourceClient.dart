import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/comic/ComicManifest.dart';

/// Talks to the node's `/comic/{mediaFileId}/…` endpoints: the manifest, the
/// per-page images of a cbz and ranged reads of the whole file (pdf). Every
/// request is authenticated with the stream token, like the epub reader.
class ComicResourceClient {
  ComicResourceClient({
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

  Future<ComicManifest> manifest() async {
    final response =
        await _http.get(await _tokenized('/comic/$mediaFileId/manifest'));
    if (response.statusCode != 200) {
      throw ComicResourceException('manifest', response.statusCode);
    }
    return ComicManifest.fromJson(
        json.decode(response.body) as Map<String, dynamic>);
  }

  /// The absolute, tokenized URL of one cbz page — loaded by image widgets,
  /// not through this client. Built lazily with the token of the moment so a
  /// URL created after a token refresh keeps working.
  String pageUrl(int index, {int? width}) {
    final token = StreamTokenService.getToken(serverName);
    return '$_base/comic/$mediaFileId/page/$index'
        '${_query({
          if (width != null) 'width': '$width',
          if (token != null) 'token': token,
        })}';
  }

  /// Cache key for [pageUrl] images: the same URL without the expiring token,
  /// so a token rotation doesn't refetch already-cached pages.
  String pageCacheKey(int index, {int? width}) =>
      '$_base/comic/$mediaFileId/page/$index'
      '${_query({if (width != null) 'width': '$width'})}';

  /// One ranged read of the whole volume file; pdfium reads pdfs in chunks
  /// this way, so large volumes never need a full download.
  Future<Uint8List> readRange(int offset, int length) async {
    if (length <= 0) return Uint8List(0);
    final response = await _http.get(
      await _tokenized('/comic/$mediaFileId/file'),
      headers: {'Range': 'bytes=$offset-${offset + length - 1}'},
    );
    if (response.statusCode != 200 && response.statusCode != 206) {
      throw ComicResourceException('file', response.statusCode);
    }
    return response.bodyBytes;
  }

  /// The volume's file size, from a zero-length range probe.
  Future<int?> fileSize() async {
    final response = await _http.get(
      await _tokenized('/comic/$mediaFileId/file'),
      headers: {'Range': 'bytes=0-0'},
    );
    if (response.statusCode == 206) {
      final contentRange = response.headers['content-range'];
      final size = contentRange?.split('/').lastOrNull;
      return size != null ? int.tryParse(size) : null;
    }
    if (response.statusCode == 200) {
      return response.bodyBytes.length;
    }
    throw ComicResourceException('file', response.statusCode);
  }

  Future<Uri> _tokenized(String path) async {
    // A failed token fetch shouldn't kill the read: the request goes out
    // without one and the server decides (bearer auth may still apply).
    String? token;
    try {
      token = await _tokenProvider(serverName);
    } catch (_) {
      token = null;
    }
    return Uri.parse('$_base$path${_query({if (token != null) 'token': token})}');
  }

  static String _query(Map<String, String> params) => params.isEmpty
      ? ''
      : '?${params.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&')}';

  void dispose() => _http.close();
}

class ComicResourceException implements Exception {
  ComicResourceException(this.what, this.statusCode);

  final String what;
  final int statusCode;

  @override
  String toString() => 'Fetching comic $what failed: $statusCode';
}
