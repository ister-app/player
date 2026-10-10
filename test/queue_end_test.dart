import 'dart:convert';
import 'dart:io';

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
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/QueueEnd.dart';
import 'package:player/utils/SleepTimerService.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/download/LocalPlayQueue.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// When the last queue item finishes, playback is torn down for good (no
/// session, no notification) but the handler keeps a snapshot of what ended,
/// so the surfaces stay put and offer "play again" instead of closing (video)
/// or sitting paused on a dead last item with a session that never expires
/// (audio).
const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/media/$id.mkv',
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

Fragment$fragmentMovie _movie() => Fragment$fragmentMovie(
      id: 'movie-1',
      name: 'The Movie',
      releaseYear: 2020,
      mediaFile: [_mediaFile('mf-movie-1')],
    );

Fragment$fragmentPlayQueue$playQueueItems _movieItem(String id) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: 1,
      movie: _movie(),
    );

Fragment$fragmentPlayQueue _queue({
  String id = 'pq-1',
  required List<Fragment$fragmentPlayQueue$playQueueItems> items,
  Enum$PlayQueueSourceType? sourceType,
  bool sourceExhausted = true,
}) =>
    Fragment$fragmentPlayQueue(
      id: id,
      currentItemId: items.first.id,
      progressInMilliseconds: 0,
      shuffle: false,
      sourceType: sourceType,
      sourceExhausted: sourceExhausted,
      controlAllowedUserIds: const [],
      playQueueItems: items,
    );

MediaItem _queueMediaItem(String itemId, String title) => MediaItem(
      id: MediaItemId(_server, IsterMediaTypes.track, itemId).toString(),
      title: title,
      album: 'The Album',
    );

