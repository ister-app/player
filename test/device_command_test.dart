import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/graphql/deviceCommandsSubscription.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DeviceCommandService.dart';
import 'package:player/utils/DevicePreferences.dart';
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

Fragment$fragmentPlayQueue _queue(String id, String currentItemId,
        {int progress = 0}) =>
    Fragment$fragmentPlayQueue(
      id: id,
      currentItemId: currentItemId,
      progressInMilliseconds: progress,
      shuffle: false,
      sourceExhausted: true,
      controlAllowedUserIds: const [],
      playQueueItems: [_item('item-1', 1), _item('item-2', 2)],
    );

Subscription$deviceCommands$deviceCommands _command(
  Enum$DeviceCommandType command, {
  Enum$MediaType? mediaType,
  String? mediaId,
  String? startId,
  String? playQueueId,
  double? positionMs,
  String? targetDeviceId,
  DateTime? sentAt,
}) =>
    Subscription$deviceCommands$deviceCommands(
      deviceId: 'this-device',
      command: command,
      mediaType: mediaType,
      mediaId: mediaId,
      startId: startId,
      playQueueId: playQueueId,
      positionInMilliseconds: positionMs,
      targetDeviceId: targetDeviceId,
      timestamp: (sentAt ?? DateTime.now().toUtc()).toIso8601String(),
    );

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
  final service = DeviceCommandService.instance;

  /// GraphQL operations the mock server received, oldest first.
  final operations = <String>[];
  final creates = <Map<String, dynamic>>[];
  final deviceCommandSends = <Map<String, dynamic>>[];

  MockClient fakeGraphQL() => MockClient((request) async {
        final body = json.decode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String? ?? '';
        final variables = (body['variables'] as Map<String, dynamic>?) ?? {};
        Map<String, dynamic> payload;
        if (query.contains('mutation createPlayQueue')) {
          operations.add('createPlayQueue');
          creates.add(variables['input'] as Map<String, dynamic>);
          payload = {
            'data': {
              '__typename': 'Mutation',
              'createPlayQueue': _queue('pq-created', 'item-2').toJson(),
            }
          };
        } else if (query.contains('query playQueue') ||
            query.contains('getPlayQueue')) {
          operations.add('getPlayQueue');
          payload = {
            'data': {
              '__typename': 'Query',
              'getPlayQueue':
                  _queue('pq-existing', 'item-1', progress: 42000).toJson(),
            }
          };
        } else if (query.contains('sendDeviceCommand')) {
          operations.add('sendDeviceCommand');
          deviceCommandSends.add(variables);
          payload = {
            'data': {'__typename': 'Mutation', 'sendDeviceCommand': true}
          };
        } else if (query.contains('followPlayQueue')) {
          operations.add('followPlayQueue');
          payload = {
            'data': {'__typename': 'Mutation', 'followPlayQueue': 'OK'}
          };
        } else if (query.contains('playbackCommands') ||
            query.contains('nowPlaying')) {
          payload = {
            'errors': [
              {'message': 'no subscriptions in test'}
            ]
          };
        } else {
          payload = {
            'data': {'__typename': 'Query'}
          };
        }
        return http.Response(json.encode(payload), 200,
            headers: {'content-type': 'application/json'});
      });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link:
              HttpLink('https://api.example/graphql', httpClient: fakeGraphQL()),
          cache: GraphQLCache(),
        );
    operations.clear();
    creates.clear();
    deviceCommandSends.clear();
  });

  tearDown(() async {
    await handler.stopFollowing(notifyServer: false);
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

  test('PLAY_MEDIA creates a queue from the source and starts it', () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.PLAY_MEDIA,
            mediaType: Enum$MediaType.TRACK,
            mediaId: 'album-1',
            startId: 'track-2'));

    expect(creates.single['sourceType'], 'ALBUM');
    expect(creates.single['sourceId'], 'album-1');
    expect(creates.single['startId'], 'track-2');
    expect(handler.playQueue?.id, 'pq-created');
    expect(handler.currentPlayQueueItem?.id, 'item-2');
  });

  test('PLAY_MEDIA without a media id is ignored', () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.PLAY_MEDIA,
            mediaType: Enum$MediaType.TRACK));

    expect(operations, isEmpty);
    expect(handler.playQueue, isNull);
  });

  test('TAKEOVER_QUEUE resumes the existing queue at the sent position',
      () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.TAKEOVER_QUEUE,
            playQueueId: 'pq-existing', positionMs: 42000));

    expect(operations, contains('getPlayQueue'));
    expect(handler.playQueue?.id, 'pq-existing');
    expect(handler.currentPlayQueueItem?.id, 'item-1');
  });

  test('HANDOFF_QUEUE hands the live queue off to the target device', () async {
    // Make pq-existing this device's own live queue first.
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.TAKEOVER_QUEUE,
            playQueueId: 'pq-existing', positionMs: 42000));
    expect(handler.isOwnLiveQueue(_server, 'pq-existing'), isTrue);

    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.HANDOFF_QUEUE,
            playQueueId: 'pq-existing', targetDeviceId: 'other-device'));

    final sent = deviceCommandSends.single;
    expect(sent['deviceId'], 'other-device');
    expect(sent['command'], 'TAKEOVER_QUEUE');
    expect(sent['playQueueId'], 'pq-existing');
    expect(sent['positionInMilliseconds'], isNotNull);
    // The queue left this device.
    expect(handler.playQueue, isNull);
  });

  test('HANDOFF_QUEUE for a queue this device is not playing is ignored',
      () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.HANDOFF_QUEUE,
            playQueueId: 'pq-existing', targetDeviceId: 'other-device'));

    expect(deviceCommandSends, isEmpty);
    expect(handler.playQueue, isNull);
  });

  test('HANDOFF_QUEUE targeting this device itself is ignored', () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.TAKEOVER_QUEUE,
            playQueueId: 'pq-existing', positionMs: 42000));
    final ownDeviceId = await DevicePreferences.getDeviceId();

    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.HANDOFF_QUEUE,
            playQueueId: 'pq-existing', targetDeviceId: ownDeviceId));

    expect(deviceCommandSends, isEmpty);
    // Playback stays untouched on this device.
    expect(handler.playQueue?.id, 'pq-existing');
  });

  test('START_FOLLOW registers this device as a follower', () async {
    await service.debugExecute(
        _server,
        _command(Enum$DeviceCommandType.START_FOLLOW,
            playQueueId: 'pq-existing'));

    expect(operations, contains('followPlayQueue'));
    expect(handler.followMode, isTrue);
    expect(handler.playQueue?.id, 'pq-existing');
  });
}
