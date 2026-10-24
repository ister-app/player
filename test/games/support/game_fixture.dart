import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/gameById.graphql.dart';

/// A `gameById` result with the fields the install and play code read.
Query$gameById$gameById gameFixture({
  String id = 'g1',
  String title = 'Test Game',
  String platform = 'PSX',
  String form = 'ROM',
  double sizeBytes = 3010,
  String? version,
  String? updatedAt,
  String? titleId,
  String? steamAppId,
  String? steamInstallDir,
}) =>
    Query$gameById$gameById.fromJson({
      '__typename': 'Game',
      'id': id,
      'name': title,
      'title': title,
      'releaseYear': 2001,
      'platform': platform,
      'form': form,
      'steamCloud': false,
      'sizeBytes': sizeBytes,
      'fileCount': 2,
      'launcher': {'__typename': 'GameLauncherHint', 'kind': 'RETROARCH', 'retroArchCore': 'pcsx_rearmed'},
      'playTimeMs': 0.0,
      'version': version,
      'updatedAt': updatedAt,
      'titleId': titleId,
      'steamAppId': steamAppId,
      'steamInstallDir': steamInstallDir,
      'savePaths': <Object>[],
      'savePathSource': 'NONE',
      'savePathOverride': <Object>[],
      'library': {'__typename': 'Library', 'id': 'lib', 'name': 'Games'},
      'saves': <Object>[],
      'achievements': {'__typename': 'GameAchievementSummary', 'total': 0, 'unlocked': 0, 'list': <Object>[]},
    });

/// One file of the fake server, served in [chunk]-sized pieces with an
/// optional gate that holds the stream after the first chunk.
class FakeGameFile {
  FakeGameFile(this.path, this.size, {this.entry = false, this.chunk = 1000, this.lastModified = '2026-01-01T00:00:00Z'});
  final String path;
  final int size;
  final bool entry;
  final int chunk;
  final String lastModified;

  /// When set, the stream waits on it after the first chunk.
  Completer<void>? gate;

  Uint8List get bytes => Uint8List.fromList(List<int>.generate(size, (i) => i % 251));

  Map<String, Object?> toJson() => {'path': path, 'size': size, 'entry': entry, 'lastModified': lastModified};
}

/// A fake game server: manifests per game id and files with Range support.
class FakeGameServer {
  FakeGameServer();

  final Map<String, List<FakeGameFile>> games = {};
  final Map<String, String?> versions = {};
  final List<http.BaseRequest> requests = [];

  /// Status to answer for a game's manifest instead of 200.
  final Map<String, int> manifestStatus = {};

  /// Save snapshots uploaded per game id, in order (version = index + 1).
  final Map<String, List<Uint8List>> uploadedSaves = {};

  http.Client get client => MockClient.streaming(_handle);

  Future<http.StreamedResponse> _handle(http.BaseRequest request, http.ByteStream body) async {
    requests.add(request);
    final segments = request.url.pathSegments;
    final gameIndex = segments.indexOf('game');
    if (gameIndex < 0 || segments.length < gameIndex + 3) return _response(404, 'nope');
    final id = segments[gameIndex + 1];
    final what = segments[gameIndex + 2];
    final files = games[id];
    if (files == null) return _response(404, 'no such game');
    if (what == 'manifest') {
      final status = manifestStatus[id];
      if (status != null) return _response(status, 'manifest error');
      final total = files.fold(0, (a, f) => a + f.size);
      return _response(
          200,
          jsonEncode({
            'gameId': id,
            'platform': 'PSX',
            'form': 'ROM',
            'entryPath': files.where((f) => f.entry).firstOrNull?.path,
            'totalBytes': total,
            'fileCount': files.length,
            'version': versions[id],
            'files': [for (final f in files) f.toJson()],
          }),
          headers: {'etag': '"$id-${versions[id]}"'});
    }
    if (what == 'saves' && request.method == 'POST') {
      final bytes = await body.toBytes();
      final version = (uploadedSaves[id] ??= []).length + 1;
      uploadedSaves[id]!.add(bytes);
      return _response(200, jsonEncode({'version': version, 'sizeBytes': bytes.length, 'sha256': 'x', 'deviceName': 'test-box'}));
    }
    if (what == 'saves') return _response(200, '[]');
    if (what == 'file') {
      final path = segments.sublist(gameIndex + 3).join('/');
      final file = files.where((f) => f.path == path).firstOrNull;
      if (file == null) return _response(404, 'no such file');
      final range = request.headers['Range'] ?? request.headers['range'];
      var start = 0;
      if (range != null) start = int.parse(range.substring('bytes='.length, range.length - 1));
      final data = file.bytes.sublist(start);
      return http.StreamedResponse(_chunks(file, data), start > 0 ? 206 : 200,
          contentLength: data.length, headers: {'accept-ranges': 'bytes'});
    }
    return _response(404, 'unknown');
  }

  Stream<List<int>> _chunks(FakeGameFile file, Uint8List data) async* {
    var offset = 0;
    var first = true;
    while (offset < data.length) {
      final end = (offset + file.chunk).clamp(0, data.length);
      yield data.sublist(offset, end);
      offset = end;
      if (first) {
        first = false;
        final gate = file.gate;
        if (gate != null) await gate.future;
      }
    }
  }

  http.StreamedResponse _response(int status, String body, {Map<String, String>? headers}) =>
      http.StreamedResponse(Stream.value(utf8.encode(body)), status, headers: headers ?? const {});
}
