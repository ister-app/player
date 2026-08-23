import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadStore.dart';

DownloadEntry _entry(String id, {bool pinned = true}) => DownloadEntry(
      kind: DownloadKind.track,
      mediaId: id,
      mediaFileId: 'mf-$id',
      nodeUrl: 'https://node',
      groupId: 'album',
      groupTitle: 'Album',
      title: 'Track $id',
      queueItemJson: {'id': 'local:track:$id'},
      createdAt: DateTime(2026, 1, 1),
      pinned: pinned,
    );

void main() {
  late Directory root;
  late DownloadStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('dlstore');
    store = DownloadStore(rootOverride: root);
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  test('slug makes a server identifier filesystem-safe', () {
    expect(DownloadStore.slug('localhost:8080/api'), 'localhost_8080_api');
    expect(DownloadStore.slug('media.example.org'), 'media.example.org');
  });

  test('entries round-trip through the manifest and reload by server', () async {
    await store.put('localhost:8080/api', _entry('1'));
    await store.put('localhost:8080/api',
        _entry('2', pinned: false).copyWith(status: DownloadStatus.complete));

    final fresh = DownloadStore(rootOverride: root);
    final servers = await fresh.loadAll();
    expect(servers, ['localhost:8080/api']);
    final entries = fresh.entries('localhost:8080/api');
    expect(entries.map((e) => e.mediaId), ['1', '2']);
    expect(entries[1].pinned, isFalse);
    expect(entries[1].status, DownloadStatus.complete);
    expect(entries[1].queueItemJson['id'], 'local:track:2');
  });

  test('writes are atomic: no temp file is left behind', () async {
    await store.put('srv', _entry('1'));
    final dir = Directory('${root.path}/srv');
    final names = dir.listSync().map((e) => e.uri.pathSegments.last).toList();
    expect(names, contains('manifest.json'));
    expect(names.where((n) => n.endsWith('.tmp')), isEmpty);
    final json = jsonDecode(File('${dir.path}/manifest.json').readAsStringSync());
    expect(json['server'], 'srv');
  });

  test('remove drops the entry and deleteItemDir the files', () async {
    await store.put('srv', _entry('1'));
    final dir = await store.itemDir('srv', 'mf-1');
    File('${dir.path}/master.m3u8').writeAsStringSync('#EXTM3U');
    expect(store.itemDirPathSync('srv', 'mf-1'), dir.path);

    await store.remove('srv', DownloadEntry.keyFor(DownloadKind.track, '1'));
    await store.deleteItemDir('srv', 'mf-1');
    expect(store.entries('srv'), isEmpty);
    expect(dir.existsSync(), isFalse);
  });
}
