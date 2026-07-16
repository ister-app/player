import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';
import 'package:player/utils/epub/ReaderBookController.dart';
import 'package:player/utils/epub/ReadingSyncService.dart';

/// Two chapters of five identifiable paragraphs each; ch1 has a media overlay
/// whose SMIL timeline runs to exactly 10s.
const _chapterHtml = '''
<html><body>
  <p id="s1">One.</p>
  <p id="s2">Two.</p>
  <p id="s3">Three.</p>
  <p id="s4">Four.</p>
  <p id="s5">Five.</p>
</body></html>
''';

const _smil = '''
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0"><body><seq>
  <par><text src="ch1.xhtml#s1"/><audio src="audio/ch1.mp3" clipBegin="0s" clipEnd="2s"/></par>
  <par><text src="ch1.xhtml#s2"/><audio src="audio/ch1.mp3" clipBegin="2s" clipEnd="4s"/></par>
  <par><text src="ch1.xhtml#s3"/><audio src="audio/ch1.mp3" clipBegin="4s" clipEnd="6s"/></par>
  <par><text src="ch1.xhtml#s4"/><audio src="audio/ch1.mp3" clipBegin="6s" clipEnd="8s"/></par>
  <par><text src="ch1.xhtml#s5"/><audio src="audio/ch1.mp3" clipBegin="8s" clipEnd="10s"/></par>
</seq></body></smil>
''';

EpubPackage _package({bool withOverlay = true}) {
  final manifest = {
    'ch1': EpubManifestItem(
      id: 'ch1',
      href: 'ch1.xhtml',
      mediaType: 'application/xhtml+xml',
      mediaOverlayId: withOverlay ? 'ch1-smil' : null,
    ),
    'ch2': EpubManifestItem(
      id: 'ch2',
      href: 'ch2.xhtml',
      mediaType: 'application/xhtml+xml',
    ),
    if (withOverlay)
      'ch1-smil': EpubManifestItem(
        id: 'ch1-smil',
        href: 'ch1.smil',
        mediaType: 'application/smil+xml',
      ),
  };
  return EpubPackage(
    title: 'Test',
    fixedLayout: false,
    opfDir: '',
    manifest: manifest,
    spine: [
      EpubSpineItem(idref: 'ch1', href: 'ch1.xhtml'),
      EpubSpineItem(idref: 'ch2', href: 'ch2.xhtml'),
    ],
    toc: const [],
  );
}

ReaderBookController _book({bool withOverlay = true}) {
  final client = EpubResourceClient(
    nodeUrl: 'https://node.example',
    mediaFileId: 'epub-file',
    serverName: 'server',
    tokenProvider: (_) async => null,
    httpClient: MockClient((request) async {
      final entry =
          Uri.decodeComponent(request.url.path.split('/resource/').last);
      return switch (entry) {
        'ch1.xhtml' || 'ch2.xhtml' => http.Response(_chapterHtml, 200),
        'ch1.smil' => http.Response(_smil, 200),
        _ => http.Response('not found', 404),
      };
    }),
  );
  return ReaderBookController(
      client: client, package: _package(withOverlay: withOverlay));
}

BookProgressChapter _chapter(String id,
        {int durationMs = 10000,
        int progressMs = 0,
        bool watched = false,
        DateTime? updatedAt}) =>
    BookProgressChapter(
      id: id,
      durationInMilliseconds: durationMs,
      progressInMilliseconds: progressMs,
      watched: watched,
      updatedAt: updatedAt,
    );

ReadingSyncService _sync(ReaderBookController book,
    {List<BookProgressChapter> chapters = const [],
    BookProgressReading? reading}) {
  final sync = ReadingSyncService(
    serverName: 'server',
    bookId: 'book',
    mediaFileId: 'epub-file',
    book: book,
  );
  sync.initWithProgress(
      BookProgress(reading: reading, chapters: chapters));
  return sync;
}

