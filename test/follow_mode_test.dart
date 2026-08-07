import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
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
        {bool accessible = true}) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: accessible,
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

Fragment$fragmentMovie _movie({String id = 'movie-1'}) => Fragment$fragmentMovie(
      id: id,
      name: 'The Movie',
      releaseYear: 2020,
      mediaFile: [_mediaFile('mf-$id')],
    );

Fragment$fragmentPlayQueue$playQueueItems _movieItem(String id, double position) =>
    Fragment$fragmentPlayQueue$playQueueItems(
      accessible: true,
      id: id,
      position: position,
      movie: _movie(id: 'movie-$id'),
    );

Fragment$fragmentPlayQueue _queue({
  String id = 'pq-follow',
  String? currentItemId = 'item-1',
  int progressInMilliseconds = 30000,
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

Fragment$fragmentPlaybackSession _session({
  String playQueueId = 'pq-follow',
  String? playQueueItemId = 'item-1',
  int progressInMilliseconds = 30000,
  Enum$PlayState playState = Enum$PlayState.PLAYING,
  int? anchorPositionMs,
  double? anchorServerTimeMs,
}) =>
    Fragment$fragmentPlaybackSession(
      playQueueId: playQueueId,
      playQueueItemId: playQueueItemId,
      userId: 'owner-1',
      userName: 'Owner',
      progressInMilliseconds: progressInMilliseconds,
      playState: playState,
      nodeName: 'node-1',
      updatedAt: '2026-08-02T12:00:00Z',
      controllable: true,
      followerCount: 1,
      anchorPositionMs: anchorPositionMs,
      anchorServerTimeMs: anchorServerTimeMs,
    );

/// GraphQL stub for the follow flow. Records every operation name so tests
/// can assert what the follower did (and did not) send.
MockClient _fakeGraphQL({
  required Fragment$fragmentPlayQueue? queue,
  Enum$FollowResult followResult = Enum$FollowResult.OK,
  required List<String> operations,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      Map<String, dynamic> payload;
      if (query.contains('followPlayQueue')) {
        operations.add('followPlayQueue');
        payload = {
          'data': {
            '__typename': 'Mutation',
            'followPlayQueue': followResult.name,
          }
        };
      } else if (query.contains('query getPlayQueue')) {
        operations.add('getPlayQueue');
        payload = {
          'data': {'__typename': 'Query', 'getPlayQueue': queue?.toJson()}
        };
      } else if (query.contains('updatePlayQueue')) {
        operations.add('updatePlayQueue');
        payload = {
          'data': {'__typename': 'Mutation', 'updatePlayQueue': queue?.toJson()}
        };
      } else if (query.contains('sendPlaybackCommand')) {
        operations.add('sendPlaybackCommand');
        payload = {
          'data': {'__typename': 'Mutation', 'sendPlaybackCommand': true}
        };
      } else if (query.contains('subscription nowPlaying')) {
        operations.add('subscribe:nowPlaying');
        // Single HTTP result; the follower treats it as the current list.
        payload = {
          'data': {
            '__typename': 'Subscription',
            'nowPlaying': [_session().toJson()],
          }
        };
      } else if (query.contains('playbackCommands')) {
        operations.add('subscribe:playbackCommands');
        // A command the client doesn't know parses to $unknown and is ignored.
        payload = {
          'data': {
            '__typename': 'Subscription',
            'playbackCommands': {
              '__typename': 'PlaybackCommand',
              'playQueueId': 'pq-follow',
              'command': 'TEST_NOOP',
              'positionInMilliseconds': null,
              'playQueueItemId': null,
              'timestamp': '2026-08-02T12:00:00Z',
            }
          }
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

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  Future<void> resetHandler() async {
    await handler.stopFollowing(notifyServer: false);
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
    await resetHandler();
  });

  tearDown(() async {
    await resetHandler();
    ClientManager.testClientBuilder = null;
  });

  test('startFollowingQueue loads the queue and never reports progress',
      () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));

    final result =
        await handler.startFollowingQueue(_server, 'pq-follow');

    expect(result, Enum$FollowResult.OK);
    expect(handler.followMode, isTrue);
    expect(handler.followModeNotifier.value, isTrue);
    expect(handler.playQueue?.id, 'pq-follow');
    expect(handler.currentPlayQueueItem?.id, 'item-1');
    expect(handler.queue.value, hasLength(2));
    // The follower registered and fetched, but sent no updatePlayQueue.
    expect(operations, contains('followPlayQueue'));
    expect(operations, contains('getPlayQueue'));
    expect(operations, isNot(contains('updatePlayQueue')));
  });

  test('the own live queue is recognised, a followed one is not', () async {
    // Own playback: the listen-along affordances must disappear for it.
    handler.serverName = _server;
    handler.playQueue = _queue();
    expect(handler.isOwnLiveQueue(_server, 'pq-follow'), isTrue);
    expect(handler.isOwnLiveQueue(_server, 'pq-other'), isFalse);
    expect(handler.isOwnLiveQueue('other-server', 'pq-follow'), isFalse);

    // Following the same queue is someone else's session, not our own.
    useClient(_fakeGraphQL(queue: _queue(), operations: []));
    await handler.startFollowingQueue(_server, 'pq-follow');
    expect(handler.isOwnLiveQueue(_server, 'pq-follow'), isFalse);
  });

  test('a denied follow leaves the handler untouched', () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(
        queue: _queue(),
        followResult: Enum$FollowResult.NO_LIBRARY_ACCESS,
        operations: operations));

    final result =
        await handler.startFollowingQueue(_server, 'pq-follow');

    expect(result, Enum$FollowResult.NO_LIBRARY_ACCESS);
    expect(handler.followMode, isFalse);
    expect(handler.playQueue, isNull);
    expect(operations, isNot(contains('getPlayQueue')));
  });

  test('transport on a follower becomes a playback command, not local state',
      () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');
    operations.clear();

    await handler.pause();
    await handler.skipToNext();

    expect(operations.where((op) => op == 'sendPlaybackCommand'), hasLength(2));
    expect(operations, isNot(contains('updatePlayQueue')));
  });

  test('a leader item change over now-playing skips the follower along',
      () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');

    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-2', progressInMilliseconds: 0)]);

    expect(handler.currentPlayQueueItem?.id, 'item-2');
    // Following the leader still never reports progress.
    expect(operations, isNot(contains('updatePlayQueue')));
  });

  test('an emission without the followed session ends follow mode', () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');

    final closeRequests = handler.closePlaybackRequest.value;
    operations.clear();

    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueId: 'someone-elses-queue')]);

    expect(handler.followMode, isFalse);
    expect(handler.followModeNotifier.value, isFalse);
    // The leader's media is gone: playback ends here rather than staying
    // paused, so no mini player (null mediaItem) and no dead queue survive.
    expect(handler.playQueue, isNull);
    expect(handler.currentPlayQueueItem, isNull);
    expect(handler.serverName, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
    expect(handler.queue.value, isEmpty);
    expect(handler.playbackState.value.playing, isFalse);
    expect(handler.playbackState.value.processingState,
        AudioProcessingState.idle);
    // The UI is asked to close what it opened for the media.
    expect(handler.closePlaybackRequest.value, closeRequests + 1);
    // A follower is not the progress writer for the shared queue, not even on
    // its way out.
    expect(operations, isNot(contains('updatePlayQueue')));
  });

  test('endPlaybackLocally tears own playback down and can skip the flush',
      () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    handler.serverName = _server;
    handler.playQueue = _queue();
    handler.currentPlayQueueItem = _trackItem('item-1', 1);
    handler.graphQLClient = ClientManager.getClientForUrl(_server).value;
    final closeRequests = handler.closePlaybackRequest.value;

    // Handoff to another device: the target owns the progress from now on, so
    // this device must not write one more position. (With no stream open the
    // flush is a no-op either way here; what this pins down is the state that
    // is left behind.)
    await handler.endPlaybackLocally(flushProgress: false);

    expect(handler.playQueue, isNull);
    expect(handler.graphQLClient, isNull);
    expect(handler.mediaItem.valueOrNull, isNull);
    expect(handler.queue.value, isEmpty);
    expect(handler.closePlaybackRequest.value, closeRequests + 1);
    expect(operations, isNot(contains('updatePlayQueue')));
  });


  test('an inaccessible current item stays silent but keeps the index',
      () async {
    final operations = <String>[];
    final queue = _queue(items: [
      _trackItem('item-1', 1),
      _trackItem('item-2', 2, accessible: false),
    ]);
    useClient(_fakeGraphQL(queue: queue, operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');

    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-2', progressInMilliseconds: 0)]);

    // The index tracks the leader, but nothing opened for the blocked item.
    expect(handler.currentPlayQueueItem?.id, 'item-2');
    expect(handler.playQueue?.currentItemId, 'item-2');
    expect(operations, isNot(contains('updatePlayQueue')));

    // The leader moving on to an accessible item resumes playback.
    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-1', progressInMilliseconds: 0)]);
    expect(handler.currentPlayQueueItem?.id, 'item-1');
  });

  test('the tight-sync anchor is stored from now-playing and cleared without one',
      () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');

    await handler.debugApplyFollowNowPlaying([
      _session(
          progressInMilliseconds: 31000,
          anchorPositionMs: 30950,
          anchorServerTimeMs: 1760000000000)
    ]);
    expect(handler.debugFollowAnchor?.positionMs, 30950);
    expect(handler.debugFollowAnchor?.serverTimeMs, 1760000000000);
    expect(handler.debugFollowAnchor?.itemId, 'item-1');

    // An emission without anchor fields (older leader) clears it, so the
    // discipline loop falls back to the coarse sync.
    await handler.debugApplyFollowNowPlaying([_session()]);
    expect(handler.debugFollowAnchor, isNull);
  });

  test('stopFollowing deregisters and clears the follow state', () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');
    operations.clear();

    await handler.stopFollowing();
    // The deregistration is fired without awaiting; let it land.
    await Future<void>.delayed(Duration.zero);

    expect(handler.followMode, isFalse);
    expect(operations, contains('followPlayQueue'));
  });

  test('starting own playback of another queue leaves follow mode', () async {
    final operations = <String>[];
    useClient(_fakeGraphQL(queue: _queue(), operations: operations));
    await handler.startFollowingQueue(_server, 'pq-follow');
    operations.clear();

    await handler.startPlayQueueForMovie(
        ClientManager.getClientForUrl(_server).value, null, _movie(), _server);
    // The deregistration is fired without awaiting; let it land.
    await Future<void>.delayed(Duration.zero);

    expect(handler.followMode, isFalse);
    expect(handler.followModeNotifier.value, isFalse);
    expect(operations, contains('followPlayQueue'));
  });

  test('joining a video session requests the video page, not the music player',
      () async {
    final queue = _queue(items: [_movieItem('item-1', 1)]);
    useClient(_fakeGraphQL(queue: queue, operations: []));
    final videoBumps = handler.openVideoPageRequest.value;
    final musicBumps = handler.openMusicPlayerRequest.value;

    await handler.startFollowingQueue(_server, 'pq-follow');

    expect(handler.openVideoPageRequest.value, videoBumps + 1);
    expect(handler.openMusicPlayerRequest.value, musicBumps);
  });

  test('leader switches steer the follower between video page and music player',
      () async {
    final queue = _queue(items: [
      _trackItem('item-1', 1),
      _movieItem('item-2', 2),
    ]);
    useClient(_fakeGraphQL(queue: queue, operations: []));
    await handler.startFollowingQueue(_server, 'pq-follow');
    final videoBumps = handler.openVideoPageRequest.value;
    final musicBumps = handler.openMusicPlayerRequest.value;

    // Track → movie: open the video page, exactly once.
    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-2', progressInMilliseconds: 0)]);
    expect(handler.openVideoPageRequest.value, videoBumps + 1);

    // The same emission again (a heartbeat) navigates nowhere.
    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-2', progressInMilliseconds: 5000)]);
    expect(handler.openVideoPageRequest.value, videoBumps + 1);

    // Movie → track: bring the music overlay back.
    await handler.debugApplyFollowNowPlaying(
        [_session(playQueueItemId: 'item-1', progressInMilliseconds: 0)]);
    expect(handler.openMusicPlayerRequest.value, musicBumps + 1);
    expect(handler.openVideoPageRequest.value, videoBumps + 1);
  });

  test('re-opening the followed queue itself keeps follow mode', () async {
    final queue = _queue(items: [_movieItem('item-1', 1)]);
    useClient(_fakeGraphQL(queue: queue, operations: []));
    await handler.startFollowingQueue(_server, 'pq-follow');
    expect(handler.movie, isNotNull);

    // The follower's movie page re-enters through the same start entry point,
    // with the followed queue's own id — that must not end the follow.
    await handler.startPlayQueueForMovie(
        ClientManager.getClientForUrl(_server).value,
        'pq-follow',
        handler.movie!,
        _server);

    expect(handler.followMode, isTrue);
  });
}
