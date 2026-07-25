import 'package:flutter_test/flutter_test.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/graphql/bookById.graphql.dart';
import 'package:player/graphql/fragmentChapter.graphql.dart';

Fragment$fragmentChapter _chapter(String id, int number, {bool audio = true}) =>
    Fragment$fragmentChapter(
      id: id,
      number: number,
      mediaFile: audio
          ? [Fragment$fragmentChapter$mediaFile(durationInMilliseconds: 1000)]
          : [],
    );

Query$bookById$bookById _book({
  String? resumeChapterId,
  List<Fragment$fragmentChapter>? chapters,
}) =>
    Query$bookById$bookById(
      id: 'book-1',
      name: 'the-raw-directory-name',
      title: 'The Clean Title',
      releaseYear: 2020,
      chapters: chapters,
      resumeChapter: resumeChapterId == null
          ? null
          : Query$bookById$bookById$resumeChapter(id: resumeChapterId),
    );

/// Selecting an audiobook in Android Auto plays it directly; the start chapter
/// comes from this fallback chain, so a started book resumes where the
/// listener left off and a fresh (or finished) one starts at the front.
void main() {
  group('IsterMediaService.startChapterIdFor', () {
    test('prefers the server\'s resume chapter', () {
      final book = _book(
        resumeChapterId: 'ch-7',
        chapters: [_chapter('ch-1', 1), _chapter('ch-7', 7)],
      );
      expect(IsterMediaService.startChapterIdFor(book), 'ch-7');
    });

    test('falls back to the first chapter that has audio', () {
      // A chapters-only epub entry (no media file) cannot be the start.
      final book = _book(chapters: [
        _chapter('ch-1', 1, audio: false),
        _chapter('ch-2', 2),
        _chapter('ch-3', 3),
      ]);
      expect(IsterMediaService.startChapterIdFor(book), 'ch-2');
    });

    test('returns null when no chapter is playable', () {
      expect(
          IsterMediaService.startChapterIdFor(
              _book(chapters: [_chapter('ch-1', 1, audio: false)])),
          isNull);
      expect(IsterMediaService.startChapterIdFor(_book(chapters: null)), isNull);
      expect(IsterMediaService.startChapterIdFor(null), isNull);
    });
  });
}
