import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentDevice.graphql.dart';
import 'package:player/graphql/myDevices.graphql.dart';
import 'package:player/graphql/pingDevice.graphql.dart';
import 'package:player/graphql/registerDevice.graphql.dart';
import 'package:player/graphql/removeDevice.graphql.dart';
import 'package:player/graphql/renameDevice.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/sendDeviceCommand.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/LoggerService.dart';

/// One of the user's registered devices, as the server lists them.
class DeviceInfo {
  const DeviceInfo({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.online,
    required this.lastSeenAt,
    required this.isThisDevice,
  });

  final String deviceId;
  final String name;
  final Enum$DevicePlatform platform;

  /// Whether the device pinged its presence recently — only online devices accept commands.
  final bool online;
  final DateTime? lastSeenAt;
  final bool isThisDevice;
}

/// Server-side device registry: registration of this install, the user's device list,
/// rename/remove, and device-targeted commands ("play on / hand off to / listen along on").
///
/// Registration runs once per app run per server and doubles as the first presence ping;
/// while the device-command channel is open a ~20s ping heartbeat keeps the device "online"
/// (the server expires presence at 60s). All calls degrade silently against an older server
/// without the devices schema — the settings/picker UI hides itself when [myDevices] fails.
class DeviceService {
  DeviceService._privateConstructor();

  static final DeviceService _instance = DeviceService._privateConstructor();

  factory DeviceService() => _instance;

  static DeviceService get instance => _instance;

  static const pingInterval = Duration(seconds: 20);

  final Set<String> _registered = {};
  final Map<String, Timer> _pingTimers = {};

  /// Registers this install with [serverName] (idempotent per app run) and starts the
  /// presence-ping heartbeat. Silently a no-op when the server predates the devices schema.
  Future<void> ensureRegistered(String serverName) async {
    if (_registered.contains(serverName)) return;
    try {
      final client = ClientManager.getClientForUrl(serverName).value;
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationregisterDevice,
        variables: Variables$Mutation$registerDevice(
          deviceId: await DevicePreferences.getDeviceId(),
          name: await DevicePreferences.getDeviceName(),
          platform: await DevicePreferences.getPlatform(),
        ).toJson(),
      ));
      if (result.hasException) {
        LoggerService().logger.w('device registration failed: ${result.exception}');
        return;
      }
      _registered.add(serverName);
      _startPingTimer(serverName);
    } catch (e) {
      LoggerService().logger.w('device registration failed: $e');
    }
  }

  void _startPingTimer(String serverName) {
    _pingTimers[serverName] ??=
        Timer.periodic(pingInterval, (_) => _ping(serverName));
  }

  Future<void> _ping(String serverName) async {
    try {
      final client = ClientManager.getClientForUrl(serverName).value;
      await client.mutate(MutationOptions(
        document: documentNodeMutationpingDevice,
        variables: Variables$Mutation$pingDevice(
                deviceId: await DevicePreferences.getDeviceId())
            .toJson(),
      ));
    } catch (e) {
      // The next tick retries; presence simply lapses while unreachable.
      LoggerService().logger.d('device ping failed: $e');
    }
  }

  /// Stops pinging and forgets the registration for [serverName] (e.g. after the user
  /// removed this device); the next [ensureRegistered] re-registers.
  void stopFor(String serverName) {
    _pingTimers.remove(serverName)?.cancel();
    _registered.remove(serverName);
  }

  /// The user's registered devices, most recently seen first. Throws on failure —
  /// callers hide the devices UI for servers without the schema.
  Future<List<DeviceInfo>> myDevices(String serverName) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.query(QueryOptions(
      document: documentNodeQuerymyDevices,
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty myDevices response');
    }
    final ownId = await DevicePreferences.getDeviceId();
    return Query$myDevices.fromJson(result.data!)
        .myDevices
        .map((d) => _toInfo(d, ownId))
        .toList();
  }

  /// Renames one of the user's devices; null when the server refused (unknown device).
  Future<DeviceInfo?> rename(
      String serverName, String deviceId, String name) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationrenameDevice,
      variables:
          Variables$Mutation$renameDevice(deviceId: deviceId, name: name)
              .toJson(),
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty renameDevice response');
    }
    final renamed = Mutation$renameDevice.fromJson(result.data!).renameDevice;
    if (renamed == null) return null;
    return _toInfo(renamed, await DevicePreferences.getDeviceId());
  }

  /// Removes one of the user's devices. Removing this device also stops its
  /// ping heartbeat; the next app start re-registers it.
  Future<bool> remove(String serverName, String deviceId) async {
    final client = ClientManager.getClientForUrl(serverName).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationremoveDevice,
      variables:
          Variables$Mutation$removeDevice(deviceId: deviceId).toJson(),
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty removeDevice response');
    }
    final removed = Mutation$removeDevice.fromJson(result.data!).removeDevice;
    if (removed && deviceId == await DevicePreferences.getDeviceId()) {
      stopFor(serverName);
    }
    return removed;
  }

  /// Sends [command] to one of the user's own devices. False means the server
  /// refused: unknown device, offline device, or a dead play queue session.
  Future<bool> sendCommand(
    String serverName, {
    required String deviceId,
    required Enum$DeviceCommandType command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    int? positionMs,
  }) async {
    try {
      final client = ClientManager.getClientForUrl(serverName).value;
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationsendDeviceCommand,
        variables: Variables$Mutation$sendDeviceCommand(
          deviceId: deviceId,
          command: command,
          mediaType: mediaType,
          mediaId: mediaId,
          startId: startId,
          playQueueId: playQueueId,
          positionInMilliseconds: positionMs?.toDouble(),
        ).toJson(),
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.w('sendDeviceCommand failed: ${result.exception}');
        return false;
      }
      return Mutation$sendDeviceCommand.fromJson(result.data!).sendDeviceCommand;
    } catch (e) {
      LoggerService().logger.w('sendDeviceCommand failed: $e');
      return false;
    }
  }

  DeviceInfo _toInfo(Fragment$fragmentDevice fragment, String ownDeviceId) {
    return DeviceInfo(
      deviceId: fragment.deviceId,
      name: fragment.name,
      platform: fragment.platform,
      online: fragment.online,
      lastSeenAt: DateTime.tryParse(fragment.lastSeenAt),
      isThisDevice: fragment.deviceId == ownDeviceId,
    );
  }
}
