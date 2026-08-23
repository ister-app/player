import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/HlsDownloader.dart';

/// Runs [HlsDownloader] on a background isolate.
///
/// Reading a response body on the UI isolate costs far more than the transfer
/// itself: measured against the real server, a segment the ingress had
/// delivered in 79 ms took 730 ms to land on disk, and the very same code in a
/// plain Dart process managed 16 MB/s serially where the app managed 2,2. The
/// download loop competes with the frame loop for the event loop, and only
/// moving it off that isolate fixes it.
///
/// Everything the downloader needs is plain data; the three couplings that are
/// not — the stream token, the auth-failure hook and the cancel token — go
/// over the port. The token is *cached* in the isolate rather than fetched per
/// request: a round trip per segment would give back what the parallelism
/// won. Only a rejection clears it, and the next request asks for a fresh one.
class IsolateHlsDownloader implements HlsDownloaderApi {
  IsolateHlsDownloader({
    this.segmentTimeout = const Duration(seconds: 90),
    this.masterTimeout = const Duration(seconds: 150),
    this.segmentConcurrency = 4,
    this.transcodeSegmentConcurrency = 2,
    Future<String?> Function(String serverName)? tokenProvider,
    void Function(String serverName)? onAuthFailure,
  })  : _tokenProvider = tokenProvider ?? StreamTokenService.ensureToken,
        _onAuthFailure = onAuthFailure ?? StreamTokenService.invalidateToken;

  final Duration segmentTimeout;
  final Duration masterTimeout;
  final int segmentConcurrency;
  final int transcodeSegmentConcurrency;
  final Future<String?> Function(String serverName) _tokenProvider;
  final void Function(String serverName) _onAuthFailure;

  /// How often the caller's [DownloadCancelToken] is checked. It is a polled
  /// flag, not a stream, so the proxy polls it and forwards the cancel as a
  /// message — the same 250 ms the in-process downloader already sleeps in.
  static const _cancelPoll = Duration(milliseconds: 250);

  @override
  Future<HlsDownloadResult> download({
    required String serverName,
    required Directory dir,
    required String nodeUrl,
    required String mediaFileId,
    required List<Fragment$fragmentMediaFiles$mediaFileStreams?>? streams,
    required DownloadSelection selection,
    String? artworkUrl,
    required void Function(DownloadProgress progress) onProgress,
    required DownloadCancelToken cancel,
  }) async {
    final result = Completer<HlsDownloadResult>();
    final fromIsolate = ReceivePort();
    final onExit = ReceivePort();
    final onError = ReceivePort();
    SendPort? toIsolate;
    var cancelSent = false;
    Timer? cancelTimer;

    void sendCancel() {
      if (cancelSent) return;
      final port = toIsolate;
      if (port == null) return;
      cancelSent = true;
      port.send(const {'cancel': true});
    }

    void finish(FutureOr<void> Function() complete) {
      cancelTimer?.cancel();
      fromIsolate.close();
      onExit.close();
      onError.close();
      complete();
    }

    fromIsolate.listen((message) {
      final msg = message as Map;
      switch (msg) {
        case {'control': final SendPort port}:
          toIsolate = port;
          // A cancel that arrived before the isolate was ready.
          if (cancel.isCancelled) sendCancel();
        case {'progress': final List<Object?> p}:
          onProgress(DownloadProgress(
              bytes: p[0]! as int,
              segmentsDone: p[1]! as int,
              segmentsTotal: p[2]! as int));
        case {'needToken': final int id, 'server': final String server}:
          unawaited(_tokenProvider(server).then(
              (token) => toIsolate?.send({'token': token, 'id': id}),
              onError: (_) => toIsolate?.send({'token': null, 'id': id})));
        case {'authFailure': final String server}:
          _onAuthFailure(server);
        case {'result': final Map r}:
          finish(() => result.complete(HlsDownloadResult(
                bytes: r['bytes'] as int,
                segmentsDone: r['segmentsDone'] as int,
                segmentsTotal: r['segmentsTotal'] as int,
                audioStreamIndexes: (r['audioStreamIndexes'] as List).cast<int>(),
                subtitleStreamIds: (r['subtitleStreamIds'] as List).cast<String>(),
                artworkFile: r['artworkFile'] as String?,
              )));
        case {'error': final Map e}:
          // Rebuilt rather than sent, so the service keeps reading the same
          // flags off the same exception types.
          finish(() => result.completeError(switch (e['kind']) {
                'cancelled' => DownloadCancelled(),
                _ => DownloadFailure(e['message'] as String,
                    noSpace: e['noSpace'] as bool? ?? false,
                    transient: e['transient'] as bool? ?? false),
              }));
      }
    });

    // An isolate that dies without a verdict (an error it could not report, a
    // kill) must not leave the download hanging forever.
    void died(String what) {
      if (result.isCompleted) return;
      finish(() => result.completeError(
          DownloadFailure('download isolate $what', transient: true)));
    }

    onError.listen((e) => died('failed: $e'));
    onExit.listen((_) => died('stopped without a result'));

    await Isolate.spawn(
      _downloadOnIsolate,
      {
        'reply': fromIsolate.sendPort,
        'serverName': serverName,
        'dirPath': dir.path,
        'nodeUrl': nodeUrl,
        'mediaFileId': mediaFileId,
        'streams': streams
            ?.whereType<Fragment$fragmentMediaFiles$mediaFileStreams>()
            .map((s) => s.toJson())
            .toList(),
        'videoQuality': selection.videoQuality.name,
        'audioQuality': selection.audioQuality.name,
        'spokenLanguages': selection.spokenLanguages,
        'downloadSubtitles': selection.downloadSubtitles,
        'artworkUrl': artworkUrl,
        'segmentTimeoutMs': segmentTimeout.inMilliseconds,
        'masterTimeoutMs': masterTimeout.inMilliseconds,
        'segmentConcurrency': segmentConcurrency,
        'transcodeSegmentConcurrency': transcodeSegmentConcurrency,
      },
      onExit: onExit.sendPort,
      onError: onError.sendPort,
      errorsAreFatal: true,
      debugName: 'download $mediaFileId',
    );

    cancelTimer = Timer.periodic(_cancelPoll, (_) {
      if (cancel.isCancelled) sendCancel();
    });

    return result.future;
  }
}

