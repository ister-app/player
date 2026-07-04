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
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:rxdart/rxdart.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
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
      await platform.setProperty('network-timeout', '30');
      await platform.setProperty('stream-lavf-o', reconnect);
      await platform.setProperty('demuxer-lavf-o', reconnect);
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
      await _player.setVideoTrack(
          mediaType == IsterMediaTypes.track ? VideoTrack.no() : VideoTrack.auto());
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

    // Not in queue — fetch episode and start a new play queue
    final episodeFragment =
        await IsterMediaService().getEpisodeFragmentById(mediaItemId);
    if (episodeFragment == null) {
      LoggerService().logger.e('playFromMediaId: episode not found for $mediaId');
      return;
    }

    final client = await IsterMediaService.getClient(mediaItemId.serverName);
    await startPlayQueue(client, null, episodeFragment, mediaItemId.serverName);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    _intendsToPlay = true;
    _loadRetries = 0;
    _syncGeneration++;
    // Publish the target index immediately so a second next/previous tap
    // during the awaits below doesn't act on the stale index.
    playbackState.add(playbackState.value.copyWith(queueIndex: index));

    MediaItemId mediaItemId = MediaItemId.byStringId(queue.value[index].id);

    final newEpisodeList = playQueue?.playQueueItems
        ?.where((element) => element.id == mediaItemId.id)
        .toList();
    if (newEpisodeList != null && newEpisodeList.isNotEmpty) {
      final queueItem = newEpisodeList.first;
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

      final playQueueObject = await _playQueueService.updateProgress(
        ClientManager.getClientForUrl(mediaItemId.serverName).value,
        playQueue!.id,
        mediaItemId.id,
        Duration(milliseconds: 0),
      );
      if (playQueueObject != null) {
        playQueue = playQueueObject;
      }
      _onPlayingChanged(true);

      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);
      // Explicitly update the mediaItem stream now that playQueue is current
      mediaItem.add(queue.value[index]);
      if (playQueue != null) {
        PlayQueueService().playQueueChanged(playQueue!);
      }
    }
  }

  final BehaviorSubject<List<MediaItem>> _recentSubject =
      BehaviorSubject.seeded(<MediaItem>[]);

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    LoggerService().logger.d('getChildren: $parentMediaId');
    if (parentMediaId == AudioService.recentRootId) {
      return _recentSubject.value;
    } else if (parentMediaId == AudioService.browsableRootId) {
      if (serverName == null) {
        LoggerService().logger.w('getChildren: serverName is null, cannot build browsable root');
        return [];
      }
      return Future.value(List.of({
        MediaItem(
          id: MediaItemId(serverName!, IsterMediaTypes.list, "recent").toString(),
          title: "Recent",
          playable: false,
        ),
        MediaItem(id: MediaItemId(serverName!, IsterMediaTypes.list, "added").toString(), title: "Library", playable: false),
      }));
    }

    var itemsByParentId = await IsterMediaService().getItemsByParentId(parentMediaId);
    return itemsByParentId.map((e) => e.mediaItem).toList();
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
        await _playQueueService.updateProgress(client, pq.id, itemId, pos);
    // Drop the response if the queue or current item changed while this
    // request was in flight — a slow response must not revert a skip.
    if (playQueueObject != null && generation == _syncGeneration) {
      playQueue = playQueueObject;
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
