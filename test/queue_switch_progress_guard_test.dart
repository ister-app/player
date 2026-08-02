import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

Fragment$fragmentMediaFiles _mediaFile(String id) => Fragment$fragmentMediaFiles(
      id: id,
      path: '/media/$id.mkv',
      size: 1,
      durationInMilliseconds: 2400000,
      directory: Fragment$fragmentMediaFiles$directory(
        node: Fragment$fragmentMediaFiles$directory$node(
            url: 'http://node.example'),
      ),
    );

final _episode = Fragment$fragmentEpisode(
  id: 'ep-1',
  number: 1,
  $show: Fragment$fragmentEpisode$show(id: 'show-1'),
  mediaFile: [_mediaFile('mf-ep')],
  watchStatus: [
    Fragment$fragmentEpisode$watchStatus(
      id: 'ws-1',
      playQueueItemId: 'ep-item-1',
      progressInMilliseconds: 2400000,
      watched: true,
    ),
  ],
);

final _album = Fragment$fragmentAlbum(
  id: 'album-1',
  name: 'The Album',
  releaseYear: 2020,
  artist: Fragment$fragmentAlbum$artist(id: 'artist-1', name: 'The Artist'),
);

final _episodeQueue = Fragment$fragmentPlayQueue(
  id: 'pq-episode',
  currentItemId: 'ep-item-1',
  progressInMilliseconds: 0,
  shuffle: false,
  sourceExhausted: true,
  controlAllowedUserIds: const [],
  playQueueItems: [
    Fragment$fragmentPlayQueue$playQueueItems(id: 'ep-item-1', position: 1),
  ],
);

final _albumQueue = Fragment$fragmentPlayQueue(
  id: 'pq-album',
  currentItemId: 'alb-item-1',
  progressInMilliseconds: 0,
  shuffle: false,
  sourceExhausted: true,
  controlAllowedUserIds: const [],
  playQueueItems: [
    Fragment$fragmentPlayQueue$playQueueItems(
      id: 'alb-item-1',
      position: 1,
      track: Fragment$fragmentPlayQueue$playQueueItems$track(
        id: 'track-1',
        number: 1,
        discNumber: 1,
        artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
            id: 'artist-1', name: 'The Artist'),
        album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
            id: 'album-1', name: 'The Album'),
        mediaFile: [_mediaFile('mf-track')],
      ),
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  /// updatePlayQueue mutations the mock server received, as their variables.
  final updates = <Map<String, dynamic>>[];

  /// While set, createPlayQueue for the ALBUM source blocks on this — the
  /// window under test, where the episode queue is still the active one.
  Completer<void>? albumCreateGate;

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        final variables = (body['variables'] as Map<String, dynamic>?) ?? {};
        Map<String, dynamic> payload;
        if (query.contains('playbackCommands')) {
          // Party-mode subscription: no live subscriptions in a widget test.
          payload = {
            'errors': [
              {'message': 'no subscriptions in test'}
            ]
          };
        } else if (query.contains('mutation createPlayQueue')) {
          final input = variables['input'] as Map<String, dynamic>;
          if (input['sourceType'] == 'ALBUM') {
            final gate = albumCreateGate;
            if (gate != null) await gate.future;
            payload = {
              'data': {
                '__typename': 'Mutation',
                'createPlayQueue': _albumQueue.toJson(),
              }
            };
          } else {
            payload = {
              'data': {
                '__typename': 'Mutation',
                'createPlayQueue': _episodeQueue.toJson(),
              }
            };
          }
        } else if (query.contains('updatePlayQueue')) {
          updates.add(variables);
          final echoed =
              variables['id'] == 'pq-album' ? _albumQueue : _episodeQueue;
          payload = {
            'data': {
              '__typename': 'Mutation',
              'updatePlayQueue': echoed.toJson(),
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

  Iterable<Object?> updatedItemIds() =>
      updates.map((u) => u['playQueueItemId']);

  Future<void> waitForUpdateOf(String playQueueItemId) async {
    for (var i = 0;
        i < 100 && !updatedItemIds().contains(playQueueItemId);
        i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(updatedItemIds(), contains(playQueueItemId));
  }

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => client();
    updates.clear();
    albumCreateGate = null;
  });

  tearDown(() {
    handler.playQueue = null;
    handler.currentPlayQueueItem = null;
    handler.currentTrackId = null;
    handler.episode = null;
    handler.album = null;
    handler.serverName = null;
    handler.graphQLClient = null;
    handler.queue.add([]);
    handler.mediaItem.add(null);
    handler.mediaLoading.value = false;
    ClientManager.testClientBuilder = null;
  });

  test(
      'a progress sync fired while an album queue switch is in flight cannot '
      'overwrite the previous episode\'s progress', () async {
    final c = client();
    await handler.startPlayQueue(c, null, _episode, _server);
    expect(handler.playQueue?.id, 'pq-episode');

    // Baseline: with the episode stream open, a forced sync (pause) reaches
    // the server for the episode's queue item. pause() is not awaited — under
    // flutter test the mpv call inside it never completes, but the progress
    // update is fired before it.
    unawaited(handler.pause());
    await waitForUpdateOf('ep-item-1');
    updates.clear();

    // Start the album while holding the createPlayQueue response open: this
    // is the round-trip window in which the watchdog used to re-open the
    // episode stream and its position events reverted the watched status.
    albumCreateGate = Completer<void>();
    final switching =
        handler.startPlayQueueForAlbum(c, null, _album, 'track-1', _server);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    // A forced sync inside the window (the dying stream's position events,
    // the heartbeat, a pause) must be dropped entirely — the active queue
    // state still points at the episode and would be overwritten.
    unawaited(handler.pause());
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(updates, isEmpty);

    // Release the round-trip: the switch completes on the album queue and
    // progress syncs flow again — for the track, never the episode.
    albumCreateGate!.complete();
    albumCreateGate = null;
    await switching;
    expect(handler.playQueue?.id, 'pq-album');

    unawaited(handler.play());
    await waitForUpdateOf('alb-item-1');
    expect(updatedItemIds(), isNot(contains('ep-item-1')));
  });
}