/// The isolate side. Only plain data crosses the boundary: the media-file
/// streams travel as JSON and are rebuilt here, so no Flutter or GraphQL type
/// is touched on this side.
Future<void> _downloadOnIsolate(Map<String, Object?> job) async {
  final reply = job['reply']! as SendPort;
  final control = ReceivePort();
  final cancel = DownloadCancelToken();
  final tokenWaiters = <int, Completer<String?>>{};
  var nextTokenId = 0;
  String? cachedToken;
  Future<String?>? pendingToken;

  control.listen((message) {
    final msg = message as Map;
    if (msg['cancel'] == true) cancel.cancel();
    if (msg.containsKey('token')) {
      cachedToken = msg['token'] as String?;
      tokenWaiters.remove(msg['id'])?.complete(cachedToken);
    }
  });
  reply.send({'control': control.sendPort});

  Future<String?> askForToken(String serverName) {
    final id = nextTokenId++;
    final waiter = Completer<String?>();
    tokenWaiters[id] = waiter;
    reply.send({'needToken': id, 'server': serverName});
    return waiter.future;
  }

  Future<String?> tokenProvider(String serverName) {
    final cached = cachedToken;
    if (cached != null) return Future.value(cached);
    // Block body: `=> pendingToken = null` would return the very future being
    // awaited and whenComplete would wait for it.
    return pendingToken ??= askForToken(serverName).whenComplete(() {
      pendingToken = null;
    });
  }

  final downloader = HlsDownloader(
    tokenProvider: tokenProvider,
    onAuthFailure: (serverName) {
      cachedToken = null;
      reply.send({'authFailure': serverName});
    },
    segmentTimeout: Duration(milliseconds: job['segmentTimeoutMs']! as int),
    masterTimeout: Duration(milliseconds: job['masterTimeoutMs']! as int),
    segmentConcurrency: job['segmentConcurrency']! as int,
    transcodeSegmentConcurrency: job['transcodeSegmentConcurrency']! as int,
  );

  try {
    final result = await downloader.download(
      serverName: job['serverName']! as String,
      dir: Directory(job['dirPath']! as String),
      nodeUrl: job['nodeUrl']! as String,
      mediaFileId: job['mediaFileId']! as String,
      streams: (job['streams'] as List?)
          ?.map((s) => Fragment$fragmentMediaFiles$mediaFileStreams.fromJson(
              (s as Map).cast<String, dynamic>()))
          .toList(),
      selection: DownloadSelection(
        videoQuality:
            DownloadVideoQuality.values.byName(job['videoQuality']! as String),
        audioQuality:
            DownloadAudioQuality.values.byName(job['audioQuality']! as String),
        spokenLanguages: (job['spokenLanguages'] as List).cast<String>(),
        downloadSubtitles: job['downloadSubtitles']! as bool,
      ),
      artworkUrl: job['artworkUrl'] as String?,
      onProgress: (p) => reply
          .send({'progress': [p.bytes, p.segmentsDone, p.segmentsTotal]}),
      cancel: cancel,
    );
    reply.send({
      'result': {
        'bytes': result.bytes,
        'segmentsDone': result.segmentsDone,
        'segmentsTotal': result.segmentsTotal,
        'audioStreamIndexes': result.audioStreamIndexes,
        'subtitleStreamIds': result.subtitleStreamIds,
        'artworkFile': result.artworkFile,
      }
    });
  } on DownloadCancelled {
    reply.send(const {'error': {'kind': 'cancelled'}});
  } on DownloadFailure catch (e) {
    reply.send({
      'error': {
        'kind': 'failure',
        'message': e.message,
        'noSpace': e.noSpace,
        'transient': e.transient,
      }
    });
  } catch (e) {
    // Unexpected, so treat it the way the service treats an unknown error:
    // worth retrying on its own.
    reply.send({
      'error': {'kind': 'failure', 'message': e.toString(), 'transient': true}
    });
  } finally {
    control.close();
  }
}
