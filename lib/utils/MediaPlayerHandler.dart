import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:flutter/foundation.dart';
import 'package:player/utils/AutoPreferences.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:rxdart/rxdart.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../graphql/schema.graphql.dart';
import 'ImageTypes.dart';
import 'ImageUtil.dart';
import 'MetadataUtil.dart';
import 'PlayQueueService.dart';

class MediaPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  MediaPlayerHandler._internal() {
    _player = Player(
      configuration: const PlayerConfiguration(
        libass: true,
        libassAndroidFont: 'assets/fonts/DroidSansFallback.ttf',
        libassAndroidFontName: 'Droid Sans Fallback',
        bufferSize: 320 * 1024 * 1024,
      ),
    );

    _videoController = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Route the in-video controls' seek bar through seekAware so backward HLS
    // seeks with an active subtitle track re-open the stream instead of
    // freezing the subtitles. The audio_service seek() override also uses
    // seekAware, but the media_kit video UI seeks via the controller directly.
    _videoController.seekHandler = seekAware;

    _playQueueService = PlayQueueService();

    // Set up listeners once – they survive for the lifetime of the singleton
    if (!_listenersAdded) {
      _player.stream.playing.listen(_onPlayingChanged);
      _listenToBuffering();
      _listenToTracks();
      _listenToPosition();
      _listenToCompletion();
      _listenToSession();
      _applyMpvNetworkOptions();
      _startStallWatchdog();
      _listenersAdded = true;
    }
  }

  /// Make HLS playback more resilient in the background. Android throttles the
  /// network when the app is backgrounded, which can stall mpv's segment
  /// fetches indefinitely. These ffmpeg/mpv options make the underlying HTTP
  /// connections time out and auto-reconnect instead of hanging forever.
  Future<void> _applyMpvNetworkOptions() async {
    if (kIsWeb) return;
    final platform = _player.platform;
    if (platform is! NativePlayer) return;
    const reconnect =
        'reconnect=1,reconnect_streamed=1,reconnect_on_network_error=1,reconnect_delay_max=30';
    try {
      // Dynamic dispatch: on web media_kit substitutes a stub NativePlayer
      // without setProperty, so a static call breaks dart2js/dart2wasm even
      // though this code is unreachable there.
      final dynamic native = platform;
      await native.setProperty('network-timeout', '30');
      await native.setProperty('stream-lavf-o', reconnect);
      await native.setProperty('demuxer-lavf-o', reconnect);
      LoggerService().logger.d('Applied mpv network reconnect options');
    } catch (e) {
      LoggerService().logger.w('Failed to set mpv network options: $e');
    }
  }

  static final MediaPlayerHandler _instance = MediaPlayerHandler._internal();

  static MediaPlayerHandler get instance => _instance;

  // ── Core objects ─────────────────────────────────────────────────────
  late final Player _player;
  late final VideoController _videoController;
  late final PlayQueueService _playQueueService;

  Player get player => _player;

  /// Playback position sampled to whole seconds. The raw `player.stream.position`
  /// fires many times per second; UI that only shows seconds (mini-player bar,
  /// seek bar label/slider) should listen here to avoid rebuilding every frame
  /// for the entire life of playback. Built once on the singleton; the source is
  /// a broadcast stream so multiple listeners share it.
  late final Stream<Duration> positionSecondsStream = _player.stream.position
      .map((p) => Duration(seconds: p.inSeconds))
      .distinct();

  VideoController get videoController => _videoController;

  // ── State ───────────────────────────────────────────────────────────
  double playerInitialControllerValue = 0.0;
  VoidCallback? dismissMusicPlayer;
  final ValueNotifier<bool> musicPlayerOpen = ValueNotifier(false);
  // Number of video pages (episode/movie) currently mounted. The mini player
  // hides its video bar while the item's own page is on screen — the full
  // player is already visible there, so the bar would only duplicate it.
  // A counter (not a bool) is robust against init-before-dispose ordering when
  // navigating from one video page straight to another.
  final ValueNotifier<int> videoPageOpen = ValueNotifier(0);

  Fragment$fragmentEpisode? episode;
  Fragment$fragmentMovie? movie;
  Fragment$fragmentAlbum? album;
  String? currentTrackId;
  // The kind of media currently loaded. Replaces the old parallel
  // _isMovie/_isTrack booleans so the type can never become inconsistent.
  IsterMediaTypes _currentMediaType = IsterMediaTypes.episode;
  Fragment$fragmentPlayQueue$playQueueItems? currentPlayQueueItem;
  Fragment$fragmentPlayQueue? playQueue;
  String? serverName;
  GraphQLClient? graphQLClient;

  // Track selection state for reload-based switching
  String? _currentMediaUrl;
  SubtitleTrack? _forcedSubtitle;
  AudioTrack? _forcedAudio;
  // The position (ms) at which the current stream was opened. Used by the
  // stall watchdog to re-open a hung stream at its resume point instead of 0.
  int _streamOpenPositionMs = 0;
  // Bumped whenever the current item or queue changes; in-flight progress
  // responses from before the bump are dropped instead of applied.
  int _syncGeneration = 0;

  // ── Public API used by the widget ─────────────────────────────────────
  Future<void> startPlayQueue(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentEpisode newEpisode,
    String newServerName,
  ) async {
    _intendsToPlay = true;
    _loadRetries = 0;
    final shouldRefresh = episode == null ||
        episode!.id != newEpisode.id ||
        serverName != newServerName;

    episode = newEpisode;
    movie = null;
    album = null;
    currentTrackId = null;
    _currentMediaType = IsterMediaTypes.episode;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
      _syncGeneration++;
      final playQueueObject = await _playQueueService.getOrCreatePlayQueue(
        client,
        playQueueId,
        newEpisode.id,
        newEpisode.$show!.id,
        _startTimeMs,
      );

      queueTitle.add("Now Playing");

      queue.add(playQueueObject?.playQueueItems?.map(
            (e) {
              Uri? imgUri;
              if (e.episode?.images != null && serverName != null) {
                final imageByType = ImageUtil.getImageByType(
                  e.episode!.images,
                  ImageTypes.background,
                );
                imgUri = imageByType != null
                    ? Uri.tryParse(ImageUtil.buildUrl(imageByType, token: StreamTokenService.getToken(newServerName)) ?? '')
                    : null;
              }

              return MediaItem(
                id: MediaItemId(newServerName, IsterMediaTypes.episode, e.id).toString(),
                title: MetadataUtil.getTitle(e.episode?.metadata) ?? "unknown",
                artist: "ister",
                duration: Duration(
                    milliseconds:
                        e.episode?.mediaFile?.firstOrNull?.durationInMilliseconds ??
                          0),
                artUri: imgUri,
              );
            },
          ).toList() ??
          []);

      playQueue = playQueueObject;
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay();
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode();
      await _openMedia(
        serverName: newServerName,
        mediaUrl: ImageUtil.buildMediaFileUrl(newEpisode.mediaFile!.first, token: StreamTokenService.getToken(newServerName), direct: directPlay, transcode: transcode) ?? '',
        startTimeInMilliseconds: _startTimeMs,
      );
    } else {
      await _resumeCurrentItem();
    }
    updatePlaybackState();
  }

  /// Starting the item that is already loaded should resume it — and restart
  /// it when it already played to the end — instead of doing nothing.
  Future<void> _resumeCurrentItem() async {
    if (_player.state.completed) {
      await _player.seek(Duration.zero);
    }
    await play();
  }

  int? get _startTimeMs {
    final ws = episode?.watchStatus;
    if (ws != null && ws.isNotEmpty && !ws.first.watched) {
      return ws.first.progressInMilliseconds;
    }
    return null;
  }

  int? get _movieStartTimeMs {
    final ws = movie?.watchStatus;
    if (ws != null && ws.isNotEmpty && !ws.first.watched) {
      return ws.first.progressInMilliseconds;
    }
    return null;
  }

  Future<void> startPlayQueueForMovie(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentMovie newMovie,
    String newServerName,
  ) async {
    _intendsToPlay = true;
    _loadRetries = 0;
    final shouldRefresh = movie == null ||
        movie!.id != newMovie.id ||
        serverName != newServerName;

    movie = newMovie;
    episode = null;
    album = null;
    currentTrackId = null;
    _currentMediaType = IsterMediaTypes.movie;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
      _syncGeneration++;
      final playQueueObject = await _playQueueService.getOrCreatePlayQueueForMovie(
        client,
        playQueueId,
        newMovie.id,
        _movieStartTimeMs,
      );

      queueTitle.add("Now Playing");

      queue.add(playQueueObject?.playQueueItems?.map((e) {
            Uri? imgUri;
            if (e.movie?.images != null && serverName != null) {
              final imageByType = ImageUtil.getImageByType(
                e.movie!.images,
                ImageTypes.background,
              );
              imgUri = imageByType != null
                  ? Uri.tryParse(ImageUtil.buildUrl(imageByType, token: StreamTokenService.getToken(newServerName)) ?? '')
                  : null;
            }
            return MediaItem(
              id: MediaItemId(newServerName, IsterMediaTypes.movie, e.id).toString(),
              title: e.movie?.name ?? newMovie.name,
              artist: "ister",
              duration: Duration(
                  milliseconds:
                      e.movie?.mediaFile?.firstOrNull?.durationInMilliseconds ??
                          0),
              artUri: imgUri,
            );
          }).toList() ??
          []);

      playQueue = playQueueObject;
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay();
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode();
      await _openMedia(
        serverName: newServerName,
        mediaUrl: ImageUtil.buildMediaFileUrl(newMovie.mediaFile!.first, token: StreamTokenService.getToken(newServerName), direct: directPlay, transcode: transcode) ?? '',
        startTimeInMilliseconds: _movieStartTimeMs,
        mediaType: IsterMediaTypes.movie,
      );
    } else {
      await _resumeCurrentItem();
    }
    updatePlaybackState();
  }

  Future<void> startPlayQueueForAlbum(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentAlbum newAlbum,
    String trackId,
    String newServerName,
  ) async {
    _intendsToPlay = true;
    _loadRetries = 0;
    final shouldRefresh = album == null ||
        album!.id != newAlbum.id ||
        serverName != newServerName ||
        currentTrackId != trackId;

    album = newAlbum;
    currentTrackId = trackId;
    episode = null;
    movie = null;
    _currentMediaType = IsterMediaTypes.track;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
      _syncGeneration++;
      final playQueueObject =
          await _playQueueService.getOrCreatePlayQueueForAlbum(
        client,
        playQueueId,
        newAlbum.id,
        trackId,
      );

      queueTitle.add("Now Playing");

      queue.add(playQueueObject?.playQueueItems?.map((e) {
            Uri? imgUri;
            if (e.track?.album.images != null && serverName != null) {
              final imageByType = ImageUtil.getImageByType(
                e.track!.album.images,
                ImageTypes.cover,
              );
              imgUri = imageByType != null
                  ? Uri.tryParse(ImageUtil.buildUrl(imageByType,
                          token: StreamTokenService.getToken(newServerName)) ??
                      '')
                  : null;
            }
            return MediaItem(
              id: MediaItemId(newServerName, IsterMediaTypes.track, e.id)
                  .toString(),
              title: MetadataUtil.getTitle(e.track?.metadata) ??
                  '${e.track?.number ?? ''}',
              artist: e.track?.artist.name ?? '',
              album: e.track?.album.name ?? newAlbum.name,
              duration: Duration(
                  milliseconds:
                      e.track?.mediaFile?.firstOrNull?.durationInMilliseconds ??
                          0),
              artUri: imgUri,
            );
          }).toList() ??
          []);

      playQueue = playQueueObject;
      currentPlayQueueItem =
          PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final currentTrack = playQueueObject?.playQueueItems
          ?.where((e) => e.track?.id == trackId)
          .firstOrNull
          ?.track;

      if (currentTrack?.mediaFile != null &&
          currentTrack!.mediaFile!.isNotEmpty) {
        final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay();
        final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode();
        await _openMedia(
          serverName: newServerName,
          mediaUrl: ImageUtil.buildMediaFileUrl(currentTrack.mediaFile!.first,
                  token: StreamTokenService.getToken(newServerName),
                  direct: directPlay,
                  transcode: transcode) ??
              '',
          mediaType: IsterMediaTypes.track,
        );
      }
    } else {
      await _resumeCurrentItem();
    }
    updatePlaybackState();
    _rememberLastPlayed(newServerName, newAlbum.id, trackId);
  }

  /// Keeps the Android Auto "recent" tile and its persisted backup in sync
  /// with what is playing.
  void _rememberLastPlayed(String serverName, String albumId, String trackId) {
    unawaited(AutoPreferences.setLastPlayed(serverName, albumId, trackId));
    final nowPlaying = mediaItem.valueOrNull;
    if (nowPlaying != null) {
      _recentSubject.add([nowPlaying]);
    }
  }

  /// Creates a shuffled queue for an entire [libraryId] and starts playback.
  /// Works for any library type — the queue items carry their own media type.
  Future<void> startLibraryShuffle(
      GraphQLClient client, String srv, String libraryId) async {
    final pq = await _playQueueService.createPlayQueue(
      client,
      sourceType: Enum$PlayQueueSourceType.LIBRARY,
      sourceId: libraryId,
      shuffle: true,
    );
    if (pq != null) await _startFromPlayQueue(client, pq, srv);
  }

  /// Creates a shuffled queue for [albumId] and starts playback.
  Future<void> startAlbumShuffle(
      GraphQLClient client, String srv, String albumId) async {
    final pq = await _playQueueService.createPlayQueue(
      client,
      sourceType: Enum$PlayQueueSourceType.ALBUM,
      sourceId: albumId,
      shuffle: true,
    );
    if (pq != null) await _startFromPlayQueue(client, pq, srv);
  }

  /// Starts playback from an already-created [pq], opening its current item
  /// (server-selected, or the first item). Used for shuffle/library sources
  /// where the starting item isn't chosen by the caller.
  Future<void> _startFromPlayQueue(
      GraphQLClient client, Fragment$fragmentPlayQueue pq, String srv) async {
    _intendsToPlay = true;
    _loadRetries = 0;
    _syncGeneration++;
    serverName = srv;
    graphQLClient = client;

    final items = PlayQueueService.sortedItems(pq);
    if (items.isEmpty) return;
    final current = PlayQueueService.getCurrentPlayQueueItem(pq) ?? items.first;
    playQueue =
        pq.currentItemId == null ? pq.copyWith(currentItemId: current.id) : pq;

    queueTitle.add("Now Playing");
    queue.add(_buildQueueItems(playQueue!, srv));
    currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

    await _openQueueItem(current, srv);
    updatePlaybackState();
  }

  /// Opens the media for [item], flipping the typed handler state (episode /
  /// movie / track) to match. Mirrors the per-type open in [skipToQueueItem].
  Future<void> _openQueueItem(
      Fragment$fragmentPlayQueue$playQueueItems item, String srv) async {
    final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay();
    final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode();
    final token = StreamTokenService.getToken(srv);

    if (item.track != null) {
      final t = item.track!;
      currentTrackId = t.id;
      episode = null;
      movie = null;
      album = null;
      _currentMediaType = IsterMediaTypes.track;
      final mf = t.mediaFile?.firstOrNull;
      if (mf == null) return;
      await _openMedia(
        serverName: srv,
        mediaUrl: ImageUtil.buildMediaFileUrl(mf,
                token: token, direct: directPlay, transcode: transcode) ??
            '',
        mediaType: IsterMediaTypes.track,
      );
      _rememberLastPlayed(srv, t.album.id, t.id);
    } else if (item.movie != null) {
      movie = item.movie;
      episode = null;
      album = null;
      currentTrackId = null;
      _currentMediaType = IsterMediaTypes.movie;
      final mf = item.movie?.mediaFile?.firstOrNull;
      if (mf == null) return;
      await _openMedia(
        serverName: srv,
        mediaUrl: ImageUtil.buildMediaFileUrl(mf,
                token: token, direct: directPlay, transcode: transcode) ??
            '',
        mediaType: IsterMediaTypes.movie,
      );
    } else {
      episode = item.episode;
      movie = null;
      album = null;
      currentTrackId = null;
      _currentMediaType = IsterMediaTypes.episode;
      final mf = item.episode?.mediaFile?.firstOrNull;
      if (mf == null) return;
      await _openMedia(
        serverName: srv,
        mediaUrl: ImageUtil.buildMediaFileUrl(mf,
                token: token, direct: directPlay, transcode: transcode) ??
            '',
        mediaType: IsterMediaTypes.episode,
      );
    }
  }

  Future<void> _openMedia({
    required String serverName,
    required String mediaUrl,
    int? startTimeInMilliseconds,
    IsterMediaTypes mediaType = IsterMediaTypes.episode,
  }) async {
    _currentMediaUrl = mediaUrl;
    _streamOpenPositionMs = startTimeInMilliseconds ?? 0;
    _mediaOpenedAt = DateTime.now();
    // Reset stall tracking for the newly opened stream.
    _lastObservedPosition = Duration(milliseconds: startTimeInMilliseconds ?? 0);
    _lastPositionAdvance = DateTime.now();
    LoggerService().logger.d('openmedia: $serverName$mediaUrl');
    final start = Duration(milliseconds: startTimeInMilliseconds ?? 0);
    final media = Media(
      mediaUrl,
      start: start,
    );

    try {
      _audioPreferenceApplied = false;
      _subtitlePreferenceApplied = false;
      await _player.open(media);
      // setVideoTrack throws UnsupportedError on web (media_kit); skipping it
      // there would otherwise abort _openMedia before mediaItem is published,
      // which is what the mini player gates its visibility on.
      if (!kIsWeb) {
        await _player.setVideoTrack(
            mediaType == IsterMediaTypes.track ? VideoTrack.no() : VideoTrack.auto());
      }
      final currentItemId = playQueue?.currentItemId;
      if (currentItemId != null) {
        final found = queue.value.where((e) =>
            e.id == MediaItemId(serverName, mediaType, currentItemId).toString()
        ).firstOrNull;
        if (found != null && mediaItem.valueOrNull != found) {
          mediaItem.add(found);
        }
      }
    } catch (e) {
      LoggerService().logger.e('Failed to open media: $e');
    }
  }

  // ── AudioService overrides ─────────────────────────────────────────────
  @override
  Future<void> play() {
    _intendsToPlay = true;
    return _player.play();
  }

  @override
  Future<void> pause() {
    _intendsToPlay = false;
    unawaited(_syncProgress(_player.state.position, force: true));
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    _intendsToPlay = false;
    unawaited(_syncProgress(_player.state.position, force: true));
    await _player.pause();
    // Explicit stop is the only place we release audio focus.
    final session = await AudioSession.instance;
    await session.setActive(false);
  }

  @override
  Future<void> seek(Duration position) => seekAware(position);

  /// Seek with subtitle awareness. When seeking backward with an active subtitle
  /// track, mpv's HLS subtitle rendering stalls (it does not re-fire sub-text
  /// events after a backward seek). Reloading the stream from [position]
  /// ensures HLS subtitle segments are fetched fresh from that point, fixing
  /// subtitle display. Forward seeks are passed straight through to the player.
  Future<void> seekAware(Duration position) async {
    final currentPosition = _player.state.position;
    final isBackward = position < currentPosition;
    final sub = _player.state.track.subtitle;
    final hasActiveSub = sub.id != 'no' && sub.id != 'auto';
    final url = _currentMediaUrl;

    if (!kIsWeb && isBackward && hasActiveSub && url != null && serverName != null) {
      _forcedSubtitle = sub;
      _forcedAudio = _player.state.track.audio;
      _audioPreferenceApplied = false;
      _subtitlePreferenceApplied = false;
      await _openMedia(
        serverName: serverName!,
        mediaUrl: url,
        startTimeInMilliseconds: position.inMilliseconds,
        mediaType: _currentMediaType,
      );
    } else {
      await _player.seek(position);
    }
  }

  @override
  Future<void> skipToNext() async {
    final q = queue.value;
    // Unknown index means we cannot know what "next" is — do nothing instead
    // of jumping to an arbitrary item.
    final index = playbackState.value.queueIndex;
    if (index == null) return;
    final next = index + 1;
    if (next < q.length) await skipToQueueItem(next);
  }

  @override
  Future<void> skipToPrevious() async {
    final index = playbackState.value.queueIndex;
    if (index == null) return;
    final prev = index - 1;
    if (prev >= 0) await skipToQueueItem(prev);
  }

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) async {
    LoggerService().logger.d('playformuri $uri');
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    LoggerService().logger.d('playMediaItem $mediaItem');
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    LoggerService().logger.d('playFromMediaId: $mediaId');

    final mediaItemId = MediaItemId.byStringId(mediaId);

    // Check if the item is already in the current queue
    final currentQueue = queue.value;
    final index = currentQueue.indexWhere((e) => e.id == mediaId);
    if (index != -1) {
      LoggerService().logger.d('zit in huidige playqueue mediaId: $mediaId');
      await skipToQueueItem(index);
      return;
    }

    // Not in queue — start a new play queue for the item.
    switch (mediaItemId.isterMediaType) {
      case IsterMediaTypes.track:
        await playTrackById(mediaItemId);
      case IsterMediaTypes.album:
        await playAlbumById(mediaItemId);
      case IsterMediaTypes.episode:
        final episodeFragment =
            await IsterMediaService().getEpisodeFragmentById(mediaItemId);
        if (episodeFragment == null) {
          LoggerService()
              .logger
              .e('playFromMediaId: episode not found for $mediaId');
          return;
        }
        final client = await IsterMediaService.getClient(mediaItemId.serverName);
        await startPlayQueue(
            client, null, episodeFragment, mediaItemId.serverName);
      default:
        LoggerService().logger.w(
            'playFromMediaId: unsupported type ${mediaItemId.isterMediaType} for $mediaId');
    }
  }

  /// Starts an album play queue from just a track id — the browse tree and
  /// the recent tile hand out bare track ids, but playback always runs on an
  /// album play queue.
  Future<void> playTrackById(MediaItemId mediaItemId) async {
    final album = await IsterMediaService()
        .getTrackAlbum(mediaItemId.serverName, mediaItemId.id);
    if (album == null) {
      LoggerService()
          .logger
          .e('playTrackById: album not found for track ${mediaItemId.id}');
      return;
    }
    final client = await IsterMediaService.getClient(mediaItemId.serverName);
    await startPlayQueueForAlbum(
        client, null, album, mediaItemId.id, mediaItemId.serverName);
  }

  /// Plays an album from its first track.
  Future<void> playAlbumById(MediaItemId mediaItemId) async {
    final album = await IsterMediaService()
        .getAlbumWithTracks(mediaItemId.serverName, mediaItemId.id);
    final firstTrack = album?.tracks?.firstOrNull;
    if (album == null || firstTrack == null) {
      LoggerService()
          .logger
          .e('playAlbumById: no playable tracks for album ${mediaItemId.id}');
      return;
    }
    final client = await IsterMediaService.getClient(mediaItemId.serverName);
    await startPlayQueueForAlbum(
        client, null, album, firstTrack.id, mediaItemId.serverName);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    _intendsToPlay = true;
    _loadRetries = 0;
    _syncGeneration++;
    final generation = _syncGeneration;
    // Publish the target index immediately so a second next/previous tap
    // during the awaits below doesn't act on the stale index.
    playbackState.add(playbackState.value.copyWith(queueIndex: index));

    MediaItemId mediaItemId = MediaItemId.byStringId(queue.value[index].id);

    final newEpisodeList = playQueue?.playQueueItems
        ?.where((element) => element.id == mediaItemId.id)
        .toList();
    if (newEpisodeList != null && newEpisodeList.isNotEmpty) {
      final queueItem = newEpisodeList.first;

      // An item without an (analyzed) media file cannot be opened — bail out
      // before flipping any local state to it.
      final hasMediaFile = queueItem.track?.mediaFile?.firstOrNull != null ||
          queueItem.movie?.mediaFile?.firstOrNull != null ||
          queueItem.episode?.mediaFile?.firstOrNull != null;
      if (!hasMediaFile) return;

      // Make the tapped item current locally, before any player or network
      // work. The server update below is only a sync — the UI must not wait
      // for its round-trip, and player events firing while it is in flight
      // must not revert the index in updatePlaybackState.
      playQueue = playQueue?.copyWith(currentItemId: mediaItemId.id);
      currentPlayQueueItem =
          PlayQueueService.getCurrentPlayQueueItem(playQueue);
      _currentMediaType = mediaItemId.isterMediaType;
      mediaItem.add(queue.value[index]);
      if (playQueue != null) {
        PlayQueueService().playQueueChanged(playQueue!);
      }

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay();
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode();

      if (queueItem.track != null) {
        final track = queueItem.track!;
        currentTrackId = track.id;
        episode = null;
        movie = null;
        _currentMediaType = IsterMediaTypes.track;
        final mediaFile = track.mediaFile?.firstOrNull;
        if (mediaFile == null) return;
        await _openMedia(
          serverName: mediaItemId.serverName,
          mediaUrl: ImageUtil.buildMediaFileUrl(mediaFile, token: StreamTokenService.getToken(mediaItemId.serverName), direct: directPlay, transcode: transcode) ?? '',
          startTimeInMilliseconds: 0,
          mediaType: IsterMediaTypes.track,
        );
      } else if (queueItem.movie != null) {
        movie = queueItem.movie;
        episode = null;
        album = null;
        currentTrackId = null;
        _currentMediaType = IsterMediaTypes.movie;
        final mediaFile = queueItem.movie?.mediaFile?.firstOrNull;
        if (mediaFile == null) return;
        await _openMedia(
          serverName: mediaItemId.serverName,
          mediaUrl: ImageUtil.buildMediaFileUrl(mediaFile, token: StreamTokenService.getToken(mediaItemId.serverName), direct: directPlay, transcode: transcode) ?? '',
          startTimeInMilliseconds: 0,
          mediaType: IsterMediaTypes.movie,
        );
      } else {
        episode = queueItem.episode;
        movie = null;
        album = null;
        currentTrackId = null;
        _currentMediaType = IsterMediaTypes.episode;
        final mediaFile = queueItem.episode?.mediaFile?.firstOrNull;
        if (mediaFile == null) return;
        await _openMedia(
          serverName: mediaItemId.serverName,
          mediaUrl: ImageUtil.buildMediaFileUrl(mediaFile, token: StreamTokenService.getToken(mediaItemId.serverName), direct: directPlay, transcode: transcode) ?? '',
          startTimeInMilliseconds: 0,
          mediaType: IsterMediaTypes.episode,
        );
      }

      _onPlayingChanged(true);
      final track = queueItem.track;
      if (track != null) {
        _rememberLastPlayed(mediaItemId.serverName, track.album.id, track.id);
      }

      // Sync the new current item to the server. The local state above is
      // already final; the response only refreshes progress data, and is
      // dropped when another skip happened in the meantime.
      final playQueueObject = await _sendProgressUpdate(
        ClientManager.getClientForUrl(mediaItemId.serverName).value,
        playQueue!.id,
        mediaItemId.id,
        Duration.zero,
      );
      if (playQueueObject != null && generation == _syncGeneration) {
        _applyServerPlayQueue(playQueueObject);
        currentPlayQueueItem =
            PlayQueueService.getCurrentPlayQueueItem(playQueue);
        PlayQueueService().playQueueChanged(playQueue!);
      }
    }
  }

  // ── Queue editing (add / remove / reorder) ───────────────────────────────

  /// Appends [mediaId] (of [mediaType]) to the end of the active queue. Only
  /// works when something is playing from the same [srv]; returns whether the
  /// item was added. A play queue belongs to a single server, so items from a
  /// different server can't be mixed in.
  Future<bool> addToQueue(
      String srv, Enum$MediaType mediaType, String mediaId) async {
    final pq = playQueue;
    final activeServer = serverName;
    if (pq == null || activeServer == null || activeServer != srv) return false;

    final items = PlayQueueService.sortedItems(pq);
    final afterId = items.isNotEmpty ? items.last.id : null;
    final client = ClientManager.getClientForUrl(srv).value;
    final updated = await _playQueueService.addPlayQueueItem(
      client,
      pq.id,
      mediaType,
      mediaId,
      afterPlayQueueItemId: afterId,
    );
    if (updated == null) return false;
    _applyServerPlayQueue(updated);
    _refreshQueueFromPlayQueue();
    return true;
  }

  /// Removes [playQueueItemId] from the active queue. The currently playing
  /// item can't be removed (skip first).
  Future<void> removeFromQueue(String playQueueItemId) async {
    final pq = playQueue;
    final srv = serverName;
    if (pq == null || srv == null) return;
    if (pq.currentItemId == playQueueItemId) return;
    final client = ClientManager.getClientForUrl(srv).value;
    final updated =
        await _playQueueService.removePlayQueueItem(client, pq.id, playQueueItemId);
    if (updated == null) return;
    _applyServerPlayQueue(updated);
    _refreshQueueFromPlayQueue();
  }

  /// Moves [playQueueItemId] to sit right after [afterPlayQueueItemId]
  /// (null moves it to the front).
  Future<void> moveQueueItem(
      String playQueueItemId, String? afterPlayQueueItemId) async {
    final pq = playQueue;
    final srv = serverName;
    if (pq == null || srv == null) return;
    final client = ClientManager.getClientForUrl(srv).value;
    final updated = await _playQueueService.movePlayQueueItem(
        client, pq.id, playQueueItemId, afterPlayQueueItemId);
    if (updated == null) return;
    _applyServerPlayQueue(updated);
    _refreshQueueFromPlayQueue();
  }

  /// Rebuilds the audio_service [queue] from [playQueue] (sorted by position),
  /// then republishes playback state and notifies queue subscribers.
  void _refreshQueueFromPlayQueue() {
    final pq = playQueue;
    final srv = serverName;
    if (pq == null || srv == null) return;
    queue.add(_buildQueueItems(pq, srv));
    currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);
    updatePlaybackState();
    PlayQueueService().playQueueChanged(pq);
  }

  /// Builds the [MediaItem] list for [pq] in playback order, handling all three
  /// media types the queue can contain.
  List<MediaItem> _buildQueueItems(Fragment$fragmentPlayQueue pq, String srv) {
    final token = StreamTokenService.getToken(srv);
    Uri? artFor(Fragment$fragmentImages? img) => img == null
        ? null
        : Uri.tryParse(ImageUtil.buildUrl(img, token: token) ?? '');

    return PlayQueueService.sortedItems(pq).map((e) {
      if (e.track != null) {
        final t = e.track!;
        return MediaItem(
          id: MediaItemId(srv, IsterMediaTypes.track, e.id).toString(),
          title: MetadataUtil.getTitle(t.metadata) ?? '${t.number}',
          artist: t.artist.name,
          album: t.album.name,
          duration: Duration(
              milliseconds:
                  t.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
          artUri: artFor(ImageUtil.getImageByType(t.album.images, ImageTypes.cover)),
        );
      } else if (e.movie != null) {
        final m = e.movie!;
        return MediaItem(
          id: MediaItemId(srv, IsterMediaTypes.movie, e.id).toString(),
          title: m.name,
          artist: "ister",
          duration: Duration(
              milliseconds:
                  m.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
          artUri: artFor(ImageUtil.getImageByType(m.images, ImageTypes.background)),
        );
      } else {
        final ep = e.episode;
        return MediaItem(
          id: MediaItemId(srv, IsterMediaTypes.episode, e.id).toString(),
          title: MetadataUtil.getTitle(ep?.metadata) ?? "unknown",
          artist: "ister",
          duration: Duration(
              milliseconds:
                  ep?.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
          artUri: ep?.images == null
              ? null
              : artFor(ImageUtil.getImageByType(ep!.images, ImageTypes.background)),
        );
      }
    }).toList();
  }

  final BehaviorSubject<List<MediaItem>> _recentSubject =
      BehaviorSubject.seeded(<MediaItem>[]);

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    LoggerService().logger.d('getChildren: $parentMediaId');
    try {
      if (parentMediaId == AudioService.recentRootId) {
        return await _getRecentChildren();
      }
      if (parentMediaId == AudioService.browsableRootId) {
        return await _getRootChildren();
      }
      final itemsByParentId =
          await IsterMediaService().getItemsByParentId(parentMediaId);
      return itemsByParentId.map((e) => e.mediaItem).toList();
    } catch (e, stackTrace) {
      // An uncaught exception here crashes the media browser connection; an
      // empty list at least keeps the tree navigable.
      LoggerService()
          .logger
          .e('getChildren failed for $parentMediaId: $e\n$stackTrace');
      return [];
    }
  }

  /// Root of the Android Auto browse tree: the categories of the remembered
  /// music library plus a node to switch libraries. Falls back to the library
  /// picker when no default could be resolved.
  Future<List<MediaItem>> _getRootChildren() async {
    final service = IsterMediaService();
    final defaultLibrary = await _resolveDefaultLibrary(service);
    if (defaultLibrary == null) {
      return (await service.getMusicLibraries())
          .map((e) => e.mediaItem)
          .toList();
    }
    final categories = await service.getLibraryCategories(
        defaultLibrary.serverName, defaultLibrary.libraryId);
    return [
      ...categories.map((e) => e.mediaItem),
      MediaItem(
        id: MediaItemId(
                defaultLibrary.serverName, IsterMediaTypes.list, "libraries")
            .toString(),
        title: IsterMediaService.loc.switchLibrary,
        playable: false,
      ),
    ];
  }

  /// The library the car opens into: the persisted choice as long as it still
  /// exists, otherwise the only music library there is. Returns null when the
  /// user has to pick one (multiple candidates, or the saved server is
  /// unreachable).
  Future<AutoLibrary?> _resolveDefaultLibrary(IsterMediaService service) async {
    final saved = await AutoPreferences.getDefaultLibrary();
    if (saved != null) {
      try {
        final libraries =
            await service.getMusicLibrariesForServer(saved.serverName);
        if (libraries.any((library) => library.id == saved.libraryId)) {
          return saved;
        }
        // The saved library no longer exists — forget it and repick below.
        await AutoPreferences.clearDefaultLibrary();
      } catch (e) {
        // Server unreachable: show the picker (other servers may still work)
        // but keep the preference for when the server comes back.
        LoggerService()
            .logger
            .w('Could not validate saved Android Auto library: $e');
      }
    }

    final servers = await WellKnownService.getServers();
    AutoLibrary? onlyLibrary;
    var count = 0;
    for (final server in servers) {
      try {
        for (final library
            in await service.getMusicLibrariesForServer(server)) {
          count++;
          onlyLibrary = AutoLibrary(serverName: server, libraryId: library.id);
        }
      } catch (e) {
        LoggerService()
            .logger
            .w('_resolveDefaultLibrary: skipping $server: $e');
      }
    }
    if (count == 1 && onlyLibrary != null) {
      await AutoPreferences.setDefaultLibrary(
          onlyLibrary.serverName, onlyLibrary.libraryId);
      return onlyLibrary;
    }
    return null;
  }

  /// The Android Auto "recent" tile. Rebuilt from the persisted last-played
  /// track when the process was restarted since the last playback.
  Future<List<MediaItem>> _getRecentChildren() async {
    if (_recentSubject.value.isNotEmpty) return _recentSubject.value;
    final last = await AutoPreferences.getLastPlayed();
    if (last == null) return [];
    final tracks = await IsterMediaService()
        .getTracksForAlbum(last.serverName, last.albumId);
    final item = tracks.where((t) => t.id == last.trackId).firstOrNull ??
        tracks.firstOrNull;
    if (item == null) return [];
    final children = [item.mediaItem];
    _recentSubject.add(children);
    return children;
  }

  @override
  Future<List<MediaItem>> search(String query,
      [Map<String, dynamic>? extras]) async {
    try {
      final library = await AutoPreferences.getDefaultLibrary();
      if (library == null) return [];
      final results = await IsterMediaService()
          .searchMusic(library.serverName, library.libraryId, query);
      return results.map((e) => e.mediaItem).toList();
    } catch (e) {
      LoggerService().logger.e('search failed for "$query": $e');
      return [];
    }
  }

  @override
  Future<void> playFromSearch(String query,
      [Map<String, dynamic>? extras]) async {
    LoggerService().logger.d('playFromSearch: $query');
    try {
      // An empty query means "play something" — resume the last played track.
      if (query.trim().isEmpty) {
        final last = await AutoPreferences.getLastPlayed();
        if (last != null) {
          await playTrackById(MediaItemId(
              last.serverName, IsterMediaTypes.track, last.trackId));
        }
        return;
      }
      final library = await AutoPreferences.getDefaultLibrary();
      if (library == null) return;
      final results = await IsterMediaService()
          .searchMusic(library.serverName, library.libraryId, query);
      final album = results
          .where((e) => e.isterMediaType == IsterMediaTypes.album)
          .firstOrNull;
      if (album != null) {
        await playAlbumById(
            MediaItemId(album.serverName, IsterMediaTypes.album, album.id));
        return;
      }
      final artist = results
          .where((e) => e.isterMediaType == IsterMediaTypes.artist)
          .firstOrNull;
      if (artist == null) return;
      final firstAlbum = (await IsterMediaService()
              .getAlbumsForArtist(artist.serverName, artist.id))
          .firstOrNull;
      if (firstAlbum != null) {
        await playAlbumById(MediaItemId(
            firstAlbum.serverName, IsterMediaTypes.album, firstAlbum.id));
      }
    } catch (e) {
      LoggerService().logger.e('playFromSearch failed for "$query": $e');
    }
  }

  // ── Listener wiring ───────────────────────────────────────────────────
  Future<void> _onPlayingChanged(bool playing) async {
    // Acquire audio focus when playback starts, but NEVER abandon it
    // automatically when `playing` briefly drops to false (e.g. during the gap
    // between two tracks). On Android 16 ("Audio Hardening") re-requesting focus
    // from the background is blocked, which silently mutes/stops playback until
    // the app is reopened. Holding focus continuously across track transitions
    // avoids that. Focus is only released on an explicit stop().
    if (playing) {
      _loadRetries = 0;
      final session = await AudioSession.instance;
      await session.setActive(true);
    }
    updatePlaybackState();
  }

  void updatePlaybackState() {
    AudioProcessingState processingState = AudioProcessingState.ready;
    if (_player.state.buffering) {
      processingState = AudioProcessingState.buffering;
    } else if (_player.state.completed) {
      processingState = AudioProcessingState.completed;
    }
    final currentItemId = playQueue?.currentItemId;
    final mediaType = _currentMediaType;
    var currentMediaItemList = (currentItemId != null && serverName != null)
        ? queue.value.where((e) =>
            e.id == MediaItemId(serverName!, mediaType, currentItemId).toString())
        : const <MediaItem>[];
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.state.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        processingState: processingState,
        androidCompactActionIndices: const [0, 1, 3],
        playing: _player.state.playing,
        updatePosition: _player.state.position,
        bufferedPosition: _player.state.buffer,
        speed: _player.state.rate,
        queueIndex: currentMediaItemList.isNotEmpty
            ? queue.value.indexOf(currentMediaItemList.first)
            : playbackState.value.queueIndex,
      ),
    );
  }

  void _listenToBuffering() {
    _player.stream.buffering.listen(
      (event) {
        updatePlaybackState();
      },
    );
  }

  void _listenToTracks() {
    _player.stream.tracks.listen((tracks) async {
      debugPrint('[TRACKS_HANDLER] audioApplied=$_audioPreferenceApplied subApplied=$_subtitlePreferenceApplied | audio=${tracks.audio.map((t) => t.id).join(",")} sub=${tracks.subtitle.map((t) => t.id).join(",")}');

      if (!_audioPreferenceApplied &&
          tracks.audio.any((t) => t.id != 'auto' && t.id != 'no')) {
        _audioPreferenceApplied = true;
        final forcedAudio = _forcedAudio;
        _forcedAudio = null;
        if (forcedAudio != null && forcedAudio.id != 'auto') {
          // Restore the audio track the user had selected before the reload.
          final match = tracks.audio.firstWhere(
            (t) => t.language != null && t.language == forcedAudio.language,
            orElse: () => AudioTrack.auto(),
          );
          debugPrint('[TRACKS_HANDLER] restoring forced audio: ${match.id}');
          await _player.setAudioTrack(match);
        } else {
          debugPrint('[TRACKS_HANDLER] applying audio preference');
          await _selectPreferredTrack<AudioTrack>(
            tracks.audio,
            LanguagePreferences.getSpokenLanguages,
            (t) => _player.setAudioTrack(t),
          );
        }
        debugPrint('[TRACKS_HANDLER] audio applied: ${_player.state.track.audio.id}');
      }

      if (!_subtitlePreferenceApplied &&
          tracks.subtitle.any((t) => t.id != 'auto' && t.id != 'no')) {
        _subtitlePreferenceApplied = true;
        final forcedSubtitle = _forcedSubtitle;
        _forcedSubtitle = null;
        if (forcedSubtitle != null) {
          if (forcedSubtitle.id == 'no') {
            debugPrint('[TRACKS_HANDLER] restoring forced subtitle: no');
            await _player.setSubtitleTrack(SubtitleTrack.no());
          } else {
            // Match by language since track IDs can change after a reload.
            final match = tracks.subtitle.firstWhere(
              (t) => t.language != null && t.language == forcedSubtitle.language,
              orElse: () => SubtitleTrack.no(),
            );
            debugPrint('[TRACKS_HANDLER] restoring forced subtitle: ${match.id}');
            await _player.setSubtitleTrack(match);
          }
        } else {
          debugPrint('[TRACKS_HANDLER] applying subtitle preference');
          await _selectPreferredTrack<SubtitleTrack>(
            tracks.subtitle,
            LanguagePreferences.getSubtitleLanguages,
            (t) => _player.setSubtitleTrack(t),
          );
        }
        debugPrint('[TRACKS_HANDLER] subtitle applied: ${_player.state.track.subtitle.id}');
      }
    });
  }

  /// Switches the subtitle track by reloading the stream at the current
  /// position. This is necessary because with a large buffer (320 MB) the
  /// HLS fetcher is far ahead and a plain setSubtitleTrack only takes effect
  /// on segments that haven't been fetched yet — which could be minutes away.
  Future<void> switchSubtitleTrack(SubtitleTrack track) async {
    if (kIsWeb) {
      // On web, hls.js applies subtitle track changes immediately — no reload needed.
      await _player.setSubtitleTrack(track);
      return;
    }

    final url = _currentMediaUrl;
    if (url == null || serverName == null) return;

    _forcedSubtitle = track;
    _forcedAudio = _player.state.track.audio;
    _audioPreferenceApplied = false;
    _subtitlePreferenceApplied = false;

    await _openMedia(
      serverName: serverName!,
      mediaUrl: url,
      startTimeInMilliseconds: _player.state.position.inMilliseconds,
      mediaType: _currentMediaType,
    );
  }

  void _listenToPosition() {
    _player.stream.position.listen((pos) async {
      // Track real forward progress so the stall watchdog can tell the
      // difference between "still playing" and "frozen near the end".
      if ((pos - _lastObservedPosition).inMilliseconds.abs() > 250) {
        _lastObservedPosition = pos;
        _lastPositionAdvance = DateTime.now();
      }

      await _syncProgress(pos);
    });
  }

  // Progress updates are sent strictly one at a time, in submission order.
  // Concurrent requests can be processed by the server out of order, letting
  // an in-flight update for the previous track overwrite the currentItemId a
  // skip just set.
  Future<void> _progressChain = Future.value();

  Future<Fragment$fragmentPlayQueue?> _sendProgressUpdate(
    GraphQLClient client,
    String playQueueId,
    String playQueueItemId,
    Duration position,
  ) {
    final send = _progressChain.then((_) => _playQueueService.updateProgress(
        client, playQueueId, playQueueItemId, position));
    _progressChain = send.then((_) {}, onError: (_) {});
    return send;
  }

  /// Replaces [playQueue] with a server response while keeping the locally
  /// tracked current item. The client is authoritative for what is playing —
  /// a response can still carry a stale currentItemId (e.g. a progress update
  /// for the previous track processed server-side around a skip).
  void _applyServerPlayQueue(Fragment$fragmentPlayQueue response) {
    final localCurrentItemId = playQueue?.currentItemId;
    playQueue = localCurrentItemId != null
        ? response.copyWith(currentItemId: localCurrentItemId)
        : response;
  }

  /// Syncs the playback position of the current item to the server. Throttled
  /// to ~10s of position delta unless [force] is set (pause/stop flush the
  /// final position so resume points don't lag behind).
  Future<void> _syncProgress(Duration pos, {bool force = false}) async {
    if (!force &&
        _lastProgress != null &&
        (pos - _lastProgress!).inMilliseconds.abs() <= 10 * 1000) {
      return;
    }
    _lastProgress = pos;

    final client = graphQLClient;
    final pq = playQueue;
    if (pq == null || client == null) return;

    String? itemId;
    if (episode != null) {
      itemId = _playQueueService.getPlayQueueItemId(pq, episode!.id);
    } else if (movie != null) {
      itemId = _playQueueService.getMoviePlayQueueItemId(pq, movie!.id);
    } else if (currentTrackId != null) {
      itemId = _playQueueService.getTrackPlayQueueItemId(pq, currentTrackId!);
    }
    if (itemId == null) return;

    final generation = _syncGeneration;
    final playQueueObject =
        await _sendProgressUpdate(client, pq.id, itemId, pos);
    // Drop the response if the queue or current item changed while this
    // request was in flight — a slow response must not revert a skip.
    if (playQueueObject != null && generation == _syncGeneration) {
      final before = playQueue?.playQueueItems?.length ?? 0;
      _applyServerPlayQueue(playQueueObject);
      final after = playQueue?.playQueueItems?.length ?? 0;
      // Sources with sourceExhausted == false grow server-side as playback
      // advances; rebuild the visible queue when new items are appended.
      if (after != before && serverName != null) {
        queue.add(_buildQueueItems(playQueue!, serverName!));
        updatePlaybackState();
        PlayQueueService().playQueueChanged(playQueue!);
      }
    }
  }

  /// Watchdog for streams that stall just before the end without ever firing
  /// `completed`. This is common with transcoded/HLS audio on Android: the
  /// final segment that signals EOF never arrives (especially while the app is
  /// backgrounded and Doze throttles the network), so mpv sits buffering near
  /// the end and `skipToNext()` is never reached. When we detect that playback
  /// is supposed to be running but the position has frozen within a few seconds
  /// of the end, we advance manually.
  void _startStallWatchdog() {
    _stallWatchdog?.cancel();
    _stallWatchdog = Timer.periodic(const Duration(seconds: 2), (_) {
      // Nothing can stall when we don't intend to be playing — skip the work so
      // the timer doesn't poke the player every 2s for the app's whole life.
      if (!_intendsToPlay) return;
      _maybeRecoverStalledLoad();
      _maybeAutoAdvanceOnStall();
    });
  }

  /// Recovers a stream that was opened but never started playing — typically a
  /// background HLS load that stalled because Android throttled the network at
  /// the moment of a track change. Without this the next track only starts once
  /// the app is reopened. We re-open the same stream a bounded number of times;
  /// the mpv reconnect options handle softer drops, this handles a full hang.
  void _maybeRecoverStalledLoad() {
    if (!_intendsToPlay) return;
    if (_player.state.playing) return;
    final openedAt = _mediaOpenedAt;
    if (openedAt == null) return;
    // Give a normal background load plenty of time before intervening.
    if (DateTime.now().difference(openedAt) < const Duration(seconds: 12)) {
      return;
    }
    // A stream with known duration that isn't buffering did load — it is
    // paused (e.g. via the in-video controls, which bypass pause() and leave
    // _intendsToPlay set), not hung.
    if (!_player.state.buffering && _player.state.duration > Duration.zero) {
      return;
    }
    // Only a stream that essentially never advanced past its open position
    // counts as a failed load. (Resumed content opens mid-stream, so compare
    // against the open position rather than 0.)
    final openPosition = Duration(milliseconds: _streamOpenPositionMs);
    if (_player.state.position - openPosition > const Duration(seconds: 1)) {
      return;
    }
    final url = _currentMediaUrl;
    if (url == null || serverName == null) return;
    if (_loadRetries >= 5) return;
    _loadRetries++;
    LoggerService().logger.w(
        '[LOADSTALL] Stream not playing 12s+ after open — re-opening (retry $_loadRetries)');
    _openMedia(
      serverName: serverName!,
      mediaUrl: url,
      startTimeInMilliseconds: _streamOpenPositionMs,
      mediaType: _currentMediaType,
    );
  }

  void _maybeAutoAdvanceOnStall() {
    if (!_player.state.playing) return;
    final dur = _player.state.duration;
    final pos = _player.state.position;
    if (dur <= Duration.zero) return;

    // Only act near the very end — a mid-track buffering hiccup should recover
    // on its own, not skip the track.
    if (dur - pos > const Duration(seconds: 3)) return;

    final stalledFor = DateTime.now().difference(_lastPositionAdvance);
    if (stalledFor < const Duration(seconds: 4)) return;

    // Debounce against a real `completed` event firing around the same time.
    final last = _lastAutoAdvance;
    if (last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 8)) {
      return;
    }
    _lastAutoAdvance = DateTime.now();
    LoggerService().logger.w(
        '[STALL] Near-end stall detected (remaining=${dur - pos}, stalledFor=$stalledFor) — advancing to next');
    skipToNext();
  }

  void _listenToCompletion() {
    _player.stream.completed.listen((completed) {
      if (completed && playQueue != null) {
        final pos = _player.state.position;
        final dur = _player.state.duration;
        final openedAt = _mediaOpenedAt;
        final msSinceOpen = openedAt != null
            ? DateTime.now().difference(openedAt).inMilliseconds
            : null;
        LoggerService().logger.d('[COMPLETION] completed=true pos=$pos dur=$dur msSinceOpen=$msSinceOpen');
        // A genuine end-of-track has a known duration and a position within a
        // few seconds of it. When that's the case we always advance — even for
        // a legitimately short track (intro/interlude) that completes < 5s after
        // it opened, which would otherwise be filtered as spurious.
        final reachedEnd = dur > Duration.zero &&
            (dur - pos) <= const Duration(seconds: 5);
        // Otherwise, ignore spurious completions that indicate a decoder failure
        // (e.g. MPEG-4 Part 2 on Android). Two patterns:
        // 1. Completion fires within 5 s of opening — decoder failed at start position.
        // 2. Position is near zero — MPV reset position after a prior failure and
        //    the surface listener re-seeked to 0, triggering another completion.
        final isPosTooEarly = pos < const Duration(seconds: 5);
        final isTooSoonAfterOpen = msSinceOpen != null && msSinceOpen < 5000;
        if (!reachedEnd && (isTooSoonAfterOpen || isPosTooEarly)) {
          LoggerService().logger.d('[COMPLETION] Ignoring: isTooSoonAfterOpen=$isTooSoonAfterOpen isPosTooEarly=$isPosTooEarly pos=$pos');
          return;
        }
        // Mark so the stall watchdog doesn't double-advance.
        _lastAutoAdvance = DateTime.now();
        skipToNext();
      }
    });
  }

  Future<void> _listenToSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_player.state.playing) {
          pause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (_interrupted) {
              play();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_player.state.playing) pause();
    });
  }

  // ── Helper methods (track selection) ───────────────────────────────────
  Duration? _lastProgress;
  bool _listenersAdded = false;
  bool _interrupted = false;
  bool _audioPreferenceApplied = false;
  bool _subtitlePreferenceApplied = false;
  DateTime? _mediaOpenedAt;

  // Stall-watchdog state: tracks real forward progress so we can detect a
  // stream that froze near the end without firing `completed`.
  Timer? _stallWatchdog;
  Duration _lastObservedPosition = Duration.zero;
  DateTime _lastPositionAdvance = DateTime.now();
  DateTime? _lastAutoAdvance;
  // Whether playback is supposed to be running. Lets the load watchdog tell a
  // failed background load apart from a deliberate pause.
  bool _intendsToPlay = false;
  int _loadRetries = 0;

  Future<void> _selectPreferredTrack<T>(
    List<T> available,
    Future<List<String>> Function() getPrefs,
    Future<void> Function(T) setter,
  ) async {
    final prefs = await getPrefs();

    for (final lang in prefs) {
      final data = await LanguageService().getLanguageData(lang);
      if (data == null) continue;

      final matches = available
          .where((t) => data.toCodeList().contains(_trackLanguage(t)))
          .toList();

      if (matches.isNotEmpty) {
        await setter(matches.first);
        return;
      }
    }

    await setter(_fallbackTrack<T>());
  }

  String? _trackLanguage<T>(T track) {
    if (track is SubtitleTrack) return track.language;
    if (track is AudioTrack) return track.language;
    return null;
  }

  T _fallbackTrack<T>() {
    if (T == SubtitleTrack) return SubtitleTrack.no() as T;
    if (T == AudioTrack) return AudioTrack.auto() as T;
    throw UnimplementedError('No fallback for type $T');
  }

// @override
// ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) {
//   print(parentMediaId);
//   return Stream.value({"String", ""}).map((_) => <String, dynamic>{}).shareValue();
// }
}
