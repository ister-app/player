import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/SleepTimerService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// A source that grows server-side (`sourceExhausted == false`) may have
/// appended items the heartbeat has not shown the client yet. The end of the
/// *visible* queue is then not the end: the handler fetches the queue once
/// more and carries on when it grew.
const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/music/$id.flac',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        servingNode: Fragment$fragmentMediaFiles$directory$servingNode(
            url: 'http://node.example'),
      ),
    );

Fragment$fragmentPlayQueue$playQueueItems _trackItem(String id, double position) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: position,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-$id',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        artists: const [],
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

Fragment$fragmentPlayQueue _queue({
  required List<Fragment$fragmentPlayQueue$playQueueItems> items,
  required bool sourceExhausted,
}) =>
    Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: items.first.id,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: Enum$PlayQueueSourceType.ARTIST,
      sourceExhausted: sourceExhausted,
      controlAllowedUserIds: const [],
      playQueueItems: items,
    );

MediaItem _queueMediaItem(String itemId, String title) => MediaItem(
      id: MediaItemId(_server, IsterMediaTypes.track, itemId).toString(),
      title: title,
      album: 'The Album',
    );

/// `getPlayQueue` answers with [fetched]; the heartbeat (`updatePlayQueue`)
/// answers with [beat] — the two can disagree, which is the whole point.
MockClient _fakeGraphQL({
  required Fragment$fragmentPlayQueue Function() fetched,
  required Fragment$fragmentPlayQueue Function() beat,
  required List<String> operations,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('query getPlayQueue')) {
        operations.add('getPlayQueue');
        payload = {
          'data': {'__typename': 'Query', 'getPlayQueue': fetched().toJson()}
        };
      } else if (query.contains('updatePlayQueueHeartbeat')) {
        operations.add('heartbeat');
        payload = {
          'data': {'__typename': 'Mutation', 'updatePlayQueue': beat().toJson()}
        };
      } else if (query.contains('updatePlayQueue')) {
        // The full update after a skip answers with the server's queue.
        operations.add('updatePlayQueue');
        payload = {
          'data': {
            '__typename': 'Mutation',
            'updatePlayQueue': fetched().toJson()
          }
        };
      } else if (query.contains('sendPlaybackCommand')) {
        operations.add('sendPlaybackCommand');
        payload = {
          'data': {'__typename': 'Mutation', 'sendPlaybackCommand': true}
        };
      } else if (query.contains('subscription')) {
        payload = {
          'errors': [
            {'message': 'no subscriptions in test'}
          ]
        };
      } else {
        operations.add('other');
        payload = {
          'data': {'__typename': 'Query'}
        };
      }
      return http.Response(json.encode(payload), 200,
          headers: {'content-type': 'application/json'});
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  Future<void> resetHandler() async {
    handler.queueEnded.value = null;
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
  }

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    SleepTimerService.instance.showMessage = (_) {};
    await resetHandler();
  });

  tearDown(() async {
    SleepTimerService.instance.notifyPlaybackStopped();
    await resetHandler();
    ClientManager.testClientBuilder = null;
  });

  final oneItem = [_trackItem('item-1', 1)];
  final twoItems = [_trackItem('item-1', 1), _trackItem('item-2', 2)];

  /// Starts a one-item queue whose source is [exhausted] or not; the server
  /// answers a refetch with [fetched].
  Future<List<String>> start({
    required bool exhausted,
    required Fragment$fragmentPlayQueue fetched,
    Fragment$fragmentPlayQueue? beat,
  }) async {
    final operations = <String>[];
    final initial = _queue(items: oneItem, sourceExhausted: exhausted);
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL(
                  fetched: () => fetched,
                  beat: () => beat ?? initial,
                  operations: operations)),
          cache: GraphQLCache(),
        );
    await handler.startFromServerQueue(
        ClientManager.getClientForUrl(_server).value, initial, _server);
    handler.mediaItem.add(_queueMediaItem('item-1', 'Track One'));
    operations.clear();
    return operations;
  }

  test('a growing source is fetched once more and playback carries on',
      () async {
    final operations = await start(
        exhausted: false,
        fetched: _queue(items: twoItems, sourceExhausted: false));

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(operations, contains('getPlayQueue'));
    expect(handler.queueEnded.value, isNull);
    expect(handler.playQueue?.currentItemId, 'item-2');
    expect(handler.currentPlayQueueItem?.id, 'item-2');
    expect(operations, isNot(contains('sendPlaybackCommand')),
        reason: 'the session goes on');
  });

  test('a growing source that did not grow is the end after all', () async {
    final operations = await start(
        exhausted: false,
        fetched: _queue(items: oneItem, sourceExhausted: true));

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(operations, contains('getPlayQueue'));
    expect(handler.queueEnded.value, isNotNull);
    expect(handler.playQueue, isNull);
    expect(operations, contains('sendPlaybackCommand'));
  });

  test('an exhausted source ends without a round-trip', () async {
    final operations = await start(
        exhausted: true,
        fetched: _queue(items: twoItems, sourceExhausted: false));

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(operations, isNot(contains('getPlayQueue')));
    expect(handler.queueEnded.value, isNotNull);
  });

  test('the heartbeat response updates the exhausted flag', () async {
    final operations = await start(
        exhausted: false,
        fetched: _queue(items: twoItems, sourceExhausted: false),
        beat: _queue(items: oneItem, sourceExhausted: true));
    expect(handler.playQueue?.sourceExhausted, isFalse);

    // A pause flushes progress: the beat's answer says the source ran dry.
    await handler.pause();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(handler.playQueue?.sourceExhausted, isTrue);
    operations.clear();

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(operations, isNot(contains('getPlayQueue')));
    expect(handler.queueEnded.value, isNotNull);
  });
}
