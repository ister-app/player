import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/PlayHistoryStore.dart';

import 'download_service_test.dart' show trackItem;

void main() {
  late Directory root;
  late DownloadStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('history');
    store = DownloadStore(rootOverride: root);
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  test('newest first, a replay moves to the front, capped, persisted', () async {
    final history = PlayHistoryStore(store, capacity: 3);
    await history.record('srv', trackItem('a'));
    await history.record('srv', trackItem('b'));
    await history.record('srv', trackItem('c'));
    await history.record('srv', trackItem('a'));
    expect((await history.recent('srv')).map((e) => e.trackId), ['a', 'c', 'b']);

    await history.record('srv', trackItem('d'));
    expect((await history.recent('srv')).map((e) => e.trackId), ['d', 'a', 'c']);

    final reloaded = PlayHistoryStore(DownloadStore(rootOverride: root));
    final entries = await reloaded.recent('srv', limit: 2);
    expect(entries.map((e) => e.trackId), ['d', 'a']);
    expect(entries.first.mediaFileId, 'mf-d');
    expect(entries.first.item.track?.album.name, 'The Album');
  });

  test('items without a media file are ignored', () async {
    final history = PlayHistoryStore(store);
    final item = trackItem('x').copyWith(
        track: trackItem('x').track!.copyWith(mediaFile: const []));
    await history.record('srv', item);
    expect(await history.recent('srv'), isEmpty);
  });
}
