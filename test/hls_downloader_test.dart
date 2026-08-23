import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/HlsDownloader.dart';

const _master = '''
#EXTM3U
#EXT-X-VERSION:6

#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-copy",LANGUAGE="und",NAME="und",DEFAULT=YES,AUTOSELECT=YES,URI="stream_audio_0_copy.m3u8?token=t1"

#EXT-X-STREAM-INF:BANDWIDTH=256000,CODECS="mp4a.40.2",AUDIO="audio-copy"
stream_audio_0_copy.m3u8?token=t1
''';

const _audioPlaylist = '''
#EXTM3U
#EXT-X-VERSION:6
#EXT-X-TARGETDURATION:6
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PLAYLIST-TYPE:VOD

#EXTINF:5.000000,
seg_audio_0_copy_00000.ts?token=t1
#EXTINF:5.000000,
seg_audio_0_copy_00001.ts?token=t1
#EXTINF:2.500000,
seg_audio_0_copy_00002.ts?token=t1
#EXT-X-ENDLIST
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

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('hlsdl');
  });

  tearDown(() async {
    await dir.delete(recursive: true);
  });

  /// The serial downloader the assertions below are written against: with a
  /// window of one, "in playlist order" is exact and a cancel stops before the
  /// next segment is ever started. The parallel behaviour has its own group.
  HlsDownloader downloader(MockClient client,
          {int tokenCounter = 0, int window = 1}) =>
      HlsDownloader(
        httpClient: client,
        tokenProvider: (_) async => 'tok${tokenCounter++}',
        backoff: (_) => const Duration(milliseconds: 1),
        maxAttempts: 4,
        segmentConcurrency: window,
        transcodeSegmentConcurrency: window,
      );

  test('mirrors master, playlist and segments in order; retries a lazy segment',
      () async {
    final requests = <String>[];
    var seg1Failures = 0;
    final client = MockClient((req) async {
      requests.add(req.url.path);
      expect(req.url.queryParameters['token'], isNotNull);
      final name = req.url.pathSegments.last;
      if (name == 'master.m3u8') {
        expect(req.url.queryParameters['direct'], 'true');
        expect(req.url.queryParameters['transcode'], 'false');
        return http.Response(_master, 200);
      }
      if (name == 'stream_audio_0_copy.m3u8') {
        return http.Response(_audioPlaylist, 200);
      }
      if (name == 'seg_audio_0_copy_00001.ts' && seg1Failures < 2) {
        seg1Failures++;
        return http.Response('not yet', 503);
      }
      if (name.endsWith('.ts')) return http.Response('x' * 10, 200);
      return http.Response('', 404);
    });

    final progress = <DownloadProgress>[];
    final result = await downloader(client).download(
      serverName: 'srv',
      dir: dir,
      nodeUrl: 'https://node.example',
      mediaFileId: 'mf1',
      streams: [_audioStream],
      selection: const DownloadSelection(),
      onProgress: progress.add,
      cancel: DownloadCancelToken(),
    );

    expect(result.segmentsTotal, 3);
    expect(result.segmentsDone, 3);
    expect(result.audioStreamIndexes, [0]);
    expect(seg1Failures, 2);
    // Segments are requested in playlist order.
    final segs = requests.where((p) => p.endsWith('.ts')).toList();
    expect(segs.first, endsWith('00000.ts'));
    expect(segs.last, endsWith('00002.ts'));

    final master = File('${dir.path}/master.m3u8').readAsStringSync();
    expect(master, isNot(contains('token')));
    expect(master, contains('stream_audio_0_copy.m3u8'));
    final playlist =
        File('${dir.path}/stream_audio_0_copy.m3u8').readAsStringSync();
    expect(playlist, isNot(contains('token')));
    expect(File('${dir.path}/seg_audio_0_copy_00002.ts').existsSync(), isTrue);
    expect(dir.listSync().where((e) => e.path.endsWith('.part')), isEmpty);
    expect(progress.last.segmentsDone, 3);
    expect(result.bytes, greaterThan(30));
  });

  test('resume skips segments already on disk and discards partials', () async {
    File('${dir.path}/seg_audio_0_copy_00000.ts').writeAsStringSync('old');
    File('${dir.path}/seg_audio_0_copy_00001.ts.part').writeAsStringSync('half');
    final fetched = <String>[];
    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      fetched.add(name);
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_audioPlaylist, 200);
      return http.Response('x' * 10, 200);
    });

    await downloader(client).download(
      serverName: 'srv',
      dir: dir,
      nodeUrl: 'https://node.example',
      mediaFileId: 'mf1',
      streams: [_audioStream],
      selection: const DownloadSelection(),
      onProgress: (_) {},
      cancel: DownloadCancelToken(),
    );

    expect(fetched, isNot(contains('seg_audio_0_copy_00000.ts')));
    expect(fetched, contains('seg_audio_0_copy_00001.ts'));
    expect(File('${dir.path}/seg_audio_0_copy_00001.ts.part').existsSync(),
        isFalse);
    expect(File('${dir.path}/seg_audio_0_copy_00001.ts').existsSync(), isTrue);
  });

  test('every request carries a fresh token', () async {
    final tokens = <String>{};
    final client = MockClient((req) async {
      tokens.add(req.url.queryParameters['token']!);
      final name = req.url.pathSegments.last;
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_audioPlaylist, 200);
      return http.Response('x', 200);
    });
    await downloader(client).download(
      serverName: 'srv',
      dir: dir,
      nodeUrl: 'https://node.example',
      mediaFileId: 'mf1',
      streams: [_audioStream],
      selection: const DownloadSelection(),
      onProgress: (_) {},
      cancel: DownloadCancelToken(),
    );
    expect(tokens.length, greaterThan(1));
  });

  test('a 404 fails permanently; cancel stops between segments', () async {
    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_audioPlaylist, 200);
      if (name.endsWith('00001.ts')) return http.Response('', 404);
      return http.Response('x', 200);
    });
    await expectLater(
      downloader(client).download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: 'https://node.example',
        mediaFileId: 'mf1',
        streams: [_audioStream],
        selection: const DownloadSelection(),
        onProgress: (_) {},
        cancel: DownloadCancelToken(),
      ),
      throwsA(isA<DownloadFailure>()),
    );

    final cancel = DownloadCancelToken();
    final client2 = MockClient((req) async {
      final name = req.url.pathSegments.last;
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_audioPlaylist, 200);
      cancel.cancel();
      return http.Response('x', 200);
    });
    await expectLater(
      downloader(client2).download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: 'https://node.example',
        mediaFileId: 'mf1',
        streams: [_audioStream],
        selection: const DownloadSelection(),
        onProgress: (_) {},
        cancel: cancel,
      ),
      throwsA(isA<DownloadCancelled>()),
    );
    expect(File('${dir.path}/seg_audio_0_copy_00002.ts').existsSync(), isFalse);
  });

  test('video: picks the 480p variant and preferred audio languages', () async {
    const videoMaster = '''
