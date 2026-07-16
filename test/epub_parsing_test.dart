import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/epub/ChapterContent.dart';
import 'package:player/utils/epub/EpubLocator.dart';
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/SmilDocument.dart';

void main() {
  group('EpubPackage.resolveHref', () {
    test('joins a directory and a relative href', () {
      expect(EpubPackage.resolveHref('OEBPS/', 'text/ch1.xhtml'),
          'OEBPS/text/ch1.xhtml');
    });

    test('collapses ../ segments', () {
      expect(EpubPackage.resolveHref('OEBPS/text/', '../images/cover.jpg'),
          'OEBPS/images/cover.jpg');
    });

    test('ignores ./ segments and empty dirs', () {
      expect(EpubPackage.resolveHref('', './ch1.xhtml'), 'ch1.xhtml');
    });

    test('decodes percent-encoded hrefs to match zip entry names', () {
      expect(EpubPackage.resolveHref('OEBPS/', 'my%20chapter.xhtml'),
          'OEBPS/my chapter.xhtml');
    });
  });

  group('EpubLocator', () {
    test('round-trips through serialize/tryParse', () {
      const locator = EpubLocator(
        spineIdref: 'chapter-1',
        blockIndex: 42,
        fragment: 'sentence;12=x',
        bookFraction: 0.25,
      );
      final parsed = EpubLocator.tryParse(locator.serialize());
      expect(parsed, isNotNull);
      expect(parsed!.spineIdref, 'chapter-1');
      expect(parsed.blockIndex, 42);
      expect(parsed.fragment, 'sentence;12=x');
      expect(parsed.bookFraction, closeTo(0.25, 1e-6));
    });

    test('serializes without a fragment', () {
      const locator = EpubLocator(spineIdref: 's1', blockIndex: 0);
      final parsed = EpubLocator.tryParse(locator.serialize());
      expect(parsed!.fragment, isNull);
      expect(parsed.blockIndex, 0);
    });

    test('rejects legacy epubcfi strings', () {
      expect(EpubLocator.tryParse('epubcfi(/6/14!/4/2/14/1:0)'), isNull);
    });

    test('rejects null, garbage and incomplete locators', () {
      expect(EpubLocator.tryParse(null), isNull);
      expect(EpubLocator.tryParse(''), isNull);
      expect(EpubLocator.tryParse('ister:v1;block=3'), isNull);
      expect(EpubLocator.tryParse('ister:v1;spine=a;block=-1'), isNull);
      expect(EpubLocator.tryParse('ister:v2;spine=a;block=1'), isNull);
    });
  });

  group('SmilDocument', () {
    test('parses clock values in all SMIL forms', () {
      expect(SmilDocument.parseClockValue('1500ms'),
          const Duration(milliseconds: 1500));
      expect(SmilDocument.parseClockValue('12.5s'),
          const Duration(milliseconds: 12500));
      expect(SmilDocument.parseClockValue('01:02.5'),
          const Duration(minutes: 1, seconds: 2, milliseconds: 500));
      expect(SmilDocument.parseClockValue('1:02:03'),
          const Duration(hours: 1, minutes: 2, seconds: 3));
      expect(SmilDocument.parseClockValue(null), Duration.zero);
      expect(SmilDocument.parseClockValue(''), Duration.zero);
    });

    test('parses pars and resolves audio hrefs against the SMIL dir', () {
      const smil = '''
<smil xmlns="http://www.w3.org/ns/SMIL" xmlns:epub="http://www.idpf.org/2007/ops" version="3.0">
  <body>
    <seq id="seq1" epub:textref="ch1.xhtml">
      <par id="p1">
        <text src="ch1.xhtml#s1"/>
        <audio src="../audio/ch1.mp3" clipBegin="0s" clipEnd="2.5s"/>
      </par>
      <par id="p2">
        <text src="ch1.xhtml#s2"/>
        <audio src="../audio/ch1.mp3" clipBegin="2.5s" clipEnd="5s"/>
      </par>
      <par id="broken">
        <text src="ch1.xhtml"/>
        <audio src="../audio/ch1.mp3" clipBegin="5s" clipEnd="6s"/>
      </par>
    </seq>
  </body>
</smil>
''';
      final document = SmilDocument.parse(smil, 'OEBPS/smil/');
      expect(document.pars, hasLength(2));
      expect(document.pars[0].fragment, 's1');
      expect(document.pars[0].audioHref, 'OEBPS/audio/ch1.mp3');
      expect(document.pars[0].clipEnd, const Duration(milliseconds: 2500));
      expect(document.end, const Duration(seconds: 5));
    });
  });

  group('ChapterContent', () {
    test('splits body into blocks and indexes ids', () {
      const html = '''
<html><body>
  <h1 id="title">Chapter one</h1>
  <p id="s1">First <span id="s1a">sentence</span>.</p>
  <p id="s2">Second sentence.</p>
</body></html>
''';
      final content = ChapterContent.parse(html, 'OEBPS/');
      expect(content.blocks, hasLength(3));
      expect(content.blockIndexForId('title'), 0);
      expect(content.blockIndexForId('s1'), 1);
      expect(content.blockIndexForId('s1a'), 1);
      expect(content.blockIndexForId('s2'), 2);
      expect(content.blockIndexForId('missing'), isNull);
      expect(content.charCount, greaterThan(0));
    });

    test('flattens wrapper divs but keeps text divs as blocks', () {
      const html = '''
<html><body>
  <div id="wrapper">
    <p>One</p>
    <div>Running text directly in a div.</div>
  </div>
</body></html>
''';
      final content = ChapterContent.parse(html, '');
      expect(content.blocks, hasLength(2));
      // The wrapper's id maps to the first block inside it.
      expect(content.blockIndexForId('wrapper'), 0);
      expect(content.blocks[1].outerHtml, contains('Running text'));
    });

    test('rewrites image references to epub:/// entry URLs', () {
      const html = '''
<html><body>
  <p><img src="../images/fig%201.png" alt=""/></p>
  <svg xmlns="http://www.w3.org/2000/svg"><image xlink:href="cover.jpg"/></svg>
</body></html>
''';
      final content = ChapterContent.parse(html, 'OEBPS/text/');
      final joined = content.blocks.map((block) => block.outerHtml).join();
      expect(joined, contains('epub:///OEBPS/images/fig 1.png'));
      expect(joined, contains('epub:///OEBPS/text/cover.jpg'));
      expect(
          ChapterContent.entryPathFromUrl('epub:///OEBPS/images/fig 1.png'),
          'OEBPS/images/fig 1.png');
      expect(ChapterContent.entryPathFromUrl('https://x/y.png'), isNull);
    });

    test('drops scripts and styles', () {
      const html = '''
<html><body>
  <script>alert(1)</script>
  <style>p { color: red }</style>
  <p>Kept.</p>
</body></html>
''';
      final content = ChapterContent.parse(html, '');
      expect(content.blocks, hasLength(1));
      expect(content.blocks.first.outerHtml, contains('Kept.'));
    });
  });

  group('EpubTocEntry.fromHref', () {
    test('splits fragment and resolves against the nav dir', () {
      final entry = EpubTocEntry.fromHref(
        label: 'Chapter 2',
        rawHref: '../text/ch2.xhtml#start',
        dir: 'OEBPS/nav/',
        depth: 1,
      );
      expect(entry.href, 'OEBPS/text/ch2.xhtml');
      expect(entry.fragment, 'start');
      expect(entry.depth, 1);
    });
  });
}
