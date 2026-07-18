import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/RatingStars.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// Full-screen player for local playback: a [PlayerView] driven by
/// [MediaPlayerHandler], pushed as a transparent overlay route.
@RoutePage()
class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late final _LocalPlayerController _controller = _LocalPlayerController();
  late final double _initialSlideValue;

  @override
  void initState() {
    super.initState();
    _initialSlideValue = MediaPlayerHandler.instance.playerInitialControllerValue;
    MediaPlayerHandler.instance.playerInitialControllerValue = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) MediaPlayerHandler.instance.musicPlayerOpen.value = true;
    });
  }

  @override
  void dispose() {
    Future.microtask(() => MediaPlayerHandler.instance.musicPlayerOpen.value = false);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerView(
      controller: _controller,
      initialSlideValue: _initialSlideValue,
      onDismissed: () => context.router.pop(),
    );
  }
}

/// Adapts [MediaPlayerHandler]'s audio_service streams to the shared
/// [PlayerViewController] interface.
class _LocalPlayerController extends PlayerViewController {
  _LocalPlayerController() {
    final handler = MediaPlayerHandler.instance;
    _position = handler.player.state.position;
    _duration = handler.player.state.duration;
    _buffer = handler.player.state.buffer;
    _subscriptions.addAll([
      handler.mediaItem.listen((_) => notifyListeners()),
      handler.queue.listen((_) => notifyListeners()),
      handler.playbackState.listen((_) => notifyListeners()),
      handler.positionSecondsStream.listen((p) {
        _position = p;
        positionTicker.notify();
      }),
      handler.player.stream.duration.listen((d) {
        _duration = d;
        positionTicker.notify();
      }),
      handler.player.stream.buffer.listen((b) {
        _buffer = b;
        positionTicker.notify();
      }),
    ]);
    handler.mediaLoading.addListener(notifyListeners);
  }

  final List<StreamSubscription> _subscriptions = [];
  bool _disposed = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _buffer = Duration.zero;

  /// Optimistic queue order held during a reorder so the list doesn't snap back
  /// while the server move is in flight. Cleared once the move round-trips.
  List<MediaItem>? _localQueue;

  MediaPlayerHandler get _handler => MediaPlayerHandler.instance;

  @override
  void dispose() {
    _disposed = true;
    for (final s in _subscriptions) {
      s.cancel();
    }
    _handler.mediaLoading.removeListener(notifyListeners);
    super.dispose();
  }

  // Local playback = the owner watching their own session, so per-session sharing is editable here.
  @override
  String? get sessionSharingQueueId => _handler.playQueue?.id;

  @override
  String? get sessionSharingServerName => _handler.serverName;

  @override
  Enum$RemoteControlScope? get sessionControlOverride =>
      _handler.playQueue?.controlScopeOverride;

  @override
  List<String> get sessionControlAllowedUserIds =>
      _handler.playQueue?.controlAllowedUserIds ?? const [];

  @override
  bool get loading => _handler.mediaLoading.value;

  MediaItem? get _item => _handler.mediaItem.valueOrNull;

  @override
  String? get artUri => _item?.artUri?.toString();

  @override
  bool get portraitArtwork => _item?.extras?['portraitArtwork'] == true;

  @override
  String? get artistLine => _item?.artist ?? '';

  @override
  String? get titleLine => _item?.title;

  @override
  String? get albumLine => _item?.album ?? '';

  @override
  int get positionMs => _position.inMilliseconds;

  @override
  int? get durationMs =>
      _duration.inMilliseconds > 0 ? _duration.inMilliseconds : null;

