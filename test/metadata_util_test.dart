import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentBookProgress.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/BookProgressUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/comic/ComicManifest.dart';
import 'package:player/utils/download/SubtitleStreams.dart';

Fragment$fragmentMetadata _meta(
  String id, {
  String? language,
  String? title,
  String? description,
  String? released,
  String? genre,
  String? tagline,
  String? source,
}) =>
    Fragment$fragmentMetadata.fromJson({
      '__typename': 'Metadata',
      'id': id,
      'language': language,
      'title': title,
      'description': description,
      'released': released,
      'genre': genre,
      'tagline': tagline,
      'sourceUri': null,
      'source': source,
    });

Fragment$fragmentBookProgress _progress({
  String mode = 'READING',
  double progress = 0.5,
  bool finished = false,
}) =>
    Fragment$fragmentBookProgress.fromJson({
      '__typename': 'BookProgress',
      'mode': mode,
      'progress': progress,
      'finished': finished,
      'durationInMilliseconds': null,
      'positionInMilliseconds': null,
    });

Fragment$fragmentMediaFiles$mediaFileStreams _stream(
  String id,
  String codecType,
  String codecName, {
  int? streamIndex,
}) =>
    Fragment$fragmentMediaFiles$mediaFileStreams.fromJson({
      '__typename': 'MediaFileStream',
      'id': id,
      'codecType': codecType,
      'codecName': codecName,
      'streamIndex': streamIndex,
      'cropHeight': null,
      'cropWidth': null,
      'cropX': null,
      'cropY': null,
      'height': 0,
      'width': 0,
      'language': null,
      'path': '',
      'title': null,
    });

