import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/comic/ComicResourceClient.dart';

const _manifestJson = '''
{
  "mediaFileId": "file-1",
  "bookId": "book-1",
  "format": "CBZ",
  "pageCount": 3,
  "pages": [
    {"index": 0, "name": "page01.png", "size": 100},
    {"index": 1, "name": "page02.png", "size": 200},
    {"index": 2, "name": "page03.png", "size": 300}
  ]
}
''';

ComicResourceClient _client(MockClient http) => ComicResourceClient(
      nodeUrl: 'https://node.example/',
      mediaFileId: 'file-1',
      serverName: 'server',
      httpClient: http,
      tokenProvider: (_) async => 'tok en',
    );

void main() {
  test('manifest is fetched with the stream token and parsed', () async {
    late Uri requested;
    final client = _client(MockClient((request) async {
      requested = request.url;
      return http.Response(_manifestJson, 200);
    }));

    final manifest = await client.manifest();

    expect(requested.path, '/comic/file-1/manifest');
    expect(requested.queryParameters['token'], 'tok en');
    expect(manifest.format, 'CBZ');
    expect(manifest.bookId, 'book-1');
    expect(manifest.pageCount, 3);
    expect(manifest.pages, hasLength(3));
    expect(manifest.pages[1].name, 'page02.png');
  });

  test('page URLs are tokenized; cache keys are not', () {
    final client = _client(MockClient((_) async => http.Response('', 404)));

    expect(client.pageCacheKey(4),
        'https://node.example/comic/file-1/page/4');
    expect(client.pageCacheKey(4, width: 240),
        'https://node.example/comic/file-1/page/4?width=240');
    final url = Uri.parse(client.pageUrl(4, width: 240));
    expect(url.path, '/comic/file-1/page/4');
    expect(url.queryParameters['width'], '240');
  });

  test('readRange sends a Range header', () async {
    late http.Request requested;
    final client = _client(MockClient((request) async {
      requested = request;
      return http.Response.bytes(utf8.encode('abcd'), 206);
    }));

    final bytes = await client.readRange(100, 4);

    expect(requested.headers['Range'], 'bytes=100-103');
    expect(utf8.decode(bytes), 'abcd');
  });

  test('failed requests throw with the status code', () async {
    final client = _client(MockClient((_) async => http.Response('', 500)));

    expect(client.manifest(), throwsA(isA<ComicResourceException>()));
    expect(client.readRange(0, 10), throwsA(isA<ComicResourceException>()));
  });

  test('fileSize comes from the Content-Range probe', () async {
    final client = _client(MockClient((request) async {
      expect(request.headers['Range'], 'bytes=0-0');
      return http.Response.bytes(const [0], 206,
          headers: {'content-range': 'bytes 0-0/12345'});
    }));

    expect(await client.fileSize(), 12345);
  });
}
