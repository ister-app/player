import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/deviceCommandsSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:player/utils/ResilientSubscription.dart';

/// Listens for commands addressed to this device and executes them.
///
/// One persistent `deviceCommands(deviceId)` subscription per server, kept alive by
/// [ResilientSubscription] for as long as the app runs — a device without a live subscriber
/// silently drops its commands (the sink is non-replaying by design, so a reconnect can never
/// re-execute an old command). As a second guard, commands older than [staleAfter] are dropped:
/// they can only reach us through some delivery anomaly, never a live send.
class DeviceCommandService {
  DeviceCommandService._privateConstructor();

  static final DeviceCommandService _instance =
      DeviceCommandService._privateConstructor();

  factory DeviceCommandService() => _instance;

  static DeviceCommandService get instance => _instance;

  static const staleAfter = Duration(seconds: 30);

  final Map<String, ResilientSubscription> _subscriptions = {};

  /// Test seam: replaces the executor so widget tests can observe commands
  /// without a real player.
  Future<void> Function(String serverName, Subscription$deviceCommands$deviceCommands command)?
      debugExecuteOverride;

  /// Opens (idempotently) the command channel for [serverName]. Call from the
  /// per-server init path once the user is logged in.
  Future<void> ensureStarted(String serverName) async {
    if (_subscriptions.containsKey(serverName)) return;
    final deviceId = await DevicePreferences.getDeviceId();
    // Re-check: the await above can race a concurrent ensureStarted.
    if (_subscriptions.containsKey(serverName)) return;
    _subscriptions[serverName] = ResilientSubscription(
      client: ClientManager.getClientForUrl(serverName).value,
      document: documentNodeSubscriptiondeviceCommands,
      variables:
          Variables$Subscription$deviceCommands(deviceId: deviceId).toJson(),
      onData: (result) => _onData(serverName, result),
      onFailure: (_) {},
    );
  }

  Future<void> stopFor(String serverName) async {
    await _subscriptions.remove(serverName)?.dispose();
  }

  void _onData(String serverName, QueryResult result) {
    final command = Subscription$deviceCommands.fromJson(result.data!).deviceCommands;
    final sentAt = DateTime.tryParse(command.timestamp);
    if (sentAt != null &&
        DateTime.now().toUtc().difference(sentAt.toUtc()) > staleAfter) {
      LoggerService().logger.w('dropping stale device command ${command.command}');
      return;
    }
    final execute = debugExecuteOverride ?? _execute;
    execute(serverName, command).catchError((Object e) {
      LoggerService().logger.e('device command ${command.command} failed: $e');
    });
  }

  /// Test seam: runs the real executor on a synthetic command.
  @visibleForTesting
  Future<void> debugExecute(String serverName,
          Subscription$deviceCommands$deviceCommands command) =>
      _execute(serverName, command);

  Future<void> _execute(String serverName,
      Subscription$deviceCommands$deviceCommands command) async {
    final handler = MediaPlayerHandler.instance;
    switch (command.command) {
      case Enum$DeviceCommandType.PLAY_MEDIA:
        await _playMedia(serverName, command);
      case Enum$DeviceCommandType.TAKEOVER_QUEUE:
        final playQueueId = command.playQueueId;
        if (playQueueId == null) return;
        await handler.startFromExistingQueue(serverName, playQueueId,
            positionMs: command.positionInMilliseconds?.round());
      case Enum$DeviceCommandType.START_FOLLOW:
        final playQueueId = command.playQueueId;
        if (playQueueId == null) return;
        await handler.startFollowingQueue(serverName, playQueueId);
      case Enum$DeviceCommandType.$unknown:
        LoggerService().logger.w('unknown device command ignored');
    }
  }

  /// PLAY_MEDIA carries the *source* in mediaId (movie/show/album/podcast/book id,
  /// per the item type in mediaType) and the item to start at in startId — the same
  /// (source, start) pair the createPlayQueue mutation takes.
  Future<void> _playMedia(String serverName,
      Subscription$deviceCommands$deviceCommands command) async {
    final mediaId = command.mediaId;
    final sourceType = _sourceTypeFor(command.mediaType);
    if (mediaId == null || sourceType == null) return;

    final handler = MediaPlayerHandler.instance;
    if (handler.followMode) await handler.stopFollowing();

    final client = ClientManager.getClientForUrl(serverName).value;
    final pq = await PlayQueueService().createPlayQueue(
      client,
      sourceType: sourceType,
      sourceId: mediaId,
      startId: command.startId,
    );
    if (pq == null) return;
    await handler.startFromServerQueue(client, pq, serverName);
  }

  Enum$PlayQueueSourceType? _sourceTypeFor(Enum$MediaType? mediaType) {
    switch (mediaType) {
      case Enum$MediaType.MOVIE:
        return Enum$PlayQueueSourceType.MOVIE;
      case Enum$MediaType.EPISODE:
        return Enum$PlayQueueSourceType.SHOW;
      case Enum$MediaType.TRACK:
        return Enum$PlayQueueSourceType.ALBUM;
      case Enum$MediaType.CHAPTER:
        return Enum$PlayQueueSourceType.BOOK;
      case Enum$MediaType.PODCAST_EPISODE:
        return Enum$PlayQueueSourceType.PODCAST;
      default:
        return null;
    }
  }
}
