import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/EpubDownloader.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';

const _container = '''<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles>
</container>''';

String _opf({required bool overlays}) => '''<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="id">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:title>Book</dc:title></metadata>
  <manifest>
    <item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    <item id="c1" href="text/ch1.xhtml" media-type="application/xhtml+xml"${overlays ? ' media-overlay="s1"' : ''}/>
    <item id="img" href="images/cover.jpg" media-type="image/jpeg"/>
    <item id="css" href="style.css" media-type="text/css"/>
    <item id="font" href="fonts/a.otf" media-type="application/vnd.ms-opentype"/>
    ${overlays ? '<item id="s1" href="smil/ch1.smil" media-type="application/smil+xml"/>' : ''}
    <item id="a1" href="audio/ch1.mp3" media-type="audio/mpeg"/>
  </manifest>
  <spine><itemref idref="c1"/></spine>
</package>''';

const _nav = '''<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops"><body>
<nav epub:type="toc"><ol><li><a href="text/ch1.xhtml">One</a></li></ol></nav></body></html>''';

MockClient _node({required bool overlays, required List<String> log}) =>
    MockClient((req) async {
      final path = Uri.decodeComponent(req.url.path);
      log.add(path);
      if (path.endsWith('META-INF/container.xml')) return http.Response(_container, 200);
      if (path.endsWith('OEBPS/content.opf')) return http.Response(_opf(overlays: overlays), 200);
      if (path.endsWith('OEBPS/nav.xhtml')) return http.Response(_nav, 200);
      if (path.contains('/epub/')) return http.Response('data for $path', 200);
      return http.Response('', 404);
    });

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('epubdl');
  });

  tearDown(() async {
    await dir.delete(recursive: true);
  });

  Future<ReadingDownloadResult> run(bool overlays, List<String> log) =>
      EpubDownloader(
        httpClient: _node(overlays: overlays, log: log),
        http: DownloadHttp(
            httpClient: _node(overlays: overlays, log: log),
            tokenProvider: (_) async => 'tok',
            backoff: (_) => const Duration(milliseconds: 1)),
      ).download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: 'https://node.example',
        mediaFileId: 'mf-epub',
        onProgress: (_) {},
        cancel: DownloadCancelToken(),
      );

  test('mirrors container, opf, nav, chapters and images; skips css and fonts',
      () async {
    final log = <String>[];
    final result = await run(false, log);
    for (final f in [
      'META-INF/container.xml',
      'OEBPS/content.opf',
      'OEBPS/nav.xhtml',
      'OEBPS/text/ch1.xhtml',
      'OEBPS/images/cover.jpg',
    ]) {
      expect(File('${dir.path}/$f').existsSync(), isTrue, reason: f);
    }
    expect(File('${dir.path}/OEBPS/style.css').existsSync(), isFalse);
    expect(File('${dir.path}/OEBPS/fonts/a.otf').existsSync(), isFalse);
    // No media overlays: embedded audio stays on the server.
    expect(File('${dir.path}/OEBPS/audio/ch1.mp3').existsSync(), isFalse);
    expect(result.itemsTotal, 5);
    expect(result.itemsDone, 5);
    expect(result.bytes, greaterThan(0));
  });

  test('a read-aloud edition brings its audio and SMIL along', () async {
    final log = <String>[];
    await run(true, log);
    expect(File('${dir.path}/OEBPS/audio/ch1.mp3').existsSync(), isTrue);
    expect(File('${dir.path}/OEBPS/smil/ch1.smil').existsSync(), isTrue);
  });

  test('the mirrored package is served from disk by EpubResourceClient', () async {
    await run(false, []);
    var network = 0;
    final client = EpubResourceClient(
      nodeUrl: 'https://node.example',
      mediaFileId: 'mf-epub',
      serverName: 'srv',
      localDir: dir,
      httpClient: MockClient((_) async {
        network++;
        return http.Response('net', 200);
      }),
    );
    expect(await client.text('OEBPS/text/ch1.xhtml'),
        'data for /epub/mf-epub/resource/OEBPS/text/ch1.xhtml');
    expect(client.isLocal('OEBPS/images/cover.jpg'), isTrue);
    expect(client.url('OEBPS/images/cover.jpg'), '${dir.path}/OEBPS/images/cover.jpg');
    expect(network, 0);
    // A missing entry still goes to the node.
    expect(client.isLocal('OEBPS/style.css'), isFalse);
    expect(await client.text('OEBPS/style.css'), 'net');
    expect(network, 1);
    client.dispose();
  });
}
