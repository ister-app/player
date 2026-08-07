import 'dart:async';

import 'package:flutter/material.dart';
import 'package:player/components/DevicePickerSheet.dart';
import 'package:player/components/SessionListenersSheet.dart';
import 'package:player/components/SessionSharingSheet.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/DeviceService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/SyncPreferences.dart';

import '../l10n/app_localizations.dart';

/// The one "listen together" surface: who is listening along with a session,
/// joining or leaving it on this device, sending it to another of the user's
/// devices, and (for the owner) sharing and moving it. What it offers follows
/// from how this device relates to the session:
///
/// - the session is this device's own playback → manage it (listeners with
///   kick, listen along on / move to another device, per-session sharing);
/// - this device follows the session → stop listening and tune the same-room
///   sync;
/// - anything else → a prominent join button.
///
/// [serverName] must be the server that owns the session (resolved from the
/// session/handler by the caller, never from the browsed route).
Future<void> showListenTogetherSheet(
  BuildContext context, {
  required String serverName,
  required String playQueueId,
  Enum$MediaType? mediaType,
  VoidCallback? onQueueMoved,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _ListenTogetherSheet(
      serverName: serverName,
      playQueueId: playQueueId,
      mediaType: mediaType,
      onQueueMoved: onQueueMoved,
    ),
  );
}

class _ListenTogetherSheet extends StatefulWidget {
  const _ListenTogetherSheet({
    required this.serverName,
    required this.playQueueId,
    this.mediaType,
    this.onQueueMoved,
  });

  final String serverName;
  final String playQueueId;

  /// The session's current media kind, for the watch/listen wording when the
  /// queue is not (yet) live on this device. A live queue overrides this.
  final Enum$MediaType? mediaType;

  /// Called after the queue was handed off to another device, so the hosting
  /// player overlay can dismiss itself along with the playback it lost.
  final VoidCallback? onQueueMoved;

  @override
  State<_ListenTogetherSheet> createState() => _ListenTogetherSheetState();
}

enum _Role { owner, follower, viewer }

class _ListenTogetherSheetState extends State<_ListenTogetherSheet> {
  /// Set when a join answered NOT_FOUND: the session is gone, so offering the
  /// join button again would only fail the same way.
  bool _sessionGone = false;
  bool _joining = false;

  MediaPlayerHandler get _handler => MediaPlayerHandler.instance;

  /// Ownership as seen when the sheet opened. Checked again on every rebuild,
  /// but never gained while open: stopFollowing keeps the followed queue as
  /// the handler's playQueue, which would otherwise read as "own live queue"
  /// and flip the sheet into managing a session that isn't ours.
  late final bool _ownerAtOpen =
      _handler.isOwnLiveQueue(widget.serverName, widget.playQueueId);

  @override
  void initState() {
    super.initState();
    // The persisted tight-sync settings must be in their notifiers before the
    // sync controls render them.
    unawaited(SyncPreferences.ensureLoaded());
  }

  /// Watching (movie/episode) or listening — drives the sheet's wording. The
  /// live queue on this device (own or followed) knows its current item and
  /// stays correct across music↔video switches; otherwise the caller's session
  /// media type decides.
  bool get _isWatch {
    if (_handler.playQueue?.id == widget.playQueueId) {
      return _handler.movie != null || _handler.episode != null;
    }
    return widget.mediaType == Enum$MediaType.MOVIE ||
        widget.mediaType == Enum$MediaType.EPISODE;
  }

  _Role _role() {
    if (_handler.followMode &&
        _handler.serverName == widget.serverName &&
        _handler.playQueue?.id == widget.playQueueId) {
      return _Role.follower;
    }
    if (_ownerAtOpen &&
        _handler.isOwnLiveQueue(widget.serverName, widget.playQueueId)) {
      return _Role.owner;
    }
    return _Role.viewer;
  }