  @override
  double get bufferedFraction => _duration.inMilliseconds > 0
      ? (_buffer.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
      : 0.0;

  @override
  bool get canSeek => _duration.inMilliseconds > 0;

  List<MediaItem> get _allItems => _localQueue ?? _handler.queue.value;

  int get _currentIndex => _handler.playbackState.valueOrNull?.queueIndex ?? -1;

  AudioServiceRepeatMode get _repeatMode =>
      _handler.playbackState.valueOrNull?.repeatMode ??
      AudioServiceRepeatMode.none;

  bool get _repeatAll => _repeatMode == AudioServiceRepeatMode.all;

  @override
  bool get hasPrevious =>
      _currentIndex > 0 || (_repeatAll && _allItems.length > 1);

  // With repeat-all the queue is a loop, so the ends are reachable.
  @override
  bool get hasNext =>
      (_currentIndex >= 0 && _currentIndex < _allItems.length - 1) ||
      (_repeatAll && _allItems.length > 1);

  /// Splits the full queue around the currently playing index into the
  /// already-played tracks (newest first) and the still-to-come tracks.
  ({List<MediaItem> previous, List<MediaItem> upNext}) _sliceQueue() {
    final allItems = _allItems;
    var currentIndex = _currentIndex;
    // queueIndex can briefly be stale (e.g. right after switching to a shorter
    // album); clamp so sublist can never reach past the queue.
    if (currentIndex >= allItems.length) currentIndex = allItems.length - 1;
    final previous = currentIndex > 0
        ? allItems.sublist(0, currentIndex).reversed.toList()
        : <MediaItem>[];
    final upNext = currentIndex >= 0 && currentIndex + 1 < allItems.length
        ? allItems.sublist(currentIndex + 1)
        : <MediaItem>[];
    return (previous: previous, upNext: upNext);
  }

  PlayerQueueEntry _toEntry(MediaItem item) => PlayerQueueEntry(
        id: item.id,
        title: item.title,
        subtitle: item.artist,
        artUrl: item.artUri?.toString(),
      );

  @override
  List<PlayerQueueEntry> get previous =>
      _sliceQueue().previous.map(_toEntry).toList();

  @override
  List<PlayerQueueEntry> get upNext =>
      _sliceQueue().upNext.map(_toEntry).toList();

  @override
  bool get supportsRepeat => true;

  @override
  bool get repeatActive => _repeatMode != AudioServiceRepeatMode.none;

  @override
  bool get repeatOne => _repeatMode == AudioServiceRepeatMode.one;

  @override
  void cycleRepeatMode() => _handler.cycleRepeatMode();

  @override
  Widget buildPlayPauseButton(BuildContext context) => const PlayPauseButton(
        iconSize: 48,
        iconColor: Colors.black,
        spinnerColor: Colors.black,
        spinnerStrokeWidth: 3,
      );

  @override
  Widget? buildRating(BuildContext context) {
    final item = _item;
    if (item == null) return null;
    final MediaItemId mediaItemId;
    try {
      mediaItemId = MediaItemId.byStringId(item.id);
    } catch (_) {
      return null;
    }
    // Only tracks carry a per-track rating; episodes/movies don't.
    if (mediaItemId.isterMediaType != IsterMediaTypes.track) return null;

    // MediaItem.id encodes the play-queue *item* id, not the track id. Look the
    // item up to get the real track id (setRating needs it) and its current
    // server-side rating; RatingStars then owns the optimistic edit state.
    final queueItemId = mediaItemId.id;
    String? trackId;
    int? rating;
    for (final queueItem in _handler.playQueue?.playQueueItems ?? const []) {
      if (queueItem.id == queueItemId) {
        trackId = queueItem.track?.id;
        rating = queueItem.track?.rating;
        break;
      }
    }
    if (trackId == null) return null;

    return RatingStars(
      // Re-key per track so switching songs adopts the new rating instead of
      // keeping the previous track's optimistic value.
      key: ValueKey('player_rating_$trackId'),
      mediaType: Enum$RatingMediaType.TRACK,
      mediaId: trackId,
      rating: rating,
      client: ClientManager.getClientForUrl(mediaItemId.serverName).value,
      size: 28,
      showValue: false,
    );
  }

  @override
  void skipToPrevious() => _handler.skipToPrevious();

  @override
  void skipToNext() => _handler.skipToNext();

  @override
  void seek(Duration position) => _handler.seek(position);

  @override
  void tapPrevious(int index) =>
      _handler.skipToQueueItem(_currentIndex - 1 - index);

  @override
  void tapUpNext(int index) =>
      _handler.skipToQueueItem(_currentIndex + 1 + index);

  @override
  Future<void> moveUpNext(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;

    final reordered = List<MediaItem>.of(_sliceQueue().upNext);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final full = _allItems;
    final currentIndex = _currentIndex;
    final head =
        currentIndex >= 0 ? full.sublist(0, currentIndex + 1) : <MediaItem>[];
    _localQueue = [...head, ...reordered];
    notifyListeners();

    final movedId = MediaItemId.byStringId(moved.id).id;
    // Moving to the head of "up next" means directly after the current item.
    final afterId = newIndex == 0
        ? _handler.playQueue?.currentItemId
        : MediaItemId.byStringId(reordered[newIndex - 1].id).id;
    await _handler.moveQueueItem(movedId, afterId);
    if (_disposed) return;
    _localQueue = null;
    notifyListeners();
  }

  @override
  Future<void> removeEntry(PlayerQueueEntry entry) async {
    final id = MediaItemId.byStringId(entry.id).id;
    _localQueue = List<MediaItem>.of(_allItems)
      ..removeWhere((e) => e.id == entry.id);
    notifyListeners();
    await _handler.removeFromQueue(id);
    if (_disposed) return;
    _localQueue = null;
    notifyListeners();
  }
}
