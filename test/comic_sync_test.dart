import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/comic/ComicLocator.dart';
import 'package:player/utils/comic/ComicSyncService.dart';

const _progressJson = '''
{
  "bookId": "book-1",
  "reading": {
    "location": "ister-comic:v1;page=7;pct=0.35",
    "mediaFileId": "file-1",
    "progress": 0.35,
    "updatedAt": "2026-07-16T10:00:00Z"
  },
  "chapters": []
}
''';

void main() {
  test('init exposes the saved locator for the same media file', () async {
    final service = ComicSyncService(
      serverName: 'server',
      bookId: 'book-1',
      mediaFileId: 'file-1',
      httpClient: MockClient((_) async => http.Response(_progressJson, 200)),
    );

    await service.init();

    expect(service.savedLocator()!.pageIndex, 7);
    expect(service.savedFraction(), closeTo(0.35, 1e-6));
  });

  test('a position written by another file falls back to the fraction',
      () async {
    final service = ComicSyncService(
      serverName: 'server',
      bookId: 'book-1',
      mediaFileId: 'file-OTHER',
      httpClient: MockClient((_) async => http.Response(_progressJson, 200)),
    );

    await service.init();

    expect(service.savedLocator(), isNull);
    expect(service.savedFraction(), closeTo(0.35, 1e-6));
  });

  test('a failed fetch leaves progress null and saving alive', () async {
    final posts = <Map<String, dynamic>>[];
    final service = ComicSyncService(
      serverName: 'server',
      bookId: 'book-1',
      mediaFileId: 'file-1',
      httpClient: MockClient((request) async {
        if (request.method == 'POST') {
          posts.add(json.decode(request.body) as Map<String, dynamic>);
          return http.Response('{}', 200);
        }
        return http.Response('nope', 500);
      }),
    );

    await service.init();
    expect(service.savedLocator(), isNull);

    service.reportPosition(const ComicLocator(pageIndex: 2, fraction: 0.2));
    await service.flush();
    expect(posts, hasLength(1));
  });

  test('saves are debounced and the newest position wins', () {
    fakeAsync((async) {
      final posts = <Map<String, dynamic>>[];
      final service = ComicSyncService(
        serverName: 'server',
        bookId: 'book-1',
        mediaFileId: 'file-1',
        httpClient: MockClient((request) async {
          if (request.method == 'POST') {
            posts.add(json.decode(request.body) as Map<String, dynamic>);
            return http.Response('{}', 200);
          }
          return http.Response(_progressJson, 200);
        }),
      );

      service.reportPosition(const ComicLocator(pageIndex: 1, fraction: 0.1));
      async.elapse(const Duration(milliseconds: 500));
      service.reportPosition(const ComicLocator(pageIndex: 4, fraction: 0.5));
      async.elapse(const Duration(seconds: 3));

      expect(posts, hasLength(1));
      expect(posts.single['location'], contains('page=4'));
      expect(posts.single['progress'], closeTo(0.5, 1e-6));
      expect(posts.single['readingLocationMediaFileId'], 'file-1');
      expect(posts.single.containsKey('chapterId'), isFalse);
    });
  });

  test('dispose flushes the pending position', () {
    fakeAsync((async) {
      final posts = <String>[];
      final service = ComicSyncService(
        serverName: 'server',
        bookId: 'book-1',
        mediaFileId: 'file-1',
        httpClient: MockClient((request) async {
          if (request.method == 'POST') {
            posts.add(request.body);
            return http.Response('{}', 200);
          }
          return http.Response(_progressJson, 200);
        }),
      );

      service.reportPosition(const ComicLocator(pageIndex: 9, fraction: 1.0));
      service.dispose();
      async.flushMicrotasks();

      expect(posts, hasLength(1));
      expect(posts.single, contains('page=9'));
    });
  });
}
