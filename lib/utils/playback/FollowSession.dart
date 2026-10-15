// Following another device's live session ("listen along"): the follow
// registration heartbeat, the now-playing subscription that mirrors the
// leader's item and play state, the tight-sync rate loop, and sending this
// device's transport taps to the session as commands instead of acting
// locally. The handler owns follow *mode* (the flag every transport method
// branches on) and the arm/teardown ordering around it; this owns the
// machinery that runs while following.
import 'dart:async';

import 'package:player/dto/IsterMediaService.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/nowPlayingSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/ClockSyncService.dart';
import 'package:player/utils/FollowSyncDecision.dart';
import 'package:player/utils/ResilientSubscription.dart';
import 'package:player/utils/SyncPreferences.dart';

import 'PlaybackCore.dart';

/// The leader's latest timeline anchor: where it was at which server time.
typedef FollowAnchor = ({
  int positionMs,
  double serverTimeMs,
  Enum$PlayState playState,
  String? itemId,
});

class FollowSession {
  FollowSession(this.core);

  final PlaybackCore core;

  Timer? _heartbeat;
  ResilientSubscription? _nowPlaying;
  // Tight sync ("same room"): the leader's latest timeline anchor and the
  // 500ms discipline loop steering this device towards it with setRate.
  Timer? _syncTimer;
  FollowAnchor? anchor;
  double _appliedRate = 1.0;
  // Serializes application of nowPlaying emissions; a next emission arrives
  // within seconds, so a dropped one is never missed for long.
  bool _busy = false;

  /// The file the leader of the followed session plays (its now-playing
  /// session reports it). A follower opens the same one: two versions of a
  /// film need not share a timeline, and the leader's position is all a
  /// follower has to go by.
  String? leaderMediaFileId;

  /// Follow mode just switched on for the queue the core holds: start the
  /// heartbeat, mirror the leader and (with a real player) the sync loop.
  void arm(String deviceId) {
    _startHeartbeat(deviceId);
    _ensureNowPlayingSubscription();
    unawaited(SyncPreferences.ensureLoaded());
    final srv = core.serverName;
    if (srv != null && !core.playerIsMocked) {
      unawaited(ClockSyncService.instance.ensureSynced(srv));
      _syncTimer?.cancel();
      _syncTimer = Timer.periodic(
        const Duration(milliseconds: 500),
        (_) => unawaited(_syncTick()),
      );
    }
  }

  /// Follow mode is off (the core flipped the flag first): stop everything
  /// and restore a neutral playback rate.
  Future<void> teardown() async {
    _heartbeat?.cancel();
    _heartbeat = null;
    _syncTimer?.cancel();
    _syncTimer = null;
    anchor = null;
    leaderMediaFileId = null;
    await _resetRate();
    _nowPlaying?.dispose();
    _nowPlaying = null;
  }

