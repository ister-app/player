import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/upload/UploadApi.dart';
import 'package:player/utils/upload/UploadModels.dart';
import 'package:player/utils/upload/UploadRunner.dart';
import 'package:player/utils/upload/UploadSource.dart';

/// A file whose bytes are its own offsets (mod 251), so that every received
/// chunk can be checked against where it claims to belong.
class _FakeFile implements UploadSourceFile {
  _FakeFile(this.relativePath, this.size);
  @override
  final String relativePath;
  @override
  final int size;
  final List<(int, int)> reads = [];

  @override
  Stream<List<int>> openRead(int start, int end) {
    reads.add((start, end));
    return Stream.value([for (var i = start; i < end; i++) i % 251]);
  }
}

/// The server's side of a local-directory upload: appends, 409s on a wrong offset.
class _FakeServer {
  final Map<String, List<int>> received = {};
  final Set<String> completed = {};
  final List<String> calls = [];
  bool aborted = false;

  /// Runs before a chunk is handled; return a response to short-circuit it.
  http.Response? Function(String fileId, int offset)? onChunk;

  Future<http.Response> handle(http.Request request) async {
    final segments = request.url.pathSegments;
    expect(request.headers['Authorization'], 'Bearer test');
    if (segments.last == 'chunk') {
      final fileId = segments[segments.length - 2];
      final offset = int.parse(request.url.queryParameters['offset']!);
      calls.add('chunk $fileId $offset');
      final intercepted = onChunk?.call(fileId, offset);
      if (intercepted != null) return intercepted;
      final bytes = received.putIfAbsent(fileId, () => []);
      if (offset != bytes.length) {
        return http.Response(jsonEncode({'fileId': fileId, 'receivedBytes': bytes.length, 'status': 'UPLOADING'}), 409);
      }
      bytes.addAll(request.bodyBytes);
      return http.Response(jsonEncode({'fileId': fileId, 'receivedBytes': bytes.length, 'status': 'UPLOADING'}), 200);
    }
    if (segments.last == 'complete') {
      final fileId = segments[segments.length - 2];
      calls.add('complete $fileId');
      completed.add(fileId);
      return http.Response(
          jsonEncode({'fileId': fileId, 'receivedBytes': received[fileId]?.length ?? 0, 'status': 'COMPLETED'}), 200);
    }
    if (segments.last == 'abort') {
      aborted = true;
      return http.Response('{}', 200);
    }
    return http.Response('not found', 404);
  }
}

UploadSession _session(List<({String id, String path, int size, int chunk, int received, List<int> parts})> files) =>
    UploadSession(sessionId: 's1', status: 'ACTIVE', skipped: const [], files: [
      for (final f in files)
        UploadFileState(
            fileId: f.id,
            relativePath: f.path,
            size: f.size,
            chunkSize: f.chunk,
            receivedBytes: f.received,
            status: f.received > 0 ? 'UPLOADING' : 'PENDING',
            completedParts: f.parts)
    ]);

