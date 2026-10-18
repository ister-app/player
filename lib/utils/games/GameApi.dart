import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/WellKnownService.dart';

/// One file of a game as the server lists it (`GET /game/{id}/manifest`).
class GameManifestFile {
  const GameManifestFile({required this.path, required this.size, required this.entry, this.lastModified});
  final String path;
  final int size;
  final bool entry;

  /// ISO instant as the server sent it; part of what tells an update apart.
  final String? lastModified;

  factory GameManifestFile.fromJson(Map<String, dynamic> json) => GameManifestFile(
        path: json['path'] as String,
        size: (json['size'] as num).toInt(),
        entry: json['entry'] == true,
        lastModified: json['lastModified']?.toString(),
      );

  Map<String, dynamic> toJson() => {'path': path, 'size': size, 'entry': entry, 'lastModified': ?lastModified};
}

class GameManifest {
  const GameManifest({
    required this.gameId,
    required this.platform,
    required this.form,
    required this.entryPath,
    required this.titleId,
    required this.steamAppId,
    required this.steamInstallDir,
    required this.totalBytes,
    required this.files,
    required this.etag,
    this.version,
    this.updatedAt,
  });
  final String gameId;
  final String platform;
  final String form;
  final String? entryPath;
  final String? titleId;
  final int? steamAppId;
  final String? steamInstallDir;
  final int totalBytes;
  final List<GameManifestFile> files;
  final String? etag;

  /// The server's version of the file set (Steam build id, or a digest of
  /// the listing); null from a server that predates it. Two manifests with
  /// different versions differ in at least one file.
  final String? version;
  final String? updatedAt;

  factory GameManifest.fromJson(Map<String, dynamic> json, {String? etag}) => GameManifest(
        gameId: json['gameId'] as String,
        platform: json['platform'] as String,
        form: json['form'] as String,
        entryPath: json['entryPath'] as String?,
        titleId: json['titleId'] as String?,
        steamAppId: (json['steamAppId'] as num?)?.toInt(),
        steamInstallDir: json['steamInstallDir'] as String?,
        totalBytes: (json['totalBytes'] as num).toInt(),
        files: [
          for (final f in json['files'] as List) GameManifestFile.fromJson((f as Map).cast<String, dynamic>())
        ],
        etag: etag ?? json['etag'] as String?,
        version: json['version']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'platform': platform,
        'form': form,
        'entryPath': entryPath,
        'titleId': titleId,
        'steamAppId': steamAppId,
        'steamInstallDir': steamInstallDir,
        'totalBytes': totalBytes,
        'files': [for (final f in files) f.toJson()],
        'etag': etag,
        'version': version,
        'updatedAt': updatedAt,
      };
}

/// A save snapshot on the server.
class GameSaveInfo {
  const GameSaveInfo({
    required this.version,
    required this.sizeBytes,
    required this.sha256,
    required this.deviceName,
    required this.note,
    required this.createdAt,
  });
  final int version;
  final int sizeBytes;
  final String sha256;
  final String? deviceName;
  final String? note;
  final DateTime? createdAt;

  factory GameSaveInfo.fromJson(Map<String, dynamic> json) => GameSaveInfo(
        version: (json['version'] as num).toInt(),
        sizeBytes: (json['sizeBytes'] as num).toInt(),
        sha256: json['sha256'] as String,
        deviceName: json['deviceName'] as String?,
        note: json['note'] as String?,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}

/// The server's head moved past the version this client synced from.
class GameSaveConflict implements Exception {
  GameSaveConflict({required this.latestVersion, required this.latestCreatedAt, required this.latestDevice});
  final int latestVersion;
  final DateTime? latestCreatedAt;
  final String? latestDevice;
  @override
  String toString() => 'GameSaveConflict(v$latestVersion from $latestDevice)';
}

class GameApiException implements Exception {
  GameApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  bool get isTransient => statusCode == 0 || statusCode == 429 || statusCode >= 500;
  @override
  String toString() => 'GameApiException($statusCode): $message';
}

/// The game endpoints of the server (`/game/{id}/...`): the manifest and
/// file urls the installer downloads from, the user's saves and the
/// achievement report. Authenticates with the login's bearer token; the
/// bulk file downloads go through [DownloadHttp] with a stream token instead.
class GameApi {
  GameApi(this.serverName, {http.Client? httpClient, Future<String?> Function(String)? bearer})
      : _http = httpClient ?? http.Client(),
        _bearer = bearer ?? LoginManager.getToken;

  final String serverName;
  final http.Client _http;
  final Future<String?> Function(String serverName) _bearer;

