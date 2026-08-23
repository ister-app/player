import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/EpubDownloader.dart';
import 'package:player/utils/download/HlsDownloader.dart';
import 'package:player/utils/download/LocalPlayQueue.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'localhost:8080/api';

const _master = '''
#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-copy",LANGUAGE="und",NAME="und",DEFAULT=YES,AUTOSELECT=YES,URI="stream_audio_0_copy.m3u8?token=t"
#EXT-X-STREAM-INF:BANDWIDTH=256000,CODECS="mp4a.40.2",AUDIO="audio-copy"
stream_audio_0_copy.m3u8?token=t
''';
const _playlist = '''
#EXTM3U
#EXTINF:5,
seg_audio_0_copy_00000.ts?token=t
#EXTINF:5,
seg_audio_0_copy_00001.ts?token=t
#EXT-X-ENDLIST
''';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/music/$id.flac',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'https://node.example'),
      ),
      mediaFileStreams: [
        Fragment$fragmentMediaFiles$mediaFileStreams(
            codecName: 'flac',
            codecType: 'AUDIO',
            height: 0,
            width: 0,
            id: 's0',
            path: '',
            streamIndex: 0),
      ],
    );

Fragment$fragmentPlayQueue$playQueueItems trackItem(String id, {int number = 1}) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: 'local:track:$id',
      position: number.toDouble(),
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: id,
        number: number,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

Future<http.Response> Function(http.Request) _hlsHandler(List<String> log) =>
    (req) async {
      final name = req.url.pathSegments.last;
      log.add(name);
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_playlist, 200);
      if (name.endsWith('.ts')) return http.Response('x' * 100, 200);
      return http.Response('', 404);
    };

MockClient _hlsClient(List<String> log) => MockClient(_hlsHandler(log));

