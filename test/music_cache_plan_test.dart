import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/MusicCacheService.dart';
import 'package:player/utils/download/PlayHistoryStore.dart';

const mb = 1000 * 1000;

PlayHistoryEntry _h(String id, int minutesAgo) => PlayHistoryEntry(
      trackId: id,
      mediaFileId: 'mf-$id',
      playedAt: DateTime(2026, 1, 1, 12).subtract(Duration(minutes: minutesAgo)),
      itemJson: const {},
    );

DownloadEntry _e(String id,
        {bool pinned = false,
        int bytes = 10 * mb,
        DownloadStatus status = DownloadStatus.complete,
        int? playedMinutesAgo}) =>
    DownloadEntry(
      kind: DownloadKind.track,
      mediaId: id,
      mediaFileId: 'mf-$id',
      nodeUrl: 'n',
      groupId: 'a',
      groupTitle: 'A',
      title: id,
      queueItemJson: const {},
      createdAt: DateTime(2025),
      pinned: pinned,
      bytes: bytes,
      status: status,
      lastPlayedAt: playedMinutesAgo == null
          ? null
          : DateTime(2026, 1, 1, 12).subtract(Duration(minutes: playedMinutesAgo)),
    );

void main() {
  List<String> dl(MusicCachePlan p) => p.toDownload.map((h) => h.trackId).toList();
  List<String> ev(MusicCachePlan p) => p.toEvict.map((e) => e.mediaId).toList();

  test('fills the most recent tracks first, up to the track limit', () {
    final plan = planMusicCache(
      history: [_h('a', 1), _h('b', 2), _h('c', 3), _h('d', 4)],
      entries: [],
      maxTracks: 3,
      maxBytes: 1000 * mb,
    );
    expect(dl(plan), ['a', 'b', 'c']);
    expect(ev(plan), isEmpty);
  });

  test('the byte limit wins when it is the lower one', () {
    final plan = planMusicCache(
      history: [_h('a', 1), _h('b', 2), _h('c', 3)],
      entries: [],
      maxTracks: 100,
      maxBytes: 25 * mb,
      avgTrackBytesEstimate: 10 * mb,
    );
    expect(dl(plan), ['a', 'b']);
  });

  test('evicts cached tracks that fell out of the recent set, oldest first', () {
    final plan = planMusicCache(
      history: [_h('a', 1), _h('b', 2)],
      entries: [_e('x', playedMinutesAgo: 60), _e('y', playedMinutesAgo: 30), _e('a')],
      maxTracks: 2,
      maxBytes: 1000 * mb,
    );
    expect(ev(plan), ['x', 'y']);
    expect(dl(plan), ['b']);
  });

  test('pinned, playing and downloading entries are never evicted', () {
    final plan = planMusicCache(
      history: [_h('a', 1)],
      entries: [
        _e('p', pinned: true),
        _e('playing'),
        _e('busy', status: DownloadStatus.downloading),
        _e('old'),
      ],
      maxTracks: 1,
      maxBytes: 1000 * mb,
      protectedMediaFileIds: {'mf-playing'},
    );
    expect(ev(plan), ['old']);
  });

  test('evicts the least recently played inside the set to get under the byte limit', () {
    final plan = planMusicCache(
      history: [_h('a', 1), _h('b', 2), _h('c', 3)],
      entries: [
        _e('pinned', pinned: true, bytes: 50 * mb),
        _e('a', playedMinutesAgo: 1),
        _e('b', playedMinutesAgo: 2),
        _e('c', playedMinutesAgo: 3),
      ],
      maxTracks: 10,
      maxBytes: 65 * mb,
    );
    // 80 MB on disk, pinned 50 MB untouchable: c then b go.
    expect(ev(plan), ['c', 'b']);
    expect(dl(plan), isEmpty);
  });

  test('already present tracks are not downloaded again', () {
    final plan = planMusicCache(
      history: [_h('a', 1), _h('b', 2)],
      entries: [_e('a', pinned: true)],
      maxTracks: 5,
      maxBytes: 1000 * mb,
    );
    expect(dl(plan), ['b']);
  });
}
