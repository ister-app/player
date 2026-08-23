import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/HlsDownloader.dart';
import 'package:player/utils/download/IsolateHlsDownloader.dart';

/// A MockClient cannot cross an isolate boundary, so these run against a real
/// loopback server — which also makes them the only test that exercises the
/// port protocol end to end.
const _master = '''
#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-copy",LANGUAGE="und",NAME="und",DEFAULT=YES,AUTOSELECT=YES,URI="stream_audio_0_copy.m3u8?token=t"
#EXT-X-STREAM-INF:BANDWIDTH=256000,CODECS="mp4a.40.2",AUDIO="audio-copy"
stream_audio_0_copy.m3u8?token=t
''';

final _audioStream = Fragment$fragmentMediaFiles$mediaFileStreams(
  codecName: 'flac',
  codecType: 'AUDIO',
  height: 0,
  width: 0,
  id: 's0',
  path: '',
  streamIndex: 0,
  language: 'und',
);

String _playlist(int count) {
  final b = StringBuffer('#EXTM3U\n#EXT-X-TARGETDURATION:6\n');
  for (var i = 0; i < count; i++) {
    b.write('#EXTINF:5,\n'
        'seg_audio_0_copy_${i.toString().padLeft(5, '0')}.ts?token=t\n');
  }
  return (b..write('#EXT-X-ENDLIST\n')).toString();
}

void main() {
  late Directory dir;
  late HttpServer server;
  late String nodeUrl;
  late List<String> requests;
  late List<String?> tokensSeen;
  int segments = 4;
  int Function(String name)? status;
  Duration segmentDelay = Duration.zero;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('isolatedl');
    requests = [];
    tokensSeen = [];
    segments = 4;
    status = null;
    segmentDelay = Duration.zero;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    nodeUrl = 'http://127.0.0.1:${server.port}';
    unawaited(server.forEach((req) async {
      final name = req.uri.pathSegments.last;
      requests.add(name);
      tokensSeen.add(req.uri.queryParameters['token']);
      if (name == 'master.m3u8') {
        req.response.write(_master);
      } else if (name.endsWith('.m3u8')) {
        req.response.write(_playlist(segments));
      } else {
        if (segmentDelay > Duration.zero) await Future<void>.delayed(segmentDelay);
        final code = status?.call(name) ?? 200;
        req.response.statusCode = code;
        if (code == 200) req.response.write('xxxxxxxxxx');
      }
      await req.response.close();
    }));
  });

  tearDown(() async {
    await server.close(force: true);
    await dir.delete(recursive: true);
  });

  Future<HlsDownloadResult> run(
    IsolateHlsDownloader downloader, {
    DownloadCancelToken? cancel,
    void Function(DownloadProgress)? onProgress,
  }) =>
      downloader.download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: nodeUrl,
        mediaFileId: 'mf1',
        streams: [_audioStream],
        selection: const DownloadSelection(),
        onProgress: onProgress ?? (_) {},
        cancel: cancel ?? DownloadCancelToken(),
      );

  test('downloads on the isolate and reports back', () async {
    final progress = <DownloadProgress>[];
    final result = await run(
      IsolateHlsDownloader(tokenProvider: (_) async => 'tok'),
      onProgress: progress.add,
    );

    expect(result.segmentsDone, 4);
    expect(result.segmentsTotal, 4);
    expect(result.audioStreamIndexes, [0]);
    expect(result.bytes, greaterThan(0));
    expect(File('${dir.path}/seg_audio_0_copy_00003.ts').existsSync(), isTrue);
    expect(File('${dir.path}/master.m3u8').readAsStringSync(),
        isNot(contains('token')));
    expect(progress, isNotEmpty);
    expect(progress.last.segmentsDone, 4);
  });

  test('the token is asked for once and reused for every request', () async {
    segments = 8;
    var asked = 0;
    await run(IsolateHlsDownloader(tokenProvider: (_) async {
      asked++;
      return 'tok';
    }));

    expect(asked, 1,
        reason: 'a round trip per segment would undo the parallelism');
    expect(tokensSeen.where((t) => t == 'tok'), hasLength(requests.length));
  });

  test('a rejected token is refreshed once and the download continues',
      () async {
    var minted = 0;
    var invalidated = 0;
    status = (name) => tokensSeen.last == 'stale' ? 401 : 200;
    final result = await run(IsolateHlsDownloader(
      tokenProvider: (_) async => 'tok${++minted}'.replaceFirst('tok1', 'stale'),
      onAuthFailure: (_) => invalidated++,
    ));

    expect(invalidated, 1);
    expect(minted, greaterThan(1), reason: 'a fresh token was asked for');
    expect(result.segmentsDone, 4);
  });

  test('a 404 comes back as a permanent failure', () async {
    status = (name) => name.endsWith('00002.ts') ? 404 : 200;
    await expectLater(
      run(IsolateHlsDownloader(tokenProvider: (_) async => 'tok')),
      throwsA(isA<DownloadFailure>()
          .having((e) => e.transient, 'transient', isFalse)),
    );
  });

  test('cancelling reaches the isolate and stops the download', () async {
    segments = 60;
    segmentDelay = const Duration(milliseconds: 30);
    final cancel = DownloadCancelToken();
    final future = run(IsolateHlsDownloader(tokenProvider: (_) async => 'tok'),
        cancel: cancel);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    cancel.cancel();

    await expectLater(future, throwsA(isA<DownloadCancelled>()));
    expect(dir.listSync().where((e) => e.path.endsWith('.part')), isEmpty);
    expect(dir.listSync().whereType<File>().length, lessThan(60));
  });
}
