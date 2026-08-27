import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) =>
    Fragment$fragmentMediaFiles(
      id: id,
      path: '/media/$id.mp3',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'http://node.example'),
      ),
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
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

/// A smart playlist's queue as the server hands it back. [currentItemId] is
/// what the server picked: the requested start item when it supports one.
Fragment$fragmentPlayQueue _playlistQueue(String currentItemId) =>
    Fragment$fragmentPlayQueue(
      id: 'pq-playlist',
      currentItemId: currentItemId,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [
        _item('pl-item-1', 1),
        _item('pl-item-2', 2),
        _item('pl-item-3', 3),
      ],
    );

/// The queue item holding a track, as the server would resolve a startId.
String _itemForTrack(String? trackId) => switch (trackId) {
      'track-2' => 'pl-item-2',
      'track-3' => 'pl-item-3',
      _ => 'pl-item-1',
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // No video output plugin in a widget test: answer the texture-create call
  // with null so the handler's VideoController setup idles. The
  // MissingPluginException it throws otherwise arrives asynchronously, so it
  // lands on whichever test happens to be running and reports that one as
  // "did not complete" — a flake that moves around and never names its cause.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  /// createPlayQueue inputs the mock server received.
  final creates = <Map<String, dynamic>>[];

  /// Set to emulate a server that rejects a start item on a smart playlist.
  var rejectsStartId = false;

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
          final input = variables['input'] as Map<String, dynamic>;
          creates.add(input);
          final startId = input['startId'] as String?;
          if (startId != null && rejectsStartId) {
            payload = {
              'errors': [
                {'message': 'Smart playlist play queues cannot start at a specific item'}
              ]
            };
          } else {
            payload = {
              'data': {
                '__typename': 'Mutation',
                'createPlayQueue': _playlistQueue(_itemForTrack(startId)).toJson(),
              }
            };
          }
        } else if (query.contains('updatePlayQueue')) {
          payload = {
            'data': {
              '__typename': 'Mutation',
              'updatePlayQueue': _playlistQueue('pl-item-1').toJson(),
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
    creates.clear();
    rejectsStartId = false;
  });

  tearDown(() {
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
    ClientManager.testClientBuilder = null;
  });

  group('startPlaylistPlay', () {
    test('the start item goes to the server, which positions the queue',
        () async {
      await handler.startPlaylistPlay(client(), _server, 'pl-smart',
          startId: 'track-3');

      expect(creates.single['sourceType'], 'PLAYLIST');
      expect(creates.single['sourceId'], 'pl-smart');
      expect(creates.single['startId'], 'track-3');
      expect(handler.currentPlayQueueItem?.id, 'pl-item-3');
    });

    test('a server rejecting the start item retries plain and opens the item',
        () async {
      rejectsStartId = true;

      await handler.startPlaylistPlay(client(), _server, 'pl-smart',
          startId: 'track-3');

      expect(creates.length, 2, reason: 'one attempt with, one without');
      expect(creates.last.containsKey('startId'), isFalse);
      expect(handler.currentPlayQueueItem?.id, 'pl-item-3',
          reason: 'the item is inside the created window, so it still starts there');
      expect(handler.playQueue?.currentItemId, 'pl-item-3');
    });

    test('an item beyond the fallback queue starts at the queue start',
        () async {
      rejectsStartId = true;

      await handler.startPlaylistPlay(client(), _server, 'pl-smart',
          startId: 'track-999');

      expect(handler.currentPlayQueueItem?.id, 'pl-item-1');
      expect(handler.playQueue?.currentItemId, 'pl-item-1');
    });

    test('a shuffled playlist never retries without the start item', () async {
      rejectsStartId = true;

      await handler.startPlaylistPlay(client(), _server, 'pl-smart',
          startId: 'track-3', shuffle: true);

      expect(creates.length, 1);
      expect(handler.playQueue, isNull);
    });
  });
}