void main() {
  late _FakeServer server;
  late UploadApi api;

  setUp(() {
    server = _FakeServer();
    api = UploadApi('srv', httpClient: MockClient(server.handle), bearer: (_) async => 'Bearer test');
  });

  UploadRunner runner(UploadSession session, Map<String, UploadSourceFile> sources, {bool s3 = false}) => UploadRunner(
      api: api,
      nodeUrl: 'http://node',
      session: session,
      sources: sources,
      partsAddressedByNumber: s3,
      backoff: (_) => Duration.zero,
      sleep: (_) async {});

  void expectIntact(_FakeFile file, List<int> bytes) =>
      expect(bytes, [for (var i = 0; i < file.size; i++) i % 251], reason: file.relativePath);

  test('uploads every file in chunks and completes it', () async {
    final a = _FakeFile('Season 01/e01.mkv', 25);
    final b = _FakeFile('poster.jpg', 7);
    final r = runner(
        _session([
          (id: 'fa', path: a.relativePath, size: 25, chunk: 10, received: 0, parts: const []),
          (id: 'fb', path: b.relativePath, size: 7, chunk: 10, received: 0, parts: const []),
        ]),
        {a.relativePath: a, b.relativePath: b});

    await r.start();

    expectIntact(a, server.received['fa']!);
    expectIntact(b, server.received['fb']!);
    expect(server.completed, {'fa', 'fb'});
    expect(r.isFinished, isTrue);
    expect(r.sentBytes, r.totalBytes);
    expect(a.reads, [(0, 10), (10, 20), (20, 25)]);
  });

  test('resumes a file from what the server already has', () async {
    final a = _FakeFile('e01.mkv', 25);
    server.received['fa'] = [for (var i = 0; i < 20; i++) i % 251];
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 25, chunk: 10, received: 20, parts: const [])]),
        {a.relativePath: a});

    await r.start();

    expect(a.reads, [(20, 25)], reason: 'only the missing tail is read and sent');
    expectIntact(a, server.received['fa']!);
  });

  test('follows the server when its offset differs (a lost response)', () async {
    final a = _FakeFile('e01.mkv', 30);
    // the client believes nothing arrived; the first chunk actually did
    server.received['fa'] = [for (var i = 0; i < 10; i++) i % 251];
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 30, chunk: 10, received: 0, parts: const [])]),
        {a.relativePath: a});

    await r.start();

    expectIntact(a, server.received['fa']!);
    expect(server.calls.first, 'chunk fa 0');
    expect(server.calls[1], 'chunk fa 10', reason: 'after the 409 it continues at the server offset');
    expect(r.items.single.phase, UploadItemPhase.done);
  });

  test('waits out a busy server and a server error instead of failing', () async {
    final a = _FakeFile('e01.mkv', 10);
    var hiccups = 0;
    server.onChunk = (_, _) {
      hiccups++;
      if (hiccups == 1) return http.Response('{"detail":"busy"}', 429, headers: {'retry-after': '2'});
      if (hiccups == 2) return http.Response('{"detail":"try again"}', 503);
      return null;
    };
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 10, chunk: 10, received: 0, parts: const [])]),
        {a.relativePath: a});

    await r.start();

    expect(hiccups, 3);
    expectIntact(a, server.received['fa']!);
    expect(r.items.single.phase, UploadItemPhase.done);
  });

  test('fails a file on a refusal that retrying cannot fix, and can retry it later', () async {
    final a = _FakeFile('e01.mkv', 10);
    var refuse = true;
    server.onChunk = (_, _) => refuse ? http.Response('{"detail":"Directory is mounted read-only"}', 403) : null;
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 10, chunk: 10, received: 0, parts: const [])]),
        {a.relativePath: a});

    await r.start();
    expect(r.items.single.phase, UploadItemPhase.failed);
    expect(r.items.single.error, 'Directory is mounted read-only');
    expect(server.calls.where((c) => c.startsWith('chunk')).length, 1, reason: 'a 403 is not retried');

    refuse = false;
    r.retryFailed();
    await r.start();
    expect(r.items.single.phase, UploadItemPhase.done);
  });

  test('S3: skips the parts the server already has, in any order', () async {
    final a = _FakeFile('e01.mkv', 35);
    final sent = <int>[];
    server.onChunk = (_, offset) {
      sent.add(offset);
      return http.Response(jsonEncode({'fileId': 'fa', 'receivedBytes': 0, 'status': 'UPLOADING'}), 200);
    };
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 35, chunk: 10, received: 20, parts: const [1, 3])]),
        {a.relativePath: a},
        s3: true);

    await r.start();

    expect(sent, [10, 30], reason: 'parts 2 and 4; 1 and 3 are there');
    expect(server.completed, {'fa'});
  });

  test('pause stops after the chunk in flight and start continues without resending', () async {
    final a = _FakeFile('e01.mkv', 30);
    late UploadRunner r;
    server.onChunk = (_, offset) {
      if (offset == 10) r.pause();
      return null;
    };
    r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 30, chunk: 10, received: 0, parts: const [])]),
        {a.relativePath: a});

    await r.start();
    expect(server.received['fa']!.length, 20);
    expect(server.completed, isEmpty);
    expect(r.items.single.phase, UploadItemPhase.queued);

    server.onChunk = null;
    await r.start();
    expect(a.reads, [(0, 10), (10, 20), (20, 30)], reason: 'nothing is read twice');
    expectIntact(a, server.received['fa']!);
    expect(r.items.single.phase, UploadItemPhase.done);
  });

  test('cancel aborts the session on the server', () async {
    final a = _FakeFile('e01.mkv', 10);
    final r = runner(
        _session([(id: 'fa', path: a.relativePath, size: 10, chunk: 10, received: 0, parts: const [])]),
        {a.relativePath: a});

    await r.cancel();

    expect(server.aborted, isTrue);
    expect(r.items.single.phase, UploadItemPhase.failed);
  });

  test('a file without a local source (after a restart) is left alone', () async {
    final r = runner(
        _session([(id: 'fa', path: 'e01.mkv', size: 10, chunk: 10, received: 0, parts: const [])]), const {});

    await r.start();

    expect(server.calls, isEmpty);
    expect(r.items.single.phase, UploadItemPhase.queued);
  });

  test('hidden files and OS droppings are not offered for upload', () {
    expect(isUploadableRelativePath('Season 01/e01.mkv'), isTrue);
    expect(isUploadableRelativePath('R.E.M./Out of Time (1991)/01.flac'), isTrue);
    expect(isUploadableRelativePath('.DS_Store'), isFalse);
    expect(isUploadableRelativePath('Season 01/.e01.mkv.swp'), isFalse);
    expect(isUploadableRelativePath('Season 01/Thumbs.db'), isFalse);
  });

  test('recognition summary reads like the library shows it', () {
    expect(UploadRecognition({'title': 'The Show', 'year': 2019, 'season': 4, 'episodes': [6, 7]}).summary(),
        'The Show · (2019) · S04E06-07');
    expect(UploadRecognition({'artist': 'R.E.M.', 'album': 'Out of Time', 'disc': 1, 'track': 1}).summary(),
        'R.E.M. · Out of Time · #1');
    expect(UploadRecognition({'series': 'Dr. Stone', 'volume': 27.0}).summary(), 'Dr. Stone · vol. 27');
  });
}
