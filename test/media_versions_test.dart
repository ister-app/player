import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/MediaVersions.dart';

Fragment$fragmentMediaFiles _file(
  String id, {
  int width = 1920,
  int height = 1080,
  String codec = 'h264',
  double size = 8e9,
  int? durationMs = 7200000,
  String ext = 'mkv',
}) =>
    Fragment$fragmentMediaFiles(
      id: id,
      path: '/movies/Heat (1995)/Heat (1995)-$id.$ext',
      size: size,
      durationInMilliseconds: durationMs,
      directory: Fragment$fragmentMediaFiles$directory(
          servingNode: Fragment$fragmentMediaFiles$directory$servingNode(
              url: 'http://node.test')),
      mediaFileStreams: [
        Fragment$fragmentMediaFiles$mediaFileStreams(
            id: 'v-$id',
            codecName: codec,
            codecType: 'VIDEO',
            width: width,
            height: height,
            path: '',
            streamIndex: 0),
        Fragment$fragmentMediaFiles$mediaFileStreams(
            id: 'a-$id',
            codecName: 'aac',
            codecType: 'AUDIO',
            width: 0,
            height: 0,
            path: '',
            streamIndex: 1),
      ],
    );

void main() {
  final hd = _file('b-hd');
  final uhd = _file('a-uhd', width: 3840, height: 2160, codec: 'hevc', size: 58e9);

  group('pickDefault', () {
    test('a single file is the answer, none is null', () {
      expect(MediaVersions.pickDefault([hd]), hd);
      expect(MediaVersions.resolve(const []), isNull);
      expect(MediaVersions.resolve(null), isNull);
    });

    test('the highest bitrate wins, whatever the list order', () {
      expect(MediaVersions.pickDefault([hd, uhd]), uhd);
      expect(MediaVersions.pickDefault([uhd, hd]), uhd);
    });

    test('a DVD rip beats a starved 1080p web encode: bitrate, not pixels', () {
      final web = _file('web', size: 2.5e9, durationMs: 3637000, ext: 'mp4');
      final dvd = _file('dvd',
          width: 720,
          height: 480,
          codec: 'mpeg2video',
          size: 3.4e9,
          durationMs: 3637000);
      expect(MediaVersions.pickDefault([web, dvd]), dvd);
    });

    test('bitrate is size over running time, not size', () {
      final longCut = _file('long', size: 9e9, durationMs: 14400000);
      expect(MediaVersions.pickDefault([longCut, hd]), hd);
      // Not analysed yet: no bitrate, so it loses from a file that has one.
      final unknown = _file('new', size: 90e9, durationMs: null);
      expect(MediaVersions.pickDefault([unknown, hd]), hd);
    });

    test('a downloaded file wins over a better one on the server', () {
      expect(MediaVersions.pickDefault([hd, uhd], isLocal: (f) => f.id == hd.id),
          hd);
    });

    test('the max video height caps the choice, unless nothing fits', () {
      expect(MediaVersions.pickDefault([hd, uhd], maxHeight: 1080), hd);
      expect(MediaVersions.pickDefault([hd, uhd], maxHeight: 480), uhd);
    });

    test('with direct play a decodable codec goes first; without it the '
        'codec is no argument', () {
      bool noHevc(String codec) => codec != 'hevc';
      expect(MediaVersions.pickDefault([hd, uhd], canDecode: noHevc), hd);
      expect(
          MediaVersions.pickDefault([hd, uhd],
              canDecode: noHevc, directPlay: false),
          uhd);
      // Nothing decodable: the rule steps aside instead of returning nothing.
      expect(MediaVersions.pickDefault([uhd], canDecode: noHevc), uhd);
    });

    test('ties go to the bigger file, then to the lowest id', () {
      final small = _file('z', size: 4e9);
      final big = _file('y', size: 12e9);
      expect(MediaVersions.pickDefault([small, big]), big);
      final twinA = _file('a');
      final twinB = _file('b');
      expect(MediaVersions.pickDefault([twinB, twinA]), twinA);
    });
  });

  group('resolve', () {
    test('a preferred file of this item wins over the default', () {
      expect(MediaVersions.resolve([hd, uhd], preferredId: hd.id), hd);
    });

    test('a preferred id the item does not have falls back to the default',
        () {
      expect(MediaVersions.resolve([hd, uhd], preferredId: 'gone'), uhd);
    });
  });

  group('sameTimeline', () {
    test('a re-encode of the same cut shares the timeline', () {
      expect(
          MediaVersions.sameTimeline(hd, _file('x', durationMs: 7200000 + 900)),
          isTrue);
    });

    test('an extended cut does not', () {
      expect(MediaVersions.sameTimeline(hd, _file('x', durationMs: 9000000)),
          isFalse);
    });

    test('an unanalysed file gets the benefit of the doubt', () {
      expect(MediaVersions.sameTimeline(hd, _file('x', durationMs: null)),
          isTrue);
    });
  });

  group('labelsFor', () {
    test('resolution, codec and size', () {
      expect(MediaVersions.labelsFor([uhd, hd]),
          ['4K · HEVC · 58 GB · 64 Mbps', '1080p · H.264 · 8.0 GB · 8.9 Mbps']);
    });

    test('a scope film in a 4K frame still reads as 4K', () {
      expect(
          MediaVersions.resolutionLabel(_file('s', width: 3840, height: 1606)),
          '4K');
    });

    test('another cut shows its running time', () {
      final extended = _file('x', durationMs: 9000000);
      expect(MediaVersions.labelsFor([hd, extended]),
          ['1080p · H.264 · 8.0 GB · 8.9 Mbps · 2:00', '1080p · H.264 · 8.0 GB · 7.1 Mbps · 2:30']);
    });

    test('equal labels get the container, and a number as the last resort',
        () {
      expect(MediaVersions.labelsFor([_file('a'), _file('b', ext: 'mp4')]),
          ['1080p · H.264 · 8.0 GB · 8.9 Mbps · MKV', '1080p · H.264 · 8.0 GB · 8.9 Mbps · MP4']);
      expect(MediaVersions.labelsFor([_file('a'), _file('b')]), [
        '1080p · H.264 · 8.0 GB · 8.9 Mbps · MKV (1)',
        '1080p · H.264 · 8.0 GB · 8.9 Mbps · MKV (2)'
      ]);
    });
  });
}
