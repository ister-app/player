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

  test('a position the server will never take does not block the ones behind it',
      () async {
    for (final book in ['book-gone', 'book-kept']) {
      final sync = ComicSyncService(
        serverName: 'srv',
        bookId: book,
        mediaFileId: 'mf-$book',
        httpClient: server(up: false),
        outbox: outbox,
      );
      await sync.init();
      sync.reportPosition(ComicLocator(pageIndex: 2, fraction: 0.25));
      await sync.flush();
    }
    expect(outbox.lastFor('srv', 'book-gone'), isNotNull);
    expect(outbox.lastFor('srv', 'book-kept'), isNotNull);

    final accepted = <String>[];
    final picky = MockClient((req) async {
      final bookId = (jsonDecode(req.body) as Map<String, dynamic>)['bookId'];
      if (bookId == 'book-gone') return http.Response('no such book', 404);
      accepted.add('$bookId');
      return http.Response('', 200);
    });
    expect(await outbox.replay('srv', httpClient: picky), 1);
    expect(accepted, ['book-kept']);
    expect(outbox.lastFor('srv', 'book-gone'), isNull);
    expect(outbox.lastFor('srv', 'book-kept'), isNull);
  });

  test('auth, rate-limit and server errors are worth another replay', () {
    for (final status in [401, 403, 408, 429, 500, 503]) {
      expect(ReadingProgressOutbox.isPermanentRejection(status), isFalse,
          reason: '$status');
    }
    for (final status in [400, 404, 410, 422]) {
      expect(ReadingProgressOutbox.isPermanentRejection(status), isTrue,
          reason: '$status');
    }
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
