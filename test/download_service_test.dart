import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/HlsDownloader.dart';
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

MockClient _hlsClient(List<String> log) => MockClient((req) async {
      final name = req.url.pathSegments.last;
      log.add(name);
      if (name == 'master.m3u8') return http.Response(_master, 200);
      if (name.endsWith('.m3u8')) return http.Response(_playlist, 200);
      if (name.endsWith('.ts')) return http.Response('x' * 100, 200);
      return http.Response('', 404);
    });

Future<void> _waitFor(bool Function() done) async {
  final end = DateTime.now().add(const Duration(seconds: 10));
  while (!done()) {
    if (DateTime.now().isAfter(end)) fail('timed out');
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
