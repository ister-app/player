import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/SleepTimerService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// When the item-counting sleep timer runs out, the queue must end up parked
/// on the *next* item, paused — so a listener who fell asleep and hits play
/// the next morning continues with fresh material instead of hearing the last
/// item again.
const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/music/$id.flac',
      size: 1,
      durationInMilliseconds: 180000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
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
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-$id')],
      ),
    );

Fragment$fragmentPlayQueue _queue(
        {List<Fragment$fragmentPlayQueue$playQueueItems>? items}) =>
    Fragment$fragmentPlayQueue(
      id: 'pq-1',
      currentItemId: 'item-1',
      progressInMilliseconds: 170000,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: items ?? [_trackItem('item-1', 1), _trackItem('item-2', 2)],
    );

MediaItem _queueMediaItem(String itemId, String title) => MediaItem(
      id: MediaItemId(_server, IsterMediaTypes.track, itemId).toString(),
      title: title,
      album: 'The Album',
    );

MockClient _fakeGraphQL(List<String> operations) => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final vars = body['variables'] as Map<String, dynamic>? ?? const {};
      Map<String, dynamic> payload;
      if (query.contains('updatePlayQueue')) {
        operations.add('updatePlayQueue:${vars['playQueueItemId']}');
        payload = {
          'data': {'__typename': 'Mutation', 'updatePlayQueue': _queue().toJson()}
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
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  Future<void> resetHandler() async {
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

  Future<List<String>> setUpOwnQueue(
      {List<Fragment$fragmentPlayQueue$playQueueItems>? items,
      List<MediaItem>? queueItems}) async {
    final operations = <String>[];
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL(operations)),
          cache: GraphQLCache(),
        );
    handler.serverName = _server;
    handler.graphQLClient = ClientManager.getClientForUrl(_server).value;
    handler.playQueue = _queue(items: items);
    handler.currentPlayQueueItem = (items ?? _queue().playQueueItems!).first;
    handler.queue.add(queueItems ??
        [
          _queueMediaItem('item-1', 'Track One'),
          _queueMediaItem('item-2', 'Track Two'),
        ]);
    handler.mediaItem.add(handler.queue.value.first);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    return operations;
  }

  test('an expired item timer parks the queue on the next item, paused',
      () async {
    final operations = await setUpOwnQueue();
    SleepTimerService.instance.startItems(1);

    handler.advanceAfterItemEnd();
    // The park runs async (suspend, then open the next item paused).
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(SleepTimerService.instance.isActive, isFalse);
    expect(handler.playQueue?.currentItemId, 'item-2');
    expect(handler.currentPlayQueueItem?.id, 'item-2');
    expect(handler.playbackState.value.queueIndex, 1);
    expect(handler.mediaItem.valueOrNull?.title, 'Track Two');
    expect(handler.playbackState.value.playing, isFalse);
    // The server learnt about the parked item so a restart resumes there too.
    expect(operations, contains('updatePlayQueue:item-2'));
  });

  test('an exhausted queue keeps the finished item loaded', () async {
    await setUpOwnQueue(
      items: [_trackItem('item-1', 1)],
      queueItems: [_queueMediaItem('item-1', 'Track One')],
    );
    SleepTimerService.instance.startItems(1);

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Nothing to park on: the finished item stays, like a normal queue end.
    expect(handler.playQueue?.currentItemId, 'item-1');
    expect(handler.mediaItem.valueOrNull?.title, 'Track One');
    expect(handler.playbackState.value.playing, isFalse);
  });
}
