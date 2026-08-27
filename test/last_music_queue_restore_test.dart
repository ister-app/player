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
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LastMusicQueuePreferences.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

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

Fragment$fragmentPlayQueue$playQueueItems _trackItem(String id, double position,
        {bool withFile = true}) =>
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
        mediaFile: withFile ? [_mediaFile('mf-$id')] : const [],
      ),
    );

Fragment$fragmentPlayQueue _musicQueue({
  String id = 'pq-1',
  String? currentItemId = 'item-2',
  int progressInMilliseconds = 42000,
  List<Fragment$fragmentPlayQueue$playQueueItems>? items,
}) =>
    Fragment$fragmentPlayQueue(
      id: id,
      currentItemId: currentItemId,
      progressInMilliseconds: progressInMilliseconds,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems:
          items ?? [_trackItem('item-1', 1), _trackItem('item-2', 2)],
    );

/// Serves getPlayQueue with [queue] (or null when absent) and echoes the queue
/// on updatePlayQueue; every other operation gets an empty-but-valid response.
MockClient _fakeGraphQL(Fragment$fragmentPlayQueue? queue) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('query getPlayQueue')) {
        payload = {
          'data': {'__typename': 'Query', 'getPlayQueue': queue?.toJson()}
        };
      } else if (query.contains('updatePlayQueue')) {
        payload = {
          'data': {
            '__typename': 'Mutation',
            'updatePlayQueue': queue?.toJson(),
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

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  void resetHandler() {
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
  }

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    resetHandler();
  });

  tearDown(() {
    // Not handler.stop(): that awaits AudioSession.instance, which never
    // resolves without a platform. The restore paths under test start no
    // heartbeat or subscription, so resetting the fields is enough.
    resetHandler();
    ClientManager.testClientBuilder = null;
  });

  test('preferences round-trip and clear', () async {
    expect(await LastMusicQueuePreferences.get(), isNull);
    await LastMusicQueuePreferences.save(_server, 'pq-1');
    final stored = await LastMusicQueuePreferences.get();
    expect(stored?.serverName, _server);
    expect(stored?.playQueueId, 'pq-1');
    await LastMusicQueuePreferences.clear();
    expect(await LastMusicQueuePreferences.get(), isNull);
  });

  test('restores the stored queue paused into the mini-player state', () async {
    useClient(_fakeGraphQL(_musicQueue()));
    await LastMusicQueuePreferences.save(_server, 'pq-1');
    final openRequestsBefore = handler.openMusicPlayerRequest.value;

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue?.id, 'pq-1');
    expect(handler.serverName, _server);
    expect(handler.currentPlayQueueItem?.id, 'item-2');
    expect(handler.currentTrackId, 'track-item-2');
    expect(handler.queue.value, hasLength(2));
    // Paused: nothing started playing and the full player was not opened.
    expect(handler.playbackState.value.playing, isFalse);
    expect(handler.openMusicPlayerRequest.value, openRequestsBefore);
    // The stored pointer survives a successful restore.
    expect(await LastMusicQueuePreferences.get(), isNotNull);
  });

  test('does nothing when the stored queue belongs to another server',
      () async {
    useClient(_fakeGraphQL(_musicQueue()));
    await LastMusicQueuePreferences.save('other-server', 'pq-1');

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
    // Kept: opening other-server later should still restore it.
    expect(await LastMusicQueuePreferences.get(), isNotNull);
  });

  test('does nothing when nothing is stored', () async {
    useClient(_fakeGraphQL(_musicQueue()));

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
  });

  test('never clobbers an already-active queue', () async {
    useClient(_fakeGraphQL(_musicQueue()));
    await LastMusicQueuePreferences.save(_server, 'pq-1');
    final active = _musicQueue(id: 'pq-live', currentItemId: 'item-1');
    handler.playQueue = active;

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue?.id, 'pq-live');
  });

  test('keeps the stored pointer when the fetch fails', () async {
    useClient(_fakeGraphQL(null));
    await LastMusicQueuePreferences.save(_server, 'pq-1');

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue, isNull);
    expect(await LastMusicQueuePreferences.get(), isNotNull);
  });

  test('clears the stored pointer when the queue moved on to non-music',
      () async {
    // Current item carries no track (e.g. the queue was reused for an
    // episode); the restore must forget it instead of loading it.
    final nonMusic = _musicQueue(
      currentItemId: 'item-x',
      items: [
        Fragment$fragmentPlayQueue$playQueueItems(accessible: true, id: 'item-x', position: 1),
      ],
    );
    useClient(_fakeGraphQL(nonMusic));
    await LastMusicQueuePreferences.save(_server, 'pq-1');

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
    expect(await LastMusicQueuePreferences.get(), isNull);
  });

  test('the Android Auto recent tile serves the stored queue current track '
      'without loading the player', () async {
    useClient(_fakeGraphQL(_musicQueue()));
    await LastMusicQueuePreferences.save(_server, 'pq-1');

    final children = await handler.getChildren(AudioService.recentRootId);

    // The tile itself is metadata only — the browse answer must stay fast —
    // and its id matches what the restore publishes.
    expect(children.single.id,
        MediaItemId(_server, IsterMediaTypes.track, 'item-2').toString());

    // The same browse request kicked the restore in the background; once it
    // lands the session holds the queue paused, ready for a resume.
    for (var i = 0; i < 100 && handler.playQueue == null; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(handler.playQueue?.id, 'pq-1');
    expect(handler.playbackState.value.playing, isFalse);
    expect(handler.mediaItem.valueOrNull?.id, children.single.id);
  });

  test('clears the stored pointer when the current track lost its media file',
      () async {
    final fileless = _musicQueue(
      currentItemId: 'item-1',
      items: [_trackItem('item-1', 1, withFile: false)],
    );
    useClient(_fakeGraphQL(fileless));
    await LastMusicQueuePreferences.save(_server, 'pq-1');

    await handler.restoreLastMusicQueue(_server);

    expect(handler.playQueue, isNull);
    expect(await LastMusicQueuePreferences.get(), isNull);
  });
}
