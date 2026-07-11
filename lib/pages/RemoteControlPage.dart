import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/nowPlayingSubscription.graphql.dart';
import 'package:player/graphql/playbackCommandsSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../components/LiveFeedBanner.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/DurationUtil.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PlayQueueService.dart';
import '../utils/ResilientSubscription.dart';
import '../utils/StreamTokenService.dart';
import '../utils/WellKnownService.dart';

/// Remote control ("party mode") for one active playback session on the
/// server: a music-player-style page — also when the session plays a video —
/// whose controls are executed by the client that owns the session. State
/// comes in over the nowPlaying subscription; queue edits arrive as
/// QUEUE_CHANGED commands on the playbackCommands subscription.
@RoutePage()
class RemoteControlPage extends StatefulWidget {
  final String serverName;
  final String playQueueId;

  const RemoteControlPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('playQueueId') required this.playQueueId,
  });

  @override
  State<RemoteControlPage> createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  Fragment$fragmentPlaybackSession? _session;
  Fragment$fragmentPlayQueue? _playQueue;
  bool _sessionEnded = false;
  bool _liveFeedBroken = false;
  int _selectedTab = 1; // 0 = previous, 1 = up next

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

  double? _dragValue;

  GraphQLClient get _client =>
      ClientManager.getClientForUrl(widget.serverName).value;

  @override
  void initState() {
    super.initState();

    StreamTokenService.ensureToken(widget.serverName).then((_) {
      if (mounted) setState(() {});
    });

    // The server replays the latest session list on subscribe, so no separate
    // snapshot query is needed to render the initial state.
    _nowPlayingSubscription = ResilientSubscription(
      client: _client,
      document: documentNodeSubscriptionnowPlaying,
      onData: (result) {
        if (!mounted) return;
        final sessions =
            Subscription$nowPlaying.fromJson(result.data!).nowPlaying;
        final session = sessions
            .where((s) => s.playQueueId == widget.playQueueId)
            .firstOrNull;
        setState(() {
          _liveFeedBroken = false;
          if (session == null) {
            _sessionEnded = true;
          } else {
            _session = session;
            _anchor = DateTime.now();
          }
        });
        _syncTicker();
      },
      onFailure: (_) {
        if (!mounted) return;
        setState(() => _liveFeedBroken = true);
      },
    );

    _commandsSubscription = ResilientSubscription(
      client: _client,
      document: documentNodeSubscriptionplaybackCommands,
      variables: {'playQueueId': widget.playQueueId},
      onData: (result) {
        if (!mounted) return;
        final command = Subscription$playbackCommands.fromJson(result.data!)
            .playbackCommands;
        _onCommandObserved(command);
      },
      onFailure: (_) {},
    );

    _refreshQueue();
  }

  @override
  void dispose() {
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
    setState(() {
      _overrideProgressMs = progressMs ?? _displayProgressMs();
      _overridePaused = paused ?? _displayPaused();
      _overrideSetAt = DateTime.now();
    });
    _syncTicker();
  }

  bool get _overrideActive =>
      _overrideSetAt != null &&
      DateTime.now().difference(_overrideSetAt!) < _overrideWindow;

  bool _displayPaused() {
    if (_overrideActive && _overridePaused != null) return _overridePaused!;
    return _session?.playState == Enum$PlayState.PAUSED;
  }

  /// Interpolated position: the freshest of the optimistic override and the
  /// last heartbeat, advanced with wall-clock time while playing.
  int _displayProgressMs() {
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

  void _syncTicker() {
    final shouldTick = !_sessionEnded && !_displayPaused();
    if (shouldTick && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!shouldTick) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  Future<void> _refreshQueue() async {
    final queue =
        await PlayQueueService().getPlayQueue(_client, widget.playQueueId);
    if (!mounted || queue == null) return;
    setState(() {
      _playQueue = queue;
      _localItems = null;
    });
  }

  Future<void> _sendCommand(
    Enum$PlaybackCommandType command, {
    Duration? position,
    String? playQueueItemId,
  }) async {
    final known = await PlayQueueService().sendPlaybackCommand(
      _client,
      widget.playQueueId,
      command,
      position: position,
      playQueueItemId: playQueueItemId,
    );
    if (!mounted) return;
    if (known == false) {
      // No live session was known server-side; the nowPlaying feed will
      // confirm and flip _sessionEnded, but tell the user right away.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.sessionEnded)));
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

  Future<void> _onReorder(
      List<Fragment$fragmentPlayQueue$playQueueItems> upNext,
      int oldIndex,
      int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;

    final reordered = List.of(upNext);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final items = _sortedItems;
    final head = _currentIndex >= 0
        ? items.sublist(0, _currentIndex + 1)
        : <Fragment$fragmentPlayQueue$playQueueItems>[];
    setState(() => _localItems = [...head, ...reordered]);

    // Moving to the head of "up next" means directly after the current item.
    final afterId =
        newIndex == 0 ? _currentItemId : reordered[newIndex - 1].id;
    await PlayQueueService()
        .movePlayQueueItem(_client, widget.playQueueId, moved.id, afterId);
    // The mutation fans out QUEUE_CHANGED, which refreshes and clears
    // _localItems; nothing else to do here.
  }

  Future<void> _removeItem(
      Fragment$fragmentPlayQueue$playQueueItems item) async {
    setState(() => _localItems =
        _sortedItems.where((e) => e.id != item.id).toList());
    await PlayQueueService()
        .removePlayQueueItem(_client, widget.playQueueId, item.id);
  }

  // ── Display helpers ──────────────────────────────────────────────────────

  String? _sessionArtworkUrl() {
    final imageId = _session?.artworkImageId;
    if (imageId == null) return null;
    final serverUrl = WellKnownService.getCached(widget.serverName)?.serverUrl;
    if (serverUrl == null) return null;
    final token = StreamTokenService.getToken(widget.serverName);
    final base = '$serverUrl/images/$imageId/download';
    return token != null ? '$base?token=$token' : base;
  }

  ({String title, String? subtitle, String? artUrl}) _itemDisplay(
      Fragment$fragmentPlayQueue$playQueueItems item) {
    final token = StreamTokenService.getToken(widget.serverName);
    if (item.track != null) {
      final t = item.track!;
      return (
        title: MetadataUtil.getTitle(t.metadata) ?? '${t.number}',
        subtitle: t.artist.name,
        artUrl: ImageUtil.buildUrl(
            ImageUtil.getImageByType(t.album.images, ImageTypes.cover),
            token: token),
      );
    } else if (item.movie != null) {
      final m = item.movie!;
      return (
        title: m.name,
        subtitle: null,
        artUrl: ImageUtil.buildUrl(
            ImageUtil.getImageByType(m.images, ImageTypes.background),
            token: token),
      );
    }
    final ep = item.episode;
    return (
      title: MetadataUtil.getTitle(ep?.metadata) ?? 'unknown',
      subtitle: null,
      artUrl: ep == null
          ? null
          : ImageUtil.buildUrl(
              ImageUtil.getImageByType(ep.images, ImageTypes.background),
              token: token),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final session = _session;
    final artUrl = _sessionArtworkUrl();

    final subtitleParts = [
      if (session?.userName != null) session!.userName!,
      if (session != null) session.nodeName,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(subtitleParts.join(' · ')),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (artUrl != null) _BlurredBackdrop(artUrl: artUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Color(0xE6000000)],
              ),
            ),
          ),
          SafeArea(
            child: _sessionEnded && session == null
                ? _endedState(loc)
                : session == null
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white54))
                    : _buildBody(context, loc, session, artUrl),
          ),
        ],
      ),
    );
  }

  Widget _endedState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tv_off, color: Colors.white38, size: 48),
          const SizedBox(height: 16),
          Text(loc.sessionEnded,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations loc,
      Fragment$fragmentPlaybackSession session, String? artUrl) {
    final (:previous, :upNext) = _sliceQueue();
    final hasQueue = previous.isNotEmpty || upNext.isNotEmpty;

    return LayoutBuilder(builder: (context, constraints) {
      final maxImageSize =
          min(constraints.maxWidth - 80, constraints.maxHeight - 360)
              .clamp(80.0, 360.0);
      return CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  if (_liveFeedBroken)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: LiveFeedBanner(),
                    ),
                  if (_sessionEnded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _SessionEndedBanner(text: loc.sessionEnded),
                    ),
                  const Spacer(),
                  _Artwork(url: artUrl, size: maxImageSize),
                  const Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(24, 0, 24, hasQueue ? 8 : 32),
                    child: _buildControls(session),
                  ),
                ],
              ),
            ),
          ),
          if (hasQueue) ..._buildQueueSlivers(loc, previous, upNext),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      );
    });
  }

  Widget _buildControls(Fragment$fragmentPlaybackSession session) {
    final paused = _displayPaused();
    final durationMs = session.durationInMilliseconds;
    final maxMs = durationMs != null && durationMs > 0
        ? durationMs.toDouble()
        : 1.0;
    final currentMs =
        (_dragValue ?? _displayProgressMs().toDouble()).clamp(0.0, maxMs);
    final index = _currentIndex;
    final itemCount = _sortedItems.length;
    final hasPrevious = index > 0;
    final hasNext = index >= 0 && index < itemCount - 1;
    final ended = _sessionEnded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          session.title ?? session.mediaId ?? session.playQueueId,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: Colors.white24,
          ),
          child: Slider(
            value: currentMs,
            min: 0,
            max: maxMs,
            onChanged: durationMs != null && durationMs > 0 && !ended
                ? (v) => setState(() => _dragValue = v)
                : null,
            onChangeEnd: (v) {
              final target = Duration(milliseconds: v.toInt());
              _applyOverride(progressMs: target.inMilliseconds);
              unawaited(_sendCommand(Enum$PlaybackCommandType.SEEK,
                  position: target));
              setState(() => _dragValue = null);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DurationUtil.format(
                      Duration(milliseconds: currentMs.toInt())),
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 12)),
              if (durationMs != null)
                Text(DurationUtil.format(Duration(milliseconds: durationMs)),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous,
                  color:
                      hasPrevious && !ended ? Colors.white : Colors.white30),
              iconSize: 40,
              onPressed: hasPrevious && !ended
                  ? () {
                      _applyOverride(progressMs: 0);
                      unawaited(
                          _sendCommand(Enum$PlaybackCommandType.PREVIOUS));
                    }
                  : null,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(paused ? Icons.play_arrow : Icons.pause,
                    color: Colors.black),
                iconSize: 48,
                onPressed: ended
                    ? null
                    : () {
                        _applyOverride(paused: !paused);
                        unawaited(_sendCommand(paused
                            ? Enum$PlaybackCommandType.PLAY
                            : Enum$PlaybackCommandType.PAUSE));
                      },
              ),
            ),
            IconButton(
              icon: Icon(Icons.skip_next,
                  color: hasNext && !ended ? Colors.white : Colors.white30),
              iconSize: 40,
              onPressed: hasNext && !ended
                  ? () {
                      _applyOverride(progressMs: 0);
                      unawaited(_sendCommand(Enum$PlaybackCommandType.NEXT));
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildQueueSlivers(
      AppLocalizations loc,
      List<Fragment$fragmentPlayQueue$playQueueItems> previous,
      List<Fragment$fragmentPlayQueue$playQueueItems> upNext) {
    final items = _selectedTab == 0 ? previous : upNext;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildTab(loc.previousTracks, 0),
                  _buildTab(loc.upNext, 1),
                ],
              ),
              const Divider(color: Colors.white24, height: 1, thickness: 1),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: items.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    _selectedTab == 0
                        ? loc.noPreviousTracks
                        : loc.noNextTracks,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14),
                  ),
                ),
              )
            : _selectedTab == 1
                ? _buildUpNextList(upNext)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in previous)
                        _dismissible(
                          item,
                          _QueueTile(
                            display: _itemDisplay(item),
                            onTap: () => unawaited(_sendCommand(
                                Enum$PlaybackCommandType.SKIP_TO_ITEM,
                                playQueueItemId: item.id)),
                          ),
                        ),
                    ],
                  ),
      ),
    ];
  }

  Widget _buildUpNextList(
      List<Fragment$fragmentPlayQueue$playQueueItems> upNext) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: upNext.length,
      onReorder: (oldIndex, newIndex) =>
          _onReorder(upNext, oldIndex, newIndex),
      itemBuilder: (context, i) => _dismissible(
        upNext[i],
        _QueueTile(
          key: ValueKey('content_${upNext[i].id}'),
          display: _itemDisplay(upNext[i]),
          onTap: () => unawaited(_sendCommand(
              Enum$PlaybackCommandType.SKIP_TO_ITEM,
              playQueueItemId: upNext[i].id)),
          trailing: ReorderableDragStartListener(
            index: i,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.drag_handle, color: Colors.white38),
            ),
          ),
        ),
      ),
      proxyDecorator: (child, index, animation) =>
          Material(color: Colors.transparent, child: child),
    );
  }

  Widget _dismissible(
      Fragment$fragmentPlayQueue$playQueueItems item, Widget child) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.withValues(alpha: 0.7),
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeItem(item),
      child: child,
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selected ? Colors.white : Colors.white.withValues(alpha: 0.45),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
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

class _Artwork extends StatelessWidget {
  const _Artwork({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: Colors.white12,
      child: Icon(Icons.music_note, color: Colors.white54, size: size * 0.4),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: url == null
            ? placeholder
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

class _BlurredBackdrop extends StatelessWidget {
  const _BlurredBackdrop({required this.artUrl});

  final String artUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // Scale up slightly so the blur samples image pixels at the edges
      // instead of bleeding transparency in.
      child: Transform.scale(
        scale: 1.2,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: CachedNetworkImage(
            imageUrl: artUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const ColoredBox(color: Color(0xFF101014)),
          ),
        ),
      ),
    );
  }
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({super.key, required this.display, required this.onTap, this.trailing});

  final ({String title, String? subtitle, String? artUrl}) display;
  final VoidCallback onTap;
  final Widget? trailing;

  Widget _artPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            display.artUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: display.artUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _artPlaceholder(),
                    ),
                  )
                : _artPlaceholder(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    display.title,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (display.subtitle != null && display.subtitle!.isNotEmpty)
                    Text(
                      display.subtitle!,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
