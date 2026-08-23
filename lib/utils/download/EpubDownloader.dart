import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/HlsDownloader.dart' show HlsDownloader;
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';

class ReadingDownloadResult {
  const ReadingDownloadResult({
    required this.bytes,
    required this.itemsDone,
    required this.itemsTotal,
    required this.artworkFile,
  });

  final int bytes;
  final int itemsDone;
  final int itemsTotal;
  final String? artworkFile;
}

/// Mirrors an epub's entries — container, OPF, nav/NCX, every manifest item
/// the reader uses — into a directory laid out like the epub itself, so
/// [EpubResourceClient] can serve them from disk. CSS and fonts are skipped
/// (the reader never loads them); audio and SMIL only come along when the
/// file is a read-aloud edition (media overlays).
class EpubDownloader {
  EpubDownloader({http.Client? httpClient, DownloadHttp? http})
      : _httpClient = httpClient,
        _http = http ?? DownloadHttp(httpClient: httpClient);

  final http.Client? _httpClient;
  final DownloadHttp _http;

  static const Duration _timeout = Duration(seconds: 90);

  static bool _skipped(EpubManifestItem item, {required bool withAudio}) {
    final type = item.mediaType.toLowerCase();
    if (type == 'text/css' ||
        type.startsWith('font/') ||
        type.startsWith('application/font') ||
        type == 'application/vnd.ms-opentype' ||
        type.startsWith('application/x-font')) {
      return true;
    }
    if (!withAudio &&
        (type.startsWith('audio/') || type == 'application/smil+xml')) {
      return true;
    }
    return false;
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

    final client = EpubResourceClient(
      nodeUrl: nodeUrl,
      mediaFileId: mediaFileId,
      serverName: serverName,
      httpClient: _httpClient,
    );
    final package = await EpubPackage.load(client);
    client.dispose();

    final withAudio = package.hasMediaOverlays;
    final entries = <String>{
      'META-INF/container.xml',
      package.opfPath,
      for (final item in package.manifest.values)
        if (!_skipped(item, withAudio: withAudio)) item.href,
    }.where((href) => href.isNotEmpty && !href.startsWith('/')).toList();

    var done = 0;
    var bytes = await DownloadHttp.existingBytes(dir);
    var lastReport = DateTime.now();
    void report({bool force = false}) {
      final now = DateTime.now();
      if (force || now.difference(lastReport).inMilliseconds >= 500) {
        lastReport = now;
        onProgress(DownloadProgress(
            bytes: bytes, segmentsDone: done, segmentsTotal: entries.length));
      }
    }

    final base = nodeUrl.endsWith('/')
        ? nodeUrl.substring(0, nodeUrl.length - 1)
        : nodeUrl;
    for (final href in entries) {
      DownloadHttp.checkCancel(cancel);
      final target = File('${dir.path}/$href');
      if (!await target.exists()) {
        bytes += await _http.getToFile(serverName,
            EpubResourceClient.resourceUrl(base, mediaFileId, href), target, cancel,
            timeout: _timeout);
      }
      done++;
      report();
    }
    report(force: true);

    final artworkFile = await HlsDownloader.fetchArtwork(
        _http, serverName, dir, artworkUrl, cancel,
        timeout: _timeout);
    return ReadingDownloadResult(
      bytes: await DownloadHttp.existingBytes(dir),
      itemsDone: done,
      itemsTotal: entries.length,
      artworkFile: artworkFile,
    );
  }
}
