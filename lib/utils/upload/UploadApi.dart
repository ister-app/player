import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:player/utils/LoginManager.dart';

import 'UploadModels.dart';

/// A call the server refused. [statusCode] decides what the uploader does
/// next: 409 with [continueAt] → resync, 429 → back off for [retryAfter],
/// anything in the 5xx range or a transport error → retry, the rest → give up.
class UploadApiException implements Exception {
  UploadApiException(this.statusCode, this.message, {this.continueAt, this.retryAfter});
  final int statusCode;
  final String message;
  final int? continueAt;
  final Duration? retryAfter;

  bool get isTransient => statusCode == 0 || statusCode == 429 || statusCode >= 500;

  @override
  String toString() => 'UploadApiException($statusCode): $message';
}

/// Thin client for the server's admin upload endpoints. Authenticates with the
/// login's bearer token — unlike the player's other REST calls, which use a
/// stream token: the server does not accept those for writing into a library.
///
/// Only GET and POST, no custom headers beyond Authorization/Content-Type: the
/// web build calls a node cross-origin and the server's CORS allows no more.
class UploadApi {
  UploadApi(this.serverName, {http.Client? httpClient, Future<String?> Function(String)? bearer})
      : _http = httpClient ?? http.Client(),
        _bearer = bearer ?? LoginManager.getToken;

  final String serverName;
  final http.Client _http;
  final Future<String?> Function(String serverName) _bearer;

  Future<Map<String, String>> _headers({String? contentType}) async {
    final token = await _bearer(serverName);
    return {
      'Authorization': ?token,
      'Content-Type': ?contentType,
    };
  }

  static String _join(String base, String path) =>
      base.endsWith('/') ? '${base.substring(0, base.length - 1)}$path' : '$base$path';

  /// Null when the server predates uploads (404) — the entry is hidden then.
  Future<List<UploadDirectory>?> directories(String serverUrl) async {
    final response = await _http
        .get(Uri.parse(_join(serverUrl, '/library-upload/directories')), headers: await _headers())
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 404) return null;
    _check(response);
    return [
      for (final d in jsonDecode(utf8.decode(response.bodyBytes)) as List)
        UploadDirectory.fromJson((d as Map).cast<String, dynamic>())
    ];
  }

  Map<String, dynamic> _plan(String directoryId, String targetParent, String? rootName, bool overwrite,
          List<({String relativePath, int size})> entries) =>
      {
        'directoryId': directoryId,
        'targetParent': targetParent,
        'rootName': rootName,
        'overwrite': overwrite,
        'entries': [
          for (final e in entries) {'relativePath': e.relativePath, 'size': e.size}
        ],
      };

  Future<UploadPreview> preview(String nodeUrl,
      {required String directoryId,
      required String targetParent,
      required String? rootName,
      required bool overwrite,
      required List<({String relativePath, int size})> entries}) async {
    final response = await _postJson(_join(nodeUrl, '/library-upload/preview'),
        _plan(directoryId, targetParent, rootName, overwrite, entries));
    return UploadPreview.fromJson(response);
  }

  Future<UploadSession> createSession(String nodeUrl,
      {required String directoryId,
      required String targetParent,
      required String? rootName,
      required bool overwrite,
      required List<({String relativePath, int size})> entries}) async {
    final response = await _postJson(_join(nodeUrl, '/library-upload/sessions'),
        _plan(directoryId, targetParent, rootName, overwrite, entries));
    return UploadSession.fromJson(response);
  }

  Future<UploadSession> session(String nodeUrl, String sessionId) async {
    final response = await _http
        .get(Uri.parse(_join(nodeUrl, '/library-upload/sessions/$sessionId')), headers: await _headers())
        .timeout(const Duration(seconds: 20));
    _check(response);
    return UploadSession.fromJson(jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  /// Sends one chunk. [bytes] is streamed, [length] announced up front: the
  /// server stores the body as it arrives and needs the length to tell a
  /// complete chunk from a connection that broke off.
  Future<UploadChunkResult> chunk(String nodeUrl, String sessionId, String fileId,
      {required int offset, required int length, required Stream<List<int>> bytes}) async {
    final request = http.StreamedRequest(
        'POST', Uri.parse(_join(nodeUrl, '/library-upload/sessions/$sessionId/files/$fileId/chunk?offset=$offset')))
      ..headers.addAll(await _headers(contentType: 'application/octet-stream'))
      ..contentLength = length;
    // Feed the body while the request is in flight; a read error travels through the sink and
    // fails the request, which the caller retries.
    unawaited(request.sink.addStream(bytes).whenComplete(request.sink.close));
    final response = await http.Response.fromStream(await _http.send(request));
    _check(response);
    return UploadChunkResult.fromJson(jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  Future<UploadChunkResult> complete(String nodeUrl, String sessionId, String fileId) async {
    final response = await _http
        .post(Uri.parse(_join(nodeUrl, '/library-upload/sessions/$sessionId/files/$fileId/complete')),
            headers: await _headers())
        // completing a large S3 upload assembles it server side
        .timeout(const Duration(minutes: 10));
    _check(response);
    return UploadChunkResult.fromJson(jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  Future<void> abort(String nodeUrl, String sessionId) async {
    final response = await _http
        .post(Uri.parse(_join(nodeUrl, '/library-upload/sessions/$sessionId/abort')), headers: await _headers())
        .timeout(const Duration(seconds: 60));
    _check(response);
  }

  Future<Map<String, dynamic>> _postJson(String url, Map<String, dynamic> body) async {
    final response = await _http
        .post(Uri.parse(url), headers: await _headers(contentType: 'application/json'), body: jsonEncode(body))
        .timeout(const Duration(minutes: 2));
    _check(response);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  void _check(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    Map<String, dynamic>? json;
    try {
      json = (jsonDecode(utf8.decode(response.bodyBytes)) as Map).cast<String, dynamic>();
    } catch (_) {
      json = null;
    }
    final retryAfter = int.tryParse(response.headers['retry-after'] ?? '');
    throw UploadApiException(
      response.statusCode,
      (json?['detail'] ?? json?['title'] ?? response.reasonPhrase ?? 'HTTP ${response.statusCode}').toString(),
      continueAt: (json?['receivedBytes'] as num?)?.toInt(),
      retryAfter: retryAfter == null ? null : Duration(seconds: retryAfter),
    );
  }
}
