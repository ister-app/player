// Progress reporting to the server for the loaded queue — throttled position
// syncs, the paused-session heartbeat, the stale-response generation guard —
// plus the local play history that feeds the music cache. Owns the request
// chain so updates reach the server in submission order.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/updatePlayQueueHeartbeat.graphql.dart';
import 'package:player/utils/ClockSyncService.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/SleepTimerService.dart';
import 'package:player/utils/SyncPreferences.dart';
import 'package:player/utils/download/MusicCacheService.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';
import 'package:player/utils/download/PlayHistoryStore.dart';

import 'PlaybackCore.dart';

class ProgressSync {
  ProgressSync(this.core);

  final PlaybackCore core;

  // Bumped whenever the current item or queue changes; in-flight progress
  // responses from before the bump are dropped instead of applied.
  int _generation = 0;
  int get generation => _generation;
  void bump() => _generation++;

  // Trace every progress update/heartbeat in the integration suite: a watch
  // status that never appears server-side is otherwise undebuggable from the
  // CI logs (successful syncs are silent). Inert in production builds.
  static const bool _trace = bool.fromEnvironment('ISTER_TEST_MODE');

  Duration? _lastProgress;

  // Playback-heartbeat state: keeps the server-side session alive (also while
  // paused); _lastSyncSentAt tracks the last actual send so the heartbeat
  // stays quiet while position-driven syncs are flowing.
  Timer? _heartbeat;
  DateTime? _lastSyncSentAt;

  /// Forgets the last reported position so the next sync goes out regardless
  /// of the throttle (a teardown; the next queue starts clean).
  void reset() {
    _lastProgress = null;
    _lastSyncSentAt = null;
  }

  /// The track whose play is not yet counted in the local history: it is
  /// recorded once 30s (or half of it) played, so skipping through an album
  /// does not fill the music cache with tracks nobody listened to.
  (String, Fragment$fragmentPlayQueue$playQueueItems)? _pendingHistory;

  void armPlayHistory(
    String srv,
    Fragment$fragmentPlayQueue$playQueueItems? item,
  ) {
    _pendingHistory = item?.track == null ? null : (srv, item!);
  }

  void recordPlayHistoryIfDue(Duration pos) {
    final pending = _pendingHistory;
    if (pending == null || kIsWeb) return;
    final duration = core.player.state.duration;
    final due =
        pos >= const Duration(seconds: 30) ||
        (duration > Duration.zero && pos >= duration ~/ 2);
    if (!due) return;
    _pendingHistory = null;
    final (srv, item) = pending;
    unawaited(
      PlayHistoryStore.instance
          .record(srv, item)
          .then((_) {
            MusicCacheService.instance.schedule(srv);
          })
          .catchError((e) {
            LoggerService().logger.w('play history record failed: $e');
          }),
    );
  }

  // Progress updates are sent strictly one at a time, in submission order.
  // Concurrent requests can be processed by the server out of order, letting
  // an in-flight update for the previous track overwrite the currentItemId a
  // skip just set.
  Future<void> _chain = Future.value();

  /// The stream settings media URLs are built with, so the server can
  /// prefetch the next queue item in the same format.
  Future<Input$StreamSettingsInput> _currentStreamSettings() async {
    final directPlay = kIsWeb
        ? false
        : await PlaybackPreferences.getDirectPlay(serverName: core.serverName);
    final transcode = kIsWeb
        ? true
        : await PlaybackPreferences.getTranscode(serverName: core.serverName);
    return Input$StreamSettingsInput(
      direct: directPlay,
      transcode: transcode,
      subtitleFormat: fromJson$Enum$SubtitleFormat(ImageUtil.subtitleFormat),
      // Which version of the item this is: the server's watched boundary and
      // session duration, followers and a device taking over all go by it.
      mediaFileId: core.currentMediaFile?.id,
    );
  }

  Future<Fragment$fragmentPlayQueue?> sendProgressUpdate(
    GraphQLClient client,
    String playQueueId,
    String playQueueItemId,
    Duration position, {
    Enum$PlayState? playState,
  }) {
    // When [playState] is null it is read inside the chained closure so it
    // reflects the state at the moment the request is actually sent, not when
    // it was queued. It comes from the player itself (not _intendsToPlay)
    // because the in-video controls can pause without going through pause().
    // play()/pause()/stop() pass it explicitly because the player state hasn't
    // flipped yet when they fire the update.
    final send = _chain.then((_) async {
      // Tight-sync anchor: sample the position and server clock at the moment
      // the request actually goes out. The device's own output latency is
      // subtracted so the anchor describes what listeners *hear*, not what the
      // decoder reports. Omitted (nulls) until the clock has been measured;
      // followers then fall back to the coarse sync.
      final anchor = _timelineAnchor();
      final effectiveState =
          playState ??
          (core.player.state.playing
              ? Enum$PlayState.PLAYING
              : Enum$PlayState.PAUSED);
      if (_trace) {
        LoggerService().logger.d(
          '[PROGRESS] update ${position.inMilliseconds}ms state=${effectiveState.name} item=$playQueueItemId',
        );
      }
      final result = await core.playQueueService.updateProgress(
        client,
        playQueueId,
        playQueueItemId,
        position,
        streamSettings: await _currentStreamSettings(),
        playState: effectiveState,
        deviceId: await DevicePreferences.getDeviceId(),
        anchorPositionMs: anchor?.positionMs,
        anchorServerTimeMs: anchor?.serverTimeMs,
        repeatMode: core.repeatModeApi,
      );
      if (_trace) {
        LoggerService().logger.d('[PROGRESS] update ack=${result != null}');
      }
      return result;
    });
    _chain = send.then((_) {}, onError: (_) {});
    return send;
  }

