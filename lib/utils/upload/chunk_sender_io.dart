import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'ChunkSender.dart';
import 'UploadApi.dart';
import 'UploadModels.dart';
import 'UploadSource.dart';

ChunkSender chunkSenderFor(UploadApi api) => IsolateChunkSender(api);

/// A chunk that never got an answer: the connection broke, the isolate died.
/// Plain [Exception] on purpose — the runner retries those with backoff.
class ChunkTransportException implements Exception {
  ChunkTransportException(this.message);
  final String message;
  @override
  String toString() => 'ChunkTransportException: $message';
}

/// Streams chunks from a background isolate.
///
/// On the UI isolate a chunk crawls: `File.openRead` hands out 64 KB blocks,
/// and every block completion and every socket-writable event is a hop
/// through the embedder's task runner (on Linux the GTK main loop, where a
/// hop costs a poll round and GLib's millisecond timer granularity). Measured
/// on a release build against the real server: a flat 6 MB/s per stream with
/// the main thread 91 % idle in `ppoll`, while the same code headless did
/// 95 MB/s. The isolate has Dart's own event loop and reads in 1 MB blocks.
///
/// Only desktop files have a path another isolate can open; anything else
/// (`localPath == null`) goes through [ApiChunkSender] as before. The token
/// is fetched here, per chunk, from the login that can refresh it, and sent
/// along with the job — an upload outlives an access token many times over.
class IsolateChunkSender implements ChunkSender {
  IsolateChunkSender(this.api, {this.readBlockSize = 1 << 20}) : _inProcess = ApiChunkSender(api);

  final UploadApi api;
  final int readBlockSize;
  final ApiChunkSender _inProcess;
  Future<_Worker>? _worker;

  @override
  Future<UploadChunkResult> send(String nodeUrl, String sessionId, String fileId,
      {required int offset, required int end, required UploadSourceFile source}) async {
    final path = source.localPath;
    if (path == null) {
      return _inProcess.send(nodeUrl, sessionId, fileId, offset: offset, end: end, source: source);
    }
    final token = await api.authorization();
    final worker = await (_worker ??= _Worker.spawn(readBlockSize, onDied: () => _worker = null));
    return worker.send({
      'url': UploadApi.chunkUri(nodeUrl, sessionId, fileId, offset).toString(),
      'token': token,
      'path': path,
      'offset': offset,
      'end': end,
    });
  }

  @override
  Future<void> dispose() async {
    final pending = _worker;
    _worker = null;
    if (pending != null) (await pending).close();
  }
}

/// The UI-isolate end of the worker: jobs out by id, verdicts back by id.
class _Worker {
  _Worker._(this._isolate, this._fromIsolate, this._toIsolate, this._onDied);

  final Isolate _isolate;
  final ReceivePort _fromIsolate;
  final SendPort _toIsolate;
  final void Function() _onDied;
  final Map<int, Completer<UploadChunkResult>> _pending = {};
  int _nextId = 0;
  bool _closed = false;

  static Future<_Worker> spawn(int readBlockSize, {required void Function() onDied}) async {
    final fromIsolate = ReceivePort();
    final ready = Completer<SendPort>();
    final onExit = ReceivePort();
    late final _Worker worker;
    fromIsolate.listen((message) {
      if (message is SendPort) {
        ready.complete(message);
        return;
      }
      worker._onMessage(message as Map);
    });
    final isolate = await Isolate.spawn(_chunkIsolate, {'reply': fromIsolate.sendPort, 'block': readBlockSize},
        onExit: onExit.sendPort, debugName: 'upload chunks');
    worker = _Worker._(isolate, fromIsolate, await ready.future, onDied);
    onExit.listen((_) {
      onExit.close();
      worker._died();
    });
    return worker;
  }

  Future<UploadChunkResult> send(Map<String, Object?> job) {
    if (_closed) return Future.error(ChunkTransportException('upload isolate stopped'));
    final id = _nextId++;
    final completer = Completer<UploadChunkResult>();
    _pending[id] = completer;
    _toIsolate.send({...job, 'id': id});
    return completer.future;
  }

  void _onMessage(Map message) {
    final completer = _pending.remove(message['id']);
    if (completer == null) return;
    switch (message) {
      case {'result': final Map r}:
        completer.complete(UploadChunkResult.fromJson(r.cast<String, dynamic>()));
      case {'error': final Map e}:
        completer.completeError(UploadApiException(
          e['statusCode'] as int,
          e['message'] as String,
          continueAt: e['continueAt'] as int?,
          retryAfter: e['retryAfterSeconds'] == null ? null : Duration(seconds: e['retryAfterSeconds'] as int),
        ));
      default:
        completer.completeError(ChunkTransportException(message['failure'].toString()));
    }
  }

  void _died() {
    if (_closed) return;
    _closed = true;
    _fromIsolate.close();
    _onDied();
    for (final c in _pending.values) {
      c.completeError(ChunkTransportException('upload isolate stopped'));
    }
    _pending.clear();
  }

  void close() {
    if (_closed) return;
    _toIsolate.send(null);
    _isolate.kill(priority: Isolate.beforeNextEvent);
    _died();
  }
}

/// The isolate side: one http client, any number of chunks in flight.
Future<void> _chunkIsolate(Map<String, Object?> init) async {
  final reply = init['reply']! as SendPort;
  final block = init['block']! as int;
  final client = http.Client();
  final jobs = ReceivePort();
  reply.send(jobs.sendPort);
  jobs.listen((message) {
    if (message == null) {
      client.close();
      jobs.close();
      return;
    }
    unawaited(_sendChunk(client, message as Map, block, reply));
  });
}

Future<void> _sendChunk(http.Client client, Map job, int block, SendPort reply) async {
  final id = job['id'];
  try {
    final offset = job['offset'] as int;
    final end = job['end'] as int;
    final request = http.StreamedRequest('POST', Uri.parse(job['url'] as String))
      ..headers['Content-Type'] = 'application/octet-stream'
      ..contentLength = end - offset;
    final token = job['token'] as String?;
    if (token != null) request.headers['Authorization'] = token;
    // The body is fed while the request is in flight; a read error travels through the sink
    // and fails the request, which comes back as a failure to retry.
    unawaited(request.sink.addStream(_readRange(job['path'] as String, offset, end, block)).whenComplete(request.sink.close));
    final response = await http.Response.fromStream(await client.send(request));
    final error = UploadApi.errorOf(response);
    if (error != null) {
      reply.send({
        'id': id,
        'error': {
          'statusCode': error.statusCode,
          'message': error.message,
          'continueAt': error.continueAt,
          'retryAfterSeconds': error.retryAfter?.inSeconds,
        },
      });
      return;
    }
    reply.send({'id': id, 'result': jsonDecode(utf8.decode(response.bodyBytes))});
  } catch (e) {
    reply.send({'id': id, 'failure': e.toString()});
  }
}

/// Bytes `[start, end)` of the file in blocks of [block], far fewer hops than
/// `File.openRead`'s 64 KB.
Stream<List<int>> _readRange(String path, int start, int end, int block) async* {
  final file = await File(path).open();
  try {
    await file.setPosition(start);
    var position = start;
    while (position < end) {
      final bytes = await file.read(min(block, end - position));
      // The file shrank under us; the server notices the short chunk.
      if (bytes.isEmpty) return;
      position += bytes.length;
      yield bytes;
    }
  } finally {
    await file.close();
  }
}
