import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadLoaders.dart';
import 'package:player/utils/download/DownloadModels.dart';

import 'episode_parts_test.dart';

void main() {
  test('an episode inside a multi-episode file becomes a download request', () {
    final file = sharedFile('mf', [6, 7]);
    final e7 = partEpisode(7, file, startMs: 1200000, durationMs: 1200000);
    final req = DownloadLoaders.episodeRequest(e7.toJson(), e7.id, 7,
        groupTitle: 'The Show');
    expect(req.item!.episode?.id, 'e7');
    expect(req.groupTitle, 'The Show');
    expect(req.sortKey, 7);
    expect(req.item!.episode?.mediaFile?.first.id, 'mf');
    expect(DownloadEntry.keyFor(DownloadKind.episode, 'e7'), 'episode:e7');
  });
}
