import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/video_controls/SegmentOverlayButtons.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

Fragment$fragmentMediaFiles _file({
  List<Fragment$fragmentMediaFiles$segments>? segments,
  int episodeCount = 1,
}) =>
    Fragment$fragmentMediaFiles(
      id: 'file-1',
      path: '/shows/s01e01.mkv',
      size: 1,
      durationInMilliseconds: 2400000,
      episodes: List.generate(
          episodeCount,
          (i) => Fragment$fragmentMediaFiles$episodes(
              id: 'ep-$i', number: i + 1)),
      directory: Fragment$fragmentMediaFiles$directory(
          node: Fragment$fragmentMediaFiles$directory$node(
              url: 'http://node.test')),
      segments: segments,
    );

Fragment$fragmentMediaFiles$segments _segment(
        Enum$MediaSegmentType type, int startMs, int endMs,
        {String? episodeId}) =>
    Fragment$fragmentMediaFiles$segments(
      id: 'seg-$type-$startMs',
      type: type,
      startInMilliseconds: startMs.toDouble(),
      endInMilliseconds: endMs.toDouble(),
      episodeId: episodeId,
    );

void main() {
  group('segmentBounds', () {
    test('null without episode, file or segments', () {
      expect(
          MediaPlayerHandler.segmentBounds(
              null, Enum$MediaSegmentType.INTRO),
          isNull);
      final noFile = Fragment$fragmentEpisode(id: 'ep-0', number: 1);
      expect(
          MediaPlayerHandler.segmentBounds(
              noFile, Enum$MediaSegmentType.INTRO),
          isNull);
      final noSegments = Fragment$fragmentEpisode(
          id: 'ep-0', number: 1, mediaFile: [_file()]);
      expect(
          MediaPlayerHandler.segmentBounds(
              noSegments, Enum$MediaSegmentType.INTRO),
          isNull);
    });

    test('returns the matching type for a single-episode file', () {
      final episode = Fragment$fragmentEpisode(id: 'ep-0', number: 1, mediaFile: [
        _file(segments: [
          _segment(Enum$MediaSegmentType.INTRO, 30000, 82000),
          _segment(Enum$MediaSegmentType.OUTRO, 2300000, 2390000),
        ])
      ]);
      expect(
          MediaPlayerHandler.segmentBounds(
              episode, Enum$MediaSegmentType.INTRO),
          (startMs: 30000, endMs: 82000));
      expect(
          MediaPlayerHandler.segmentBounds(
              episode, Enum$MediaSegmentType.OUTRO),
          (startMs: 2300000, endMs: 2390000));
    });

    test('a multi-episode file only yields this episode\'s segment', () {
      final file = _file(episodeCount: 2, segments: [
        _segment(Enum$MediaSegmentType.INTRO, 0, 52000, episodeId: 'ep-0'),
        _segment(Enum$MediaSegmentType.INTRO, 1200000, 1252000,
            episodeId: 'ep-1'),
      ]);
      final second = Fragment$fragmentEpisode(
        id: 'ep-1',
        number: 2,
        mediaFileParts: [
          Fragment$fragmentEpisode$mediaFileParts(
              startInMilliseconds: 1200000,
              durationInMilliseconds: 1200000,
              mediaFile: file),
        ],
      );
      expect(
          MediaPlayerHandler.segmentBounds(
              second, Enum$MediaSegmentType.INTRO),
          (startMs: 1200000, endMs: 1252000));
      final stranger = Fragment$fragmentEpisode(
          id: 'ep-x', number: 3, mediaFile: [file]);
      expect(
          MediaPlayerHandler.segmentBounds(
              stranger, Enum$MediaSegmentType.INTRO),
          isNull);
    });

    test('degenerate segments are ignored', () {
      final episode = Fragment$fragmentEpisode(id: 'ep-0', number: 1, mediaFile: [
        _file(segments: [_segment(Enum$MediaSegmentType.INTRO, 5000, 5000)])
      ]);
      expect(
          MediaPlayerHandler.segmentBounds(
              episode, Enum$MediaSegmentType.INTRO),
          isNull);
    });
  });

  group('autoSkipIntroTarget', () {
    const intro = (startMs: 30000, endMs: 90000);

    test('skips to the intro end from inside the intro', () {
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 45000, intro: intro),
          90000);
    });

    test('leaves the first second alone', () {
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 30500, intro: intro),
          isNull);
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 31000, intro: intro),
          90000);
    });

    test('no micro-seek near the end, and nothing outside or without intro', () {
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 88000, intro: intro),
          isNull);
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 10000, intro: intro),
          isNull);
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 95000, intro: intro),
          isNull);
      expect(MediaPlayerHandler.autoSkipIntroTarget(posMs: 45000, intro: null),
          isNull);
    });
  });

  group('SegmentOverlayButtons.visibilityFor', () {
    const intro = (startMs: 30000, endMs: 90000);
    const outro = (startMs: 2300000, endMs: 2390000);

    test('skip intro shows during the intro, minus the last second', () {
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 30000, intro: intro, outro: outro, hasNext: true),
          (skipIntro: true, nextEpisode: false));
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 88999, intro: intro, outro: outro, hasNext: true),
          (skipIntro: true, nextEpisode: false));
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 89000, intro: intro, outro: outro, hasNext: true),
          (skipIntro: false, nextEpisode: false));
    });

    test('next episode shows from the outro start, only with a next item', () {
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 2300000, intro: intro, outro: outro, hasNext: true),
          (skipIntro: false, nextEpisode: true));
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 2300000, intro: intro, outro: outro, hasNext: false),
          (skipIntro: false, nextEpisode: false));
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 1000000, intro: intro, outro: outro, hasNext: true),
          (skipIntro: false, nextEpisode: false));
    });

    test('nothing without segments', () {
      expect(
          SegmentOverlayButtons.visibilityFor(
              posMs: 45000, intro: null, outro: null, hasNext: true),
          (skipIntro: false, nextEpisode: false));
    });
  });
}
