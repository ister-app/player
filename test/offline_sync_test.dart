import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';
import 'package:player/utils/download/OfflineSyncService.dart';

import 'download_service_test.dart' show trackItem;

const _server = 'srv';

void main() {
  late Directory root;
  late DownloadStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('offsync');
    store = DownloadStore(rootOverride: root);
    DownloadService.instance = DownloadService(store: store);
    OfflineProgressStore.resetForTest();
    OfflineSyncService.resetForTest();
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  GraphQLClient client(List<Map<String, dynamic>> calls, {bool fail = false}) =>
      GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: MockClient((request) async {
              final body = json.decode(request.body) as Map<String, dynamic>;
              final query = body['query'] as String;
              final vars = body['variables'] as Map<String, dynamic>? ?? {};
              if (fail) return http.Response('boom', 500);
              Map<String, dynamic> payload;
              if (query.contains('createPlayQueue')) {
                calls.add({'op': 'create', ...vars});
                final startId = (vars['input'] as Map)['startId'] as String;
                final pq = Fragment$fragmentPlayQueue(
                  id: 'pq-$startId',
                  currentItemId: 'server-item-$startId',
                  progressInMilliseconds: 0,
                  shuffle: false,
                  sourceExhausted: true,
                  controlAllowedUserIds: const [],
                  playQueueItems: [
                    trackItem(startId).copyWith(id: 'server-item-$startId'),
                  ],
                );
                payload = {
                  'data': {'__typename': 'Mutation', 'createPlayQueue': pq.toJson()}
                };
              } else if (query.contains('updatePlayQueue')) {
                calls.add({'op': 'update', ...vars});
                payload = {
                  'data': {'__typename': 'Mutation', 'updatePlayQueue': null}
                };
              } else {
                payload = {'data': {'__typename': 'Query'}};
              }
              return http.Response(json.encode(payload), 200,
                  headers: {'content-type': 'application/json'});
            })),
        cache: GraphQLCache(),
      );

  test('records progress per item and replays one queue per item', () async {
    final progress = OfflineProgressStore.instance;
    await progress.record(_server, trackItem('a'), positionMs: 30000, durationMs: 180000);
    await progress.record(_server, trackItem('a'), positionMs: 45000, durationMs: 180000);
    await progress.record(_server, trackItem('b'), positionMs: 176000, durationMs: 180000, finished: true);
    expect(progress.unsynced(_server), hasLength(2));

    // Survives a reload from disk.
    OfflineProgressStore.resetForTest();
    await OfflineProgressStore.instance.load(_server);
    expect(OfflineProgressStore.instance.get(_server, 'track:a')!.positionMs, 45000);

    final calls = <Map<String, dynamic>>[];
    final n = await OfflineSyncService.trySync(_server, client: client(calls));
    expect(n, 2);
    expect(calls.where((c) => c['op'] == 'create'), hasLength(2));
    final creates = calls.where((c) => c['op'] == 'create').map((c) => c['input'] as Map).toList();
    expect(creates.first['sourceType'], 'ALBUM');
    expect(creates.first['sourceId'], 'album-1');
    expect(creates.first['startId'], 'a');
    final updates = calls.where((c) => c['op'] == 'update').toList();
    expect(updates, hasLength(2));
    expect(updates[0]['playQueueItemId'], 'server-item-a');
    expect(updates[0]['progressInMilliseconds'], 45000);
    // A finished item reports its full length so the server marks it watched.
    expect(updates[1]['progressInMilliseconds'], 180000);
    expect(OfflineProgressStore.instance.unsynced(_server), isEmpty);

    // Nothing left: a second run is a no-op.
    expect(await OfflineSyncService.trySync(_server, client: client(calls), force: true), 0);
  });

  test('a failing server leaves entries unsynced for next time', () async {
    await OfflineProgressStore.instance
        .record(_server, trackItem('a'), positionMs: 1000, durationMs: 5000);
    final n = await OfflineSyncService.trySync(_server, client: client([], fail: true));
    expect(n, 0);
    expect(OfflineProgressStore.instance.unsynced(_server), hasLength(1));
    // Not marked as "done this run": the next shell connect retries.
    final calls = <Map<String, dynamic>>[];
    expect(await OfflineSyncService.trySync(_server, client: client(calls)), 1);
  });
}