  /// The slim heartbeat twin of [sendProgressUpdate]: same request chain (a
  /// beat must not overtake an in-flight full update), minimal response.
  Future<Mutation$updatePlayQueueHeartbeat$updatePlayQueue?>
  _sendProgressHeartbeat(
    GraphQLClient client,
    String playQueueId,
    String playQueueItemId,
    Duration position, {
    Enum$PlayState? playState,
  }) {
    final send = _chain.then((_) async {
      final anchor = _timelineAnchor();
      final effectiveState =
          playState ??
          (core.player.state.playing
              ? Enum$PlayState.PLAYING
              : Enum$PlayState.PAUSED);
      if (_trace) {
        LoggerService().logger.d(
          '[PROGRESS] heartbeat ${position.inMilliseconds}ms state=${effectiveState.name} item=$playQueueItemId',
        );
      }
      final result = await core.playQueueService.updateProgressHeartbeat(
        client,
        playQueueId,
        playQueueItemId,
        position,
        streamSettings: await _currentStreamSettings(),
        playState: effectiveState,
        deviceId: await DevicePreferences.getDeviceId(),
        anchorPositionMs: anchor?.positionMs,
        anchorServerTimeMs: anchor?.serverTimeMs,
        repeatMode: core.repeatModeApi,
      );
      if (_trace) {
        LoggerService().logger.d('[PROGRESS] heartbeat ack=${result != null}');
      }
      return result;
    });
    _chain = send.then((_) {}, onError: (_) {});
    return send;
  }

  /// The tight-sync anchor for the currently playing stream, or null when the
  /// server clock hasn't been measured (yet) or nothing is open.
  ({int positionMs, double serverTimeMs})? _timelineAnchor() {
    final srv = core.serverName;
    if (srv == null || core.currentMediaUrl == null) return null;
    final serverNow = ClockSyncService.instance.serverNowMs(srv);
    if (serverNow == null) return null;
    final positionMs =
        core.player.state.position.inMilliseconds -
        SyncPreferences.outputLatencyMs.value;
    return (
      positionMs: positionMs < 0 ? 0 : positionMs,
      serverTimeMs: serverNow,
    );
  }

  /// Replaces [PlaybackCore.playQueue] with a server response while keeping the locally
  /// tracked current item. Returns whether the response was applied — a
  /// response for a queue other than the active one is dropped.
  bool applyServerPlayQueue(Fragment$fragmentPlayQueue response) {
    final merged = mergeServerPlayQueue(core.playQueue, response);
    if (merged == null) return false;
    core.playQueue = merged;
    return true;
  }

  /// Merges a server play-queue [response] into [current], keeping the locally
  /// tracked current item — the client is authoritative for what is playing;
  /// a response can still carry a stale currentItemId (e.g. a progress update
  /// for the previous track processed server-side around a skip).
  ///
  /// Returns null when [response] belongs to a different queue than [current]:
  /// the generation counter alone can't catch this, because starting a new
  /// queue bumps the generation *before* the createPlayQueue round-trip — a
  /// progress update for the old queue sent during that window carries the new
  /// generation, and its late response would otherwise reinstate the old queue.
  static Fragment$fragmentPlayQueue? mergeServerPlayQueue(
    Fragment$fragmentPlayQueue? current,
    Fragment$fragmentPlayQueue response,
  ) {
    if (current == null || response.id != current.id) return null;
    final localCurrentItemId = current.currentItemId;
    return localCurrentItemId != null
        ? response.copyWith(currentItemId: localCurrentItemId)
        : response;
  }

