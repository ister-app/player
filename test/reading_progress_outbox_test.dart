import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/comic/ComicLocator.dart';
import 'package:player/utils/comic/ComicSyncService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/ReadingProgressOutbox.dart';

void main() {
  late Directory root;
  late ReadingProgressOutbox outbox;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('outbox');
    final store = DownloadStore(rootOverride: root);
    await store.root();
    outbox = ReadingProgressOutbox(store);
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  MockClient server({required bool up, List<Map<String, dynamic>>? posts}) =>
      MockClient((req) async {
        if (!up) return http.Response('down', 503);
        if (req.method == 'POST') {
          posts?.add(jsonDecode(req.body) as Map<String, dynamic>);
          return http.Response('', 200);
        }
        return http.Response(jsonEncode({'reading': null, 'chapters': []}), 200);
      });

  test('a failed save is kept, reopens the book there, and replays later',
      () async {
    final sync = ComicSyncService(
      serverName: 'srv',
      bookId: 'book-1',
      mediaFileId: 'mf-1',
      httpClient: server(up: false),
      outbox: outbox,
    );
    await sync.init();
    sync.reportPosition(ComicLocator(pageIndex: 4, fraction: 0.5));
    await sync.flush();
    final pending = outbox.lastFor('srv', 'book-1')!;
    expect(pending.location, ComicLocator(pageIndex: 4, fraction: 0.5).serialize());
    expect(pending.progress, 0.5);

    // Survives a reload and feeds the next init while the server is down.
    final reloaded = ReadingProgressOutbox(DownloadStore(rootOverride: root));
    final again = ComicSyncService(
      serverName: 'srv',
      bookId: 'book-1',
      mediaFileId: 'mf-1',
      httpClient: server(up: false),
      outbox: reloaded,
    );
    await again.init();
    expect(again.savedLocator()?.pageIndex, 4);
    expect(again.savedFraction(), 0.5);

    // Server back: the replay posts the payload once and clears the entry.
    final posts = <Map<String, dynamic>>[];
    expect(await reloaded.replay('srv', httpClient: server(up: true, posts: posts)), 1);
    expect(posts.single['bookId'], 'book-1');
    expect(posts.single['readingLocationMediaFileId'], 'mf-1');
    expect(reloaded.lastFor('srv', 'book-1'), isNull);
    expect(await reloaded.replay('srv', httpClient: server(up: true)), 0);
  });

  test('a successful save clears a pending one', () async {
    await outbox.put('srv', 'book-1', {'bookId': 'book-1', 'location': 'x', 'progress': 0.1});
    final sync = ComicSyncService(
      serverName: 'srv',
      bookId: 'book-1',
      mediaFileId: 'mf-1',
      httpClient: server(up: true),
      outbox: outbox,
    );
    sync.reportPosition(ComicLocator(pageIndex: 1, fraction: 0.2));
    await sync.flush();
    expect(outbox.lastFor('srv', 'book-1'), isNull);
  });
}
