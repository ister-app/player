import 'dart:async';
import 'dart:io';

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
import 'package:player/utils/ClockSyncService.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/SyncPreferences.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LastMusicQueuePreferences.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/PlaybackPreferences.dart';
import 'package:player/utils/ResilientSubscription.dart';
import 'package:player/utils/QueueItemDisplay.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:rxdart/rxdart.dart';

import '../graphql/fragmentAlbum.graphql.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../graphql/fragmentWatchStatus.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../graphql/fragmentServerActivity.graphql.dart';
import '../graphql/nowPlayingSubscription.graphql.dart';
import '../graphql/playbackCommandsSubscription.graphql.dart';
import '../graphql/schema.graphql.dart';
import 'FollowSyncDecision.dart';
import 'ImageTypes.dart';
import 'ImageUtil.dart';
import 'MetadataUtil.dart';
import 'PlayQueueService.dart';
import 'SleepTimerService.dart';

class MediaPlayerHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  MediaPlayerHandler._internal() {
    _player = Player(
      configuration: PlayerConfiguration(
        libass: true,
        libassAndroidFont: 'assets/fonts/DroidSansFallback.ttf',
        libassAndroidFontName: 'Droid Sans Fallback',
        bufferSize: _demuxerBufferSize(),
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
      _listenToErrors();
      _listenToSession();
      _applyMpvNetworkOptions();
      _startStallWatchdog();
      StreamTokenService.tokenVersion.addListener(_refreshArtworkTokens);
      SleepTimerService.instance.onExpire = stop;
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

  /// mpv demuxer cache budget. media_kit applies this value to *both*
  /// demuxer-max-bytes and demuxer-max-back-bytes, so the real ceiling is
  /// twice what is returned here. On low-RAM devices (2GB Android TV boxes)
  /// the 320MB desktop default lets the process grow past 800MB RSS and the
  /// lowmemorykiller SIGKILLs the app mid-playback — scale down there.
  static int _demuxerBufferSize() {
    const desktop = 320 * 1024 * 1024;
    const lowRam = 32 * 1024 * 1024;
    final totalRam = _totalPhysicalMemory();
    if (totalRam != null && totalRam < 3 * 1024 * 1024 * 1024) return lowRam;
    return desktop;
  }

  /// Total physical memory in bytes, or null when it cannot be determined
  /// (web, non-procfs platforms).
  static int? _totalPhysicalMemory() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isLinux)) return null;
    try {
      final memInfo = File('/proc/meminfo').readAsStringSync();
      final match = RegExp(r'MemTotal:\s+(\d+) kB').firstMatch(memInfo);
      if (match == null) return null;
      return int.parse(match.group(1)!) * 1024;
    } catch (_) {
      return null;
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

  /// Bumped when follow mode needs the current video item's page on screen:
  /// joining a session that plays a movie/episode, and the leader switching to
  /// one. Same globally-mounted listener as [openMusicPlayerRequest] — the mini
  /// player — which navigates to the movie/episode page hosting the video.
  final ValueNotifier<int> openVideoPageRequest = ValueNotifier(0);

  /// Bumped by [endPlaybackLocally]: playback was torn down for good on this
  /// device (the watch-along leader stopped, or the queue moved to another
  /// device), so the UI must close what it opened for it — the music overlay
  /// and the video page/fullscreen. The mini player disappears on its own
  /// because [mediaItem] goes null.
  final ValueNotifier<int> closePlaybackRequest = ValueNotifier(0);

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
    // Starting own playback ends listening/watching along — except when the
    // page merely re-opens the followed queue itself (the follower's video
    // surface goes through this same entry point).
    if (followMode && playQueue?.id != playQueueId) await stopFollowing();
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
      await _silenceForQueueSwitch();
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
    _rememberLastMusicQueue();
  }

  /// Silences the current item ahead of the getOrCreatePlayQueue round-trip of
  /// a queue switch. Clearing the media URL and open timestamp for the duration
  /// of the round-trip keeps the stall watchdog from "recovering" the freshly
  /// stopped stream (audibly re-opening the previous item) and gates
  /// [_syncProgress], so nothing can overwrite the previous item's progress —
  /// e.g. reverting a fully-watched episode to the watchdog's re-open position —
  /// before [_openMedia] installs the new stream.
  Future<void> _silenceForQueueSwitch() async {
    _syncGeneration++;
    _currentMediaUrl = null;
    _mediaOpenedAt = null;
    // Under flutter test there is no real mpv event loop and player calls
    // never complete — same seam as _openMedia.
    if (!ClientManager.usesTestClients) await _player.stop();
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
    // Same follow-mode rule as startPlayQueue: only a *different* queue ends it.
    if (followMode && playQueue?.id != playQueueId) await stopFollowing();
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
      await _silenceForQueueSwitch();
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
    _rememberLastMusicQueue();
  }

  Future<void> startPlayQueueForAlbum(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentAlbum newAlbum,
    String trackId,
    String newServerName,
  ) async {
    // Same follow-mode rule as startPlayQueue: only a *different* queue ends it.
    if (followMode && playQueue?.id != playQueueId) await stopFollowing();
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
      await _silenceForQueueSwitch();
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
    _rememberLastMusicQueue();
  }

  /// Keeps the Android Auto "recent" tile and its persisted backup in sync
  /// with what is playing.
  void _rememberLastPlayed(String serverName, String albumId, String trackId) {
    if (_followMode) return;
    unawaited(AutoPreferences.setLastPlayed(serverName, albumId, trackId));
    final nowPlaying = mediaItem.valueOrNull;
    if (nowPlaying != null) {
      _recentSubject.add([nowPlaying]);
    }
  }

