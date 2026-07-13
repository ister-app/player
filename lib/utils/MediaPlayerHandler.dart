import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:flutter/foundation.dart';
import 'package:player/utils/AutoPreferences.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/ResilientSubscription.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:rxdart/rxdart.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentImages.graphql.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../graphql/fragmentWatchStatus.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../graphql/playbackCommandsSubscription.graphql.dart';
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
      // Drop the loading skeleton exactly when new metadata is delivered to the
      // UI stream — same event the music player's StreamBuilder rebuilds on — so
      // the previous track's cover/title can't flash in between.
      mediaItem.listen((item) {
        if (mediaLoading.value && item != _loadingFromItem) {
          mediaLoading.value = false;
        }
      });
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
  final ValueNotifier<bool> musicPlayerOpen = ValueNotifier(false);

  /// Bumped whenever the user starts a music track from a browse surface (album
  /// tap, album/library shuffle). A globally-mounted listener — the mini player
  /// — pushes the full [MusicPlayerRoute] so playback opens the player directly
  /// instead of leaving the user to tap the mini player.
  final ValueNotifier<int> openMusicPlayerRequest = ValueNotifier(0);

  /// True from the moment a user-initiated new track begins loading until its
  /// [mediaItem] metadata is published. The music player shows a skeleton while
  /// this is set so it never displays the *previous* track's cover/title.
  final ValueNotifier<bool> mediaLoading = ValueNotifier(false);

  /// The item that was showing when the current load started. The skeleton is
  /// dropped only once [mediaItem] actually *emits* something different — see
  /// the `mediaItem.listen` in the constructor. Clearing [mediaLoading] on the
  /// same stream event that delivers the new item (rather than synchronously in
  /// `_openMedia`) avoids a one-frame flash of the old metadata: otherwise the
  /// flag flips before the `StreamBuilder<MediaItem>` receives the new value.
  MediaItem? _loadingFromItem;

  /// Begins a skeletonised load: remembers what was on screen so the listener
  /// can tell when genuinely new metadata has arrived.
  void _beginMediaLoading() {
    _loadingFromItem = mediaItem.valueOrNull;
    mediaLoading.value = true;
  }
  // Number of video pages (episode/movie) currently mounted. The mini player
  // hides its video bar while the item's own page is on screen — the full
  // player is already visible there, so the bar would only duplicate it.
  // A counter (not a bool) is robust against init-before-dispose ordering when
  // navigating from one video page straight to another.
  final ValueNotifier<int> videoPageOpen = ValueNotifier(0);

  /// True while a video is showing fullscreen. Guards the auto-fullscreen
  /// trigger in [IsterPlayer] against re-entering while already fullscreen.
  bool videoFullscreen = false;

  /// Repeat mode for the queue. Persisted in [playbackState] so notification
  /// controls and the music UI stay in sync. `one` replays the current track on
  /// completion; `all` wraps past the ends of the queue. The backend play queue
  /// has no repeat concept, so this is enforced entirely client-side in
  /// [skipToNext]/[skipToPrevious] and the completion/stall auto-advance.
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;
  AudioServiceRepeatMode get repeatMode => _repeatMode;

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
  // Remote-control ("party mode"): commands for the active queue arrive over
  // this subscription and are executed as if the user tapped the controls.
  ResilientSubscription? _commandSubscription;
  String? _commandQueueId;
  // When this client last edited its own queue; the QUEUE_CHANGED echo of that
  // edit should not toast as if someone else changed the queue.
  DateTime? _lastLocalQueueEdit;

  // ── Public API used by the widget ─────────────────────────────────────
  Future<void> startPlayQueue(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentEpisode newEpisode,
    String newServerName,
  ) async {
    _intendsToPlay = true;
    _loadRetries = 0;
    _startHeartbeat();
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
      // Silence the previous item immediately so it doesn't keep playing
      // during the getOrCreatePlayQueue round-trip below.
      await _player.stop();
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
      _ensureCommandSubscription();
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: newServerName);
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: newServerName);
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

  /// Resume position for a long-form audio item (podcast episode, audiobook
  /// chapter): the recorded progress, unless it already played to the end.
  /// Music tracks intentionally have no resume — they always start at zero.
  static int? _resumeMs(List<Fragment$fragmentWatchStatus>? watchStatus) {
    final ws = watchStatus;
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
    _startHeartbeat();
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
      // Silence the previous item immediately so it doesn't keep playing
      // during the getOrCreatePlayQueue round-trip below.
      await _player.stop();
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
      _ensureCommandSubscription();
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: newServerName);
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: newServerName);
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
    _startHeartbeat();
    final shouldRefresh = album == null ||
        album!.id != newAlbum.id ||
        serverName != newServerName ||
        currentTrackId != trackId;

    // Open the full player immediately; show a skeleton (not the previous
    // track) while the new track's metadata loads.
    if (shouldRefresh) _beginMediaLoading();
    openMusicPlayerRequest.value++;

    album = newAlbum;
    currentTrackId = trackId;
    episode = null;
    movie = null;
    _currentMediaType = IsterMediaTypes.track;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
      _syncGeneration++;
      // Silence the previous item immediately so it doesn't keep playing
      // during the getOrCreatePlayQueue round-trip below.
      await _player.stop();
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
      _ensureCommandSubscription();
      currentPlayQueueItem =
          PlayQueueService.getCurrentPlayQueueItem(playQueue);

      final currentTrack = playQueueObject?.playQueueItems
          ?.where((e) => e.track?.id == trackId)
          .firstOrNull
          ?.track;

      if (currentTrack?.mediaFile != null &&
          currentTrack!.mediaFile!.isNotEmpty) {
        final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: newServerName);
        final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: newServerName);
        await _openMedia(
          serverName: newServerName,
          mediaUrl: ImageUtil.buildMediaFileUrl(currentTrack.mediaFile!.first,
                  token: StreamTokenService.getToken(newServerName),
                  direct: directPlay,
                  transcode: transcode) ??
              '',
          mediaType: IsterMediaTypes.track,
        );
      } else {
        // No playable file — _openMedia never ran, so no new item will arrive.
        // Clear here rather than leave the player stuck on a skeleton.
        mediaLoading.value = false;
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

  /// Starts (or resumes) an audiobook: creates a BOOK play queue of the book's
  /// chapters in order, starting at [chapterId] (or the first chapter).
  Future<void> startPlayQueueForBook(
    GraphQLClient client,
    String? playQueueId,
    String bookId,
    String? chapterId,
    String srv,
  ) async {
    final pq = await _playQueueService.getOrCreatePlayQueueForBook(
      client,
      playQueueId,
      bookId,
      chapterId,
    );
    if (pq != null) await _startFromPlayQueue(client, pq, srv);
  }

  /// Starts (or resumes) a podcast: creates a PODCAST play queue of the
  /// episodes newest-first, starting at [episodeId] (or the newest episode).
  Future<void> startPlayQueueForPodcast(
    GraphQLClient client,
    String? playQueueId,
    String podcastId,
    String? episodeId,
    String srv,
  ) async {
    final pq = await _playQueueService.getOrCreatePlayQueueForPodcast(
      client,
      playQueueId,
      podcastId,
      episodeId,
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
    _startHeartbeat();
    _syncGeneration++;
    serverName = srv;
    graphQLClient = client;

    // Shuffle always starts a fresh track — open the player and skeletonise
    // until the first shuffled item's metadata is published.
    _beginMediaLoading();
    openMusicPlayerRequest.value++;

    final items = PlayQueueService.sortedItems(pq);
    if (items.isEmpty) {
      mediaLoading.value = false;
      return;
    }
    final current = PlayQueueService.getCurrentPlayQueueItem(pq) ?? items.first;
    playQueue =
        pq.currentItemId == null ? pq.copyWith(currentItemId: current.id) : pq;
    _ensureCommandSubscription();

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
    currentPlayQueueItem = item;
    final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: srv);
    final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: srv);
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
    } else if (item.chapter != null) {
      // Audiobook chapters behave exactly like tracks: audio-only HLS.
      episode = null;
      movie = null;
      album = null;
      currentTrackId = null;
      _currentMediaType = IsterMediaTypes.track;
      final mf = item.chapter?.mediaFile?.firstOrNull;
      if (mf == null) return;
      await _openMedia(
        serverName: srv,
        mediaUrl: ImageUtil.buildMediaFileUrl(mf,
                token: token, direct: directPlay, transcode: transcode) ??
            '',
        startTimeInMilliseconds: _resumeMs(item.chapter?.watchStatus),
        mediaType: IsterMediaTypes.track,
      );
    } else if (item.podcastEpisode != null) {
      // Podcast episodes behave exactly like tracks once downloaded.
      episode = null;
      movie = null;
      album = null;
      currentTrackId = null;
      _currentMediaType = IsterMediaTypes.track;
      final mf = item.podcastEpisode?.mediaFile?.firstOrNull;
      if (mf == null) return;
      await _openMedia(
        serverName: srv,
        mediaUrl: ImageUtil.buildMediaFileUrl(mf,
                token: token, direct: directPlay, transcode: transcode) ??
            '',
        startTimeInMilliseconds: _resumeMs(item.podcastEpisode?.watchStatus),
        mediaType: IsterMediaTypes.track,
      );
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
      // Silence the currently-playing stream right away so it doesn't keep
      // playing while the new (HLS) stream loads — otherwise there's audible
      // overlap until _player.open() finishes buffering the next item.
      await _player.stop();
      await _player.open(media);
      // setVideoTrack throws UnsupportedError on web (media_kit); skipping it
      // there would otherwise abort _openMedia before mediaItem is published,
      // which is what the mini player gates its visibility on.
      if (!kIsWeb) {
        await _player.setVideoTrack(
            mediaType == IsterMediaTypes.track ? VideoTrack.no() : VideoTrack.auto());
      }
      final currentItemId = playQueue?.currentItemId;
      final found = currentItemId != null
          ? queue.value
              .where((e) =>
                  e.id ==
                  MediaItemId(serverName, mediaType, currentItemId).toString())
              .firstOrNull
          : null;
      if (found != null && mediaItem.valueOrNull != found) {
        // The mediaItem listener drops the skeleton on delivery of this event,
        // in lock-step with the UI's StreamBuilder — no old-metadata flash.
        mediaItem.add(found);
      } else {
        // Already the right item (or unresolved) — no new emission is coming,
        // so clear here; there's no stream event to race against.
        mediaLoading.value = false;
      }
    } catch (e) {
      mediaLoading.value = false;
      LoggerService().logger.e('Failed to open media: $e');
    }
  }

  // ── AudioService overrides ─────────────────────────────────────────────
  @override
  Future<void> play() {
    _intendsToPlay = true;
    // Resuming after stop() must restart the heartbeat the stop cancelled.
    if (playQueue != null) _startHeartbeat();
    final result = _player.play();
    // Tell the server we resumed right away. playState is passed explicitly
    // because _player.state.playing hasn't flipped to true yet at this point.
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PLAYING));
    return result;
  }

  @override
  Future<void> pause() {
    _intendsToPlay = false;
    // playState is passed explicitly: _player.state.playing is still true here
    // (pause() below hasn't taken effect), so deriving it would report PLAYING.
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PAUSED));
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    _intendsToPlay = false;
    // There is no explicit stop mutation: ending the heartbeat is the stop
    // signal. The final flush below records the resume position; the server
    // expires the session 60s after this last update.
    _stopHeartbeat();
    // A stopped session can no longer be remote-controlled.
    _stopCommandSubscription();
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PAUSED));
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
    if (next < q.length) {
      await skipToQueueItem(next);
    } else if (_repeatMode == AudioServiceRepeatMode.all && q.isNotEmpty) {
      // Wrap to the top of the queue. `repeat one` is deliberately ignored for a
      // manual next — the user asked to move on — and only loops on auto-advance.
      await skipToQueueItem(0);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final index = playbackState.value.queueIndex;
    if (index == null) return;
    final prev = index - 1;
    if (prev >= 0) {
      await skipToQueueItem(prev);
    } else if (_repeatMode == AudioServiceRepeatMode.all) {
      final q = queue.value;
      if (q.isNotEmpty) await skipToQueueItem(q.length - 1);
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _repeatMode = repeatMode;
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
  }

  /// Cycles repeat none → all → one → none, for a single UI toggle button.
  Future<void> cycleRepeatMode() async {
    const order = [
      AudioServiceRepeatMode.none,
      AudioServiceRepeatMode.all,
      AudioServiceRepeatMode.one,
    ];
    final next = order[(order.indexOf(_repeatMode) + 1) % order.length];
    await setRepeatMode(next);
  }

  /// Replays the current track from the start — used by the completion/stall
  /// handlers when [AudioServiceRepeatMode.one] is active.
  Future<void> _repeatCurrent() async {
    await _player.seek(Duration.zero);
    await _player.play();
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

  /// Whether [item] has an (analyzed) media file for any of its media types —
  /// the precondition for opening it in the player.
  bool _itemHasMediaFile(Fragment$fragmentPlayQueue$playQueueItems item) =>
      item.track?.mediaFile?.firstOrNull != null ||
      item.chapter?.mediaFile?.firstOrNull != null ||
      item.podcastEpisode?.mediaFile?.firstOrNull != null ||
      item.movie?.mediaFile?.firstOrNull != null ||
      item.episode?.mediaFile?.firstOrNull != null;

  /// Index of the first queue item at or after [from] that has a playable media
  /// file, or -1 when none remain. Used to skip over not-yet-analyzed items.
  int _nextPlayableIndex(int from) {
    final q = queue.value;
    for (var i = from; i < q.length; i++) {
      final id = MediaItemId.byStringId(q[i].id).id;
      final item =
          playQueue?.playQueueItems?.where((e) => e.id == id).firstOrNull;
      if (item != null && _itemHasMediaFile(item)) return i;
    }
    return -1;
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    _intendsToPlay = true;
    _loadRetries = 0;
    _startHeartbeat();
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

      // An item without an (analyzed) media file cannot be opened. Instead of
      // silently stalling (the previous item just keeps playing), tell the user
      // and jump to the next playable item in the queue.
      if (!_itemHasMediaFile(queueItem)) {
        showAppSnackBar(IsterMediaService.loc
            .skippedTrackNoFile(queue.value[index].title));
        final nextPlayable = _nextPlayableIndex(index + 1);
        if (nextPlayable != -1) await skipToQueueItem(nextPlayable);
        return;
      }

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

      final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: mediaItemId.serverName);
      final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: mediaItemId.serverName);

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
      } else if (queueItem.chapter != null) {
        // Audiobook chapter: same audio-only handling as a track.
        episode = null;
        movie = null;
        album = null;
        currentTrackId = null;
        _currentMediaType = IsterMediaTypes.track;
        final mediaFile = queueItem.chapter?.mediaFile?.firstOrNull;
        if (mediaFile == null) return;
        await _openMedia(
          serverName: mediaItemId.serverName,
          mediaUrl: ImageUtil.buildMediaFileUrl(mediaFile, token: StreamTokenService.getToken(mediaItemId.serverName), direct: directPlay, transcode: transcode) ?? '',
          startTimeInMilliseconds: _resumeMs(queueItem.chapter?.watchStatus),
          mediaType: IsterMediaTypes.track,
        );
      } else if (queueItem.podcastEpisode != null) {
        // Podcast episode: same audio-only handling as a track.
        episode = null;
        movie = null;
        album = null;
        currentTrackId = null;
        _currentMediaType = IsterMediaTypes.track;
        final mediaFile = queueItem.podcastEpisode?.mediaFile?.firstOrNull;
        if (mediaFile == null) return;
        await _openMedia(
          serverName: mediaItemId.serverName,
          mediaUrl: ImageUtil.buildMediaFileUrl(mediaFile, token: StreamTokenService.getToken(mediaItemId.serverName), direct: directPlay, transcode: transcode) ?? '',
          startTimeInMilliseconds: _resumeMs(queueItem.podcastEpisode?.watchStatus),
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
    _lastLocalQueueEdit = DateTime.now();
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
    _lastLocalQueueEdit = DateTime.now();
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
    _lastLocalQueueEdit = DateTime.now();
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
      } else if (e.chapter != null) {
        final c = e.chapter!;
        return MediaItem(
          id: MediaItemId(srv, IsterMediaTypes.track, e.id).toString(),
          title: MetadataUtil.getTitle(c.metadata) ?? 'Chapter ${c.number}',
          artist: c.author.name,
          album: c.book.name,
          duration: Duration(
              milliseconds:
                  c.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
          artUri: artFor(ImageUtil.getImageByType(c.book.images, ImageTypes.cover)),
        );
      } else if (e.podcastEpisode != null) {
        final pe = e.podcastEpisode!;
        return MediaItem(
          id: MediaItemId(srv, IsterMediaTypes.track, e.id).toString(),
          title: MetadataUtil.getTitle(pe.metadata) ?? pe.podcast.title,
          artist: pe.podcast.author ?? pe.podcast.title,
          album: pe.podcast.title,
          duration: Duration(
              milliseconds:
                  pe.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
          artUri: artFor(
              ImageUtil.getImageByType(pe.podcast.images, ImageTypes.cover)),
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
        final libraries = await service
            .getMusicLibrariesForServer(saved.serverName)
            .timeout(IsterMediaService.perServerTimeout);
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
        for (final library in await service
            .getMusicLibrariesForServer(server)
            .timeout(IsterMediaService.perServerTimeout)) {
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
            () => LanguagePreferences.getSpokenLanguages(serverName: serverName),
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
            () => LanguagePreferences.getSubtitleLanguages(serverName: serverName),
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

  /// The stream settings media URLs are built with, so the server can
  /// prefetch the next queue item in the same format.
  Future<Input$StreamSettingsInput> _currentStreamSettings() async {
    final directPlay = kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: serverName);
    final transcode = kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: serverName);
    return Input$StreamSettingsInput(
      direct: directPlay,
      transcode: transcode,
      subtitleFormat: fromJson$Enum$SubtitleFormat(ImageUtil.subtitleFormat),
    );
  }

  Future<Fragment$fragmentPlayQueue?> _sendProgressUpdate(
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
    final send = _progressChain.then((_) async => _playQueueService
        .updateProgress(client, playQueueId, playQueueItemId, position,
            streamSettings: await _currentStreamSettings(),
            playState: playState ??
                (_player.state.playing
                    ? Enum$PlayState.PLAYING
                    : Enum$PlayState.PAUSED)));
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
  Future<void> _syncProgress(Duration pos,
      {bool force = false, Enum$PlayState? playState}) async {
    if (!force &&
        _lastProgress != null &&
        (pos - _lastProgress!).inMilliseconds.abs() <= 10 * 1000) {
      return;
    }
    _lastProgress = pos;

    final client = graphQLClient;
    final pq = playQueue;
    if (pq == null || client == null) return;

    // The current queue item is the item id; chapters and podcast episodes have
    // no typed handler field to reconstruct it from (episode/movie/track are all
    // null for them), so they would never sync at all if we went by media type.
    String? itemId = currentPlayQueueItem?.id;
    if (itemId == null) {
      if (episode != null) {
        itemId = _playQueueService.getPlayQueueItemId(pq, episode!.id);
      } else if (movie != null) {
        itemId = _playQueueService.getMoviePlayQueueItemId(pq, movie!.id);
      } else if (currentTrackId != null) {
        itemId = _playQueueService.getTrackPlayQueueItemId(pq, currentTrackId!);
      }
    }
    if (itemId == null) return;

    final generation = _syncGeneration;
    _lastSyncSentAt = DateTime.now();
    final playQueueObject =
        await _sendProgressUpdate(client, pq.id, itemId, pos, playState: playState);
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
  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(seconds: 5), (_) {
      if (playQueue == null || graphQLClient == null) return;
      // Safety net: any path that (re)activated a queue without explicitly
      // subscribing still becomes remote-controllable within one tick.
      _ensureCommandSubscription();
      final last = _lastSyncSentAt;
      if (last != null &&
          DateTime.now().difference(last) < const Duration(seconds: 10)) {
        return;
      }
      unawaited(_syncProgress(_player.state.position, force: true));
    });
  }

  void _stopHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = null;
  }

  // ── Remote control ("party mode") ────────────────────────────────────────

  /// Subscribes to remote-control commands for the active queue. Idempotent:
  /// only (re)subscribes when the queue id changed since the last call.
  void _ensureCommandSubscription() {
    final pq = playQueue;
    final client = graphQLClient;
    if (pq == null || client == null) return;
    if (_commandQueueId == pq.id && _commandSubscription != null) return;
    _commandSubscription?.dispose();
    _commandQueueId = pq.id;
    _commandSubscription = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionplaybackCommands,
      variables: {'playQueueId': pq.id},
      onData: (result) {
        final command =
            Subscription$playbackCommands.fromJson(result.data!).playbackCommands;
        unawaited(_onRemoteCommand(command));
      },
      // ResilientSubscription retries by itself; missed commands are simply
      // not executed, which is the right failure mode for remote control.
      onFailure: (_) {},
    );
  }

  void _stopCommandSubscription() {
    _commandSubscription?.dispose();
    _commandSubscription = null;
    _commandQueueId = null;
  }

  Future<void> _onRemoteCommand(
      Subscription$playbackCommands$playbackCommands command) async {
    _showRemoteCommandToast(command.command);
    switch (command.command) {
      case Enum$PlaybackCommandType.PLAY:
        await play();
      case Enum$PlaybackCommandType.PAUSE:
        await pause();
      case Enum$PlaybackCommandType.NEXT:
        await skipToNext();
      case Enum$PlaybackCommandType.PREVIOUS:
        await skipToPrevious();
      case Enum$PlaybackCommandType.SEEK:
        final ms = command.positionInMilliseconds;
        if (ms != null) await seek(Duration(milliseconds: ms));
      case Enum$PlaybackCommandType.SKIP_TO_ITEM:
        final itemId = command.playQueueItemId;
        if (itemId != null) await _skipToItemId(itemId);
      case Enum$PlaybackCommandType.QUEUE_CHANGED:
        await _reloadPlayQueueFromServer();
      case Enum$PlaybackCommandType.$unknown:
        break;
    }
  }

  /// Tells the user on this client that someone took the controls. Suppressed
  /// for the QUEUE_CHANGED echo of the client's own queue edits — those fan
  /// out over the same subscription and would toast on every local action.
  void _showRemoteCommandToast(Enum$PlaybackCommandType command) {
    final loc = IsterMediaService.loc;
    final String? message;
    switch (command) {
      case Enum$PlaybackCommandType.PLAY:
        message = loc.remotePlay;
      case Enum$PlaybackCommandType.PAUSE:
        message = loc.remotePause;
      case Enum$PlaybackCommandType.NEXT:
        message = loc.remoteNext;
      case Enum$PlaybackCommandType.PREVIOUS:
        message = loc.remotePrevious;
      case Enum$PlaybackCommandType.SEEK:
        message = loc.remoteSeek;
      case Enum$PlaybackCommandType.SKIP_TO_ITEM:
        message = loc.remoteSkipToItem;
      case Enum$PlaybackCommandType.QUEUE_CHANGED:
        final lastLocalEdit = _lastLocalQueueEdit;
        message = lastLocalEdit != null &&
                DateTime.now().difference(lastLocalEdit) <
                    const Duration(seconds: 3)
            ? null
            : loc.remoteQueueChanged;
      case Enum$PlaybackCommandType.$unknown:
        message = null;
    }
    if (message != null) showAppSnackBar(message);
  }

  /// Skips to the queue item with [playQueueItemId]. The item may sit outside
  /// the materialized window the queue was last fetched with — refetch once
  /// and retry before giving up.
  Future<void> _skipToItemId(String playQueueItemId) async {
    int indexOf() => queue.value.indexWhere(
        (m) => MediaItemId.byStringId(m.id).id == playQueueItemId);
    var index = indexOf();
    if (index == -1) {
      await _reloadPlayQueueFromServer();
      index = indexOf();
    }
    if (index != -1) await skipToQueueItem(index);
  }

  /// Refetches the active queue after a QUEUE_CHANGED notification (someone —
  /// possibly another user — edited it) and rebuilds the visible queue. When
  /// the locally playing item was removed remotely, the server has already
  /// picked a new current item; adopt it and open it.
  Future<void> _reloadPlayQueueFromServer() async {
    final pq = playQueue;
    final client = graphQLClient;
    if (pq == null || client == null) return;
    final generation = _syncGeneration;
    final fresh = await _playQueueService.getPlayQueue(client, pq.id);
    // Drop the response when a skip happened while the fetch was in flight.
    if (fresh == null || generation != _syncGeneration) return;

    final localItemStillExists = fresh.playQueueItems
            ?.any((e) => e.id == playQueue?.currentItemId) ??
        false;
    _applyServerPlayQueue(fresh);
    if (!localItemStillExists) {
      playQueue = playQueue?.copyWith(currentItemId: fresh.currentItemId);
    }
    _refreshQueueFromPlayQueue();
    if (!localItemStillExists && fresh.currentItemId != null) {
      await _skipToItemId(fresh.currentItemId!);
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
    // A skip is already in flight for a failed load — don't re-open the old
    // (failing) stream in the window before the next item takes over.
    if (_handlingFailedLoad) return;
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
    // Re-opening the same stream never got it playing — the load has
    // definitively failed (commonly a server-side transcode that emits a valid
    // manifest but never delivers segments). Skip the item and tell the user
    // instead of buffering forever.
    if (_loadRetries >= 5) {
      _loadRetries = 0;
      unawaited(_skipFailedLoad());
      return;
    }
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

  /// Called when a stream never started playing after the bounded re-opens in
  /// [_maybeRecoverStalledLoad] — the load has failed for good. Skips to the
  /// next playable queue item and tells the user why, or stops when nothing
  /// playable remains. The item's media file exists (this isn't the
  /// not-yet-analysed case), so [_nextPlayableIndex] simply advances past it.
  Future<void> _skipFailedLoad() async {
    if (_handlingFailedLoad) return;
    _handlingFailedLoad = true;
    try {
      final index = playbackState.value.queueIndex;
      final title = mediaItem.valueOrNull?.title ??
          (index != null && index >= 0 && index < queue.value.length
              ? queue.value[index].title
              : '');
      LoggerService()
          .logger
          .w('[LOADSTALL] Load failed after retries — skipping ‘$title’');
      showAppSnackBar(IsterMediaService.loc.skippedTrackPlaybackFailed(title));
      final nextPlayable =
          index == null ? -1 : _nextPlayableIndex(index + 1);
      if (nextPlayable != -1) {
        await skipToQueueItem(nextPlayable);
      } else {
        await stop();
      }
    } finally {
      _handlingFailedLoad = false;
    }
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
    if (_repeatMode == AudioServiceRepeatMode.one) {
      _repeatCurrent();
    } else {
      skipToNext();
    }
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
        if (_repeatMode == AudioServiceRepeatMode.one) {
          _repeatCurrent();
        } else {
          skipToNext();
        }
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

  // Playback-heartbeat state: keeps the server-side session alive (also while
  // paused); _lastSyncSentAt tracks the last actual send so the heartbeat
  // stays quiet while position-driven syncs are flowing.
  Timer? _heartbeat;
  DateTime? _lastSyncSentAt;

  // Stall-watchdog state: tracks real forward progress so we can detect a
  // stream that froze near the end without firing `completed`.
  Timer? _stallWatchdog;
  Duration _lastObservedPosition = Duration.zero;
  DateTime _lastPositionAdvance = DateTime.now();
  DateTime? _lastAutoAdvance;
  // Guards the skip-on-failed-load path so the watchdog doesn't re-open the
  // failing stream while the skip to the next item is still in flight.
  bool _handlingFailedLoad = false;
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