  String get baseUrl {
    final url = WellKnownService.getCached(serverName)?.serverUrl ?? serverName;
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  String fileUrl(String gameId, String relativePath) {
    final encoded = relativePath.split('/').map(Uri.encodeComponent).join('/');
    return '$baseUrl/game/$gameId/file/$encoded';
  }

  String saveUrl(String gameId, int version) => '$baseUrl/game/$gameId/saves/$version';

  Future<Map<String, String>> _headers({String? contentType, Map<String, String>? extra}) async {
    final token = await _bearer(serverName);
    return {
      'Authorization': ?token,
      'Content-Type': ?contentType,
      ...?extra,
    };
  }

  Future<GameManifest> manifest(String gameId) async {
    final response = await _http
        .get(Uri.parse('$baseUrl/game/$gameId/manifest'), headers: await _headers())
        .timeout(const Duration(seconds: 60));
    _check(response);
    return GameManifest.fromJson(_json(response), etag: response.headers['etag']);
  }

  Future<List<GameSaveInfo>> saves(String gameId) async {
    final response = await _http
        .get(Uri.parse('$baseUrl/game/$gameId/saves'), headers: await _headers())
        .timeout(const Duration(seconds: 30));
    _check(response);
    return [
      for (final s in jsonDecode(utf8.decode(response.bodyBytes)) as List)
        GameSaveInfo.fromJson((s as Map).cast<String, dynamic>())
    ];
  }

  /// Uploads a snapshot; throws [GameSaveConflict] when the server has a
  /// newer version than [baseVersion] and [force] is false.
  Future<GameSaveInfo> uploadSave(String gameId, File zip,
      {required int baseVersion, bool force = false, String? device, String? note, String? sha256}) async {
    final uri = Uri.parse('$baseUrl/game/$gameId/saves').replace(queryParameters: {
      'baseVersion': '$baseVersion',
      if (force) 'force': 'true',
      'device': ?device,
      'note': ?note,
    });
    final request = http.StreamedRequest('POST', uri);
    final length = await zip.length();
    request.headers.addAll(await _headers(contentType: 'application/zip', extra: {
      'X-Content-SHA256': ?sha256,
    }));
    request.contentLength = length;
    unawaited(zip.openRead().pipe(request.sink));
    final streamed = await _http.send(request).timeout(const Duration(minutes: 30));
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 409) {
      final body = _json(response);
      throw GameSaveConflict(
        latestVersion: (body['latestVersion'] as num).toInt(),
        latestCreatedAt: DateTime.tryParse(body['latestCreatedAt']?.toString() ?? ''),
        latestDevice: body['latestDevice'] as String?,
      );
    }
    _check(response);
    return GameSaveInfo.fromJson(_json(response));
  }

  /// Downloads a snapshot to [target] (streamed, no Range: saves are small).
  Future<void> downloadSave(String gameId, int version, File target) async {
    final request = http.Request('GET', Uri.parse(saveUrl(gameId, version)));
    request.headers.addAll(await _headers());
    final response = await _http.send(request).timeout(const Duration(minutes: 10));
    if (response.statusCode != 200) {
      throw GameApiException(response.statusCode, 'save download failed');
    }
    await target.parent.create(recursive: true);
    final part = File('${target.path}.part');
    final sink = part.openWrite();
    try {
      await response.stream.pipe(sink);
    } catch (_) {
      try {
        await part.delete();
      } catch (_) {}
      rethrow;
    }
    await part.rename(target.path);
  }

  Future<void> reportAchievements(String gameId, Map<String, dynamic> report) async {
    final response = await _http
        .post(Uri.parse('$baseUrl/game/$gameId/achievements'),
            headers: await _headers(contentType: 'application/json'), body: jsonEncode(report))
        .timeout(const Duration(seconds: 60));
    _check(response);
  }

  Future<void> uploadAchievementIcon(String gameId, String source, String externalId, List<int> png) async {
    final response = await _http
        .post(
            Uri.parse('$baseUrl/game/$gameId/achievements/$source/${Uri.encodeComponent(externalId)}/icon'),
            headers: await _headers(contentType: 'image/png'),
            body: png)
        .timeout(const Duration(seconds: 60));
    _check(response);
  }

  Map<String, dynamic> _json(http.Response response) =>
      (jsonDecode(utf8.decode(response.bodyBytes)) as Map).cast<String, dynamic>();

  void _check(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw GameApiException(response.statusCode, response.body.isEmpty ? response.reasonPhrase ?? '' : response.body);
  }
}
