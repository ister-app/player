import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/nowPlayingSubscription.graphql.dart';
import 'package:player/graphql/playbackCommandsSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../components/LiveFeedBanner.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PlayQueueService.dart';
import '../utils/ResilientSubscription.dart';
import '../utils/StreamTokenService.dart';
import '../utils/WellKnownService.dart';

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
  late final _RemotePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _RemotePlayerController(
      serverName: widget.serverName,
      playQueueId: widget.playQueueId,
      onSessionUnknown: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.sessionEnded)));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Session gone before we ever saw it: no player to render, just say so.
        if (_controller.sessionEnded && !_controller.hasSession) {
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
          controller: _controller,
          headerTitle: _controller.headerTitle,
          onDismissed: () => context.router.pop(),
          bannerBuilder: !_controller.liveFeedBroken && !_controller.sessionEnded
              ? null
              : (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.liveFeedBroken) const LiveFeedBanner(),
                      if (_controller.sessionEnded)
                        _SessionEndedBanner(text: loc.sessionEnded),
                    ],
                  ),
        );
      },
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
class _RemotePlayerController extends PlayerViewController {
  _RemotePlayerController({
    required this.serverName,
    required this.playQueueId,
    required this.onSessionUnknown,
  }) {
    StreamTokenService.ensureToken(serverName).then((_) {
      if (!_disposed) notifyListeners();
    });

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
  DateTime? _overrideSetAt;

  /// Optimistic queue order held during a reorder/remove so the list doesn't
  /// snap back while the mutation is in flight.
  List<Fragment$fragmentPlayQueue$playQueueItems>? _localItems;

  GraphQLClient get _client => ClientManager.getClientForUrl(serverName).value;

  bool get hasSession => _session != null;

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
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _nowPlayingSubscription?.dispose();
    _commandsSubscription?.dispose();
    super.dispose();
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
      case Enum$PlaybackCommandType.$unknown:
        break;
    }
  }

  void _applyOverride({int? progressMs, bool? paused}) {
    _overrideProgressMs = progressMs ?? positionMs;
    _overridePaused = paused ?? _displayPaused();
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
  }) async {
    final known = await PlayQueueService().sendPlaybackCommand(
      _client,
      playQueueId,
      command,
      position: position,
      playQueueItemId: playQueueItemId,
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
  String? get _currentItemId =>
      _session?.playQueueItemId ?? _playQueue?.currentItemId;

  List<Fragment$fragmentPlayQueue$playQueueItems> get _sortedItems =>
      _localItems ?? PlayQueueService.sortedItems(_playQueue);

  int get _currentIndex {
    final id = _currentItemId;
    if (id == null) return -1;
    return _sortedItems.indexWhere((e) => e.id == id);
  }

  ({
    List<Fragment$fragmentPlayQueue$playQueueItems> previous,
    List<Fragment$fragmentPlayQueue$playQueueItems> upNext
  }) _sliceQueue() {
    final items = _sortedItems;
    final index = _currentIndex;
    final previous = index > 0
        ? items.sublist(0, index).reversed.toList()
        : <Fragment$fragmentPlayQueue$playQueueItems>[];
    final upNext = index >= 0 && index + 1 < items.length
        ? items.sublist(index + 1)
        : <Fragment$fragmentPlayQueue$playQueueItems>[];
    return (previous: previous, upNext: upNext);
  }

  // ── Display helpers ──────────────────────────────────────────────────────

  String? _sessionArtworkUrl() {
    final imageId = _session?.artworkImageId;
    if (imageId == null) return null;
    final serverUrl = WellKnownService.getCached(serverName)?.serverUrl;
    if (serverUrl == null) return null;
    final token = StreamTokenService.getToken(serverName);
    final base = '$serverUrl/images/$imageId/download';
    return token != null ? '$base?token=$token' : base;
  }

  ({String title, String? subtitle, String? album, String? artUrl})
      _itemDisplay(Fragment$fragmentPlayQueue$playQueueItems item) {
    final token = StreamTokenService.getToken(serverName);
    if (item.track != null) {
      final t = item.track!;
      return (
        title: MetadataUtil.getTitle(t.metadata) ?? '${t.number}',
        subtitle: t.artist.name,
        album: t.album.name,
        artUrl: ImageUtil.buildUrl(
            ImageUtil.getImageByType(t.album.images, ImageTypes.cover),
            token: token),
      );
    } else if (item.movie != null) {
      final m = item.movie!;
      return (
        title: m.name,
        subtitle: null,
        album: null,
        artUrl: ImageUtil.buildUrl(
            ImageUtil.getImageByType(m.images, ImageTypes.background),
            token: token),
      );
    }
    final ep = item.episode;
    return (
      title: MetadataUtil.getTitle(ep?.metadata) ?? 'unknown',
      subtitle: null,
      album: null,
      artUrl: ep == null
          ? null
          : ImageUtil.buildUrl(
              ImageUtil.getImageByType(ep.images, ImageTypes.background),
              token: token),
    );
  }

  Fragment$fragmentPlayQueue$playQueueItems? get _currentItem {
    final id = _currentItemId;
    if (id == null) return null;
    return _sortedItems.where((e) => e.id == id).firstOrNull;
  }

  // ── PlayerViewController ─────────────────────────────────────────────────

  @override
  bool get loading => _session == null && !sessionEnded;

  @override
  bool get enabled => !sessionEnded;

  @override
  String? get artUri {
    final current = _currentItem;
    return _sessionArtworkUrl() ??
        (current == null ? null : _itemDisplay(current).artUrl);
  }

  @override
  bool get portraitArtwork => _currentItem?.chapter != null;

  @override
  String? get artistLine =>
      _currentItem == null ? null : _itemDisplay(_currentItem!).subtitle;

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
  bool get hasPrevious => _currentIndex > 0;

  @override
  bool get hasNext {
    final index = _currentIndex;
    return index >= 0 && index < _sortedItems.length - 1;
  }

  PlayerQueueEntry _toEntry(Fragment$fragmentPlayQueue$playQueueItems item) {
    final display = _itemDisplay(item);
    return PlayerQueueEntry(
      id: item.id,
      title: display.title,
      subtitle: display.subtitle,
      artUrl: display.artUrl,
    );
  }

  @override
  List<PlayerQueueEntry> get previous =>
      _sliceQueue().previous.map(_toEntry).toList();

  @override
  List<PlayerQueueEntry> get upNext =>
      _sliceQueue().upNext.map(_toEntry).toList();

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
  void tapPrevious(int index) => _skipToItem(_sliceQueue().previous[index]);

  @override
  void tapUpNext(int index) => _skipToItem(_sliceQueue().upNext[index]);

  @override
  Future<void> moveUpNext(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;

    final reordered = List.of(_sliceQueue().upNext);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final items = _sortedItems;
    final head = _currentIndex >= 0
        ? items.sublist(0, _currentIndex + 1)
        : <Fragment$fragmentPlayQueue$playQueueItems>[];
    _localItems = [...head, ...reordered];
    notifyListeners();

    // Moving to the head of "up next" means directly after the current item.
    final afterId = newIndex == 0 ? _currentItemId : reordered[newIndex - 1].id;
    await PlayQueueService()
        .movePlayQueueItem(_client, playQueueId, moved.id, afterId);
    // The mutation fans out QUEUE_CHANGED, which refreshes and clears
    // _localItems; nothing else to do here.
  }

  @override
  Future<void> removeEntry(PlayerQueueEntry entry) async {
    _localItems = _sortedItems.where((e) => e.id != entry.id).toList();
    notifyListeners();
    await PlayQueueService()
        .removePlayQueueItem(_client, playQueueId, entry.id);
  }
}