void main() {
  tearDown(() => MetadataUtil.debugLanguageCode = null);

  group('MetadataUtil', () {
    final rows = [
      _meta('1', language: 'eng', title: 'The Title', description: 'English'),
      _meta('2', language: 'nld', title: 'De titel', description: 'Nederlands'),
      _meta('3', language: 'deu', title: 'Der Titel', description: 'Deutsch'),
    ];

    test('a Dutch UI prefers the Dutch row', () {
      MetadataUtil.debugLanguageCode = 'nl';
      expect(MetadataUtil.getTitle(rows), 'De titel');
      expect(MetadataUtil.getDescription(rows), 'Nederlands');
    });

    test('any other UI language prefers the English row', () {
      MetadataUtil.debugLanguageCode = 'en';
      expect(MetadataUtil.getTitle(rows), 'The Title');
      MetadataUtil.debugLanguageCode = 'fr';
      expect(MetadataUtil.getDescription(rows), 'English');
    });

    test('falls through to the next language when a field is empty', () {
      MetadataUtil.debugLanguageCode = 'nl';
      final sparse = [
        _meta('1', language: 'eng', title: 'The Title', tagline: 'A tagline'),
        _meta('2', language: 'nld', title: '', tagline: null),
        _meta('3', title: 'No language', genre: 'Drama'),
      ];
      expect(MetadataUtil.getTitle(sparse), 'The Title');
      expect(MetadataUtil.getTagline(sparse), 'A tagline');
      expect(MetadataUtil.getGenre(sparse), 'Drama');
      expect(MetadataUtil.getDescription(sparse), isNull);
    });

    test('rows in a language the app does not show are ignored', () {
      final german = [_meta('3', language: 'deu', title: 'Der Titel')];
      expect(MetadataUtil.getTitle(german), isNull);
      expect(MetadataUtil.getMetadata(german), isEmpty);
    });

    test('null and empty lists give null', () {
      expect(MetadataUtil.getTitle(null), isNull);
      expect(MetadataUtil.getMetadata(null), isNull);
      expect(MetadataUtil.getTitle(const []), isNull);
      expect(MetadataUtil.getMetaLine(const []), isNull);
    });

    test('meta line joins what is there', () {
      expect(
          MetadataUtil.getMetaLine(
              [_meta('1', language: 'eng', released: '1982', genre: 'Sci-fi')]),
          '1982 • Sci-fi');
      expect(MetadataUtil.getMetaLine([_meta('1', language: 'eng', genre: 'Sci-fi')]),
          'Sci-fi');
    });

    test('titleWithYear drops an unknown year', () {
      expect(MetadataUtil.titleWithYear('Blade Runner', 1982),
          'Blade Runner (1982)');
      expect(MetadataUtil.titleWithYear('Blade Runner', 0), 'Blade Runner');
      expect(MetadataUtil.titleWithYear('Blade Runner', null), 'Blade Runner');
    });

    test('sources are distinct and skip rows without one', () {
      final sources = MetadataUtil.getSources([
        _meta('1', language: 'eng', source: 'TMDB'),
        _meta('2', language: 'nld', source: 'TMDB'),
        _meta('3', language: 'eng'),
        _meta('4', language: 'deu', source: 'WIKIPEDIA'),
      ]);
      expect(sources, [Enum$MetadataSource.TMDB]);
    });
  });

  group('BookProgressUtil', () {
    test('no bar without progress or for a finished book', () {
      expect(BookProgressUtil.barValue(null), isNull);
      expect(BookProgressUtil.barValue(_progress(finished: true)), isNull);
      expect(BookProgressUtil.percentage(_progress(finished: true)), isNull);
    });

    test('clamps out-of-range fractions', () {
      expect(BookProgressUtil.barValue(_progress(progress: 1.4)), 1.0);
      expect(BookProgressUtil.barValue(_progress(progress: -0.2)), 0.0);
      expect(BookProgressUtil.percentage(_progress(progress: 0.426)), 43);
    });

    test('mode tells listening from reading', () {
      expect(BookProgressUtil.isListening(_progress(mode: 'LISTENING')), isTrue);
      expect(BookProgressUtil.isListening(_progress()), isFalse);
      expect(BookProgressUtil.isListening(null), isFalse);
    });
  });

  group('SubtitleStreams', () {
    test('the external row wins over the embedded one, whatever the order', () {
      final embedded = _stream('a', 'SUBTITLE', 'subrip', streamIndex: 2);
      final external = _stream('b', 'EXTERNAL_SUBTITLE', 'subrip', streamIndex: 2);
      expect(SubtitleStreams.sideloadable([embedded, external]).single.id, 'b');
      expect(SubtitleStreams.sideloadable([external, embedded]).single.id, 'b');
    });

    test('bitmap codecs, other stream types and index-less rows are skipped', () {
      final result = SubtitleStreams.sideloadable([
        null,
        _stream('pgs', 'SUBTITLE', 'hdmv_pgs_subtitle', streamIndex: 3),
        _stream('ass', 'SUBTITLE', 'ASS', streamIndex: 4),
        _stream('audio', 'AUDIO', 'aac', streamIndex: 1),
        _stream('noindex', 'SUBTITLE', 'subrip'),
      ]);
      expect(result.map((s) => s.id), ['ass']);
      expect(SubtitleStreams.sideloadable(null), isEmpty);
    });

    test('embedded cover art is not video', () {
      expect(
          SubtitleStreams.hasVideo([
            _stream('cover', 'VIDEO', 'MJPEG', streamIndex: 1),
            _stream('audio', 'AUDIO', 'flac', streamIndex: 0),
          ]),
          isFalse);
      expect(
          SubtitleStreams.hasVideo([_stream('v', 'VIDEO', 'h264', streamIndex: 0)]),
          isTrue);
      expect(SubtitleStreams.hasVideo(null), isFalse);
    });
  });

  group('ComicManifest', () {
    test('round-trips through json', () {
      final manifest = ComicManifest(
        mediaFileId: 'mf',
        bookId: 'book',
        format: 'CBZ',
        pageCount: 2,
        pages: [
          ComicPageInfo(index: 0, name: '001.jpg', size: 10),
          ComicPageInfo(index: 1, name: '002.jpg', size: 20),
        ],
      );
      final copy = ComicManifest.fromJson(manifest.toJson());
      expect(copy.mediaFileId, 'mf');
      expect(copy.format, 'CBZ');
      expect(copy.pageCount, 2);
      expect(copy.pages.map((p) => p.name), ['001.jpg', '002.jpg']);
      expect(copy.pages.last.size, 20);
    });

    test('tolerates a manifest without pages or page count', () {
      final manifest = ComicManifest.fromJson(
          {'mediaFileId': 'mf', 'bookId': 'book', 'format': 'PDF'});
      expect(manifest.pageCount, isNull);
      expect(manifest.pages, isEmpty);
    });
  });
}