  Future<void> _join() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _joining = true);
    final result = await _handler.startFollowingQueue(
        widget.serverName, widget.playQueueId);
    if (!mounted) return;
    setState(() => _joining = false);
    switch (result) {
      case Enum$FollowResult.OK:
        // Don't pop: followModeNotifier flips and the sheet rebuilds into
        // follower mode, landing the user on the stop/sync controls.
        break;
      case Enum$FollowResult.NO_LIBRARY_ACCESS:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.followNoLibraryAccess)));
      case Enum$FollowResult.NOT_FOUND:
      case Enum$FollowResult.$unknown:
        setState(() => _sessionGone = true);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.followQueueUnavailable)));
    }
  }

  /// Lets another of the user's devices listen along with this session. The
  /// device executes the follow itself, so the usual follow permission checks
  /// run there (same user, so they match this device's).
  Future<void> _listenAlongOnDevice() async {
    final loc = AppLocalizations.of(context)!;
    final device = await showDevicePickerSheet(context,
        serverName: widget.serverName, title: loc.deviceListenAlongOn);
    if (device == null || !mounted) return;
    final accepted = await DeviceService.instance.sendCommand(
      widget.serverName,
      deviceId: device.deviceId,
      command: Enum$DeviceCommandType.START_FOLLOW,
      playQueueId: widget.playQueueId,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(accepted
            ? loc.deviceCommandSent(device.name)
            : loc.deviceCommandFailed)));
  }

  /// Hands the queue off to another device: pause (flushes progress), tell the
  /// target to take over at the current position, and stop locally once the
  /// server accepted. On refusal local playback resumes where it was.
  Future<void> _moveQueueToDevice() async {
    final loc = AppLocalizations.of(context)!;
    final device = await showDevicePickerSheet(context,
        serverName: widget.serverName, title: loc.deviceMoveQueue);
    if (device == null || !mounted) return;

    final wasPlaying = _handler.playbackState.value.playing;
    await _handler.pause();
    final accepted = await DeviceService.instance.sendCommand(
      widget.serverName,
      deviceId: device.deviceId,
      command: Enum$DeviceCommandType.TAKEOVER_QUEUE,
      playQueueId: widget.playQueueId,
      positionMs: _handler.playbackState.value.position.inMilliseconds,
    );
    if (accepted) {
      // Close this sheet first: the teardown below closes the video page/music
      // overlay underneath it, which shouldn't happen while a modal of ours is
      // still on top of them.
      if (mounted) Navigator.of(context).pop();
      // End playback here after the send: the target's first heartbeat (same
      // user, so ownership holds) takes the session over from this device.
      // No progress flush — the pause above already wrote the position, and
      // from here on the target owns it.
      await _handler.endPlaybackLocally(flushProgress: false);
      widget.onQueueMoved?.call();
    } else if (wasPlaying) {
      await _handler.play();
    }
    // The sheet may just have popped itself, so use the app-level messenger.
    showAppSnackBar(accepted
        ? loc.deviceCommandSent(device.name)
        : loc.deviceCommandFailed);
  }

  Future<void> _openSessionSharing() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SessionSharingSheet(
        serverName: widget.serverName,
        playQueueId: widget.playQueueId,
        currentOverride: _handler.playQueue?.controlScopeOverride,
        currentAllowedUserIds: _handler.playQueue?.controlAllowedUserIds ?? const [],
      ),
    );
  }

  List<Widget> _ownerContent(AppLocalizations loc) => [
        SessionListenersList(
          serverName: widget.serverName,
          playQueueId: widget.playQueueId,
          canKick: true,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.speaker_group),
          title: Text(loc.deviceListenAlongOn),
          onTap: _listenAlongOnDevice,
        ),
        ListTile(
          leading: const Icon(Icons.devices),
          title: Text(loc.deviceMoveQueue),
          onTap: _moveQueueToDevice,
        ),
        ListTile(
          leading: const Icon(Icons.ios_share),
          title: Text(loc.shareThisSession),
          onTap: _openSessionSharing,
        ),
      ];

  /// Leaves the session: the shared media is the leader's, so playback ends
  /// here rather than staying paused (teardown) — the video page/music overlay
  /// under this sheet closes with it. The sheet itself stays open and rebuilds
  /// into its join state, so rejoining is one tap away.
  void _stopFollowing() => unawaited(_handler.stopFollowing(teardown: true));

  List<Widget> _followerContent(AppLocalizations loc) => [
        ListTile(
          leading: Icon(_isWatch ? Icons.connected_tv : Icons.headphones),
          title: Text(_isWatch ? loc.watchingBadge : loc.followingBadge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _stopFollowing,
            child: Text(
                _isWatch ? loc.stopWatchingAlong : loc.stopListeningAlong),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _TightSyncControls(),
        ),
        SessionListenersList(
          serverName: widget.serverName,
          playQueueId: widget.playQueueId,
          hideWhenUnavailable: true,
        ),
      ];

  List<Widget> _viewerContent(AppLocalizations loc) => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _sessionGone || _joining ? null : _join,
            icon: Icon(_isWatch ? Icons.connected_tv : Icons.headphones),
            label: Text(_sessionGone
                ? loc.sessionEnded
                : _isWatch
                    ? loc.followWatchAlong
                    : loc.followListenAlong),
          ),
        ),
        SessionListenersList(
          serverName: widget.serverName,
          playQueueId: widget.playQueueId,
          hideWhenUnavailable: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder<bool>(
      valueListenable: _handler.followModeNotifier,
      builder: (context, _, __) => StreamBuilder<Object?>(
        // The wording (watch/listen) follows the live queue's current item, so
        // the sheet rebuilds when the session switches between music and video.
        stream: _handler.mediaItem,
        builder: (context, _) {
          final children = switch (_role()) {
            _Role.owner => _ownerContent(loc),
            _Role.follower => _followerContent(loc),
            _Role.viewer => _viewerContent(loc),
          };
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Text(
                        _isWatch
                            ? loc.watchTogetherTitle
                            : loc.listenTogetherTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Tight-sync controls for a following device: the "same room" switch and,
/// when enabled, the output-latency slider (the one thing software cannot
/// measure — the user shifts it until the echo between devices disappears).
class _TightSyncControls extends StatelessWidget {
  const _TightSyncControls();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: SyncPreferences.tightSyncEnabled,
      builder: (context, tightSync, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(loc.tightSyncToggle),
            value: tightSync,
            onChanged: (enabled) => SyncPreferences.setTightSyncEnabled(enabled),
          ),
          if (tightSync)
            ValueListenableBuilder<int>(
              valueListenable: SyncPreferences.outputLatencyMs,
              builder: (context, latency, _) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(loc.outputLatencySlider(latency),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  Slider(
                    value: latency.toDouble(),
                    min: 0,
                    max: 500,
                    divisions: 50,
                    onChanged: (value) =>
                        SyncPreferences.setOutputLatencyMs(value.round()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