void main() {
  test('maps audio to text sentence-exactly through a matching SMIL',
      () async {
    final book = _book();
    final sync = _sync(book, chapters: [_chapter('c1'), _chapter('c2')]);

    // 5s into chapter 0 falls in the s3 par (4s–6s) -> block index 2.
    final position = await sync.audioToText(0, 5000);
    expect(position, isNotNull);
    expect(position!.spineIndex, 0);
    expect(position.blockIndex, 2);
  });

  test('maps text to audio through the SMIL clip begins', () async {
    final book = _book();
    final sync = _sync(book, chapters: [_chapter('c1'), _chapter('c2')]);

    final audio = await sync.textToAudio(0, 3);
    expect(audio, isNotNull);
    expect(audio!.chapterId, 'c1');
    expect(audio.positionInMilliseconds, 6000);
  });

  test('interpolates within the chapter when there is no overlay', () async {
    final book = _book(withOverlay: false);
    final sync = _sync(book, chapters: [_chapter('c1'), _chapter('c2')]);

    // Last block of a 5-block chapter -> end of the chapter's audio.
    final audio = await sync.textToAudio(0, 4);
    expect(audio!.chapterId, 'c1');
    expect(audio.positionInMilliseconds, 10000);

    // Halfway through chapter 1's audio -> middle block.
    final position = await sync.audioToText(1, 5000);
    expect(position!.spineIndex, 1);
    expect(position.blockIndex, 2);
  });

  test('rejects a SMIL timeline that does not match the chapter duration',
      () async {
    final book = _book();
    // Audiobook chapter is 60s but the SMIL ends at 10s: interpolate instead.
    final sync =
        _sync(book, chapters: [_chapter('c1', durationMs: 60000), _chapter('c2')]);

    final audio = await sync.textToAudio(0, 2);
    // Interpolation: block 2 of 5 -> 2/4 of 60s = 30s (not the 4s clipBegin).
    expect(audio!.positionInMilliseconds, 30000);
  });

  test('falls back to proportional mapping when nothing aligns', () async {
    final book = _book();
    // Three chapters against a two-item spine: unaligned.
    final sync = _sync(book, chapters: [
      _chapter('c1', durationMs: 10000),
      _chapter('c2', durationMs: 10000),
      _chapter('c3', durationMs: 20000),
    ]);

    // 5s into chapter 1 = 15s of 40s total = 0.375 of the book.
    final position = await sync.audioToText(1, 5000);
    expect(position, isNotNull);

    final audio = await sync.textToAudio(0, 2);
    expect(audio, isNotNull);
  });

  test('listening position picks the chapter touched last, or the next one '
      'when it was finished', () {
    final book = _book();
    final sync = _sync(book, chapters: [
      _chapter('c1',
          progressMs: 10000,
          watched: true,
          updatedAt: DateTime.utc(2026, 7, 1)),
      _chapter('c2', progressMs: 3000, updatedAt: DateTime.utc(2026, 6, 1)),
    ]);

    final listening = sync.listeningPosition();
    expect(listening, isNotNull);
    // c1 is newest but watched -> resume at c2's own progress.
    expect(listening!.chapterIndex, 1);
    expect(listening.positionInMilliseconds, 3000);
    expect(listening.updatedAt, DateTime.utc(2026, 7, 1));
  });

  test(
      'aligns through top-level TOC entries when the spine has front matter '
      'and the TOC has nested entries', () async {
    // Spine: cover + two chapters; audiobook has two chapters. The flattened
    // TOC has three entries (one nested), the top-level TOC has two — only
    // the top-level list lines up with the audiobook.
    final package = EpubPackage(
      title: 'Test',
      fixedLayout: false,
      opfDir: '',
      manifest: {
        'cover': EpubManifestItem(
            id: 'cover', href: 'cover.xhtml', mediaType: 'application/xhtml+xml'),
        'ch1': EpubManifestItem(
            id: 'ch1', href: 'ch1.xhtml', mediaType: 'application/xhtml+xml'),
        'ch2': EpubManifestItem(
            id: 'ch2', href: 'ch2.xhtml', mediaType: 'application/xhtml+xml'),
      },
      spine: [
        EpubSpineItem(idref: 'cover', href: 'cover.xhtml'),
        EpubSpineItem(idref: 'ch1', href: 'ch1.xhtml'),
        EpubSpineItem(idref: 'ch2', href: 'ch2.xhtml'),
      ],
      toc: [
        EpubTocEntry(label: 'One', href: 'ch1.xhtml', depth: 0),
        EpubTocEntry(label: 'One, part two', href: 'ch1.xhtml', fragment: 's3', depth: 1),
        EpubTocEntry(label: 'Two', href: 'ch2.xhtml', depth: 0),
      ],
    );
    final client = EpubResourceClient(
      nodeUrl: 'https://node.example',
      mediaFileId: 'epub-file',
      serverName: 'server',
      tokenProvider: (_) async => null,
      httpClient: MockClient((request) async => http.Response(_chapterHtml, 200)),
    );
    final book = ReaderBookController(client: client, package: package);
    final sync = _sync(book, chapters: [
      _chapter('c1', durationMs: 10000),
      _chapter('c2', durationMs: 10000),
    ]);

    // Chapter 0 must map onto ch1.xhtml (spine index 1), not the cover.
    final position = await sync.audioToText(0, 0);
    expect(position!.spineIndex, 1);

    final audio = await sync.textToAudio(2, 0);
    expect(audio!.chapterId, 'c2');
  });

  test('savedLocator ignores legacy epubcfi and other editions', () {
    final book = _book();

    final legacy = _sync(book,
        reading: BookProgressReading(
            location: 'epubcfi(/6/14!/4/2/14/1:0)',
            mediaFileId: 'epub-file',
            progress: 0.4));
    expect(legacy.savedLocator(), isNull);

    final otherEdition = _sync(book,
        reading: BookProgressReading(
            location: 'ister:v1;spine=ch1;block=2;pct=0.2',
            mediaFileId: 'other-file',
            progress: 0.2));
    expect(otherEdition.savedLocator(), isNull);

    final valid = _sync(book,
        reading: BookProgressReading(
            location: 'ister:v1;spine=ch1;block=2;pct=0.2',
            mediaFileId: 'epub-file',
            progress: 0.2));
    expect(valid.savedLocator(), isNotNull);
    expect(valid.savedLocator()!.spineIdref, 'ch1');
    expect(valid.savedLocator()!.blockIndex, 2);
  });
}
