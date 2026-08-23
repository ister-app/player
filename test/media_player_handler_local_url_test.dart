import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LastMusicQueuePreferences.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/LocalPlayQueue.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'download_service_test.dart' show trackItem, episodePartItem;
import 'package:player/graphql/fragmentMediafiles.graphql.dart';

const _server = 'test-server';

Fragment$fragmentPlayQueue _queue(List<Fragment$fragmentPlayQueue$playQueueItems> items) =>
    Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: items.first.id,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: items,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;
  late Directory root;
  late DownloadStore store;

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: MockClient((request) async {
              final query =
                  (json.decode(request.body) as Map)['query'] as String? ?? '';
              final payload = query.contains('playbackCommands')
                  ? {
                      'errors': [
                        {'message': 'no subscriptions in test'}
                      ]
                    }
                  : {
                      'data': {'__typename': 'Mutation', 'updatePlayQueue': null}
                    };
              return http.Response(json.encode(payload), 200,
                  headers: {'content-type': 'application/json'});
            })),
        cache: GraphQLCache(),
      );

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    root = await Directory.systemTemp.createTemp('dlhandler');
    store = DownloadStore(rootOverride: root);
    await store.root();
    DownloadService.instance = DownloadService(store: store);
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.serverName = null;
    handler.graphQLClient = null;
  });

  tearDown(() async {
    ClientManager.testClientBuilder = null;
    // Let the handler's fire-and-forget lastPlayedAt stamp land first.
    await Future.delayed(const Duration(milliseconds: 50));
    await root.delete(recursive: true);
  });

  Future<DownloadEntry> completeEntry(String trackId, {int sortKey = 0}) async {
    final item = trackItem(trackId);
    final entry = DownloadEntry(
      kind: DownloadKind.track,
      mediaId: trackId,
      mediaFileId: 'mf-$trackId',
      nodeUrl: 'https://node.example',
      groupId: 'album-1',
      groupTitle: 'The Album',
      title: 'Track $trackId',
      queueItemJson: item.toJson(),
      createdAt: DateTime.now(),
      status: DownloadStatus.complete,
      sortKey: sortKey,
    );
    await store.put(_server, entry);
    return entry;
  }

  test('a server queue opens the local mirror when the file is downloaded',
      () async {
    await completeEntry('t1');
    final items = [trackItem('t1'), trackItem('t2', number: 2)];
    await handler.startFromServerQueue(client(), _queue(items), _server);
    expect(handler.currentMediaUrl, endsWith('/mf-t1/master.m3u8'));
    expect(MediaPlayerHandler.isLocalMediaUrl(handler.currentMediaUrl!), isTrue);

    // The second track has no download: back to the server's HLS master.
    await handler.skipToNext();
    expect(handler.currentMediaUrl, startsWith('https://node.example/hls/mf-t2/'));
    expect(MediaPlayerHandler.isLocalMediaUrl(handler.currentMediaUrl!), isFalse);
  });

  test('a local queue plays without a client and is never remembered as last music queue',
      () async {
    final e1 = await completeEntry('t1', sortKey: 1);
    final e2 = await completeEntry('t2', sortKey: 2);
    await LastMusicQueuePreferences.save(_server, 'pq-old');
    final pq = LocalPlayQueue.build(_server, [e2, e1], startKey: e1.key);
    expect(LocalPlayQueue.isLocal(pq.id), isTrue);

    await handler.startLocalPlayQueue(_server, pq,
        startItemId: pq.currentItemId, openPlayer: false);
    expect(handler.isLocalQueue, isTrue);
    expect(handler.graphQLClient, isNull);
    expect(handler.currentMediaUrl, endsWith('/mf-t1/master.m3u8'));
    expect(handler.queue.value, hasLength(2));
    expect(handler.queue.value.first.id, contains('local:track:t1'));
    expect(await LastMusicQueuePreferences.get(), isNull);
  });

  test('a local queue opens a multi-episode slice at its own start', () async {
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
    );
    final e7 = episodePartItem(7, file, startMs: 1200000, durationMs: 1200000);
    final entry = DownloadEntry(
      kind: DownloadKind.episode,
      mediaId: 'e7',
      mediaFileId: 'mf-shared',
      nodeUrl: 'https://node.example',
      groupId: 'show',
      groupTitle: 'Show',
      title: 'E7',
      queueItemJson: e7.toJson(),
      createdAt: DateTime.now(),
      status: DownloadStatus.complete,
      sortKey: 7,
    );
    await store.put(_server, entry);
    final pq = LocalPlayQueue.build(_server, [entry], startKey: entry.key);

    await handler.startLocalPlayQueue(_server, pq,
        startItemId: pq.currentItemId, startTimeMs: null, openPlayer: false);
    expect(handler.currentMediaUrl, endsWith('/mf-shared/master.m3u8'));
    expect(handler.lastStartTimeMs, 1200000);

    // A position inside the slice is kept; one before it is clamped.
    await handler.startLocalPlayQueue(_server, pq,
        startItemId: pq.currentItemId, startTimeMs: 1500000, openPlayer: false);
    expect(handler.lastStartTimeMs, 1500000);
    await handler.startLocalPlayQueue(_server, pq,
        startItemId: pq.currentItemId, startTimeMs: 0, openPlayer: false);
    expect(handler.lastStartTimeMs, 1200000);
  });
}
