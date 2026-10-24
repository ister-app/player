import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/endActivity.graphql.dart';
import 'package:player/graphql/reportActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/DeviceService.dart';
import 'package:player/utils/LoggerService.dart';

/// Now-playing presence for activities that have no play queue: reading a
/// book or comic and playing a game. [begin] claims a client-generated session
/// id on the server (`reportActivity`), keeps it alive with a heartbeat and
/// [ActivityHandle.end] drops it at once (`endActivity`); without the end the
/// server forgets the session 60 s after the last heartbeat, like a playback
/// session whose client died.
///
/// Everything degrades silently: against a server that predates the mutation
/// the first validation error marks that server unsupported and the loop
/// stops, and a transport failure is simply retried on the next tick. Callers
/// never await anything here — presence must not slow the reader or the game
/// down.
class ActivityPresenceService {
  ActivityPresenceService._() : this.forTest();

  @visibleForTesting
  ActivityPresenceService.forTest({
    GraphQLClient Function(String serverName)? clientFor,
    Future<String> Function()? deviceId,
    void Function(String serverName)? registerDevice,
    String Function()? newSessionId,
    DateTime Function()? clock,
    this._heartbeatInterval = defaultHeartbeatInterval,
  })  : _clientFor = clientFor ?? ((server) => ClientManager.getClientForUrl(server).value),
        _deviceId = deviceId ?? DevicePreferences.getDeviceId,
        _registerDevice = registerDevice ?? ((server) => unawaited(DeviceService.instance.ensureRegistered(server))),
        _newSessionId = newSessionId ?? randomSessionId,
        _clock = clock ?? DateTime.now;

  static final ActivityPresenceService instance = ActivityPresenceService._();

  /// The server expires a session 60 s after its last heartbeat; a third of
  /// that survives a missed tick, like the device presence ping.
  static const defaultHeartbeatInterval = Duration(seconds: 20);

  /// Progress updates closer together than this ride on the next tick; a
  /// changed play state always goes out immediately.
  static const minResendGap = Duration(seconds: 5);

  final GraphQLClient Function(String serverName) _clientFor;
  final Future<String> Function() _deviceId;
  final void Function(String serverName) _registerDevice;
  final String Function() _newSessionId;
  final DateTime Function() _clock;
  final Duration _heartbeatInterval;

  /// Servers whose schema has no reportActivity: nothing is sent to them again
  /// this run.
  final Set<String> _unsupported = {};

  bool isSupported(String serverName) => !_unsupported.contains(serverName);

  /// A random UUID v4 string: the server keys the session by it and the id
  /// only has to be unique among this user's sessions.
  static String randomSessionId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// Starts a session and sends its first heartbeat. Returns at once; the
  /// handle keeps the session alive until [ActivityHandle.end].
  ActivityHandle begin({
    required String serverName,
    required Enum$MediaType mediaType,
    required String mediaId,
    String? mediaFileId,
    double? progressFraction,
    String? progressLabel,
    Enum$PlayState playState = Enum$PlayState.PLAYING,
  }) {
    final handle = ActivityHandle._(
      service: this,
      serverName: serverName,
      sessionId: _newSessionId(),
      mediaType: mediaType,
      mediaId: mediaId,
      mediaFileId: mediaFileId,
      progressFraction: progressFraction,
      progressLabel: progressLabel,
      playState: playState,
    );
    if (!isSupported(serverName)) {
      handle._ended = true;
      return handle;
    }
    // No client for this server (its well-known data was never fetched, e.g.
    // a reader opened outside the server shell): no presence either.
    try {
      _clientFor(serverName);
    } catch (e) {
      LoggerService().logger.d('activity presence: no client for $serverName: $e');
      handle._ended = true;
      return handle;
    }
    // The device name on the card comes from the registration; a reader opened
    // right after app start may get there before the shell registered.
    try {
      _registerDevice(serverName);
    } catch (e) {
      LoggerService().logger.d('activity presence: device registration skipped: $e');
    }
    handle._sendNow();
    handle._timer = Timer.periodic(_heartbeatInterval, (_) => handle._sendNow());
    return handle;
  }

