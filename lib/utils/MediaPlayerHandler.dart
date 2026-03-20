import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguagePreferences.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:rxdart/rxdart.dart';

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

    _playQueueService = PlayQueueService();

    // Set up listeners once – they survive for the lifetime of the singleton
    if (!_listenersAdded) {
      _player.stream.playing.listen(_onPlayingChanged);
      _listenToBuffering();
      _listenToTracks();
      _listenToPosition();
      _listenToCompletion();
      _listenToSession();
      _listenersAdded = true;
    }
  }

  static final MediaPlayerHandler _instance = MediaPlayerHandler._internal();

  static MediaPlayerHandler get instance => _instance;

  // ── Core objects ─────────────────────────────────────────────────────
  late final Player _player;
  late final VideoController _videoController;
  late final PlayQueueService _playQueueService;

  Player get player => _player;

  VideoController get videoController => _videoController;

  // ── State ───────────────────────────────────────────────────────────
  Fragment$fragmentEpisode? episode;
  Fragment$fragmentMovie? movie;
  bool _isMovie = false;
  Fragment$fragmentPlayQueue$playQueueItems? currentPlayQueueItem;
  Fragment$fragmentPlayQueue? playQueue;
  String? serverName;
  GraphQLClient? graphQLClient;

  // ── Public API used by the widget ─────────────────────────────────────
  Future<void> startPlayQueue(
    GraphQLClient client,
    String? playQueueId,
    Fragment$fragmentEpisode newEpisode,
    String newServerName,
  ) async {
    final shouldRefresh = episode == null ||
        episode!.id != newEpisode.id ||
        serverName != newServerName;

    episode = newEpisode;
    movie = null;
    _isMovie = false;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
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
                  episode!.images,
                  ImageTypes.background,
                );
                imgUri = imageByType != null
                    ? Uri.tryParse(ImageUtil.buildUrl(imageByType) ?? '')
                    : null;
              }

              return MediaItem(
                id: MediaItemId(newServerName, IsterMediaTypes.episode, e.id).toString(),
                title: MetadataUtil.getTitle(e.episode?.metadata) ?? "unkown",
                artist: "ister",
                duration: Duration(
                    milliseconds:
                        e.episode?.mediaFile?.first.durationInMilliseconds ?? 0),
                artUri: imgUri,
                artHeaders: LoginManager.getHeaders(serverName ?? ""),
              );
            },
          ).toList() ??
          []);

      playQueue = playQueueObject;
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      await _openMedia(
        serverName: newServerName,
        mediaUrl: ImageUtil.buildMediaFileUrl(newEpisode.mediaFile!.first) ?? '',
        startTimeInMilliseconds: _startTimeMs,
      );
    }
    updatePlaybackState();
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
    final shouldRefresh = movie == null ||
        movie!.id != newMovie.id ||
        serverName != newServerName;

    movie = newMovie;
    episode = null;
    _isMovie = true;
    serverName = newServerName;
    graphQLClient = client;

    if (shouldRefresh) {
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
                newMovie.images,
                ImageTypes.background,
              );
              imgUri = imageByType != null
                  ? Uri.tryParse(ImageUtil.buildUrl(imageByType) ?? '')
                  : null;
            }
            return MediaItem(
              id: MediaItemId(newServerName, IsterMediaTypes.movie, e.id).toString(),
              title: e.movie?.name ?? newMovie.name,
              artist: "ister",
              duration: Duration(
                  milliseconds:
                      e.movie?.mediaFile?.first.durationInMilliseconds ?? 0),
              artUri: imgUri,
              artHeaders: LoginManager.getHeaders(serverName ?? ""),
            );
          }).toList() ??
          []);

      playQueue = playQueueObject;
      currentPlayQueueItem = PlayQueueService.getCurrentPlayQueueItem(playQueue);

      await _openMedia(
        serverName: newServerName,
        mediaUrl: ImageUtil.buildMediaFileUrl(newMovie.mediaFile!.first) ?? '',
        startTimeInMilliseconds: _movieStartTimeMs,
        isMovie: true,
      );
    }
    updatePlaybackState();
  }

  Future<void> _openMedia({
    required String serverName,
    required String mediaUrl,
    int? startTimeInMilliseconds,
    bool isMovie = false,
  }) async {
    print("openmedia: " + serverName + mediaUrl);
    final start = Duration(milliseconds: startTimeInMilliseconds ?? 0);
    final media = Media(
      mediaUrl,
      start: start,
      httpHeaders: LoginManager.getHeaders(serverName),
    );

    try {
      await _player.open(media);
      _playing = true;
      final currentItemId = playQueue?.currentItemId;
      if (currentItemId != null) {
        final mediaType = isMovie ? IsterMediaTypes.movie : IsterMediaTypes.episode;
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
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    final q = queue.value;
    final index = playbackState.value.queueIndex ?? -1;
    final next = index + 1;
    if (next < q.length) await skipToQueueItem(next);
  }

  @override
  Future<void> skipToPrevious() async {
    final q = queue.value;
    final index = playbackState.value.queueIndex ?? q.length;
    final prev = index - 1;
    if (prev >= 0) await skipToQueueItem(prev);
  }

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) async {
    print("playformuri " + uri.toString());
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    print("playMediaItem " + mediaItem.toString());
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    print("playFromMediaId: $mediaId");

    final mediaItemId = MediaItemId.byStringId(mediaId);

    // Check if the item is already in the current queue
    final currentQueue = queue.value;
    final index = currentQueue.indexWhere((e) => e.id == mediaId);
    if (index != -1) {
      print("zit in huidige playqueue mediaId: $mediaId");
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

    MediaItemId mediaItemId = MediaItemId.byStringId(queue.value[index].id);

    final newEpisodeList = playQueue?.playQueueItems
        ?.where((element) => element.id == mediaItemId.id)
        .toList();
    if (newEpisodeList != null && newEpisodeList.isNotEmpty) {
      episode = newEpisodeList.first.episode;
      await _openMedia(
        serverName: mediaItemId.serverName,
        mediaUrl: ImageUtil.buildMediaFileUrl(newEpisodeList.first.episode!.mediaFile!.first) ?? '',
        startTimeInMilliseconds: 0,
      );
      final playQueueObject = await _playQueueService.updateProgress(
        ClientManager.getClientForUrl(serverName!).value,
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
    print("getChildren: $parentMediaId");
    if (parentMediaId == AudioService.recentRootId) {
      return _recentSubject.value;
    } else if (parentMediaId == AudioService.browsableRootId) {
      return Future.value(List.of({
        MediaItem(
          id: MediaItemId(serverName ?? "media.droogers.cloud/api", IsterMediaTypes.list, "recent").toString(),
          title: "Recent",
          playable: false,
        ),
        MediaItem(id: MediaItemId(serverName ?? "media.droogers.cloud/api", IsterMediaTypes.list, "added").toString(), title: "Library", playable: false),
      }));
    }

    var itemsByParentId = await IsterMediaService().getItemsByParentId(parentMediaId);
    return itemsByParentId.map((e) => e.mediaItem).toList();
  }

  // ── Listener wiring ───────────────────────────────────────────────────
  Future<void> _onPlayingChanged(bool playing) async {
    final session = await AudioSession.instance;
    session.setActive(playing);
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
    final mediaType = _isMovie ? IsterMediaTypes.movie : IsterMediaTypes.episode;
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
      await _selectPreferredTrack<SubtitleTrack>(
        tracks.subtitle,
        LanguagePreferences.getSubtitleLanguages,
        (t) => _player.setSubtitleTrack(t),
      );
      await _selectPreferredTrack<AudioTrack>(
        tracks.audio,
        LanguagePreferences.getSpokenLanguages,
        (t) => _player.setAudioTrack(t),
      );
    });
  }

  void _listenToPosition() {
    _player.stream.position.listen((pos) async {
      // Throttle updates to ~10s to avoid spamming the server
      if (_lastProgress == null ||
          (pos - _lastProgress!).inMilliseconds.abs() > 10 * 1000) {
        _lastProgress = pos;

        final client = graphQLClient;
        if (playQueue != null && client != null) {
          String? itemId;
          if (episode != null) {
            itemId = _playQueueService.getPlayQueueItemId(playQueue!, episode!.id);
          } else if (movie != null) {
            itemId = _playQueueService.getMoviePlayQueueItemId(playQueue!, movie!.id);
          }
          if (itemId != null) {
            final playQueueObject = await _playQueueService.updateProgress(
              client,
              playQueue!.id,
              itemId,
              pos,
            );
            playQueueObject != null ? playQueue = playQueueObject : null;
          }
        }
      }
    });
  }

  void _listenToCompletion() {
    _player.stream.completed.listen((completed) {
      if (completed && playQueue != null) {
        _playing = false;
        skipToNext();
      }
    });
  }

  Future<void> _listenToSession() async {
    final session = await AudioSession.instance;
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          pause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
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
      if (_playing) pause();
    });
  }

  // ── Helper methods (track selection) ───────────────────────────────────
  Duration? _lastProgress;
  bool _listenersAdded = false;
  bool _playing = false;
  bool _interrupted = false;

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
