import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';

const _container = '''
<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
''';

const _opf = '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="uid">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:title>Fixture Book</dc:title>
    <meta property="rendition:layout">reflowable</meta>
  </metadata>
  <manifest>
    <item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="ch1" href="text/ch1.xhtml" media-type="application/xhtml+xml" media-overlay="ch1-smil"/>
    <item id="ch2" href="text/ch2.xhtml" media-type="application/xhtml+xml"/>
    <item id="ch1-smil" href="smil/ch1.smil" media-type="application/smil+xml"/>
    <item id="cover" href="images/cover.jpg" media-type="image/jpeg" properties="cover-image"/>
  </manifest>
  <spine toc="ncx">
    <itemref idref="ch1"/>
    <itemref idref="ch2"/>
    <itemref idref="cover" linear="no"/>
  </spine>
</package>
''';

const _nav = '''
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<body>
  <nav epub:type="toc">
    <ol>
      <li><a href="text/ch1.xhtml">One</a>
        <ol><li><a href="text/ch1.xhtml#part2">One, part two</a></li></ol>
      </li>
      <li><a href="text/ch2.xhtml">Two</a></li>
    </ol>
  </nav>
</body>
</html>
''';

const _ncx = '''
<?xml version="1.0"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
  <navMap>
    <navPoint id="n1"><navLabel><text>One</text></navLabel><content src="text/ch1.xhtml"/></navPoint>
    <navPoint id="n2"><navLabel><text>Two</text></navLabel><content src="text/ch2.xhtml"/></navPoint>
  </navMap>
</ncx>
''';

EpubResourceClient _clientFor(Map<String, String> entries) {
  return EpubResourceClient(
    nodeUrl: 'https://node.example',
    mediaFileId: 'file-1',
    serverName: 'server',
    tokenProvider: (_) async => 'tok',
    httpClient: MockClient((request) async {
      const prefix = '/epub/file-1/resource/';
      final entry = Uri.decodeComponent(
          request.url.path.substring(prefix.length));
      final body = entries[entry];
      if (body == null) return http.Response('not found', 404);
      expect(request.url.queryParameters['token'], 'tok');
      return http.Response(body, 200);
    }),
  );
}

void main() {
  test('loads container, OPF, spine and EPUB 3 nav TOC', () async {
    final client = _clientFor({
      'META-INF/container.xml': _container,
      'OEBPS/content.opf': _opf,
      'OEBPS/nav.xhtml': _nav,
    });
    final package = await EpubPackage.load(client);

    expect(package.title, 'Fixture Book');
    expect(package.fixedLayout, isFalse);
    expect(package.hasMediaOverlays, isTrue);
    expect(package.spine, hasLength(3));
    expect(package.spine[0].href, 'OEBPS/text/ch1.xhtml');
    expect(package.spine[2].linear, isFalse);

    expect(package.toc, hasLength(3));
    expect(package.toc[0].label, 'One');
    expect(package.toc[0].href, 'OEBPS/text/ch1.xhtml');
    expect(package.toc[1].fragment, 'part2');
    expect(package.toc[1].depth, 1);

    final overlay = package.mediaOverlayForSpineIndex(0);
    expect(overlay, isNotNull);
    expect(overlay!.href, 'OEBPS/smil/ch1.smil');
    expect(package.mediaOverlayForSpineIndex(1), isNull);

    expect(package.spineIndexForIdref('ch2'), 1);
    expect(package.spineIndexForTocEntry(package.toc[2]), 1);
  });

  test('falls back to the NCX when there is no nav document', () async {
    final client = _clientFor({
      'META-INF/container.xml': _container,
      'OEBPS/content.opf': _opf,
      // No nav.xhtml: the nav fetch 404s and the NCX takes over.
      'OEBPS/toc.ncx': _ncx,
    });
    final package = await EpubPackage.load(client);
    expect(package.toc, hasLength(2));
    expect(package.toc[0].label, 'One');
    expect(package.toc[1].href, 'OEBPS/text/ch2.xhtml');
  });

  test('throws a structure exception for a container without rootfile',
      () async {
    final client = _clientFor({
      'META-INF/container.xml': '<container/>',
    });
    expect(() => EpubPackage.load(client),
        throwsA(isA<EpubStructureException>()));
  });
}
