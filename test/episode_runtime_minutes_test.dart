import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/TvShowSeasonList.dart';

void main() {
  group('TvShowSeasonList.runtimeMinutes', () {
    test('the file on disk goes before the metadata runtime', () {
      expect(
          TvShowSeasonList.runtimeMinutes(
              fileMs: [3637135], metadataMinutes: 45),
          61);
    });

    test('an episode in a combined file shows its own part', () {
      expect(
          TvShowSeasonList.runtimeMinutes(
              partMs: [660000.0], fileMs: [1320000]),
          11);
    });

    test('a file that was not analysed yet falls back to the metadata', () {
      expect(
          TvShowSeasonList.runtimeMinutes(
              fileMs: [null, 0], metadataMinutes: 22),
          22);
      expect(TvShowSeasonList.runtimeMinutes(), isNull);
    });

    test('a clip under half a minute still reads as one minute', () {
      expect(TvShowSeasonList.runtimeMinutes(fileMs: [20000]), 1);
    });
  });
}
