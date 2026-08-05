import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/media/$id.mka',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'http://node.example'),
      ),
    );

final _album = Fragment$fragmentAlbum(
  id: 'album-1',
  name: 'The Album',
  releaseYear: 2020,
  artist: Fragment$fragmentAlbum$artist(id: 'artist-1', name: 'The Artist'),
);

Fragment$fragmentPlayQueue$playQueueItems _item(String id, int position) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: position.toDouble(),
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-$position',
        number: position,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-$position')],
      ),
    );

Fragment$fragmentPlayQueue _queue(String currentItemId) =>
    Fragment$fragmentPlayQueue(
      id: 'pq-album',
      currentItemId: currentItemId,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [_item('item-1', 1), _item('item-2', 2)],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  /// playQueueItemIds the mock server was told about, in order.
  final updatedItemIds = <String?>[];

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        final variables = (body['variables'] as Map<String, dynamic>?) ?? {};
        Map<String, dynamic> payload;
        if (query.contains('playbackCommands')) {
          payload = {
            'errors': [
              {'message': 'no subscriptions in test'}
            ]
          };
        } else if (query.contains('mutation createPlayQueue')) {
          payload = {
            'data': {
              '__typename': 'Mutation',
              'createPlayQueue': _queue('item-1').toJson(),
            }
          };
        } else if (query.contains('updatePlayQueue')) {
          final itemId = variables['playQueueItemId'] as String?;
          updatedItemIds.add(itemId);
          payload = {
            'data': {
              '__typename': 'Mutation',
              // The server echoes the item it was told is current.
              'updatePlayQueue': _queue(itemId ?? 'item-1').toJson(),
            }
          };
        } else {
          payload = {
            'data': {'__typename': 'Query'}
          };
        }
        return http.Response(json.encode(payload), 200,
            headers: {'content-type': 'application/json'});
      });

  GraphQLClient client() => GraphQLClient(
        link: HttpLink('https://api.example/graphql', httpClient: fakeGraphQL()),
        cache: GraphQLCache(),
      );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    updatedItemIds.clear();
  });

  tearDown(() {
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.album = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
    ClientManager.testClientBuilder = null;
  });

  test(
      'an item switch publishes one optimistic and one server-confirmed change, '
      'so a refetching subscriber only sees the confirmed one', () async {
    final c = client();
    await handler.startPlayQueueForAlbum(c, null, _album, 'track-1', _server);
    expect(handler.playQueue?.id, 'pq-album');

    final all = <String?>[];
    final confirmed = <String?>[];
    final subs = [
      PlayQueueService()
          .getPlayQueueChangedStream()
          .listen((q) => all.add(q.currentItemId)),
      PlayQueueService()
          .getPlayQueueChangedStream(includeOptimistic: false)
          .listen((q) => confirmed.add(q.currentItemId)),
    ];
    addTearDown(() {
      for (final s in subs) {
        s.cancel();
      }
    });

    // Auto-advance at the end of a track takes this same path.
    unawaited(handler.skipToQueueItem(1));
    for (var i = 0; i < 100 && !updatedItemIds.contains('item-2'); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(updatedItemIds, contains('item-2'));
    // Let the sync response land and publish.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // The optimistic emission precedes the updatePlayQueue round trip: a
    // subscriber that answers by re-querying the server would read the old
    // current item and visibly settle twice.
    expect(all, ['item-2', 'item-2'],
        reason: 'local state change first, server confirmation second');
    expect(confirmed, ['item-2']);
  });
}
