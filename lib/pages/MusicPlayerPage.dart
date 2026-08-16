import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/components/QueuePlayerViewController.dart';
import 'package:player/components/video_controls/SegmentOverlayButtons.dart';
import 'package:player/components/RatingStars.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
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
      if (!mounted) return;
      // Cold URL open of /player: nothing is playing, so an empty transparent
      // overlay over nothing would render. Send the visitor to their last
      // server (or the server list) instead, mirroring the root deepLinkBuilder.
      // A fresh in-app play (openMusicPlayerRequest) also lands here before the
      // queue round-trip fills mediaItem — mediaLoading distinguishes it from a
      // genuinely idle cold open.
      final handler = MediaPlayerHandler.instance;
      if (!handler.mediaLoading.value &&
          handler.mediaItem.valueOrNull == null &&
          handler.queue.value.isEmpty) {
        final lastServer = ClientManager.instance.lastClientUsed;
        context.router.replaceAll([
          if (lastServer != null)
            ServerHomeRoute(serverName: lastServer)
          else
            HomeRoute(),
        ]);
        return;
      }
      MediaPlayerHandler.instance.musicPlayerOpen.value = true;
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
class _LocalPlayerController extends QueuePlayerViewController<MediaItem> {
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
  bool get isLocalSession => true;

  @override
  String? get sessionSharingQueueId => _handler.playQueue?.id;

  @override
  String? get sessionSharingServerName => _handler.serverName;

  @override
  IconData get artPlaceholderIcon => _handler.movie != null
      ? Icons.movie
      : _handler.episode != null
          ? Icons.tv
          : Icons.music_note;

  @override
  bool get loading => _handler.mediaLoading.value;

  MediaItem? get _item => _handler.mediaItem.valueOrNull;

  /// Resolve targets from the current play-queue item (mixed queues like a
  /// library shuffle can span albums), falling back to the handler's source
  /// album. The playing server can differ from the browsed one, so the route
  /// is paired with the handler's server.
  @override
  ({String serverName, PageRouteInfo route})? get artistRoute {
    final srv = _handler.serverName;
    if (srv == null) return null;
    final item = _handler.currentPlayQueueItem;
    final personId = item?.track?.artist.id ??
        item?.chapter?.author.id ??
        _handler.album?.artist.id;
    if (personId == null) return null;
    return (serverName: srv, route: PersonRoute(personId: personId));
  }

  @override
  ({String serverName, PageRouteInfo route})? get albumRoute {
    final srv = _handler.serverName;
    if (srv == null) return null;
    final item = _handler.currentPlayQueueItem;
    final albumId = item?.track?.album.id ?? _handler.album?.id;
    if (albumId != null) {
      return (serverName: srv, route: AlbumRoute(albumId: albumId));
    }
    final bookId = item?.chapter?.book.id;
    if (bookId != null) {
      return (serverName: srv, route: BookRoute(bookId: bookId));
    }
    final podcastId = item?.podcastEpisode?.podcast.id;
    if (podcastId != null) {
      return (serverName: srv, route: PodcastRoute(podcastId: podcastId));
    }
    return null;
  }

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

  @override
  List<MediaItem> get queueItems => _localQueue ?? _handler.queue.value;

  @override
  int get currentIndex => _handler.playbackState.valueOrNull?.queueIndex ?? -1;

  @override
  String? get currentQueueItemId => _handler.playQueue?.currentItemId;

  @override
  String queueItemIdOf(MediaItem item) => MediaItemId.byStringId(item.id).id;

  @override
  void setOptimisticQueue(List<MediaItem>? items) => _localQueue = items;

  @override
  bool get disposed => _disposed;

  // With repeat-all the queue is a loop, so the ends stay reachable.
  @override
  bool get queueWrapsAround => _repeatAll;

  @override
  Future<void> applyMove(String movedId, String? afterId) =>
      _handler.moveQueueItem(movedId, afterId);

  @override
  Future<void> applyRemove(String queueItemId) =>
      _handler.removeFromQueue(queueItemId);

  AudioServiceRepeatMode get _repeatMode =>
      _handler.playbackState.valueOrNull?.repeatMode ??
      AudioServiceRepeatMode.none;

  bool get _repeatAll => _repeatMode == AudioServiceRepeatMode.all;

  @override
  PlayerQueueEntry entryFor(MediaItem item) => PlayerQueueEntry(
        id: item.id,
        title: item.title,
        subtitle: item.artist,
        artUrl: item.artUri?.toString(),
      );

  @override
  bool get supportsRepeat => true;

  @override
  bool get supportsSleepTimer => true;

  // Ends the session for good; the surfaces close themselves through the
  // handler's closePlaybackRequest, so no local dismiss is needed here.
  @override
  bool get supportsStop => true;

  @override
  void stop() => unawaited(_handler.stopPlayback());

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
  Widget? buildRating(BuildContext context, Color accent) {
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
      // Match the accent-tinted transport controls on the dark backdrop.
      color: accent,
      emptyColor: Colors.white30,
    );
  }

  @override
  void skipToPrevious() => _handler.skipToPrevious();

  @override
  void skipToNext() => _handler.skipToNext();

  /// Naturally inert for music: the handler's segment bounds are only non-null
  /// while an episode with detected segments is playing.
  @override
  SegmentActions get segmentActions => SegmentOverlayButtons.visibilityFor(
        posMs: positionMs,
        intro: _handler.currentIntroBounds,
        outro: _handler.currentOutroBounds,
        hasNext: hasNext,
      );

  @override
  void skipIntro() {
    final intro = _handler.currentIntroBounds;
    if (intro == null) return;
    _handler.seek(Duration(milliseconds: intro.endMs));
  }

  @override
  void seek(Duration position) => _handler.seek(position);

  @override
  void tapPrevious(int index) =>
      _handler.skipToQueueItem(currentIndex - 1 - index);

  @override
  void tapUpNext(int index) =>
      _handler.skipToQueueItem(currentIndex + 1 + index);
}