Future<void> _waitFor(bool Function() done, {String Function()? describe}) async {
  final end = DateTime.now().add(const Duration(seconds: 10));
  while (!done()) {
    if (DateTime.now().isAfter(end)) fail('timed out: ${describe?.call()}');
    await Future.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late Directory root;
  late DownloadService service;
  late List<String> requests;

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: MockClient((_) async => http.Response(
                  json.encode({'data': {'__typename': 'Query'}}), 200,
                  headers: {'content-type': 'application/json'}))),
          cache: GraphQLCache(),
        );
    root = await Directory.systemTemp.createTemp('dlsvc');
    requests = [];
    service = DownloadService(
      store: DownloadStore(rootOverride: root),
      downloader: HlsDownloader(
          httpClient: _hlsClient(requests),
          tokenProvider: (_) async => 'tok',
          backoff: (_) => const Duration(milliseconds: 1)),
    );
    DownloadService.instance = service;
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    await root.delete(recursive: true);
  });

  test('enqueue downloads the item, persists it and makes it playable locally',
      () async {
    await service.enqueue(_server, DownloadRequest(item: trackItem('t1')));
    final key = DownloadEntry.keyFor(DownloadKind.track, 't1');
    expect(service.entryFor(_server, key)?.status,
        isIn([DownloadStatus.queued, DownloadStatus.downloading]));
    expect(service.localMasterFor(_server, 'mf-t1'), isNull);

    await _waitFor(() => service.entryFor(_server, key)?.isComplete ?? false);

    final entry = service.entryFor(_server, key)!;
    expect(entry.pinned, isTrue);
    expect(entry.groupTitle, 'The Album');
    expect(entry.segmentsTotal, 2);
    expect(entry.bytes, greaterThan(200));
    final master = service.localMasterFor(_server, 'mf-t1')!;
    expect(master, endsWith('/localhost_8080_api/mf-t1/master.m3u8'));
    expect(File(master).existsSync(), isTrue);
    expect(requests.where((r) => r.endsWith('.ts')), hasLength(2));

    // A fresh service (next app start) sees the same entry from disk.
    final again = DownloadService(
        store: DownloadStore(rootOverride: root),
        downloader: HlsDownloader(httpClient: _hlsClient([])));
    await again.ensureStarted();
    expect(again.localMasterFor(_server, 'mf-t1'), master);
  });

  test('a cache entry becomes pinned when downloaded manually; remove deletes files',
      () async {
    await service.enqueue(
        _server, DownloadRequest(item: trackItem('t2'), pinned: false));
    final key = DownloadEntry.keyFor(DownloadKind.track, 't2');
    await _waitFor(() => service.entryFor(_server, key)?.isComplete ?? false);
    expect(service.entryFor(_server, key)!.pinned, isFalse);
    final fetched = requests.length;

    await service.enqueue(_server, DownloadRequest(item: trackItem('t2')));
    expect(service.entryFor(_server, key)!.pinned, isTrue);
    expect(requests.length, fetched, reason: 'no re-download');

    final dir = Directory(service.store.itemDirPathSync(_server, 'mf-t2')!);
    expect(dir.existsSync(), isTrue);
    await service.remove(_server, key);
    expect(service.entryFor(_server, key), isNull);
    expect(dir.existsSync(), isFalse);
    expect(service.localMasterFor(_server, 'mf-t2'), isNull);
  });

  test('episodes sharing one file mirror it once and share the directory',
      () async {
    final file = Fragment$fragmentMediaFiles(
      id: 'mf-shared',
      path: '/tv/s04e06-e07.mkv',
      size: 1,
      durationInMilliseconds: 2400000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(url: 'https://node.example'),
      ),
      episodes: [
        Fragment$fragmentMediaFiles$episodes(id: 'e6', number: 6),
        Fragment$fragmentMediaFiles$episodes(id: 'e7', number: 7),
      ],
      mediaFileStreams: [
        Fragment$fragmentMediaFiles$mediaFileStreams(
            codecName: 'aac', codecType: 'AUDIO', height: 0, width: 0, id: 's0', path: '', streamIndex: 0),
      ],
    );
    final e6 = episodePartItem(6, file, startMs: 0, durationMs: 1200000);
    final e7 = episodePartItem(7, file, startMs: 1200000, durationMs: 1200000);
    await service.enqueueAll(_server, [
      DownloadRequest(item: e6, groupTitle: 'Show', sortKey: 6),
      DownloadRequest(item: e7, groupTitle: 'Show', sortKey: 7),
    ]);
    final k6 = DownloadEntry.keyFor(DownloadKind.episode, 'e6');
    final k7 = DownloadEntry.keyFor(DownloadKind.episode, 'e7');
    await _waitFor(() =>
        (service.entryFor(_server, k6)?.isComplete ?? false) &&
        (service.entryFor(_server, k7)?.isComplete ?? false));

    expect(requests.where((r) => r == 'master.m3u8'), hasLength(1),
        reason: 'the shared file is mirrored once');
    expect(service.entryFor(_server, k7)!.segmentsTotal, 2);
    expect(service.bytesFor(_server), service.entryFor(_server, k6)!.bytes,
        reason: 'shared bytes count once');
    final dir = Directory(service.store.itemDirPathSync(_server, 'mf-shared')!);

    await service.remove(_server, k6);
    expect(dir.existsSync(), isTrue, reason: 'e7 still needs the files');
    expect(service.localMasterFor(_server, 'mf-shared'), isNotNull);

    // Enqueued again after the fact: adopts the mirrored file, no HTTP.
    final fetched = requests.length;
    await service.enqueue(_server, DownloadRequest(item: e6, groupTitle: 'Show'));
    await _waitFor(() => service.entryFor(_server, k6)?.isComplete ?? false);
    expect(requests.length, fetched);

    await service.remove(_server, k6);
    await service.remove(_server, k7);
    expect(dir.existsSync(), isFalse);
  });

  test('an epub entry is mirrored by the epub downloader and readable locally',
      () async {
    final epubRequests = <String>[];
    final epubClient = MockClient((req) async {
      final path = Uri.decodeComponent(req.url.path);
      epubRequests.add(path);
      if (path.endsWith('container.xml')) {
        return http.Response('<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container"><rootfiles><rootfile full-path="content.opf"/></rootfiles></container>', 200);
      }
      if (path.endsWith('content.opf')) {
        return http.Response('<package xmlns="http://www.idpf.org/2007/opf"><metadata/><manifest><item id="c" href="c.xhtml" media-type="application/xhtml+xml"/></manifest><spine><itemref idref="c"/></spine></package>', 200);
      }
      return http.Response('<html/>', 200);
    });
    final reading = DownloadService(
      store: service.store,
      downloader: service.downloader,
      epubDownloader: EpubDownloader(
          httpClient: epubClient,
          http: DownloadHttp(httpClient: epubClient, tokenProvider: (_) async => 't')),
    );
    DownloadService.instance = reading;
    await reading.enqueue(
        _server,
        const DownloadRequest.book(
          bookId: 'book-1',
          mediaFileId: 'mf-epub',
          nodeUrl: 'https://node.example',
          title: 'The Book',
          format: BookFormat.epub,
          author: 'Author',
        ));
    final key = DownloadEntry.keyFor(DownloadKind.book, 'mf-epub');
    await _waitFor(() => reading.entryFor(_server, key)?.isComplete ?? false);
    final entry = reading.entryFor(_server, key)!;
    expect(entry.isReading, isTrue);
    expect(entry.groupId, 'book-1');
    expect(entry.subtitle, 'Author');
    expect(entry.queueItemJson, isNull);
    expect(entry.segmentsTotal, 3);
    final dir = await reading.localReadingDir(_server, 'mf-epub');
    expect(dir, isNotNull);
    expect(File('$dir/c.xhtml').existsSync(), isTrue);
    expect(reading.localMasterFor(_server, 'mf-epub'), isNull,
        reason: 'not playable');
    expect(LocalPlayQueue.build(_server, [entry], startKey: key).playQueueItems,
        isEmpty);

    await reading.remove(_server, key);
    expect(Directory(dir!).existsSync(), isFalse);
  });

  test('a network failure is retried on its own: on connectivity change and on schedule',
      () async {
    var online = false;
    final log = <String>[];
    final flaky = MockClient((req) async {
      if (!online) throw const SocketException('Failed host lookup');
      return _hlsHandler(log)(req);
    });
    final network = StreamController<void>.broadcast();
    var clock = DateTime(2026, 1, 1, 12);
    final svc = DownloadService(
      store: DownloadStore(rootOverride: root),
      downloader: HlsDownloader(
          httpClient: flaky,
          tokenProvider: (_) async => 'tok',
          backoff: (_) => const Duration(milliseconds: 1),
          maxAttempts: 2),
      connectivityChanges: network.stream,
      now: () => clock,
    );
    DownloadService.instance = svc;
    await svc.enqueue(_server, DownloadRequest(item: trackItem('t9')));
    final key = DownloadEntry.keyFor(DownloadKind.track, 't9');
    String state() { final e = svc.entryFor(_server, key); return '${e?.status} ${e?.error} rc=${e?.retryCount}'; }
    await _waitFor(() => svc.entryFor(_server, key)?.status == DownloadStatus.failed, describe: state);
    final failed = svc.entryFor(_server, key)!;
    expect(failed.retryable, isTrue);
    expect(failed.retryCount, 1);
    expect(failed.nextRetryAt, clock.add(const Duration(minutes: 5)));

    // Not due yet: the scheduled sweep leaves it alone.
    await svc.retryFailed();
    expect(svc.entryFor(_server, key)!.status, DownloadStatus.failed);

    // Connectivity changes while still offline: retried at once, fails again
    // with a longer delay.
    network.add(null);
    await _waitFor(() => svc.entryFor(_server, key)?.retryCount == 2, describe: state);
    expect(svc.entryFor(_server, key)!.nextRetryAt,
        clock.add(const Duration(minutes: 10)));

    // Back online and the retry time has come: completes.
    online = true;
    clock = clock.add(const Duration(minutes: 11));
    await svc.retryFailed();
    await _waitFor(() => svc.entryFor(_server, key)?.isComplete ?? false, describe: state);
    expect(svc.entryFor(_server, key)!.retryCount, 0);
    await network.close();
  });

  test('retryDelay doubles from five minutes up to an hour', () {
    expect(DownloadService.retryDelay(0), const Duration(minutes: 5));
    expect(DownloadService.retryDelay(1), const Duration(minutes: 10));
    expect(DownloadService.retryDelay(3), const Duration(minutes: 40));
    expect(DownloadService.retryDelay(8), const Duration(minutes: 60));
  });

  test('pause stops the run and resume finishes it', () async {
    await service.pauseAll();
    await service.enqueue(_server, DownloadRequest(item: trackItem('t3')));
    final key = DownloadEntry.keyFor(DownloadKind.track, 't3');
    await Future.delayed(const Duration(milliseconds: 50));
    expect(service.entryFor(_server, key)!.status, DownloadStatus.queued);
    expect(requests, isEmpty);

    await service.resumeAll();
    await _waitFor(() => service.entryFor(_server, key)?.isComplete ?? false);
  });
}

// ---- multi-episode files -------------------------------------------------

Fragment$fragmentPlayQueue$playQueueItems episodePartItem(
    int number, Fragment$fragmentMediaFiles file,
    {required int startMs, required int durationMs}) {
  final ep = Fragment$fragmentEpisode(
    id: 'e$number',
    number: number,
    mediaFile: [file],
    mediaFileParts: [
      Fragment$fragmentEpisode$mediaFileParts(
          startInMilliseconds: startMs.toDouble(),
          durationInMilliseconds: durationMs.toDouble(),
          mediaFile: file),
    ],
  );
  return Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true, id: 'local:episode:e$number', position: number.toDouble(), episode: ep);
}

// ---- reading entries -----------------------------------------------------
