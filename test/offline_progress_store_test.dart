import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';

import 'download_service_test.dart' show trackItem;

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('offprog');
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  test('a record near the given end marks the item finished and keeps durationMs',
      () async {
    final store = OfflineProgressStore(DownloadStore(rootOverride: root));
    // The handler passes a part's end as durationMs for multi-episode files.
    await store.record('srv', trackItem('a'),
        positionMs: 2397000, durationMs: 2400000, finished: true);
    final e = store.get('srv', 'track:a')!;
    expect(e.finished, isTrue);
    expect(e.durationMs, 2400000);
    expect(e.synced, isFalse);

    // A later, earlier position (rewatch) is recorded as not finished.
    await store.record('srv', trackItem('a'),
        positionMs: 1000, durationMs: 2400000);
    expect(store.get('srv', 'track:a')!.finished, isFalse);
    expect(store.get('srv', 'track:a')!.positionMs, 1000);
  });
}