  Future<void> _report(ActivityHandle handle) async {
    try {
      final client = _clientFor(handle.serverName);
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationreportActivity,
        // A heartbeat nobody reads back from the cache: keep it out of the
        // normalized store, or every tick deep-compares all watched queries.
        fetchPolicy: FetchPolicy.noCache,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
        variables: Variables$Mutation$reportActivity(
          sessionId: handle.sessionId,
          mediaType: handle.mediaType,
          mediaId: handle.mediaId,
          mediaFileId: handle.mediaFileId,
          progressFraction: handle.progressFraction,
          progressLabel: handle.progressLabel,
          playState: handle.playState,
          deviceId: await _deviceId(),
        ).toJson(),
      ));
      if (result.hasException) {
        _onFailure(handle, result.exception!);
      }
    } catch (e) {
      LoggerService().logger.d('activity presence: heartbeat failed: $e');
    }
  }

  Future<void> _end(ActivityHandle handle) async {
    try {
      final client = _clientFor(handle.serverName);
      await client.mutate(MutationOptions(
        document: documentNodeMutationendActivity,
        fetchPolicy: FetchPolicy.noCache,
        cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
        variables: Variables$Mutation$endActivity(sessionId: handle.sessionId).toJson(),
      ));
    } catch (e) {
      // The server forgets the session after its timeout anyway.
      LoggerService().logger.d('activity presence: end failed: $e');
    }
  }

  void _onFailure(ActivityHandle handle, OperationException exception) {
    if (isSchemaMismatch(exception)) {
      LoggerService().logger.i(
          'activity presence: ${handle.serverName} has no reportActivity, not reporting there again');
      _unsupported.add(handle.serverName);
      handle._stopTimer();
      return;
    }
    LoggerService().logger.d('activity presence: heartbeat rejected: $exception');
  }

  /// A GraphQL validation error — the server does not know the operation or
  /// one of its arguments — as opposed to a transient transport failure.
  @visibleForTesting
  static bool isSchemaMismatch(OperationException exception) {
    if (exception.linkException != null) return false;
    for (final error in exception.graphqlErrors) {
      final classification = error.extensions?['classification']?.toString();
      if (classification == 'ValidationError') return true;
      final message = error.message;
      if (message.contains('Validation error') ||
          message.contains('FieldUndefined') ||
          message.contains('Unknown argument') ||
          message.contains('UnknownArgument')) {
        return true;
      }
    }
    return false;
  }
}

/// One activity session on one server. [update] changes what the heartbeat
/// reports; [end] drops the session on the server and stops the heartbeat.
/// After [end] every call is a no-op.
class ActivityHandle {
  ActivityHandle._({
    required this._service,
    required this.serverName,
    required this.sessionId,
    required this.mediaType,
    required this.mediaId,
    required this.mediaFileId,
    required this._progressFraction,
    required this._progressLabel,
    required this._playState,
  });

  final ActivityPresenceService _service;
  final String serverName;
  final String sessionId;
  final Enum$MediaType mediaType;
  final String mediaId;
  final String? mediaFileId;

  double? _progressFraction;
  String? _progressLabel;
  Enum$PlayState _playState;
  Timer? _timer;
  bool _ended = false;
  bool _reported = false;
  DateTime? _lastSent;

  /// Requests are chained so an [end] can never overtake the heartbeat that
  /// is still in flight (which would resurrect the session on the server).
  Future<void> _chain = Future.value();

  double? get progressFraction => _progressFraction;
  String? get progressLabel => _progressLabel;
  Enum$PlayState get playState => _playState;
  bool get ended => _ended;

  /// Updates the reported position and/or state. A changed play state goes
  /// out at once; a position change waits [ActivityPresenceService.minResendGap]
  /// since the last send, otherwise it rides on the next heartbeat.
  void update({
    double? progressFraction,
    String? progressLabel,
    Enum$PlayState? playState,
  }) {
    if (_ended) return;
    final stateChanged = playState != null && playState != _playState;
    if (progressFraction != null) _progressFraction = progressFraction;
    if (progressLabel != null) _progressLabel = progressLabel;
    if (playState != null) _playState = playState;
    final last = _lastSent;
    if (stateChanged ||
        last == null ||
        _service._clock().difference(last) >= ActivityPresenceService.minResendGap) {
      _sendNow();
    }
  }

  /// Ends the session on the server and stops the heartbeat.
  Future<void> end() {
    if (_ended) return _chain;
    _ended = true;
    _stopTimer();
    // Never reported, or the server turned out not to know the mutation:
    // nothing to end there.
    if (!_reported || !_service.isSupported(serverName)) return _chain;
    _chain = _chain.then((_) => _service._end(this));
    return _chain;
  }

  void _sendNow() {
    if (_ended) return;
    _reported = true;
    _lastSent = _service._clock();
    _chain = _chain.then((_) => _service._report(this));
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