  /// Keeps the "last music queue" restore state in sync with what just opened:
  /// saved while a real track plays, cleared for everything else (audiobook
  /// chapters and podcast episodes also open as [IsterMediaTypes.track], but
  /// only real tracks set [currentTrackId]), so a fresh app start only ever
  /// restores a queue whose last-played item was music.
  void _rememberLastMusicQueue() {
    // A followed queue is someone else's session — it must neither replace
    // nor clear this user's own "last music queue".
    if (_followMode) return;
    final srv = serverName;
    final queueId = playQueue?.id;
    if (_currentMediaType == IsterMediaTypes.track &&
        currentTrackId != null &&
        srv != null &&
        queueId != null) {
      unawaited(LastMusicQueuePreferences.save(srv, queueId));
    } else {
      unawaited(LastMusicQueuePreferences.clear());
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

  /// Plays a custom-filter result as a FILTER queue: the server pins the
  /// definition, evaluates it as of now and grows the queue lazily. Only
  /// track/movie/episode filters are playable.
  Future<void> startFilteredPlay(
    GraphQLClient client,
    String srv,
    Input$MediaFilterInput filter,
    Enum$FilterKind filterKind, {
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    bool shuffle = false,
  }) async {
    final pq = await _playQueueService.createPlayQueue(
      client,
      sourceType: Enum$PlayQueueSourceType.FILTER,
      filter: filter,
      filterKind: filterKind,
      libraryId: libraryId,
      sorting: shuffle ? null : sorting,
      sortingOrder: shuffle ? null : sortingOrder,
      shuffle: shuffle,
    );
    if (pq != null) await _startFromPlayQueue(client, pq, srv);
  }

  /// Plays one of the user's playlists as a PLAYLIST queue. Manual playlists
  /// play their entries in order (or seeded-shuffled); smart playlists pin
  /// their filter server-side, like FILTER queues. [startId] is the media item
  /// to start at (a book id starts at that book's first chapter).
  ///
  /// Servers before the "start a filter-backed queue at an item" support reject
  /// [startId] on a smart playlist; that failure retries without it and opens
  /// the item client-side instead, which only reaches items inside the created
  /// window.
  Future<void> startPlaylistPlay(
    GraphQLClient client,
    String srv,
    String playlistId, {
    String? startId,
    bool shuffle = false,
  }) async {
    Future<Fragment$fragmentPlayQueue?> create(String? start) =>
        _playQueueService.createPlayQueue(
          client,
          sourceType: Enum$PlayQueueSourceType.PLAYLIST,
          sourceId: playlistId,
          startId: start,
          shuffle: shuffle,
        );

    final pq = await create(startId);
    if (pq != null) {
      await _startFromPlayQueue(client, pq, srv);
      return;
    }
    if (startId == null || shuffle) return;
    final fallback = await create(null);
    if (fallback != null) {
      await _startFromPlayQueue(client, fallback, srv, startMediaId: startId);
    }
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

  /// Plays an artist's ranked track list (most played / last played / highest
  /// rated) as the queue, starting at [startTrackId]. The server evaluates the
  /// ranking and keeps growing the queue past the visible top of the list.
  Future<void> startPlayQueueForArtistRankedList(GraphQLClient client,
      String srv, String personId, Enum$RankKind rankKind, String startTrackId) async {
    final pq = await _playQueueService.createPlayQueue(
      client,
      sourceType: Enum$PlayQueueSourceType.ARTIST,
      sourceId: personId,
      rankKind: rankKind,
      startId: startTrackId,
    );
    if (pq != null) await _startFromPlayQueue(client, pq, srv);
  }

  /// Starts playback from an already-created [pq], opening its current item
  /// (server-selected, or the first item). Used for shuffle/library sources
  /// where the starting item isn't chosen by the caller. [startMediaId] picks
  /// the queue item holding that media instead — for sources whose creation
  /// mutation takes no startId; unknown ids keep the queue's own start.
  Future<void> _startFromPlayQueue(
      GraphQLClient client, Fragment$fragmentPlayQueue pq, String srv,
      {String? startMediaId, int? startTimeMs}) async {
    // Same follow-mode rule as startPlayQueue: only a *different* queue ends it.
    if (followMode && playQueue?.id != pq.id) await stopFollowing();
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
    final current = (startMediaId == null
            ? null
            : PlayQueueService.itemForMedia(items, startMediaId)) ??
        PlayQueueService.getCurrentPlayQueueItem(pq) ??
        items.first;
    playQueue = pq.currentItemId == current.id
        ? pq
        : pq.copyWith(currentItemId: current.id);
    _ensureCommandSubscription();

    queueTitle.add("Now Playing");
    queue.add(_buildQueueItems(playQueue!, srv));
    currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

    await _openQueueItem(current, srv, startTimeMs: startTimeMs);
    updatePlaybackState();
  }

  /// Starts playback of a queue the server just created for a device command
  /// ("play on this device"): same path as the shuffle/library starts.
  Future<void> startFromServerQueue(
          GraphQLClient client, Fragment$fragmentPlayQueue pq, String srv) =>
      _startFromPlayQueue(client, pq, srv);

  /// Resumes an existing play queue on this device — the receiving side of a
  /// queue handoff. Opens the queue's current item at [positionMs] (the
  /// position the sending device flushed before handing off) and takes over
  /// the heartbeat; same-user ownership makes that takeover valid server-side.
  Future<void> startFromExistingQueue(String srv, String playQueueId,
      {int? positionMs}) async {
    if (followMode) await stopFollowing();
    final client = ClientManager.getClientForUrl(srv).value;
    final pq = await _playQueueService.getPlayQueue(client, playQueueId);
    if (pq == null) return;
    await _startFromPlayQueue(client, pq, srv, startTimeMs: positionMs);
  }

  /// Re-loads the play queue that last played music — paused, at the server's
  /// recorded item and position — so a fresh app start gets its music back in
  /// the mini player. A no-op unless [srv] is the server the queue belongs to
  /// (see [LastMusicQueuePreferences]) and nothing is loaded yet, so a live
  /// session (e.g. Android's audio service surviving the UI process) is never
  /// clobbered. Deliberately does not set [_intendsToPlay], start the
  /// heartbeat or open the music player: the restored state is silent until
  /// the user hits play, which takes the normal [play] path.
  Future<void> restoreLastMusicQueue(String srv) async {
    if (playQueue != null) return;
    final last = await LastMusicQueuePreferences.get();
    if (last == null || last.serverName != srv) return;

    final client = ClientManager.getClientForUrl(srv).value;
    // Null covers both "queue deleted" and a transient failure; keep the
    // preference so a later start can still restore after a network hiccup.
    final pq = await _playQueueService.getPlayQueue(client, last.playQueueId);
    if (pq == null) return;
    // Something started playing during the fetch — its state wins.
    if (playQueue != null) return;

    final current = PlayQueueService.getCurrentPlayQueueItem(pq) ??
        PlayQueueService.sortedItems(pq).firstOrNull;
    final track = current?.track;
    final mf = track?.mediaFile?.firstOrNull;
    if (current == null || track == null || mf == null) {
      // The queue moved on to non-music (or lost its media): forget it.
      await LastMusicQueuePreferences.clear();
      return;
    }

    serverName = srv;
    graphQLClient = client;
    _syncGeneration++;
    playQueue =
        pq.currentItemId == null ? pq.copyWith(currentItemId: current.id) : pq;
    currentPlayQueueItem = current;
    currentTrackId = track.id;
    episode = null;
    movie = null;
    album = null;
    _currentMediaType = IsterMediaTypes.track;
    // No command subscription yet: a restored queue has no live server session
    // to remote-control. play() arms it along with the heartbeat.

    queueTitle.add("Now Playing");
    queue.add(_buildQueueItems(playQueue!, srv));

    // A track that already played to (almost) the end restarts at zero, like
    // the long-form resume rule.
    final duration = mf.durationInMilliseconds;
    var startMs = pq.progressInMilliseconds;
    if (duration != null && startMs >= duration - 5000) startMs = 0;

    final directPlay =
        kIsWeb ? false : await PlaybackPreferences.getDirectPlay(serverName: srv);
    final transcode =
        kIsWeb ? true : await PlaybackPreferences.getTranscode(serverName: srv);
    await _openMedia(
      serverName: srv,
      mediaUrl: ImageUtil.buildMediaFileUrl(mf,
              token: StreamTokenService.getToken(srv),
              direct: directPlay,
              transcode: transcode) ??
          '',
      startTimeInMilliseconds: startMs,
      mediaType: IsterMediaTypes.track,
      autoPlay: false,
    );
    updatePlaybackState();
  }

  /// [restoreLastMusicQueue] for the headless Android Auto paths: looks up
  /// which server holds the last music queue and bootstraps login and stream
  /// token first (the UI normally does that before the in-app restore),
  /// bounded so an unreachable server cannot hang the whole browse request.
  /// Returns true when a queue is loaded afterwards — restored or already
  /// live.
  Future<bool> _tryRestoreLastMusicQueue() async {
    if (playQueue != null) return true;
    final last = await LastMusicQueuePreferences.get();
    if (last == null) return false;
    try {
      if (!ClientManager.usesTestClients) {
        await LoginManager.waitForToken(last.serverName)
            .timeout(IsterMediaService.perServerTimeout);
        await StreamTokenService.ensureToken(last.serverName);
      }
      await restoreLastMusicQueue(last.serverName);
    } catch (e) {
      LoggerService().logger.w('last music queue restore failed: $e');
    }
    return playQueue != null;
  }

  Future<bool>? _autoRestoreFuture;

  /// Deduplicated [_tryRestoreLastMusicQueue]: Android Auto fires a burst of
  /// browse requests when the car connects and a tap can race the background
  /// kick-off, but the restore must run only once. A failed attempt clears
  /// the slot so a later trigger can retry after e.g. a network hiccup.
  Future<bool> _restoreLastMusicQueueOnce() async {
    final inFlight = _autoRestoreFuture;
    if (inFlight != null) return inFlight;
    final attempt = _tryRestoreLastMusicQueue();
    _autoRestoreFuture = attempt;
    final restored = await attempt;
    if (!restored) _autoRestoreFuture = null;
    return restored;
  }

  /// Opens the media for [item], flipping the typed handler state (episode /
  /// movie / track) to match. Mirrors the per-type open in [skipToQueueItem].
  /// [startTimeMs] overrides the per-type resume position (follow mode opens
  /// at the leading device's position, whatever the item type).
  Future<void> _openQueueItem(
      Fragment$fragmentPlayQueue$playQueueItems item, String srv,
      {int? startTimeMs}) async {
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
        startTimeInMilliseconds: startTimeMs,
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
        startTimeInMilliseconds:
            startTimeMs ?? _resumeMs(item.chapter?.watchStatus),
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
        startTimeInMilliseconds:
            startTimeMs ?? _resumeMs(item.podcastEpisode?.watchStatus),
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
        startTimeInMilliseconds: startTimeMs,
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
        startTimeInMilliseconds: startTimeMs,
        mediaType: IsterMediaTypes.episode,
      );
    }
    _rememberLastMusicQueue();
  }

  Future<void> _openMedia({
    required String serverName,
    required String mediaUrl,
    int? startTimeInMilliseconds,
    IsterMediaTypes mediaType = IsterMediaTypes.episode,
    // False only for the paused restore of the last music queue: the media is
    // loaded and published but playback waits for an explicit play().
    bool autoPlay = true,
  }) async {
    _currentMediaUrl = mediaUrl;
    _streamOpenPositionMs = startTimeInMilliseconds ?? 0;
    _mediaOpenedAt = DateTime.now();
    // Reset stall tracking for the newly opened stream.
    _loadErrorSeen = false;
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
      // Under flutter test (mock GraphQL clients) there is no real mpv event
      // loop, so the player calls below would never complete; skip them and
      // still publish the mediaItem/queue state the tests assert on.
      if (!ClientManager.usesTestClients) {
        // Silence the currently-playing stream right away so it doesn't keep
        // playing while the new (HLS) stream loads — otherwise there's audible
        // overlap until _player.open() finishes buffering the next item.
        await _player.stop();
        await _player.open(media, play: autoPlay);
        // setVideoTrack throws UnsupportedError on web (media_kit); skipping it
        // there would otherwise abort _openMedia before mediaItem is published,
        // which is what the mini player gates its visibility on.
        if (!kIsWeb) {
          await _player.setVideoTrack(
              mediaType == IsterMediaTypes.track ? VideoTrack.no() : VideoTrack.auto());
        }
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

  /// Replaces the stream token embedded in [item]'s artUri with [token].
  /// Returns [item] unchanged when there is no artwork or the token already
  /// matches. Static and pure so it can be unit-tested without a [Player].
  static MediaItem restampArtToken(MediaItem item, String token) {
    final art = item.artUri;
    if (art == null || art.queryParameters['token'] == token) return item;
    return item.copyWith(
      artUri: art.replace(
          queryParameters: {...art.queryParameters, 'token': token}),
    );
  }

  /// Re-publishes queue and current item with the current stream token in
  /// their artUris. The artUri is built once at queue construction, but
  /// Android re-downloads notification artwork from it whenever it rebuilds
  /// the media notification — long after the embedded token has rotated or
  /// expired, which made the cover silently disappear.
  void _refreshArtworkTokens() {
    MediaItem restamp(MediaItem item) {
      final String serverName;
      try {
        serverName = MediaItemId.byStringId(item.id).serverName;
      } catch (_) {
        return item;
      }
      final token = StreamTokenService.getToken(serverName);
      return token == null ? item : restampArtToken(item, token);
    }

    final items = queue.valueOrNull ?? const [];
    final restamped = items.map(restamp).toList();
    if (Iterable.generate(items.length)
        .any((i) => !identical(items[i], restamped[i]))) {
      queue.add(restamped);
    }
    final current = mediaItem.valueOrNull;
    if (current != null) {
      final fresh = restamp(current);
      if (!identical(fresh, current)) mediaItem.add(fresh);
    }
  }

  /// While the app sits suspended in the background (Doze), the refresh
  /// timers in [StreamTokenService] don't fire, so the token can expire
  /// outright. Fetching one on resume bumps [StreamTokenService.tokenVersion],
  /// which re-stamps the published artUris via [_refreshArtworkTokens].
  Future<void> _ensureFreshArtToken() async {
    final id = mediaItem.valueOrNull?.id;
    if (id == null) return;
    try {
      await StreamTokenService.ensureToken(MediaItemId.byStringId(id).serverName);
    } catch (e) {
      LoggerService().logger.w('Stream token refresh on resume failed: $e');
    }
  }

  // ── AudioService overrides ─────────────────────────────────────────────
  @override
  Future<void> play() async {
    // Following device: transport goes over the command bus (the echo plays
    // this device, the same command plays the leader) so everyone stays in
    // step. _applyingRemoteSync marks the echo/state application itself.
    if (_followMode && !_applyingRemoteSync) {
      await _sendFollowCommand(Enum$PlaybackCommandType.PLAY);
      return;
    }
    // A play command with nothing loaded (e.g. the car's resume button right
    // after connecting, before any browse): restore the last queue first so
    // "play" continues the last music instead of doing nothing.
    if (playQueue == null) await _restoreLastMusicQueueOnce();
    _intendsToPlay = true;
    unawaited(_ensureFreshArtToken());
    // Resuming after stop() (or a paused restore) must restart the heartbeat
    // and the remote-command subscription those paths left down.
    if (playQueue != null) {
      _startHeartbeat();
      _ensureCommandSubscription();
    }
    final result = _player.play();
    // Tell the server we resumed right away. playState is passed explicitly
    // because _player.state.playing hasn't flipped to true yet at this point.
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PLAYING));
    return result;
  }

  @override
  Future<void> pause() {
    if (_followMode && !_applyingRemoteSync) {
      return _sendFollowCommand(Enum$PlaybackCommandType.PAUSE);
    }
    _intendsToPlay = false;
    // playState is passed explicitly: _player.state.playing is still true here
    // (pause() below hasn't taken effect), so deriving it would report PLAYING.
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PAUSED));
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    // Stopping a following device only stops *this* device: leave follow mode
    // (deregistering at the server) without touching the leader's session.
    await stopFollowing();
    _intendsToPlay = false;
    // There is no explicit stop mutation: ending the heartbeat is the stop
    // signal. The final flush below records the resume position; the server
    // expires the session 60s after this last update.
    _stopHeartbeat();
    // A stopped session can no longer be remote-controlled.
    _stopCommandSubscription();
    unawaited(_syncProgress(_player.state.position,
        force: true, playState: Enum$PlayState.PAUSED));
    SleepTimerService.instance.notifyPlaybackStopped();
    await _player.pause();
    // Explicit stop is the only place we release audio focus.
    final session = await AudioSession.instance;
    await session.setActive(false);
  }

  /// Ends playback on *this* device for good: unlike [stop] (which pauses and
  /// keeps the item loaded so the notification/mini player can resume it) this
  /// closes the stream and clears the loaded media entirely. Used when the
  /// media is gone from this device rather than merely paused — the followed
  /// session ended, or the queue was handed off to another device.
  ///
  /// [flushProgress] writes one last position to the server. Pass false after a
  /// handoff: the target device owns the progress from that moment, and a late
  /// flush from here would drag it back.
  Future<void> endPlaybackLocally({bool flushProgress = true}) async {
    await stopFollowing();
    _intendsToPlay = false;
    _stopHeartbeat();
    _stopCommandSubscription();
    if (flushProgress) {
      unawaited(_syncProgress(_player.state.position,
          force: true, playState: Enum$PlayState.PAUSED));
    }
    SleepTimerService.instance.notifyPlaybackStopped();
    // In-flight progress responses must not resurrect the queue we clear below.
    _syncGeneration++;
    // stop(), not pause(): pausing leaves the HLS load (and the video texture)
    // alive, which is exactly what this method exists to get rid of.
    if (!ClientManager.usesTestClients) await _player.stop();

    playQueue = null;
    currentPlayQueueItem = null;
    episode = null;
    movie = null;
    album = null;
    currentTrackId = null;
    serverName = null;
    graphQLClient = null;
    _currentMediaUrl = null;
    _forcedAudio = null;
    _forcedSubtitle = null;
    _audioPreferenceApplied = false;
    _subtitlePreferenceApplied = false;
    _streamOpenPositionMs = 0;
    _mediaOpenedAt = null;
    _loadErrorSeen = false;
    _loadRetries = 0;
    _lastProgress = null;
    _lastSyncSentAt = null;

    queue.add(const []);
    mediaItem.add(null);
    updatePlaybackState();

    if (!ClientManager.usesTestClients) {
      try {
        final session = await AudioSession.instance;
        await session.setActive(false);
      } catch (e) {
        LoggerService().logger.w('Releasing audio focus on teardown failed: $e');
      }
    }
    closePlaybackRequest.value++;
  }

  @override
  Future<void> seek(Duration position) {
    if (_followMode && !_applyingRemoteSync) {
      return _sendFollowCommand(Enum$PlaybackCommandType.SEEK,
          position: position);
    }
    return seekAware(position);
  }

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
    if (_followMode && !_applyingRemoteSync) {
      await _sendFollowCommand(Enum$PlaybackCommandType.NEXT);
      return;
    }
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
    if (_followMode && !_applyingRemoteSync) {
      await _sendFollowCommand(Enum$PlaybackCommandType.PREVIOUS);
      return;
    }
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
    // The mode rides along on the next heartbeat, but a remote control would
    // then show the old state for up to ~10s; a forced sync closes that gap.
    unawaited(_syncProgress(_player.state.position, force: true));
  }

  /// The wire form of an audio_service repeat mode; the session relays it so
  /// remote controls can show and toggle the same state.
  static Enum$RepeatMode repeatModeToApi(AudioServiceRepeatMode mode) =>
      switch (mode) {
        AudioServiceRepeatMode.all => Enum$RepeatMode.ALL,
        AudioServiceRepeatMode.one => Enum$RepeatMode.ONE,
        // audio_service also knows "group", which this app never sets.
        _ => Enum$RepeatMode.NONE,
      };

  static AudioServiceRepeatMode repeatModeFromApi(Enum$RepeatMode mode) =>
      switch (mode) {
        Enum$RepeatMode.ALL => AudioServiceRepeatMode.all,
        Enum$RepeatMode.ONE => AudioServiceRepeatMode.one,
        Enum$RepeatMode.NONE || Enum$RepeatMode.$unknown =>
          AudioServiceRepeatMode.none,
      };

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

    // Tapping the item that is already loaded (e.g. the Android Auto recent
    // tile after a paused queue restore) resumes at the loaded position;
    // skipToQueueItem below would rebuild it from the track start instead.
    if (playQueue != null && mediaItem.valueOrNull?.id == mediaId) {
      if (!playbackState.value.playing) await play();
      return;
    }

    // The recent tile of a not-yet-restored queue: load that queue paused at
    // its recorded position and resume it, instead of rebuilding an album
    // queue from the track start.
    if (playQueue == null &&
        _recentSubject.value.any((item) => item.id == mediaId) &&
        await _restoreLastMusicQueueOnce()) {
      if (mediaItem.valueOrNull?.id == mediaId) {
        await play();
        return;
      }
      // The queue moved on server-side — fall through to the tapped item.
    }

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
      case IsterMediaTypes.book:
        // A book leaf resumes where the listener left off — the server's
        // resumeChapter knows which chapter that is, and the queue item's
        // watch status carries the position within it.
        final startChapterId = await IsterMediaService()
            .getBookStartChapterId(mediaItemId.serverName, mediaItemId.id);
        final client = await IsterMediaService.getClient(mediaItemId.serverName);
        await startPlayQueueForBook(
            client, null, mediaItemId.id, startChapterId, mediaItemId.serverName);
      case IsterMediaTypes.chapter:
        // Composite id: "bookId~chapterId".
        final parts =
            mediaItemId.id.split(IsterMediaService.compositeIdSeparator);
        if (parts.length != 2) {
          LoggerService()
              .logger
              .e('playFromMediaId: malformed chapter id $mediaId');
          return;
        }
        final client = await IsterMediaService.getClient(mediaItemId.serverName);
        await startPlayQueueForBook(
            client, null, parts[0], parts[1], mediaItemId.serverName);
      case IsterMediaTypes.playlist:
        final client = await IsterMediaService.getClient(mediaItemId.serverName);
        await startPlaylistPlay(client, mediaItemId.serverName, mediaItemId.id);
      case IsterMediaTypes.podcastEpisode:
        // Composite id: "podcastId~episodeId".
        final parts =
            mediaItemId.id.split(IsterMediaService.compositeIdSeparator);
        if (parts.length != 2) {
          LoggerService()
              .logger
              .e('playFromMediaId: malformed podcast episode id $mediaId');
          return;
        }
        final client = await IsterMediaService.getClient(mediaItemId.serverName);
        await startPlayQueueForPodcast(
            client, null, parts[0], parts[1], mediaItemId.serverName);
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

  /// Whether [item] can actually be opened by *this* user: it has an analyzed
  /// media file and the caller's library access allows streaming it (the
  /// per-viewer `accessible` flag — only ever false on someone else's queue).
  bool _itemIsPlayable(Fragment$fragmentPlayQueue$playQueueItems item) =>
      _itemHasMediaFile(item) && item.accessible;

  /// Index of the first queue item at or after [from] that has a playable media
  /// file, or -1 when none remain. Used to skip over not-yet-analyzed items
  /// (and, on a followed queue, items this user's libraries cannot stream).
  int _nextPlayableIndex(int from) {
    final q = queue.value;
    for (var i = from; i < q.length; i++) {
      final id = MediaItemId.byStringId(q[i].id).id;
      final item =
          playQueue?.playQueueItems?.where((e) => e.id == id).firstOrNull;
      if (item != null && _itemIsPlayable(item)) return i;
    }
    return -1;
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    // A user-initiated skip on a following device is a remote-control action:
    // everyone (including this device, via the command echo) executes it.
    if (_followMode && !_applyingRemoteSync) {
      final itemId = MediaItemId.byStringId(queue.value[index].id).id;
      await _sendFollowCommand(Enum$PlaybackCommandType.SKIP_TO_ITEM,
          playQueueItemId: itemId);
      return;
    }
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

      // On a followed queue an unplayable item (no file, or this user's
      // libraries can't stream it) must not skip ahead — the leader owns the
      // position. Track the index, explain why it's silent, and wait.
      if (_followMode && !_itemIsPlayable(queueItem)) {
        _announceFollowItemUnavailable(mediaItemId.id);
        return;
      }

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

      // Defensive: `accessible` is only ever false on someone else's queue,
      // but should an own-queue item turn inaccessible, skip past it like a
      // file-less item rather than open a stream that will 404.
      if (!queueItem.accessible) {
        showAppSnackBar(IsterMediaService.loc
            .followTrackNotAvailable(queue.value[index].title));
        final nextPlayable = _nextPlayableIndex(index + 1);
        if (nextPlayable != -1) await skipToQueueItem(nextPlayable);
        return;
      }

      // Whether the item being replaced was on a video surface — decided
      // before _currentMediaType is overwritten below, for the follow-mode
      // navigation at the end of this method.
      final wasVideo = _currentMediaType == IsterMediaTypes.movie ||
          _currentMediaType == IsterMediaTypes.episode;

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
        // Optimistic: the server still has the previous item as current until
        // the sync below lands, so subscribers that refetch must skip this one.
        PlayQueueService().playQueueChanged(playQueue!, optimistic: true);
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

      // A leader-driven switch (never a heartbeat — same-item emissions don't
      // reach this method) keeps the follower's screen on the right surface:
      // video items get their page opened, and leaving video for audio brings
      // up the music overlay. Track→track stays as it always was.
      if (_followMode && _applyingRemoteSync) {
        if (queueItem.movie != null || queueItem.episode != null) {
          openVideoPageRequest.value++;
        } else if (wasVideo) {
          openMusicPlayerRequest.value++;
        }
      }

      _onPlayingChanged(true);
      final track = queueItem.track;
      if (track != null) {
        _rememberLastPlayed(mediaItemId.serverName, track.album.id, track.id);
      }
      _rememberLastMusicQueue();

      // A follower never reports to updatePlayQueue — the leading device is
      // the only progress writer for this queue.
      if (_followMode) return;

      // Sync the new current item to the server. The local state above is
      // already final; the response only refreshes progress data, and is
      // dropped when another skip happened in the meantime.
      final playQueueObject = await _sendProgressUpdate(
        ClientManager.getClientForUrl(mediaItemId.serverName).value,
        playQueue!.id,
        mediaItemId.id,
        Duration.zero,
      );
      if (playQueueObject != null &&
          generation == _syncGeneration &&
          _applyServerPlayQueue(playQueueObject)) {
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

  /// Appends all tracks of [albumId] to the end of the active queue in one
  /// server call. Same server rule as [addToQueue]; returns whether the album
  /// was added.
  Future<bool> addAlbumToQueue(String srv, String albumId) async {
    final pq = playQueue;
    final activeServer = serverName;
    if (pq == null || activeServer == null || activeServer != srv) return false;

    final client = ClientManager.getClientForUrl(srv).value;
    _lastLocalQueueEdit = DateTime.now();
    final updated =
        await _playQueueService.addPlayQueueAlbum(client, pq.id, albumId);
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

  /// Builds the [MediaItem] list for [pq] in playback order. What each item
  /// looks like is [QueueItemDisplay]'s job — shared with the remote control,
  /// which renders the same queues without playing them.
  List<MediaItem> _buildQueueItems(Fragment$fragmentPlayQueue pq, String srv) {
    final token = StreamTokenService.getToken(srv);
    return PlayQueueService.sortedItems(pq).map((e) {
      final display = QueueItemDisplay.of(e, token: token);
      return MediaItem(
        id: MediaItemId(srv, display.mediaType, e.id).toString(),
        title: display.title,
        artist: display.artist,
        album: display.album,
        duration: display.duration,
        artUri: display.artUrl == null ? null : Uri.tryParse(display.artUrl!),
        // Book covers are portrait — flag it so the player shows the cover in
        // its true 2:3 aspect ratio instead of cropping it square.
        extras: display.portraitArtwork ? const {'portraitArtwork': true} : null,
      );
    }).toList();
  }

  final BehaviorSubject<List<MediaItem>> _recentSubject =
      BehaviorSubject.seeded(<MediaItem>[]);

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    LoggerService().logger.d('getChildren: $parentMediaId');
    // A browse request means a car (or other browser) just connected: kick
    // off the last-queue restore in the background — deliberately not
    // awaited, browse answers must return fast. Once it lands, the media
    // session publishes the paused track and the Android Auto home card
    // flips from "tap to open" to the resumable last track.
    unawaited(_restoreLastMusicQueueOnce());
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

  /// Root of the Android Auto browse tree: an Albums tab (the albums view of
  /// the remembered music library — no Albums/Artists picker in between) and
  /// a tab to switch libraries. Falls back to the library picker when no
  /// default could be resolved.
  Future<List<MediaItem>> _getRootChildren() async {
    final service = IsterMediaService();
    final defaultLibrary = await _resolveDefaultLibrary(service);
    if (defaultLibrary == null) {
      return (await service.getBrowsableLibraries())
          .map((e) => e.mediaItem)
          .toList();
    }
    return [
      MediaItem(
        id: MediaItemId(defaultLibrary.serverName, IsterMediaTypes.list,
                "albums:${defaultLibrary.libraryId}")
            .toString(),
        title: IsterMediaService.loc.albums,
        playable: false,
      ),
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

  /// The Android Auto "recent" tile. Prefers the current track of the last
  /// music play queue (the same one the in-app restore uses) — metadata only,
  /// so the browse answer stays fast: the queue itself is restored when the
  /// tile is tapped ([playFromMediaId]), resuming at the recorded position.
  /// Falls back to rebuilding an album queue from the persisted last-played
  /// track when no queue is stored.
  Future<List<MediaItem>> _getRecentChildren() async {
    if (_recentSubject.value.isNotEmpty) return _recentSubject.value;
    // A live (or already restored) session: the tile mirrors it.
    final current = mediaItem.valueOrNull;
    if (playQueue != null && current != null) {
      final children = [current];
      _recentSubject.add(children);
      return children;
    }
    final tile = await _lastMusicQueueTile();
    if (tile != null) {
      final children = [tile];
      _recentSubject.add(children);
      return children;
    }
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

  /// The current track of the stored last music queue as a browse item.
  /// Nothing is loaded into the player here; the returned item's id matches
  /// what [restoreLastMusicQueue] will publish, so a tap on it can restore
  /// and resume. Null (→ fallbacks) when there is no stored queue or the
  /// server cannot deliver it quickly.
  Future<MediaItem?> _lastMusicQueueTile() async {
    final last = await LastMusicQueuePreferences.get();
    if (last == null) return null;
    try {
      if (!ClientManager.usesTestClients) {
        await LoginManager.waitForToken(last.serverName)
            .timeout(IsterMediaService.perServerTimeout);
        await StreamTokenService.ensureToken(last.serverName);
      }
      final client = ClientManager.getClientForUrl(last.serverName).value;
      final pq = await _playQueueService.getPlayQueue(client, last.playQueueId);
      if (pq == null) return null;
      final currentId = pq.currentItemId ??
          PlayQueueService.sortedItems(pq).firstOrNull?.id;
      if (currentId == null) return null;
      final id =
          MediaItemId(last.serverName, IsterMediaTypes.track, currentId)
              .toString();
      return _buildQueueItems(pq, last.serverName)
          .where((m) => m.id == id)
          .firstOrNull;
    } catch (e) {
      LoggerService().logger.w('recent tile from last music queue failed: $e');
      return null;
    }
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
      // An empty query means "play something" — resume the loaded (or
      // restored) last music queue at its recorded position, falling back to
      // restarting the last played track.
      if (query.trim().isEmpty) {
        if (await _restoreLastMusicQueueOnce()) {
          await play();
          return;
        }
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
    // Nothing loaded (after endPlaybackLocally): publish an idle, control-less
    // state so audio_service drops the notification instead of leaving a dead
    // one behind.
    if (playQueue == null && mediaItem.valueOrNull == null) {
      playbackState.add(playbackState.value.copyWith(
        controls: const [],
        systemActions: const {},
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
        queueIndex: null,
      ));
      return;
    }
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

  /// mpv reports network/manifest failures (a 404'd HLS playlist, a denied
  /// stream) only through its error stream — `open()` resolves normally. An
  /// error during the load window (after open, before the stream ever
  /// advanced) marks the load as failing so the stall watchdog fails fast
  /// (~3s, 1 retry) instead of sitting through its full 12s×5 regime.
  void _listenToErrors() {
    _player.stream.error.listen((message) {
      final openedAt = _mediaOpenedAt;
      if (!_intendsToPlay || openedAt == null) return;
      final openPosition = Duration(milliseconds: _streamOpenPositionMs);
      final advanced =
          _player.state.position - openPosition > const Duration(seconds: 1);
      if (!advanced) {
        _loadErrorSeen = true;
        LoggerService()
            .logger
            .w('[LOADSTALL] player error during load window: $message');
      }
    });
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
    final send = _progressChain.then((_) async {
      // Tight-sync anchor: sample the position and server clock at the moment
      // the request actually goes out. The device's own output latency is
      // subtracted so the anchor describes what listeners *hear*, not what the
      // decoder reports. Omitted (nulls) until the clock has been measured;
      // followers then fall back to the coarse sync.
      final anchor = _timelineAnchor();
      return _playQueueService.updateProgress(
          client, playQueueId, playQueueItemId, position,
          streamSettings: await _currentStreamSettings(),
          playState: playState ??
              (_player.state.playing
                  ? Enum$PlayState.PLAYING
                  : Enum$PlayState.PAUSED),
          deviceId: await DevicePreferences.getDeviceId(),
          anchorPositionMs: anchor?.positionMs,
          anchorServerTimeMs: anchor?.serverTimeMs,
          repeatMode: repeatModeToApi(_repeatMode));
    });
    _progressChain = send.then((_) {}, onError: (_) {});
    return send;
  }

  /// The tight-sync anchor for the currently playing stream, or null when the
  /// server clock hasn't been measured (yet) or nothing is open.
  ({int positionMs, double serverTimeMs})? _timelineAnchor() {
    final srv = serverName;
    if (srv == null || _currentMediaUrl == null) return null;
    final serverNow = ClockSyncService.instance.serverNowMs(srv);
    if (serverNow == null) return null;
    final positionMs = _player.state.position.inMilliseconds -
        SyncPreferences.outputLatencyMs.value;
    return (positionMs: positionMs < 0 ? 0 : positionMs, serverTimeMs: serverNow);
  }

  /// Replaces [playQueue] with a server response while keeping the locally
  /// tracked current item. Returns whether the response was applied — a
  /// response for a queue other than the active one is dropped.
  bool _applyServerPlayQueue(Fragment$fragmentPlayQueue response) {
    final merged = mergeServerPlayQueue(playQueue, response);
    if (merged == null) return false;
    playQueue = merged;
    return true;
  }

  /// Merges a server play-queue [response] into [current], keeping the locally
  /// tracked current item — the client is authoritative for what is playing;
  /// a response can still carry a stale currentItemId (e.g. a progress update
  /// for the previous track processed server-side around a skip).
  ///
  /// Returns null when [response] belongs to a different queue than [current]:
  /// the generation counter alone can't catch this, because starting a new
  /// queue bumps the generation *before* the createPlayQueue round-trip — a
  /// progress update for the old queue sent during that window carries the new
  /// generation, and its late response would otherwise reinstate the old queue.
  static Fragment$fragmentPlayQueue? mergeServerPlayQueue(
    Fragment$fragmentPlayQueue? current,
    Fragment$fragmentPlayQueue response,
  ) {
    if (current == null || response.id != current.id) return null;
    final localCurrentItemId = current.currentItemId;
    return localCurrentItemId != null
        ? response.copyWith(currentItemId: localCurrentItemId)
        : response;
  }

  /// Syncs the playback position of the current item to the server. Throttled
  /// to ~10s of position delta unless [force] is set (pause/stop flush the
  /// final position so resume points don't lag behind).
  Future<void> _syncProgress(Duration pos,
      {bool force = false, Enum$PlayState? playState}) async {
    // A following device never reports progress: updatePlayQueue is
    // owner-only, and two reporters on one queue would fight over the
    // session. The server writes this user's watch status instead.
    if (_followMode) return;
    // No stream is open — a queue switch is in flight (see
    // _silenceForQueueSwitch) or nothing was ever opened. Any position event
    // arriving now belongs to the silenced previous stream; syncing it would
    // overwrite that item's progress with a bogus position.
    if (_currentMediaUrl == null) return;
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
    // request was in flight — a slow response must not revert a skip or
    // reinstate a queue that was replaced in the meantime.
    if (playQueueObject != null && generation == _syncGeneration) {
      final before = playQueue?.playQueueItems?.length ?? 0;
      if (!_applyServerPlayQueue(playQueueObject)) return;
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
    // Every start/resume path funnels through here (track auto-advance does
    // not), so this is where the automatic sleep timer gets a chance to arm.
    unawaited(SleepTimerService.instance.notifyPlaybackStarted());
    // A follower has its own heartbeat (followPlayQueue); the session
    // heartbeat below would try to report progress it must not send.
    if (_followMode) return;
    // Arm the tight-sync anchor: once the server clock is measured (and the
    // output-latency preference loaded), every progress update carries one.
    final srv = serverName;
    if (srv != null && !ClientManager.usesTestClients) {
      unawaited(SyncPreferences.ensureLoaded());
      unawaited(ClockSyncService.instance.ensureSynced(srv));
    }
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
    // Not a transport command: the session owner removed one following device.
    // Everyone on the queue receives it, so it is matched on the install id.
    if (command.command == Enum$PlaybackCommandType.STOP_FOLLOW) {
      await _onRemovedByOwner(command.targetDeviceId);
      return;
    }
    _showRemoteCommandToast(command.command);
    // In follow mode the bus is the transport: commands (including this
    // device's own echoes) must run the local paths, not be re-sent.
    final wasApplying = _applyingRemoteSync;
    if (_followMode) _applyingRemoteSync = true;
    try {
      await _executeRemoteCommand(command);
    } finally {
      _applyingRemoteSync = wasApplying;
    }
  }

  Future<void> _executeRemoteCommand(
      Subscription$playbackCommands$playbackCommands command) async {
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
      case Enum$PlaybackCommandType.SET_REPEAT:
        final mode = command.repeatMode;
        if (mode != null) await setRepeatMode(repeatModeFromApi(mode));
      // Handled before this switch; the owner's kick is not a transport command.
      case Enum$PlaybackCommandType.STOP_FOLLOW:
      case Enum$PlaybackCommandType.$unknown:
        break;
    }
  }

  /// The session owner kicked a device off their session. Only the addressed
  /// device reacts, and only while it is actually following: leave follow mode
  /// without telling the server (it already dropped the registration).
  Future<void> _onRemovedByOwner(String? targetDeviceId) async {
    if (!_followMode || targetDeviceId == null) return;
    if (targetDeviceId != await DevicePreferences.getDeviceId()) return;
    showAppSnackBar(IsterMediaService.loc.followerRemovedByOwner);
    await stopFollowing(notifyServer: false, teardown: true);
  }

  /// Tells the user on this client that someone took the controls. Suppressed
  /// for the QUEUE_CHANGED echo of the client's own queue edits — those fan
  /// out over the same subscription and would toast on every local action.
  void _showRemoteCommandToast(Enum$PlaybackCommandType command) {
    // On a following device the command bus is the normal transport — every
    // play/pause/skip would toast. Only queue edits stay worth announcing.
    if (_followMode && command != Enum$PlaybackCommandType.QUEUE_CHANGED) {
      return;
    }
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
      case Enum$PlaybackCommandType.SET_REPEAT:
      case Enum$PlaybackCommandType.STOP_FOLLOW:
      case Enum$PlaybackCommandType.$unknown:
        message = null;
    }
    if (message != null) showAppSnackBar(message);
  }

  // ── Follow mode ("listen along") ─────────────────────────────────────────

  /// True while this device follows another device's session: it plays the
  /// same queue, executes the command bus like the playing device, and stays
  /// completely silent towards updatePlayQueue — the session owner's device is
  /// the only progress reporter, and the server writes this user's watch
  /// status server-side.
  bool get followMode => _followMode;
  bool _followMode = false;

  /// UI hook for the "listening along" indicator.
  final ValueNotifier<bool> followModeNotifier = ValueNotifier(false);

  /// True when [playQueueId] on [srv] is this device's *own* live playback
  /// rather than a queue it merely follows. Listening along with yourself is
  /// a no-op (and would tear down the very session it joins), so the UI hides
  /// the listen-along affordances for such a session.
  bool isOwnLiveQueue(String srv, String playQueueId) =>
      !_followMode && serverName == srv && playQueue?.id == playQueueId;

  Timer? _followHeartbeat;
  ResilientSubscription? _followNowPlayingSubscription;
  // Tight sync ("same room"): the leader's latest timeline anchor and the
  // 500ms discipline loop steering this device towards it with setRate.
  Timer? _followSyncTimer;
  ({
    int positionMs,
    double serverTimeMs,
    Enum$PlayState playState,
    String? itemId
  })? _followAnchor;
  double _followAppliedRate = 1.0;
  // Serializes application of nowPlaying emissions; a next emission arrives
  // within seconds, so a dropped one is never missed for long.
  bool _followSyncBusy = false;
  // Set while a bus command or nowPlaying state is being applied locally: the
  // transport overrides then run their normal local path instead of sending
  // a command (which would echo forever).
  bool _applyingRemoteSync = false;

  /// Starts following [playQueueId]'s live session on [srv]. Returns the
  /// server's decision: only [Enum$FollowResult.OK] means playback started;
  /// NOT_FOUND / NO_LIBRARY_ACCESS are for the caller to explain to the user.
  Future<Enum$FollowResult> startFollowingQueue(
      String srv, String playQueueId) async {
    final client = ClientManager.getClientForUrl(srv).value;
    // A stale/expired stream token would 4xx every media URL below.
    if (!ClientManager.usesTestClients) {
      await StreamTokenService.ensureToken(srv);
    }
    final deviceId = await DevicePreferences.getDeviceId();
    final result = await _playQueueService.followPlayQueue(
        client, playQueueId, deviceId, true);
    if (result != Enum$FollowResult.OK) {
      return result ?? Enum$FollowResult.NOT_FOUND;
    }

    final pq = await _playQueueService.getPlayQueue(client, playQueueId);
    if (pq == null) {
      unawaited(_playQueueService.followPlayQueue(
          client, playQueueId, deviceId, false));
      return Enum$FollowResult.NOT_FOUND;
    }

    // Tear down a previous follow first. Deregister its queue unless it is the
    // same one — the registration above just re-armed that.
    await stopFollowing(notifyServer: playQueue?.id != playQueueId);
    await _silenceForQueueSwitch();
    _followMode = true;
    followModeNotifier.value = true;
    _intendsToPlay = true;
    _loadRetries = 0;
    serverName = srv;
    graphQLClient = client;

    final items = PlayQueueService.sortedItems(pq);
    final current =
        PlayQueueService.getCurrentPlayQueueItem(pq) ?? items.firstOrNull;
    playQueue = pq.currentItemId == null && current != null
        ? pq.copyWith(currentItemId: current.id)
        : pq;
    currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

    queueTitle.add("Now Playing");
    queue.add(_buildQueueItems(playQueue!, srv));
    _ensureCommandSubscription();
    _startFollowHeartbeat(deviceId);
    _ensureFollowNowPlayingSubscription();
    unawaited(SyncPreferences.ensureLoaded());
    if (!ClientManager.usesTestClients) {
      unawaited(ClockSyncService.instance.ensureSynced(srv));
      _followSyncTimer?.cancel();
      _followSyncTimer = Timer.periodic(
          const Duration(milliseconds: 500), (_) => unawaited(_followSyncTick()));
    }

    if (current != null && current.track != null) {
      // Music opens the full player, like every other music start path.
      _beginMediaLoading();
      openMusicPlayerRequest.value++;
    }
    if (current != null &&
        (current.movie != null || current.episode != null) &&
        _itemIsPlayable(current)) {
      // Watching along needs the video's page on screen, or the follower
      // would only hear the movie's audio.
      openVideoPageRequest.value++;
    }
    if (current != null) {
      if (!_itemIsPlayable(current)) {
        _announceFollowItemUnavailable(current.id);
      } else {
        await _openQueueItem(current, srv,
            startTimeMs: pq.progressInMilliseconds);
      }
    }
    updatePlaybackState();
    return Enum$FollowResult.OK;
  }

  /// Leaves follow mode: tears down the follow subscriptions/heartbeat,
  /// deregisters at the server and silences playback. Safe to call twice.
  ///
  /// [teardown] additionally ends playback on this device altogether (see
  /// [endPlaybackLocally]) — for the paths where the shared media is *gone*
  /// (the leader stopped, the owner kicked us, the user left the session)
  /// rather than the ones that immediately start something else here.
  Future<void> stopFollowing(
      {bool notifyServer = true, bool teardown = false}) async {
    if (!_followMode) {
      // A teardown request still applies when we were never following (or a
      // concurrent path already left follow mode).
      if (teardown) await endPlaybackLocally(flushProgress: false);
      return;
    }
    _followMode = false;
    followModeNotifier.value = false;
    _intendsToPlay = false;
    _followHeartbeat?.cancel();
    _followHeartbeat = null;
    _followSyncTimer?.cancel();
    _followSyncTimer = null;
    _followAnchor = null;
    await _resetFollowRate();
    _followNowPlayingSubscription?.dispose();
    _followNowPlayingSubscription = null;
    _stopCommandSubscription();
    final client = graphQLClient;
    final pq = playQueue;
    if (notifyServer && client != null && pq != null) {
      final deviceId = await DevicePreferences.getDeviceId();
      unawaited(
          _playQueueService.followPlayQueue(client, pq.id, deviceId, false));
    }
    if (!ClientManager.usesTestClients) await _player.pause();
    updatePlaybackState();
    // endPlaybackLocally calls stopFollowing itself; follow mode is already
    // off by now, so this recurses exactly one level and stops there.
    // No progress flush: a follower is never the progress writer for the
    // shared queue, and follow mode is already off so the usual guard in
    // _syncProgress no longer holds it back.
    if (teardown) await endPlaybackLocally(flushProgress: false);
  }

  /// The follow registration doubles as a heartbeat (~20s; the server expires
  /// it after 60s). A NOT_FOUND answer means the followed session ended while
  /// we were listening — leave follow mode with a toast. A null answer is a
  /// transient network failure: keep going, the next tick retries.
  void _startFollowHeartbeat(String deviceId) {
    _followHeartbeat?.cancel();
    _followHeartbeat = Timer.periodic(const Duration(seconds: 20), (_) async {
      final client = graphQLClient;
      final pq = playQueue;
      if (!_followMode || client == null || pq == null) return;
      final result = await _playQueueService.followPlayQueue(
          client, pq.id, deviceId, true);
      if (_followMode && result == Enum$FollowResult.NOT_FOUND) {
        showAppSnackBar(IsterMediaService.loc.followLeaderStopped);
        await stopFollowing(notifyServer: false, teardown: true);
      }
    });
  }

  /// One tick of the tight-sync discipline loop (every 500ms while following):
  /// extrapolates the leader's position from its anchor and the shared server
  /// clock, then applies [decideFollowSync] — seek for large errors, a ≤2%
  /// rate nudge for moderate ones, rate 1.0 once locked. Falls back to doing
  /// nothing (and a neutral rate) whenever tight sync is off, the anchor is
  /// missing/stale, the items differ, or either side is paused.
  Future<void> _followSyncTick() async {
    if (!_followMode || ClientManager.usesTestClients) return;
    final srv = serverName;
    final anchor = _followAnchor;
    if (srv == null) return;
    if (!SyncPreferences.tightSyncEnabled.value || anchor == null) {
      await _resetFollowRate();
      return;
    }
    // Keeps the offset fresh; a no-op within its refresh interval.
    unawaited(ClockSyncService.instance.ensureSynced(srv));
    final sameItem =
        anchor.itemId != null && anchor.itemId == currentPlayQueueItem?.id;
    if (!sameItem ||
        anchor.playState != Enum$PlayState.PLAYING ||
        !_player.state.playing ||
        _player.state.duration <= Duration.zero) {
      await _resetFollowRate();
      return;
    }
    final serverNow = ClockSyncService.instance.serverNowMs(srv);
    if (serverNow == null) return;
    final targetMs = anchor.positionMs +
        (serverNow - anchor.serverTimeMs) +
        SyncPreferences.outputLatencyMs.value;
    final errorMs = _player.state.position.inMilliseconds - targetMs;
    final action =
        decideFollowSync(errorMs: errorMs, currentRate: _followAppliedRate);
    switch (action.type) {
      case FollowSyncActionType.seek:
        await _resetFollowRate();
        // Aim slightly past the target: the seek itself takes a beat, and on
        // HLS it lands on a segment boundary; the rate loop trims the rest.
        await _player.seek(Duration(milliseconds: targetMs.round() + 100));
      case FollowSyncActionType.rate:
        _followAppliedRate = action.rate;
        await _player.setRate(action.rate);
      case FollowSyncActionType.none:
        break;
    }
  }

  /// mpv's speed is a player-level property that survives stream loads, so a
  /// non-neutral rate must be reset explicitly whenever steering stops.
  Future<void> _resetFollowRate() async {
    if (_followAppliedRate == 1.0) return;
    _followAppliedRate = 1.0;
    if (!ClientManager.usesTestClients) await _player.setRate(1.0);
  }

  /// Follows the leading device through the now-playing fan-out: it is the
  /// source of truth for what the leader does *locally* (its play/pause/skip
  /// don't travel over the command bus). Item changes, play state and coarse
  /// position corrections all come from here; the command bus only provides
  /// lower latency when someone explicitly remote-controls the session.
  void _ensureFollowNowPlayingSubscription() {
    _followNowPlayingSubscription?.dispose();
    final client = graphQLClient;
    if (client == null) return;
    _followNowPlayingSubscription = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionnowPlaying,
      variables: const {},
      onData: (result) {
        final sessions =
            Subscription$nowPlaying.fromJson(result.data!).nowPlaying;
        unawaited(_onFollowNowPlaying(sessions));
      },
      // The sink replays the latest list on reconnect, so a dropped
      // subscription self-heals with fresh state.
      onFailure: (_) {},
    );
  }

  Future<void> _onFollowNowPlaying(
      List<Fragment$fragmentPlaybackSession> sessions) async {
    if (!_followMode || _followSyncBusy) return;
    final pqId = playQueue?.id;
    if (pqId == null) return;
    final session =
        sessions.where((s) => s.playQueueId == pqId).firstOrNull;
    if (session == null) {
      // The list is always complete: an emission without our session means
      // the leader stopped (or timed out server-side). The media is gone from
      // this device with it: tear playback down rather than leaving a paused
      // stream (and a mini player) behind.
      showAppSnackBar(IsterMediaService.loc.followLeaderStopped);
      await stopFollowing(notifyServer: false, teardown: true);
      return;
    }
    // Tight-sync anchor for the discipline loop; null when the leader doesn't
    // report one (older client, or its clock is not measured yet).
    final anchorPosition = session.anchorPositionMs;
    final anchorServerTime = session.anchorServerTimeMs;
    _followAnchor = anchorPosition != null && anchorServerTime != null
        ? (
            positionMs: anchorPosition,
            serverTimeMs: anchorServerTime,
            playState: session.playState,
            itemId: session.playQueueItemId,
          )
        : null;
    _followSyncBusy = true;
    _applyingRemoteSync = true;
    try {
      final itemId = session.playQueueItemId;
      if (itemId != null && itemId != currentPlayQueueItem?.id) {
        await _skipToItemId(itemId);
      }
      final leaderPlaying = session.playState == Enum$PlayState.PLAYING;
      if (!ClientManager.usesTestClients) {
        if (leaderPlaying && !_player.state.playing) {
          await play();
        } else if (!leaderPlaying && _player.state.playing) {
          await pause();
        }
      } else {
        _intendsToPlay = leaderPlaying;
      }
      // Coarse position correction, only within the same item and once the
      // stream is actually loaded. The leader reports every ~10s; small skews
      // are left alone (an HLS seek is more disruptive than a 2s offset).
      // With tight sync active and an anchor available the discipline loop
      // owns the position — the coarse seek would fight its rate steering.
      final tightSyncActive =
          SyncPreferences.tightSyncEnabled.value && _followAnchor != null;
      if (!tightSyncActive &&
          itemId != null &&
          itemId == currentPlayQueueItem?.id &&
          !ClientManager.usesTestClients &&
          _player.state.duration > Duration.zero) {
        final leaderPos =
            Duration(milliseconds: session.progressInMilliseconds);
        if ((_player.state.position - leaderPos).abs() >
            const Duration(seconds: 3)) {
          await seek(leaderPos);
        }
      }
    } finally {
      _applyingRemoteSync = false;
      _followSyncBusy = false;
    }
  }

  /// Test seam: applies a now-playing emission as if it arrived over the
  /// follow subscription (the real one needs a live websocket).
  @visibleForTesting
  Future<void> debugApplyFollowNowPlaying(
          List<Fragment$fragmentPlaybackSession> sessions) =>
      _onFollowNowPlaying(sessions);

  /// Test seam: the tight-sync anchor as last stored from a now-playing
  /// emission.
  @visibleForTesting
  ({
    int positionMs,
    double serverTimeMs,
    Enum$PlayState playState,
    String? itemId
  })? get debugFollowAnchor => _followAnchor;

  /// A followed item this user's library access cannot stream: keep the queue
  /// index in step with the leader but stay silent until the leader moves on.
  /// Skipping ahead ourselves would desynchronize (we don't own the session).
  void _announceFollowItemUnavailable(String playQueueItemId) {
    final mediaItemIndex = queue.value.indexWhere(
        (m) => MediaItemId.byStringId(m.id).id == playQueueItemId);
    final title = mediaItemIndex != -1 ? queue.value[mediaItemIndex].title : '';
    showAppSnackBar(IsterMediaService.loc.followTrackNotAvailable(title));
    playQueue = playQueue?.copyWith(currentItemId: playQueueItemId);
    currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);
    if (mediaItemIndex != -1) {
      mediaItem.add(queue.value[mediaItemIndex]);
      playbackState
          .add(playbackState.value.copyWith(queueIndex: mediaItemIndex));
    }
    if (playQueue != null) PlayQueueService().playQueueChanged(playQueue!);
    unawaited(_silenceForQueueSwitch());
  }

  /// Sends a transport action as a remote-control command instead of acting
  /// locally — in follow mode every participant (including this device, via
  /// the command echo) executes the command, which keeps everyone in step.
  Future<void> _sendFollowCommand(Enum$PlaybackCommandType command,
      {Duration? position, String? playQueueItemId}) async {
    final client = graphQLClient;
    final pq = playQueue;
    if (client == null || pq == null) return;
    await _playQueueService.sendPlaybackCommand(client, pq.id, command,
        position: position, playQueueItemId: playQueueItemId);
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
    if (!_applyServerPlayQueue(fresh)) return;
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
    // Give a normal background load plenty of time before intervening — but
    // fail fast when mpv already reported a load error (e.g. a 404/denied
    // stream): those never recover, only the retry-then-skip path helps.
    final stallThreshold = _loadErrorSeen
        ? const Duration(seconds: 3)
        : const Duration(seconds: 12);
    if (DateTime.now().difference(openedAt) < stallThreshold) {
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
    // instead of buffering forever. A hard player error needs only one retry.
    final maxRetries = _loadErrorSeen ? 1 : 5;
    if (_loadRetries >= maxRetries) {
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
      // A follower may not skip the shared queue; go silent on this item and
      // wait for the leader to move on (a 404 here usually means this user's
      // library access was revoked mid-queue).
      if (_followMode) {
        final itemId = currentPlayQueueItem?.id;
        if (itemId != null) _announceFollowItemUnavailable(itemId);
        return;
      }
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
    // A follower never advances on its own; the leader's item change arrives
    // over the now-playing fan-out.
    if (_followMode) return;
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
    _advanceAfterItemEnd();
  }

  void _listenToCompletion() {
    _player.stream.completed.listen((completed) {
      // A follower's track ending slightly early must not skip the shared
      // queue ahead — wait for the leader's item change instead.
      if (_followMode) return;
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
        _advanceAfterItemEnd();
      }
    });
  }

  /// Auto-advance at the end of an item, unless an item-counting sleep timer
  /// just ran out — it stops playback itself, so nothing must follow.
  void _advanceAfterItemEnd() {
    if (SleepTimerService.instance.notifyItemFinished()) return;
    if (_repeatMode == AudioServiceRepeatMode.one) {
      _repeatCurrent();
    } else {
      skipToNext();
    }
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
  // Set by the player error stream while the current load never advanced;
  // switches the load watchdog to its fast-fail regime (3s, 1 retry).
  bool _loadErrorSeen = false;

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
