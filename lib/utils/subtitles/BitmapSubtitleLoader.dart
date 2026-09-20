import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

import 'BitmapSubtitles.dart';

/// Fetches a bitmap subtitle's cue index and sprite sheets — from the serving
/// node (stream-token auth, like every other `/hls/` resource) or from the
/// files a download mirrored.
class BitmapSubtitleLoader {
  BitmapSubtitleLoader.remote(
      {required String baseUrl, required String? Function() token, http.Client? client})
      : _baseUrl = baseUrl,
        _token = token,
        _localDir = null,
        _client = client ?? http.Client();

  BitmapSubtitleLoader.local(String dir)
      : _baseUrl = null,
        _token = null,
        _localDir = dir,
        _client = null;

  final String? _baseUrl;
  final String? Function()? _token;
  final String? _localDir;
  final http.Client? _client;

  /// The first request for a file makes the server generate the artifacts
  /// (it reads the container once), so this is a generous timeout.
  static const Duration timeout = Duration(seconds: 90);

  static String indexName(String streamId) => 'bsub_$streamId.json';

  /// Identifies the source, so an overlay can tell "same file, re-opened"
  /// from "another file".
  String get key => _localDir ?? _baseUrl!;

  Future<BitmapSubtitleIndex> loadIndex(String streamId) async {
    final bytes = await _read(indexName(streamId));
    return BitmapSubtitleIndex.parse(String.fromCharCodes(bytes));
  }

  Future<ui.Image> loadSheet(String name) async {
    final codec = await ui.instantiateImageCodec(await _read(name));
    try {
      return (await codec.getNextFrame()).image;
    } finally {
      codec.dispose();
    }
  }

  Future<Uint8List> _read(String name) async {
    final dir = _localDir;
    if (dir != null) return File('$dir/$name').readAsBytes();
    final token = _token!();
    final uri = Uri.parse(
        token == null ? '$_baseUrl/$name' : '$_baseUrl/$name?token=$token');
    final response = await _client!.get(uri).timeout(timeout);
    if (response.statusCode != 200) {
      throw StateError('HTTP ${response.statusCode} for $name');
    }
    return response.bodyBytes;
  }
}
