import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/RatingStars.dart';
import 'package:player/components/QueuePlayerViewController.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/nowPlayingSubscription.graphql.dart';
import 'package:player/graphql/playbackCommandsSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../components/LiveFeedBanner.dart';
import '../routes/AppRouter.gr.dart';
import '../l10n/app_localizations.dart';
import '../utils/AppMessenger.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/SyncPreferences.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';
import '../utils/ImageUtil.dart';
import '../utils/PlayQueueService.dart';
import '../utils/QueueItemDisplay.dart';
import '../utils/ResilientSubscription.dart';
import '../utils/StreamTokenService.dart';

/// Remote control ("party mode") for one active playback session on the
/// server: the same [PlayerView] overlay as the local music player — also when
/// the session plays a video — whose controls are executed by the client that
/// owns the session. State comes in over the nowPlaying subscription; queue
/// edits arrive as QUEUE_CHANGED commands on the playbackCommands
/// subscription.
@RoutePage()
class RemoteControlPage extends StatefulWidget {
  final String serverName;
  final String playQueueId;

  const RemoteControlPage({
    super.key,
    @PathParam('serverName') required this.serverName,
    @PathParam('playQueueId') required this.playQueueId,
  });

  @override
  State<RemoteControlPage> createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  _RemotePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  /// A cold URL open (shared party link) lands here without the server shell
  /// ever mounting, so LoginManager/WellKnownService may be uninitialized and
  /// the GraphQL calls would go out unauthenticated. waitForToken bootstraps
  /// both (same seam the audio-service session restore uses); the warm path
  /// resolves near-instantly.
  Future<void> _bootstrap() async {
    try {
      await LoginManager.waitForToken(widget.serverName);
    } catch (e) {
      LoggerService().logger.w('Remote-control token bootstrap failed: $e');
      // Fall through: the session-unknown handling below reports the failure.
    }
    if (!mounted) return;
    setState(() {
      _controller = _RemotePlayerController(
        serverName: widget.serverName,
        playQueueId: widget.playQueueId,
        onSessionUnknown: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.sessionEnded)));
        },
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final controller = _controller;
    if (controller == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF101014),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white54),
        ),
      );
    }
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // Session gone before we ever saw it: no player to render, just say so.
        if (controller.sessionEnded && !controller.hasSession) {
          return Scaffold(
            backgroundColor: const Color(0xFF101014),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tv_off, color: Colors.white38, size: 48),
                  const SizedBox(height: 16),
                  Text(loc.sessionEnded,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          );
        }

        return PlayerView(
          controller: controller,
          onDismissed: () => context.router.pop(),
        );
      },
    );
  }
}

/// Start/stop "listen along" for this session on *this* device. Anyone who
/// can open the remote control may also follow (same server-side permission);
/// the server still verifies and answers NOT_FOUND / NO_LIBRARY_ACCESS.
class _ListenAlongBanner extends StatelessWidget {
  const _ListenAlongBanner({
    required this.serverName,
    required this.playQueueId,
  });

  final String serverName;
  final String playQueueId;