#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-192k",LANGUAGE="eng",NAME="eng",DEFAULT=YES,AUTOSELECT=YES,URI="stream_audio_1_192k.m3u8?token=a"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-192k",LANGUAGE="nld",NAME="nld",DEFAULT=NO,AUTOSELECT=YES,URI="stream_audio_2_192k.m3u8?token=a"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-192k",LANGUAGE="deu",NAME="deu",DEFAULT=NO,AUTOSELECT=YES,URI="stream_audio_3_192k.m3u8?token=a"
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",LANGUAGE="eng",NAME="eng",DEFAULT=NO,AUTOSELECT=YES,FORCED=NO,URI="stream_sub_7_srt.m3u8?token=a"
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,CODECS="avc1.640028,mp4a.40.2",AUDIO="audio-192k",SUBTITLES="subs"
stream_video_720p.m3u8?token=a
#EXT-X-STREAM-INF:BANDWIDTH=1000000,RESOLUTION=854x480,CODECS="avc1.640028,mp4a.40.2",AUDIO="audio-192k",SUBTITLES="subs"
stream_video_480p.m3u8?token=a
''';
    const one = '#EXTM3U\n#EXTINF:5,\nSEG\n#EXT-X-ENDLIST\n';
    final fetched = <String>[];
    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      fetched.add(name);
      if (name == 'master.m3u8') {
        expect(req.url.queryParameters['transcode'], 'true');
        return http.Response(videoMaster, 200);
      }
      if (name.endsWith('.m3u8')) {
        return http.Response(one.replaceAll('SEG', '${name.replaceAll('stream_', 'seg_').replaceAll('.m3u8', '')}_00000.ts'), 200);
      }
      if (name.endsWith('.srt')) return http.Response('1\n00:00:01,000 --> 00:00:02,000\nhi\n', 200);
      return http.Response('x', 200);
    });
    final video = Fragment$fragmentMediaFiles$mediaFileStreams(
        codecName: 'h264', codecType: 'VIDEO', height: 1080, width: 1920, id: 'v', path: '', streamIndex: 0);
    final sub = Fragment$fragmentMediaFiles$mediaFileStreams(
        codecName: 'subrip', codecType: 'SUBTITLE', height: 0, width: 0, id: '7', path: '', streamIndex: 4, language: 'eng');

    final result = await downloader(client).download(
      serverName: 'srv',
      dir: dir,
      nodeUrl: 'https://node.example',
      mediaFileId: 'mf1',
      streams: [video, _audioStream, sub],
      selection: const DownloadSelection(
          videoQuality: DownloadVideoQuality.p480, spokenLanguages: ['nld']),
      onProgress: (_) {},
      cancel: DownloadCancelToken(),
    );

    expect(fetched, contains('stream_video_480p.m3u8'));
    expect(fetched, isNot(contains('stream_video_720p.m3u8')));
    expect(fetched, contains('stream_audio_1_192k.m3u8')); // default
    expect(fetched, contains('stream_audio_2_192k.m3u8')); // preferred
    expect(fetched, isNot(contains('stream_audio_3_192k.m3u8')));
    expect(fetched, contains('sub_7.srt'));
    expect(result.audioStreamIndexes, [1, 2]);
    expect(result.subtitleStreamIds, ['7']);
    final master = File('${dir.path}/master.m3u8').readAsStringSync();
    expect(master, isNot(contains('720p')));
    expect(master, isNot(contains('SUBTITLES')));
    expect(master, isNot(contains('TYPE=SUBTITLES')));
  });

  // ── parallel segments ───────────────────────────────────────────────────

  /// A playlist of [count] segments, and a client that gates every segment on
  /// [release] so a test can see how many requests are in flight at once.
  ({MockClient client, List<String> fetched, int Function() peak}) gatedClient(
      int count,
      {Completer<void>? release, int Function(String name)? status}) {
    final playlist = StringBuffer('#EXTM3U\n#EXT-X-TARGETDURATION:6\n');
    for (var i = 0; i < count; i++) {
      playlist.write('#EXTINF:5,\n'
          'seg_audio_0_copy_${i.toString().padLeft(5, '0')}.ts?token=t\n');
    }
    playlist.write('#EXT-X-ENDLIST\n');
    final fetched = <String>[];
    var inFlight = 0;
    var peak = 0;
    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      fetched.add(name);
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(playlist.toString(), 200);
      inFlight++;
      if (inFlight > peak) peak = inFlight;
      try {
        if (release != null) await release.future;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        final code = status?.call(name) ?? 200;
        return http.Response(code == 200 ? 'xxxxxxxxxx' : '', code);
      } finally {
        inFlight--;
      }
    });
    return (client: client, fetched: fetched, peak: () => peak);
  }

  Future<HlsDownloadResult> run(HlsDownloader d,
          {DownloadCancelToken? cancel,
          void Function(DownloadProgress)? onProgress,
          DownloadSelection selection = const DownloadSelection()}) =>
      d.download(
        serverName: 'srv',
        dir: dir,
        nodeUrl: 'https://node.example',
        mediaFileId: 'mf1',
        streams: [_audioStream],
        selection: selection,
        onProgress: onProgress ?? (_) {},
        cancel: cancel ?? DownloadCancelToken(),
      );

  test('a copy stream fetches four segments at a time', () async {
    final release = Completer<void>();
    final g = gatedClient(12, release: release);
    final future = run(downloader(g.client, window: 4));
    // Let the workers reach the gate, then let everything through.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(g.peak(), 4, reason: 'exactly the window, no more and no fewer');
    release.complete();
    final result = await future;

    expect(result.segmentsDone, 12);
    expect(result.segmentsTotal, 12);
    expect(g.fetched.where((n) => n.endsWith('.ts')), hasLength(12));
    for (var i = 0; i < 12; i++) {
      final name = 'seg_audio_0_copy_${i.toString().padLeft(5, '0')}.ts';
      expect(File('${dir.path}/$name').existsSync(), isTrue, reason: name);
    }
    expect(dir.listSync().where((e) => e.path.endsWith('.part')), isEmpty);
  });

  test('a re-encoded stream keeps the window small', () async {
    final release = Completer<void>();
    final g = gatedClient(12, release: release);
    final future = run(
      HlsDownloader(
        httpClient: g.client,
        tokenProvider: (_) async => 'tok',
        backoff: (_) => const Duration(milliseconds: 1),
        segmentConcurrency: 4,
        transcodeSegmentConcurrency: 2,
      ),
      selection:
          const DownloadSelection(audioQuality: DownloadAudioQuality.compact),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(g.peak(), 2,
        reason: 'the FFmpeg pass is the bottleneck there, not the request');
    release.complete();
    await future;
  });

  test('a failing segment stops the other workers and propagates once',
      () async {
    final g = gatedClient(12,
        status: (name) => name.endsWith('00005.ts') ? 404 : 200);
    await expectLater(
      run(downloader(g.client, window: 4)),
      throwsA(isA<DownloadFailure>()),
    );
    // The workers stop instead of draining the rest of the playlist. A bare
    // Future.wait would also leave the sibling failures unobserved, which
    // fails this test through the error zone.
    expect(g.fetched.where((n) => n.endsWith('.ts')).length, lessThan(12));
    expect(dir.listSync().where((e) => e.path.endsWith('.part')), isEmpty);
  });

  test('cancelling mid-window reports cancellation, not failure', () async {
    final cancel = DownloadCancelToken();
    final g = gatedClient(12);
    var seen = 0;
    final client = MockClient((req) async {
      if (req.url.pathSegments.last.endsWith('.ts') && ++seen == 3) {
        cancel.cancel();
      }
      final r = await g.client.send(http.Request('GET', req.url));
      return http.Response.fromStream(r);
    });
    await expectLater(
      run(downloader(client, window: 4), cancel: cancel),
      throwsA(isA<DownloadCancelled>()),
    );
    // Which of the in-flight segments landed is not deterministic; that none
    // of them left a partial file behind is.
    expect(dir.listSync().where((e) => e.path.endsWith('.part')), isEmpty);
  });

  test('a repeated init segment is fetched once and counted once', () async {
    const playlist = '#EXTM3U\n'
        '#EXT-X-TARGETDURATION:6\n'
        '#EXT-X-MAP:URI="init.mp4?token=t"\n'
        '#EXTINF:5,\n'
        'seg_audio_0_copy_00000.ts?token=t\n'
        '#EXT-X-MAP:URI="init.mp4?token=t"\n'
        '#EXTINF:5,\n'
        'seg_audio_0_copy_00001.ts?token=t\n'
        '#EXT-X-ENDLIST\n';
    final fetched = <String>[];
    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      fetched.add(name);
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(playlist, 200);
      return http.Response('xxxxxxxxxx', 200);
    });
    final result = await run(downloader(client, window: 4));

    expect(fetched.where((n) => n == 'init.mp4'), hasLength(1),
        reason: 'two workers on one .part file would corrupt it');
    expect(result.segmentsTotal, 3);
    expect(result.segmentsDone, 3);
  });

  test('progress never goes backwards and ends at the total', () async {
    final g = gatedClient(12);
    final seen = <DownloadProgress>[];
    final result =
        await run(downloader(g.client, window: 4), onProgress: seen.add);
    for (var i = 1; i < seen.length; i++) {
      expect(seen[i].segmentsDone,
          greaterThanOrEqualTo(seen[i - 1].segmentsDone));
    }
    expect(seen.last.segmentsDone, result.segmentsTotal);
  });
}