  /// The follow registration doubles as a heartbeat (~20s; the server expires
  /// it after 60s). A NOT_FOUND answer means the followed session ended while
  /// we were listening — leave follow mode with a toast. A null answer is a
  /// transient network failure: keep going, the next tick retries.
  void _startHeartbeat(String deviceId) {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(seconds: 20), (_) async {
      final client = core.graphQLClient;
      final pq = core.playQueue;
      if (!core.followMode || client == null || pq == null) return;
      final result = await core.playQueueService.followPlayQueue(
        client,
        pq.id,
        deviceId,
        true,
      );
      if (core.followMode && result == Enum$FollowResult.NOT_FOUND) {
        showAppSnackBar(IsterMediaService.loc.followLeaderStopped);
        await core.stopFollowing(notifyServer: false, teardown: true);
      }
    });
  }

  /// One tick of the tight-sync discipline loop (every 500ms while following):
  /// extrapolates the leader's position from its anchor and the shared server
  /// clock, then applies [decideFollowSync] — seek for large errors, a ≤2%
  /// rate nudge for moderate ones, rate 1.0 once locked. Falls back to doing
  /// nothing (and a neutral rate) whenever tight sync is off, the anchor is
  /// missing/stale, the items differ, or either side is paused.
  Future<void> _syncTick() async {
    if (!core.followMode || core.playerIsMocked) return;
    final srv = core.serverName;
    final anchor = this.anchor;
    if (srv == null) return;
    if (!SyncPreferences.tightSyncEnabled.value || anchor == null) {
      await _resetRate();
      return;
    }
    // Keeps the offset fresh; a no-op within its refresh interval.
    unawaited(ClockSyncService.instance.ensureSynced(srv));
    final sameItem =
        anchor.itemId != null && anchor.itemId == core.currentPlayQueueItem?.id;
    if (!sameItem ||
        anchor.playState != Enum$PlayState.PLAYING ||
        !core.player.state.playing ||
        core.player.state.duration <= Duration.zero) {
      await _resetRate();
      return;
    }
    final serverNow = ClockSyncService.instance.serverNowMs(srv);
    if (serverNow == null) return;
    final targetMs =
        anchor.positionMs +
        (serverNow - anchor.serverTimeMs) +
        SyncPreferences.outputLatencyMs.value;
    final errorMs = core.player.state.position.inMilliseconds - targetMs;
    final action = decideFollowSync(
      errorMs: errorMs,
      currentRate: _appliedRate,
    );
    switch (action.type) {
      case FollowSyncActionType.seek:
        await _resetRate();
        // Aim slightly past the target: the seek itself takes a beat, and on
        // HLS it lands on a segment boundary; the rate loop trims the rest.
        await core.player.seek(Duration(milliseconds: targetMs.round() + 100));
      case FollowSyncActionType.rate:
        _appliedRate = action.rate;
        await core.player.setRate(action.rate);
      case FollowSyncActionType.none:
        break;
    }
  }

  /// mpv's speed is a player-level property that survives stream loads, so a
  /// non-neutral rate must be reset explicitly whenever steering stops.
  Future<void> _resetRate() async {
    if (_appliedRate == 1.0) return;
    _appliedRate = 1.0;
    if (!core.playerIsMocked) await core.player.setRate(1.0);
  }

  /// Follows the leading device through the now-playing fan-out: it is the
  /// source of truth for what the leader does *locally* (its play/pause/skip
  /// don't travel over the command bus). Item changes, play state and coarse
  /// position corrections all come from here; the command bus only provides
  /// lower latency when someone explicitly remote-controls the session.
  void _ensureNowPlayingSubscription() {
    _nowPlaying?.dispose();
    final client = core.graphQLClient;
    if (client == null) return;
    _nowPlaying = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionnowPlaying,
      variables: const {},
      onData: (result) {
        final sessions = Subscription$nowPlaying.fromJson(result.data!)
            .nowPlaying;
        unawaited(applyNowPlaying(sessions));
      },
      // The sink replays the latest list on reconnect, so a dropped
      // subscription self-heals with fresh state.
      onFailure: (_) {},
    );
  }

  Future<void> applyNowPlaying(
    List<Fragment$fragmentPlaybackSession> sessions,
  ) async {
    if (!core.followMode || _busy) return;
    final pqId = core.playQueue?.id;
    if (pqId == null) return;
    final session = sessions.where((s) => s.playQueueId == pqId).firstOrNull;
    if (session == null) {
      // The list is always complete: an emission without our session means
      // the leader stopped (or timed out server-side). The media is gone from
      // this device with it: tear playback down rather than leaving a paused
      // stream (and a mini player) behind.
      showAppSnackBar(IsterMediaService.loc.followLeaderStopped);
      await core.stopFollowing(notifyServer: false, teardown: true);
      return;
    }
    // Tight-sync anchor for the discipline loop; null when the leader doesn't
    // report one (older client, or its clock is not measured yet).
    final anchorPosition = session.anchorPositionMs;
    final anchorServerTime = session.anchorServerTimeMs;
    anchor = anchorPosition != null && anchorServerTime != null
        ? (
            positionMs: anchorPosition,
            serverTimeMs: anchorServerTime,
            playState: session.playState,
            itemId: session.playQueueItemId,
          )
        : null;
    // Before the item switch below, so its open already picks this file.
    leaderMediaFileId = session.mediaFileId;
    _busy = true;
    core.applyingRemoteSync = true;
    try {
      final itemId = session.playQueueItemId;
      if (itemId != null && itemId != core.currentPlayQueueItem?.id) {
        await core.skipToItemId(itemId);
      } else if (core.shouldFollowLeaderFile(session.mediaFileId)) {
        // Same item, another version: the leader switched.
        await core.queueVersionSwitch(
          session.mediaFileId!,
          leaderPositionMs: session.progressInMilliseconds,
        );
      }
      final leaderPlaying = session.playState == Enum$PlayState.PLAYING;
      if (!core.playerIsMocked) {
        if (leaderPlaying && !core.player.state.playing) {
          await core.play();
        } else if (!leaderPlaying && core.player.state.playing) {
          await core.pause();
        }
      } else {
        core.intendsToPlay = leaderPlaying;
      }
      // Coarse position correction, only within the same item and once the
      // stream is actually loaded. The leader reports every ~10s; small skews
      // are left alone (an HLS seek is more disruptive than a 2s offset).
      // With tight sync active and an anchor available the discipline loop
      // owns the position — the coarse seek would fight its rate steering.
      final tightSyncActive =
          SyncPreferences.tightSyncEnabled.value && anchor != null;
      if (!tightSyncActive &&
          itemId != null &&
          itemId == core.currentPlayQueueItem?.id &&
          !core.playerIsMocked &&
          core.player.state.duration > Duration.zero) {
        final leaderPos = Duration(
          milliseconds: session.progressInMilliseconds,
        );
        if ((core.player.state.position - leaderPos).abs() >
            const Duration(seconds: 3)) {
          await core.seek(leaderPos);
        }
      }
    } finally {
      core.applyingRemoteSync = false;
      _busy = false;
    }
  }

  /// Sends a transport action as a remote-control command instead of acting
  /// locally — in follow mode every participant (including this device, via
  /// the command echo) executes the command, which keeps everyone in step.
  Future<void> sendCommand(
    Enum$PlaybackCommandType command, {
    Duration? position,
    String? playQueueItemId,
  }) async {
    final client = core.graphQLClient;
    final pq = core.playQueue;
    if (client == null || pq == null) return;
    final ok = await core.playQueueService.sendPlaybackCommand(
      client,
      pq.id,
      command,
      position: position,
      playQueueItemId: playQueueItemId,
    );
    // false = the server refused (no control permission on this session);
    // without feedback the tapped control appears simply broken. null is a
    // transport error and stays silent, like before.
    if (ok == false) {
      showAppSnackBar(IsterMediaService.loc.followControlDenied);
    }
  }
}
