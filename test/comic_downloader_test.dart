import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/download/ComicDownloader.dart';
import 'package:player/utils/download/DownloadHttp.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('comicdl');
  });

  tearDown(() async {
    await dir.delete(recursive: true);
  });

  MockClient node(Map<String, dynamic> manifest, List<String> log) =>
      MockClient((req) async {
        log.add(req.url.path);
        if (req.url.path.endsWith('/manifest')) {
          return http.Response(jsonEncode(manifest), 200);
        }
        if (req.url.path.contains('/page/')) return http.Response('img', 200);
        if (req.url.path.endsWith('/file')) return http.Response('%PDF', 200);
        return http.Response('', 404);
      });

  Future<void> run(Map<String, dynamic> manifest, List<String> log) =>
      ComicDownloader(
        httpClient: node(manifest, log),
        http: DownloadHttp(
            httpClient: node(manifest, log),
            tokenProvider: (_) async => 'tok',
            backoff: (_) => const Duration(milliseconds: 1)),
      ).download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: 'https://node.example',
        mediaFileId: 'mf-comic',
        onProgress: (_) {},
        cancel: DownloadCancelToken(),
      );

  test('cbz: every page at full resolution plus the manifest', () async {
    final log = <String>[];
    await run({
      'mediaFileId': 'mf-comic',
      'bookId': 'b',
      'format': 'CBZ',
      'pageCount': 3,
      'pages': [
        {'index': 0, 'name': '001.png', 'size': 1},
        {'index': 1, 'name': '002.jpg', 'size': 1},
        {'index': 2, 'name': '003.webp', 'size': 1},
      ],
    }, log);
    expect(File('${dir.path}/page_00000.png').existsSync(), isTrue);
    expect(File('${dir.path}/page_00001.jpg').existsSync(), isTrue);
    expect(File('${dir.path}/page_00002.webp').existsSync(), isTrue);
    expect(log.where((p) => p.contains('/page/')), hasLength(3));
    expect(log.any((p) => p.contains('width')), isFalse);
    final manifest = (await ComicDownloader.readLocalManifest(dir))!;
    expect(manifest.format, 'CBZ');
    expect(manifest.pages.map((p) => p.name), ['001.png', '002.jpg', '003.webp']);
  });

  test('pdf: the whole file', () async {
    await run({'mediaFileId': 'mf-comic', 'bookId': 'b', 'format': 'PDF', 'pageCount': 12}, []);
    expect(File('${dir.path}/${ComicDownloader.pdfFile}').readAsStringSync(), '%PDF');
    expect((await ComicDownloader.readLocalManifest(dir))!.pageCount, 12);
  });
}
