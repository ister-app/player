import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/upload/UploadApi.dart';
import 'package:player/utils/upload/UploadSource.dart';
import 'package:player/utils/upload/chunk_sender_io.dart';
import 'package:player/utils/upload/upload_source_io.dart';

class _NoPathFile implements UploadSourceFile {
  @override
  String get relativePath => 'blob.bin';
  @override
  int get size => 4;
  @override
  String? get localPath => null;
  @override
  Stream<List<int>> openRead(int start, int end) => Stream.value([for (var i = start; i < end; i++) i]);
}

void main() {
  late Directory tmp;
  late File file;
  late List<int> content;

  setUpAll(() async {
    tmp = await Directory.systemTemp.createTemp('chunk_sender');
    // 2,5 MB: more than two read blocks, and not a multiple of one
    content = List<int>.generate((2.5 * 1024 * 1024).toInt(), (i) => (i * 7 + i ~/ 1024) % 256);
    file = File('${tmp.path}/big.datwin')..writeAsBytesSync(content);
  });
  tearDownAll(() => tmp.delete(recursive: true));

  UploadApi api({String? token = 'Bearer t0k3n'}) =>
      UploadApi('srv', httpClient: MockClient((_) async => http.Response('unused', 500)), bearer: (_) async => token);

  Future<(HttpServer, List<HttpRequest>, List<List<int>>)> serve(
      Future<void> Function(HttpRequest request, List<int> body) respond) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final requests = <HttpRequest>[];
    final bodies = <List<int>>[];
    server.listen((request) async {
      final body = await request.fold<List<int>>([], (acc, chunk) => acc..addAll(chunk));
      requests.add(request);
      bodies.add(body);
      await respond(request, body);
    });
    return (server, requests, bodies);
  }

  test('streams exactly the requested range from another isolate, with the token', () async {
    final (server, requests, bodies) = await serve((request, body) async {
      request.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'receivedBytes': body.length, 'status': 'UPLOADING'}));
      await request.response.close();
    });
    final sender = IsolateChunkSender(api(), readBlockSize: 1 << 20);
    try {
      final source = IoUploadFile(file, 'big.datwin', content.length);
      const start = 300 * 1024;
      final end = content.length - 17;
      final result =
          await sender.send('http://127.0.0.1:${server.port}', 's1', 'f1', offset: start, end: end, source: source);
      expect(result.receivedBytes, end - start);
      expect(bodies.single, content.sublist(start, end));
      expect(requests.single.uri.path, '/library-upload/sessions/s1/files/f1/chunk');
      expect(requests.single.uri.queryParameters['offset'], '$start');
      expect(requests.single.headers.value('authorization'), 'Bearer t0k3n');
      expect(requests.single.headers.contentLength, end - start);
    } finally {
      await sender.dispose();
      await server.close(force: true);
    }
  });

  test('a refused chunk comes back as the same UploadApiException the api throws', () async {
    final (server, _, _) = await serve((request, body) async {
      request.response
        ..statusCode = 409
        ..headers.set('retry-after', '3')
        ..write(jsonEncode({'detail': 'incomplete', 'receivedBytes': 1024}));
      await request.response.close();
    });
    final sender = IsolateChunkSender(api());
    try {
      final source = IoUploadFile(file, 'big.datwin', content.length);
      await expectLater(
        sender.send('http://127.0.0.1:${server.port}', 's1', 'f1', offset: 0, end: 4096, source: source),
        throwsA(isA<UploadApiException>()
            .having((e) => e.statusCode, 'status', 409)
            .having((e) => e.message, 'message', 'incomplete')
            .having((e) => e.continueAt, 'continueAt', 1024)
            .having((e) => e.retryAfter, 'retryAfter', const Duration(seconds: 3))),
      );
    } finally {
      await sender.dispose();
      await server.close(force: true);
    }
  });

  test('a connection that fails is a transport exception, not an api error', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final port = server.port;
    await server.close(force: true);
    final sender = IsolateChunkSender(api());
    try {
      final source = IoUploadFile(file, 'big.datwin', content.length);
      await expectLater(
        sender.send('http://127.0.0.1:$port', 's1', 'f1', offset: 0, end: 4096, source: source),
        throwsA(allOf(isA<ChunkTransportException>(), isNot(isA<UploadApiException>()))),
      );
    } finally {
      await sender.dispose();
    }
  });

  test('a later send after dispose spawns a fresh isolate', () async {
    final (server, _, bodies) = await serve((request, body) async {
      request.response.write(jsonEncode({'receivedBytes': body.length, 'status': 'UPLOADING'}));
      await request.response.close();
    });
    final sender = IsolateChunkSender(api());
    try {
      final source = IoUploadFile(file, 'big.datwin', content.length);
      final url = 'http://127.0.0.1:${server.port}';
      await sender.send(url, 's1', 'f1', offset: 0, end: 10, source: source);
      await sender.dispose();
      await sender.send(url, 's1', 'f1', offset: 10, end: 20, source: source);
      expect(bodies, [content.sublist(0, 10), content.sublist(10, 20)]);
    } finally {
      await sender.dispose();
      await server.close(force: true);
    }
  });

  test('a source without a path stays in this isolate and goes through the api', () async {
    http.Request? seen;
    final apiWithMock = UploadApi('srv',
        httpClient: MockClient((request) async {
          seen = request;
          return http.Response(jsonEncode({'receivedBytes': 4, 'status': 'UPLOADING'}), 200);
        }),
        bearer: (_) async => 'Bearer x');
    final sender = IsolateChunkSender(apiWithMock);
    final result = await sender.send('http://node', 's1', 'f1', offset: 0, end: 4, source: _NoPathFile());
    expect(result.receivedBytes, 4);
    expect(seen!.url.toString(), 'http://node/library-upload/sessions/s1/files/f1/chunk?offset=0');
    expect(seen!.headers['Authorization'], 'Bearer x');
    await sender.dispose();
  });
}