  /// Syncs the playback position of the current item to the server. Throttled
  /// to ~10s of position delta unless [force] is set (pause/stop flush the
  /// final position so resume points don't lag behind).
  Future<void> syncProgress(
    Duration pos, {
    bool force = false,
    Enum$PlayState? playState,
  }) async {
    // A following device never reports progress: updatePlayQueue is
    // owner-only, and two reporters on one queue would fight over the
    // session. The server writes this user's watch status instead.
    if (core.followMode) return;
    // No stream is open — a queue switch is in flight (see
    // _silenceForQueueSwitch) or nothing was ever opened. Any position event
    // arriving now belongs to the silenced previous stream; syncing it would
    // overwrite that item's progress with a bogus position.
    if (core.currentMediaUrl == null) return;
    if (!force &&
        _lastProgress != null &&
        (pos - _lastProgress!).inMilliseconds.abs() <= 10 * 1000) {
      return;
    }
    _lastProgress = pos;

    final client = core.graphQLClient;
    final pq = core.playQueue;
    if (pq == null) return;
    if (core.isLocalQueue) {
      final item = core.currentPlayQueueItem;
      final srv = core.serverName;
      if (item != null && srv != null) {
        // A slice of a multi-episode file ends at its part boundary, not at
        // the end of the file.
        final endMs = core.currentItemEndMs(item.episode);
        await OfflineProgressStore.instance.record(
          srv,
          item,
          positionMs: pos.inMilliseconds,
          durationMs: endMs,
          finished: endMs > 0 && pos.inMilliseconds >= endMs - 5000,
        );
      }
      return;
    }
    if (client == null) return;

    // The current queue item is the item id; chapters and podcast episodes have
    // no typed handler field to reconstruct it from (episode/movie/track are all
    // null for them), so they would never sync at all if we went by media type.
    String? itemId = core.currentPlayQueueItem?.id;
    if (itemId == null) {
      if (core.episode != null) {
        itemId = core.playQueueService.getPlayQueueItemId(pq, core.episode!.id);
      } else if (core.movie != null) {
        itemId = core.playQueueService.getMoviePlayQueueItemId(
          pq,
          core.movie!.id,
        );
      } else if (core.currentTrackId != null) {
        itemId = core.playQueueService.getTrackPlayQueueItemId(
          pq,
          core.currentTrackId!,
        );
      }
    }
    if (itemId == null) return;

    final generation = _generation;
    _lastSyncSentAt = DateTime.now();
    final beat = await _sendProgressHeartbeat(
      client,
      pq.id,
      itemId,
      pos,
      playState: playState,
    );
    // Drop the response if the queue or current item changed while this
    // request was in flight — a slow response must not revert a skip or
    // reinstate a queue that was replaced in the meantime.
    if (beat != null && generation == _generation) {
      if (beat.id != core.playQueue?.id) return;
      // The source ran dry since the queue was fetched: remember it, so the
      // end of the queue needs no extra round-trip to be sure.
      if (beat.sourceExhausted != core.playQueue?.sourceExhausted) {
        core.playQueue = core.playQueue?.copyWith(
          sourceExhausted: beat.sourceExhausted,
        );
      }
      // Sources with sourceExhausted == false grow server-side as playback
      // advances. The heartbeat only carries item ids (parsing the full queue
      // every beat is a visible hitch on low-end TVs); fetch the full queue
      // once when the server reports a different item set.
      final localCount = core.playQueue?.playQueueItems?.length ?? 0;
      final serverCount = beat.playQueueItems?.length ?? 0;
      if (serverCount != localCount) {
        await core.reloadPlayQueueFromServer();
      }
    }
  }

  /// The server treats updatePlayQueue as the playback heartbeat: a session
  /// with no update for 60s counts as stopped. While playing, the position
  /// stream drives ~10s updates; while paused the position stops advancing,
  /// so this wall-clock timer keeps the session alive with PAUSED updates.
  /// The 10s gate keeps it silent whenever position-driven syncs already
  /// went out recently, so nothing is sent twice.
  ///
  /// When the queue plays out without an explicit stop() the heartbeat keeps
  /// reporting PAUSED and the session stays visible server-side; only stop()
  /// (or the app dying) lets the server expire the session.
  void startHeartbeat() {
    // Every start/resume path funnels through here (track auto-advance does
    // not), so this is where the automatic sleep timer gets a chance to arm.
    unawaited(SleepTimerService.instance.notifyPlaybackStarted());
    // A follower has its own heartbeat (followPlayQueue); the session
    // heartbeat below would try to report progress it must not send.
    if (core.followMode) return;
    // Arm the tight-sync anchor: once the server clock is measured (and the
    // output-latency preference loaded), every progress update carries one.
    final srv = core.serverName;
    if (srv != null && !core.playerIsMocked) {
      unawaited(SyncPreferences.ensureLoaded());
      unawaited(ClockSyncService.instance.ensureSynced(srv));
    }
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(seconds: 5), (_) {
      if (core.playQueue == null || core.graphQLClient == null) return;
      // Safety net: any path that (re)activated a queue without explicitly
      // subscribing still becomes remote-controllable within one tick.
      core.ensureCommandSubscription();
      final last = _lastSyncSentAt;
      if (last != null &&
          DateTime.now().difference(last) < const Duration(seconds: 10)) {
        return;
      }
      unawaited(syncProgress(core.player.state.position, force: true));
    });
  }

  void stopHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = null;
  }
}