/// Records every operation with the variables that matter here.
MockClient _fakeGraphQL(
        {required Fragment$fragmentPlayQueue queue,
        required List<String> operations}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final vars = body['variables'] as Map<String, dynamic>? ?? const {};
      Map<String, dynamic> payload;
      if (query.contains('query getPlayQueue')) {
        operations.add('getPlayQueue:${vars['id']}');
        payload = {
          'data': {'__typename': 'Query', 'getPlayQueue': queue.toJson()}
        };
      } else if (query.contains('updatePlayQueue')) {
        operations.add('updatePlayQueue:${vars['playQueueItemId']}'
            ':${vars['progressInMilliseconds']}:${vars['playState']}');
        payload = {
          'data': {'__typename': 'Mutation', 'updatePlayQueue': queue.toJson()}
        };
      } else if (query.contains('sendPlaybackCommand')) {
        operations.add('sendPlaybackCommand:${vars['command']}');
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

  Future<void> resetHandler() async {
    handler.queueEnded.value = null;
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.movie = null;
    handler.episode = null;
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

  List<String> useQueue(Fragment$fragmentPlayQueue queue) {
    final operations = <String>[];
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL(queue: queue, operations: operations)),
          cache: GraphQLCache(),
        );
    return operations;
  }

  /// A one-track album queue, started for real so a stream is "open" (the
  /// progress flush only writes for an open stream).
  Future<List<String>> startSingleTrackQueue() async {
    final pq = _queue(
        items: [_trackItem('item-1', 1)],
        sourceType: Enum$PlayQueueSourceType.ALBUM);
    final operations = useQueue(pq);
    await handler.startFromServerQueue(
        ClientManager.getClientForUrl(_server).value, pq, _server);
    handler.mediaItem.add(_queueMediaItem('item-1', 'Track One'));
    operations.clear();
    return operations;
  }

  /// A one-movie queue seeded directly, like the page leaves it.
  List<String> seedMovieQueue() {
    final pq = _queue(
        items: [_movieItem('item-m')],
        sourceType: Enum$PlayQueueSourceType.MOVIE);
    final operations = useQueue(pq);
    handler.serverName = _server;
    handler.graphQLClient = ClientManager.getClientForUrl(_server).value;
    handler.playQueue = pq;
    handler.currentPlayQueueItem = pq.playQueueItems!.first;
    handler.movie = _movie();
    handler.queue.add([
      MediaItem(
          id: MediaItemId(_server, IsterMediaTypes.movie, 'item-m').toString(),
          title: 'The Movie')
    ]);
    handler.mediaItem.add(handler.queue.value.first);
    handler.playbackState
        .add(handler.playbackState.value.copyWith(queueIndex: 0));
    return operations;
  }

  test('a video that plays out keeps its page and remembers what ended',
      () async {
    final operations = seedMovieQueue();
    final closeRequestsBefore = handler.closePlaybackRequest.value;

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final ended = handler.queueEnded.value;
    expect(ended, isNotNull);
    expect(ended!.kind, QueueEndKind.movie);
    expect(ended.isVideo, isTrue);
    expect(ended.movie?.id, 'movie-1');
    expect(ended.playQueue.id, 'pq-1');
    expect(ended.lastMediaItem.title, 'The Movie');
    expect(handler.closePlaybackRequest.value, closeRequestsBefore,
        reason: 'the page shows the ended state; it must not be closed');
    expect(handler.movie, isNull, reason: 'playback itself is torn down');
    expect(handler.playQueue, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
    expect(handler.playbackState.value.processingState,
        AudioProcessingState.idle);
    expect(operations, contains('sendPlaybackCommand:STOP'),
        reason: 'followers and remotes see the session end right away');
  });

  test('audio that plays out ends the session and remembers what ended',
      () async {
    final operations = await startSingleTrackQueue();
    final closeRequestsBefore = handler.closePlaybackRequest.value;

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final ended = handler.queueEnded.value;
    expect(ended, isNotNull);
    expect(ended!.kind, QueueEndKind.album);
    expect(ended.isVideo, isFalse);
    expect(ended.isLocal, isFalse);
    expect(ended.lastMediaItem.title, 'Track One');
    expect(ended.lastItem.id, 'item-1');
    expect(handler.closePlaybackRequest.value, closeRequestsBefore);
    expect(handler.mediaItem.valueOrNull, isNull,
        reason: 'nothing stays loaded: the notification goes away');
    expect(handler.playbackState.value.processingState,
        AudioProcessingState.idle);
    expect(operations, contains('updatePlayQueue:item-1:0:PAUSED'),
        reason: 'one last progress write for the finished item');
    expect(operations, contains('sendPlaybackCommand:STOP'));
  });

  test('dismissing the ended state closes the surfaces as an own stop',
      () async {
    seedMovieQueue();
    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final closeRequestsBefore = handler.closePlaybackRequest.value;

    handler.dismissQueueEnd();

    expect(handler.queueEnded.value, isNull);
    expect(handler.closePlaybackRequest.value, closeRequestsBefore + 1);
    expect(handler.lastPlaybackCloseKeepsPage, isTrue,
        reason: 'the page falls back to its cover, it is never popped');
  });

  test('replaying an ended video restarts it from the beginning on the same '
      'queue', () async {
    final operations = seedMovieQueue();
    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    operations.clear();

    await handler.replayEndedQueue();

    expect(handler.queueEnded.value, isNull);
    expect(handler.movie?.id, 'movie-1');
    expect(handler.playQueue?.id, 'pq-1');
    expect(operations, contains('getPlayQueue:pq-1'));
    expect(operations, contains('updatePlayQueue:item-m:0:null'),
        reason: 'the start position is 0, not the stale watch status');
  });

  test('play with nothing loaded after a queue ended replays it', () async {
    await startSingleTrackQueue();
    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(handler.playQueue, isNull);

    await handler.play();

    expect(handler.queueEnded.value, isNull);
    expect(handler.playQueue?.id, 'pq-1');
    expect(handler.playQueue?.currentItemId, 'item-1');
    expect(handler.currentPlayQueueItem?.id, 'item-1');
  });

  test('a queue built from downloads ends offline, marked finished',
      () async {
    final root = await Directory.systemTemp.createTemp('queue-end');
    addTearDown(() => root.delete(recursive: true));
    final progress = OfflineProgressStore(DownloadStore(rootOverride: root));
    OfflineProgressStore.useForTest(progress);
    addTearDown(OfflineProgressStore.resetForTest);
    final operations = useQueue(_queue(items: [_trackItem('item-1', 1)]));
    final pq = _queue(
        id: '${LocalPlayQueue.idPrefix}$_server:1',
        items: [_trackItem('item-1', 1)]);
    await handler.startLocalPlayQueue(_server, pq, openPlayer: false);
    handler.mediaItem.add(_queueMediaItem('item-1', 'Track One'));
    handler.playbackState.add(handler.playbackState.value
        .copyWith(updatePosition: const Duration(milliseconds: 180000)));
    operations.clear();

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final ended = handler.queueEnded.value;
    expect(ended, isNotNull);
    expect(ended!.isLocal, isTrue);
    expect(ended.kind, QueueEndKind.album,
        reason: 'no source type on a local queue: the item decides');
    expect(operations, isEmpty, reason: 'nothing goes to a server');
    final entry = progress.get(
        _server, DownloadEntry.keyFor(DownloadKind.track, 'track-item-1'));
    expect(entry?.finished, isTrue,
        reason: 'the final flush lands at the end, so the sync replays it '
            'as finished');
  });

  test('an item-counting sleep timer still parks instead of ending', () async {
    await startSingleTrackQueue();
    SleepTimerService.instance.startItems(1);

    handler.advanceAfterItemEnd();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(handler.queueEnded.value, isNull);
    expect(handler.mediaItem.valueOrNull?.title, 'Track One',
        reason: 'the listener is asleep: the finished item stays loaded');
  });
}
