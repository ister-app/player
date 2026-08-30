import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/utils/comic/ComicManifest.dart';
import 'package:player/utils/comic/ComicResourceClient.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/EpubDownloader.dart';
import 'package:player/utils/download/HlsDownloader.dart' show HlsDownloader;

/// Mirrors a comic volume: the manifest plus every page at full resolution
/// (`page_00000.jpg`…) — cbz entries and server-rasterized pdf pages alike.
class ComicDownloader {
  ComicDownloader({http.Client? httpClient, DownloadHttp? http})
      : _httpClient = httpClient,
        _http = http ?? DownloadHttp(httpClient: httpClient);

  final http.Client? _httpClient;
  final DownloadHttp _http;

  static const String manifestFile = 'manifest.json';

  /// Whole-file mirror name from before pdfs became per-page; only referenced
  /// to detect and clean up those legacy downloads.
  static const String pdfFile = 'file.pdf';
  static const Duration _timeout = Duration(seconds: 90);

  static String pageFileName(int index, String sourceName) {
    final dot = sourceName.lastIndexOf('.');
    final ext = dot > 0 ? sourceName.substring(dot + 1).toLowerCase() : 'jpg';
    return 'page_${index.toString().padLeft(5, '0')}.$ext';
  }

  Future<ReadingDownloadResult> download({
    required String serverName,
    required Directory dir,
    required String nodeUrl,
    required String mediaFileId,
    String? artworkUrl,
    required void Function(DownloadProgress progress) onProgress,
    required DownloadCancelToken cancel,
  }) async {
    await dir.create(recursive: true);
    await DownloadHttp.discardPartials(dir);

    final client = ComicResourceClient(
      nodeUrl: nodeUrl,
      mediaFileId: mediaFileId,
      serverName: serverName,
      httpClient: _httpClient,
    );
    final manifest = await client.manifest();
    await DownloadHttp.writeAtomic(
        File('${dir.path}/$manifestFile'), jsonEncode(manifest.toJson()));

    var bytes = await DownloadHttp.existingBytes(dir);
    var done = 0;
    final int total;
    var lastReport = DateTime.now();
    void report(int total, {bool force = false}) {
      final now = DateTime.now();
      if (force || now.difference(lastReport).inMilliseconds >= 500) {
        lastReport = now;
        onProgress(DownloadProgress(
            bytes: bytes, segmentsDone: done, segmentsTotal: total));
      }
    }

    switch (manifest.format) {
      case 'CBZ':
      case 'PDF':
        // A mirror from before pdfs became per-page holds the whole file;
        // deleting it here lets a re-run convert itself to the page mirror.
        final legacyPdf = File('${dir.path}/$pdfFile');
        if (await legacyPdf.exists()) {
          await legacyPdf.delete();
        }
        final count = manifest.pageCount ?? manifest.pages.length;
        total = count;
        for (var i = 0; i < count; i++) {
          DownloadHttp.checkCancel(cancel);
          final name = i < manifest.pages.length ? manifest.pages[i].name : 'page.jpg';
          final target = File('${dir.path}/${pageFileName(i, name)}');
          if (!await target.exists()) {
            bytes += await _http.getToFile(
                serverName, client.pageCacheKey(i), target, cancel,
                timeout: _timeout);
          }
          done++;
          report(total);
        }
      default:
        client.dispose();
        throw DownloadFailure('unsupported comic format ${manifest.format}');
    }
    client.dispose();
    report(total, force: true);

    final artworkFile = await HlsDownloader.fetchArtwork(
        _http, serverName, dir, artworkUrl, cancel,
        timeout: _timeout);
    return ReadingDownloadResult(
      bytes: await DownloadHttp.existingBytes(dir),
      itemsDone: done,
      itemsTotal: total,
      artworkFile: artworkFile,
    );
  }

  /// The locally mirrored manifest, or null when the directory has none.
  static Future<ComicManifest?> readLocalManifest(Directory dir) async {
    final f = File('${dir.path}/$manifestFile');
    if (!await f.exists()) return null;
    return ComicManifest.fromJson(
        jsonDecode(await f.readAsString()) as Map<String, dynamic>);
  }
}
