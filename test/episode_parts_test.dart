import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/l10n/app_localizations_en.dart';
import 'package:player/utils/EpisodeParts.dart';

Fragment$fragmentMediaFiles sharedFile(String id, List<int> numbers) =>
    Fragment$fragmentMediaFiles(
      id: id,
      path: '/tv/$id.mkv',
      size: 1,
      durationInMilliseconds: 2400000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'https://node.example'),
      ),
      episodes: [
        for (final n in numbers)
          Fragment$fragmentMediaFiles$episodes(id: 'e$n', number: n),
      ],
    );

/// Episode [number] as the slice [startMs, startMs+durationMs) of [file].
Fragment$fragmentEpisode partEpisode(int number, Fragment$fragmentMediaFiles file,
        {required int startMs, required int durationMs}) =>
    Fragment$fragmentEpisode(
      id: 'e$number',
      number: number,
      mediaFile: [file],
      mediaFileParts: [
        Fragment$fragmentEpisode$mediaFileParts(
            startInMilliseconds: startMs.toDouble(),
            durationInMilliseconds: durationMs.toDouble(),
            mediaFile: file),
      ],
    );

void main() {
  test('bounds are absolute file time; null for single-episode files', () {
    final file = sharedFile('mf', [6, 7]);
    final e7 = partEpisode(7, file, startMs: 1200000, durationMs: 1200000);
    expect(EpisodeParts.bounds(e7), (startMs: 1200000, endMs: 2400000));
    final single = partEpisode(1, sharedFile('mf1', [1]), startMs: 0, durationMs: 100);
    expect(EpisodeParts.bounds(single), isNull);
    expect(EpisodeParts.bounds(null), isNull);
  });

  test('sharedNumbers sorts and needs at least two', () {
    expect(EpisodeParts.sharedNumbers([7, 6]), [6, 7]);
    expect(EpisodeParts.sharedNumbers([3]), isNull);
    expect(EpisodeParts.sharedNumbers(null), isNull);
  });

  test('label', () {
    expect(EpisodeParts.label(AppLocalizationsEn(), [6, 7]), '⧉ E6+E7');
  });
}