  Future<void> _start(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final result = await MediaPlayerHandler.instance
        .startFollowingQueue(serverName, playQueueId);
    switch (result) {
      case Enum$FollowResult.OK:
        break;
      case Enum$FollowResult.NO_LIBRARY_ACCESS:
        showAppSnackBar(loc.followNoLibraryAccess);
      case Enum$FollowResult.NOT_FOUND:
      case Enum$FollowResult.$unknown:
        showAppSnackBar(loc.followQueueUnavailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final handler = MediaPlayerHandler.instance;
    // Make sure the persisted tight-sync settings are in their notifiers
    // before the controls below render them.
    unawaited(SyncPreferences.ensureLoaded());
    return ValueListenableBuilder<bool>(
      valueListenable: handler.followModeNotifier,
      builder: (context, following, _) {
        final followingThisQueue =
            following && handler.playQueue?.id == playQueueId;
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.headphones, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      followingThisQueue
                          ? loc.followingBadge
                          : loc.followListenAlong,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: followingThisQueue
                        ? () => handler.stopFollowing()
                        : () => _start(context),
                    child: Text(followingThisQueue
                        ? loc.stopListeningAlong
                        : loc.followListenAlong),
                  ),
                ],
              ),
              if (followingThisQueue) const _TightSyncControls(),
            ],
          ),
        );
      },
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
    return ValueListenableBuilder<bool>(
      valueListenable: SyncPreferences.tightSyncEnabled,
      builder: (context, tightSync, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(loc.tightSyncToggle,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            value: tightSync,
            onChanged: (enabled) =>
                SyncPreferences.setTightSyncEnabled(enabled),
          ),
          if (tightSync)
            ValueListenableBuilder<int>(
              valueListenable: SyncPreferences.outputLatencyMs,
              builder: (context, latency, _) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(loc.outputLatencySlider(latency),
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
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

class _SessionEndedBanner extends StatelessWidget {
  const _SessionEndedBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.tv_off, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.orange, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

/// Adapts a remote playback session (nowPlaying + playbackCommands
/// subscriptions and playback-command mutations) to the shared
/// [PlayerViewController] interface.
class _RemotePlayerController
    extends QueuePlayerViewController<Fragment$fragmentPlayQueue$playQueueItems> {
  _RemotePlayerController({
    required this.serverName,
    required this.playQueueId,
    required this.onSessionUnknown,
  }) {
    StreamTokenService.ensureToken(serverName).then((_) {
      if (!_disposed) notifyListeners();
    });
    // Artwork URLs are built in the getters, so a token renewal only has to
    // trigger a rebuild — otherwise every cover goes stale mid-session.
    StreamTokenService.tokenVersion.addListener(_onTokenRefreshed);

    // The server replays the latest session list on subscribe, so no separate
    // snapshot query is needed to render the initial state.
    _nowPlayingSubscription = ResilientSubscription(
      client: _client,
      document: documentNodeSubscriptionnowPlaying,
      onData: (result) {
        if (_disposed) return;
        final sessions =
            Subscription$nowPlaying.fromJson(result.data!).nowPlaying;
        final session =
            sessions.where((s) => s.playQueueId == playQueueId).firstOrNull;
        liveFeedBroken = false;
        if (session == null) {
          sessionEnded = true;
        } else {
          _session = session;
          _anchor = DateTime.now();
        }
        _syncTicker();
        notifyListeners();
      },
      onFailure: (_) {
        if (_disposed) return;
        liveFeedBroken = true;
        notifyListeners();
      },
    );

    _commandsSubscription = ResilientSubscription(
      client: _client,
      document: documentNodeSubscriptionplaybackCommands,
      variables: {'playQueueId': playQueueId},
      onData: (result) {
        if (_disposed) return;
        final command = Subscription$playbackCommands.fromJson(result.data!)
            .playbackCommands;
        _onCommandObserved(command);
      },
      onFailure: (_) {},
    );

    _refreshQueue();
  }

  final String serverName;
  final String playQueueId;

  /// Notifies that a transport command was sent for a session the server no
  /// longer knows; the nowPlaying feed will confirm and flip [sessionEnded].
  final VoidCallback onSessionUnknown;

  Fragment$fragmentPlaybackSession? _session;
  Fragment$fragmentPlayQueue? _playQueue;
  bool sessionEnded = false;
  bool liveFeedBroken = false;
  bool _disposed = false;

  ResilientSubscription? _nowPlayingSubscription;
  ResilientSubscription? _commandsSubscription;

  /// Wall-clock instant the current [_session] snapshot was received; PLAYING
  /// sessions interpolate their position from it between heartbeats.
  DateTime? _anchor;
  Timer? _ticker;

  /// Optimistic state after sending (or observing) a transport command. The
  /// playing client's next heartbeat can lag up to ~10s behind and would snap
  /// the seek bar back, so session progress/playState are ignored while an
  /// override is fresh.
  static const _overrideWindow = Duration(seconds: 6);
  int? _overrideProgressMs;
  bool? _overridePaused;
  Enum$RepeatMode? _overrideRepeatMode;
  DateTime? _overrideSetAt;

  /// Optimistic queue order held during a reorder/remove so the list doesn't
  /// snap back while the mutation is in flight.
  List<Fragment$fragmentPlayQueue$playQueueItems>? _localItems;

  GraphQLClient get _client => ClientManager.getClientForUrl(serverName).value;

  bool get hasSession => _session != null;

  @override
  String? get headerTitle {
    final session = _session;
    if (session == null) return null;
    final parts = [
      if (session.userName != null) session.userName!,
      session.nodeName,
    ];
    return parts.join(' · ');
  }

  @override
  Widget? buildBanner(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (liveFeedBroken) const LiveFeedBanner(),
        if (sessionEnded) _SessionEndedBanner(text: loc.sessionEnded),
        if (!sessionEnded)
          _ListenAlongBanner(
            serverName: serverName,
            playQueueId: playQueueId,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    StreamTokenService.tokenVersion.removeListener(_onTokenRefreshed);
    _nowPlayingSubscription?.dispose();
    _commandsSubscription?.dispose();
    super.dispose();
  }

  void _onTokenRefreshed() {
    if (!_disposed) notifyListeners();
  }

  /// Applies commands (our own echoes and other controllers') optimistically
  /// so every open remote reflects a change before the next heartbeat lands.
  void _onCommandObserved(
      Subscription$playbackCommands$playbackCommands command) {
    switch (command.command) {
      case Enum$PlaybackCommandType.QUEUE_CHANGED:
        _refreshQueue();
      case Enum$PlaybackCommandType.PLAY:
        _applyOverride(paused: false);
      case Enum$PlaybackCommandType.PAUSE:
        _applyOverride(paused: true);
      case Enum$PlaybackCommandType.SEEK:
        final ms = command.positionInMilliseconds;
        if (ms != null) _applyOverride(progressMs: ms);
      case Enum$PlaybackCommandType.NEXT:
      case Enum$PlaybackCommandType.PREVIOUS:
      case Enum$PlaybackCommandType.SKIP_TO_ITEM:
        // The playing client force-syncs the new item right away; the next
        // nowPlaying emission carries it. Only reset the bar optimistically.
        _applyOverride(progressMs: 0);
      case Enum$PlaybackCommandType.SET_REPEAT:
        _applyOverride(repeatMode: command.repeatMode);
      // Aimed at one following device, and changes nothing about the session.
      case Enum$PlaybackCommandType.STOP_FOLLOW:
      case Enum$PlaybackCommandType.$unknown:
        break;
    }
  }

  void _applyOverride(
      {int? progressMs, bool? paused, Enum$RepeatMode? repeatMode}) {
    _overrideProgressMs = progressMs ?? positionMs;
    _overridePaused = paused ?? _displayPaused();
    _overrideRepeatMode = repeatMode ?? _displayRepeatMode();
    _overrideSetAt = DateTime.now();
    _syncTicker();
    positionTicker.notify();
    notifyListeners();
  }

  bool get _overrideActive =>
      _overrideSetAt != null &&
      DateTime.now().difference(_overrideSetAt!) < _overrideWindow;

  bool _displayPaused() {
    if (_overrideActive && _overridePaused != null) return _overridePaused!;
    return _session?.playState == Enum$PlayState.PAUSED;
  }

  void _syncTicker() {
    final shouldTick = !sessionEnded && !_displayPaused();
    if (shouldTick && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_disposed) positionTicker.notify();
      });
    } else if (!shouldTick) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  Future<void> _refreshQueue() async {
    final queue = await PlayQueueService().getPlayQueue(_client, playQueueId);
    if (_disposed || queue == null) return;
    _playQueue = queue;
    _localItems = null;
    notifyListeners();
  }

  Future<void> _sendCommand(
    Enum$PlaybackCommandType command, {
    Duration? position,
    String? playQueueItemId,
    Enum$RepeatMode? repeatMode,
  }) async {
    final known = await PlayQueueService().sendPlaybackCommand(
      _client,
      playQueueId,
      command,
      position: position,
      playQueueItemId: playQueueItemId,
      repeatMode: repeatMode,
    );
    if (_disposed) return;
    if (known == false) {
      // No live session was known server-side; tell the user right away.
      onSessionUnknown();
    }
  }

  // ── Queue helpers ────────────────────────────────────────────────────────

  /// The id of the item the session is playing right now; the live session is
  /// authoritative, the stored queue's currentItemId is the fallback.
  @override
  String? get currentQueueItemId =>
      _session?.playQueueItemId ?? _playQueue?.currentItemId;

  @override
  List<Fragment$fragmentPlayQueue$playQueueItems> get queueItems =>
      _localItems ?? PlayQueueService.sortedItems(_playQueue);

  @override
  int get currentIndex {
    final id = currentQueueItemId;
    if (id == null) return -1;
    return queueItems.indexWhere((e) => e.id == id);
  }

  @override
  String queueItemIdOf(Fragment$fragmentPlayQueue$playQueueItems item) => item.id;

  @override
  void setOptimisticQueue(List<Fragment$fragmentPlayQueue$playQueueItems>? items) => _localItems = items;

  @override
  bool get disposed => _disposed;

  /// The move/remove mutations fan out QUEUE_CHANGED, and that refresh clears
  /// the optimistic order — doing it here as well would flash the stale queue.
  @override
  bool get clearsOptimisticQueue => false;

  @override
  Future<void> applyMove(String movedId, String? afterId) =>
      PlayQueueService().movePlayQueueItem(_client, playQueueId, movedId, afterId);

  @override
  Future<void> applyRemove(String queueItemId) =>
      PlayQueueService().removePlayQueueItem(_client, playQueueId, queueItemId);

  // ── Display helpers ──────────────────────────────────────────────────────

  QueueItemDisplay _itemDisplay(
          Fragment$fragmentPlayQueue$playQueueItems item) =>
      QueueItemDisplay.of(item,
          token: StreamTokenService.getToken(serverName));

  Fragment$fragmentPlayQueue$playQueueItems? get _currentItem {
    final index = currentIndex;
    return index < 0 ? null : queueItems[index];
  }

  // ── PlayerViewController ─────────────────────────────────────────────────

  @override
  bool get loading => _session == null && !sessionEnded;

  @override
  bool get enabled => !sessionEnded;

  @override
  String? get artUri {
    final current = _currentItem;
    return ImageUtil.buildUrlById(serverName, _session?.artworkImageId) ??
        (current == null ? null : _itemDisplay(current).artUrl);
  }

  @override
  bool get portraitArtwork {
    final current = _currentItem;
    return current != null && _itemDisplay(current).portraitArtwork;
  }

  @override
  String? get artistLine =>
      _currentItem == null ? null : _itemDisplay(_currentItem!).artist;

  @override
  String? get titleLine {
    final current = _currentItem;
    if (current != null) return _itemDisplay(current).title;
    final session = _session;
    return session?.title ?? session?.mediaId ?? playQueueId;
  }

  @override
  String? get albumLine =>
      _currentItem == null ? null : _itemDisplay(_currentItem!).album;

  /// Interpolated position: the freshest of the optimistic override and the
  /// last heartbeat, advanced with wall-clock time while playing.
  @override
  int get positionMs {
    int position;
    DateTime? anchor;
    if (_overrideActive && _overrideProgressMs != null) {
      position = _overrideProgressMs!;
      anchor = _overrideSetAt;
    } else {
      position = _session?.progressInMilliseconds ?? 0;
      anchor = _anchor;
    }
    if (!_displayPaused() && anchor != null) {
      position += DateTime.now().difference(anchor).inMilliseconds;
    }
    final total = _session?.durationInMilliseconds;
    if (total != null && position > total) position = total;
    return position < 0 ? 0 : position;
  }

  @override
  int? get durationMs => _session?.durationInMilliseconds;

  @override
  bool get canSeek {
    final total = durationMs;
    return total != null && total > 0 && !sessionEnded;
  }

  @override
  PlayerQueueEntry entryFor(Fragment$fragmentPlayQueue$playQueueItems item) {
    final display = _itemDisplay(item);
    return PlayerQueueEntry(
      id: item.id,
      title: display.title,
      subtitle: display.artist,
      artUrl: display.artUrl,
    );
  }

  /// Rating of the playing track. The play queue carries the track's id and
  /// current rating, and setRating is not owner-scoped, so a remote controller
  /// can rate along exactly like the playing device does.
  @override
  Widget? buildRating(BuildContext context, Color accent) {
    final track = _currentItem?.track;
    if (track == null) return null;
    return RatingStars(
      // Re-key per track so switching songs adopts the new rating instead of
      // keeping the previous track's optimistic value.
      key: ValueKey('remote_rating_${track.id}'),
      mediaType: Enum$RatingMediaType.TRACK,
      mediaId: track.id,
      rating: track.rating,
      client: _client,
      size: 28,
      showValue: false,
      color: accent,
      emptyColor: Colors.white30,
    );
  }

  /// Resolve targets from the playing queue item, paired with the session's
  /// server — the same navigation the local player offers.
  @override
  ({String serverName, PageRouteInfo route})? get artistRoute {
    final item = _currentItem;
    final personId = item?.track?.artist.id ?? item?.chapter?.author.id;
    if (personId == null) return null;
    return (serverName: serverName, route: PersonRoute(personId: personId));
  }

  @override
  ({String serverName, PageRouteInfo route})? get albumRoute {
    final item = _currentItem;
    final albumId = item?.track?.album.id;
    if (albumId != null) {
      return (serverName: serverName, route: AlbumRoute(albumId: albumId));
    }
    final bookId = item?.chapter?.book.id;
    if (bookId != null) {
      return (serverName: serverName, route: BookRoute(bookId: bookId));
    }
    final podcastId = item?.podcastEpisode?.podcast.id;
    if (podcastId != null) {
      return (serverName: serverName, route: PodcastRoute(podcastId: podcastId));
    }
    return null;
  }

  /// The session's repeat mode, overridden optimistically right after a change
  /// so the toggle reacts before the playing device's next heartbeat.
  Enum$RepeatMode _displayRepeatMode() {
    if (_overrideActive && _overrideRepeatMode != null) {
      return _overrideRepeatMode!;
    }
    return _session?.repeatMode ?? Enum$RepeatMode.NONE;
  }

  // The playing client owns the repeat mode and reports it on its heartbeat,
  // so a controller can show and cycle it just like the local player.
  @override
  bool get supportsRepeat => true;

  @override
  bool get repeatActive => _displayRepeatMode() != Enum$RepeatMode.NONE;

  @override
  bool get repeatOne => _displayRepeatMode() == Enum$RepeatMode.ONE;

  @override
  bool get queueWrapsAround => _displayRepeatMode() == Enum$RepeatMode.ALL;

  @override
  void cycleRepeatMode() {
    const order = [
      Enum$RepeatMode.NONE,
      Enum$RepeatMode.ALL,
      Enum$RepeatMode.ONE,
    ];
    final next =
        order[(order.indexOf(_displayRepeatMode()) + 1) % order.length];
    _applyOverride(repeatMode: next);
    unawaited(_sendCommand(Enum$PlaybackCommandType.SET_REPEAT,
        repeatMode: next));
  }

  @override
  Widget buildPlayPauseButton(BuildContext context) {
    final paused = _displayPaused();
    return IconButton(
      icon: Icon(paused ? Icons.play_arrow : Icons.pause, color: Colors.black),
      iconSize: 48,
      onPressed: sessionEnded
          ? null
          : () {
              _applyOverride(paused: !paused);
              unawaited(_sendCommand(paused
                  ? Enum$PlaybackCommandType.PLAY
                  : Enum$PlaybackCommandType.PAUSE));
            },
    );
  }

  @override
  void skipToPrevious() {
    _applyOverride(progressMs: 0);
    unawaited(_sendCommand(Enum$PlaybackCommandType.PREVIOUS));
  }

  @override
  void skipToNext() {
    _applyOverride(progressMs: 0);
    unawaited(_sendCommand(Enum$PlaybackCommandType.NEXT));
  }

  @override
  void seek(Duration position) {
    _applyOverride(progressMs: position.inMilliseconds);
    unawaited(
        _sendCommand(Enum$PlaybackCommandType.SEEK, position: position));
  }

  void _skipToItem(Fragment$fragmentPlayQueue$playQueueItems item) {
    unawaited(_sendCommand(Enum$PlaybackCommandType.SKIP_TO_ITEM,
        playQueueItemId: item.id));
  }

  @override
  void tapPrevious(int index) => _skipToItem(sliceQueue().previous[index]);

  @override
  void tapUpNext(int index) => _skipToItem(sliceQueue().upNext[index]);
}
