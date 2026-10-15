// What a playback collaborator may see of MediaPlayerHandler.
//
// The handler owns all shared playback state (tests set it directly); the
// collaborators under lib/utils/playback/ get this narrow view of it instead
// of the handler itself, so every dependency between them is named here and
// grep-able. Grow it per collaborator; a collaborator that needs a large
// slice of it is cut at the wrong seam.
import 'dart:ui' show Rect;

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/graphql/fragmentMovie.graphql.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:player/utils/subtitles/BitmapSubtitles.dart';

abstract class PlaybackCore {
  /// The one media_kit player. Not real under test ([playerIsMocked]).
  Player get player;

  /// The loaded play queue, or null while nothing is loaded. Collaborators
  /// may replace it with a merged server response.
  Fragment$fragmentPlayQueue? get playQueue;
  set playQueue(Fragment$fragmentPlayQueue? value);

  Fragment$fragmentPlayQueue$playQueueItems? get currentPlayQueueItem;

  /// The server the loaded queue belongs to, and its client.
  String? get serverName;
  GraphQLClient? get graphQLClient;

  /// The typed current item, by kind; chapters and podcast episodes set none
  /// of these (only [currentPlayQueueItem]).
  Fragment$fragmentEpisode? get episode;
  Fragment$fragmentMovie? get movie;
  String? get currentTrackId;
  Fragment$fragmentMediaFiles? get currentMediaFile;

  /// The stream url mpv has open, or null between items (a queue switch in
  /// flight, or nothing opened yet).
  String? get currentMediaUrl;

  /// A downloaded queue (`local:` id): no client, progress goes offline.
  bool get isLocalQueue;

  /// The repeat mode as the server API spells it.
  Enum$RepeatMode get repeatModeApi;

  /// Where the current item ends in its file's timeline (a slice of a
  /// multi-episode file ends at its part boundary).
  int currentItemEndMs(Fragment$fragmentEpisode? ep);

  /// Keeps the remote-control command subscription on the active queue.
  void ensureCommandSubscription();

  /// Re-fetches the active queue from the server and adopts it.
  Future<void> reloadPlayQueueFromServer();

  /// Bumped on every stream open; an async step that outlives its open
  /// compares against it and bails out.
  int get openGeneration;

  /// The video file that is open (null for audio), and its stream rows.
  Fragment$fragmentMediaFiles? get currentVideoFile;
  List<Fragment$fragmentMediaFiles$mediaFileStreams?> get currentVideoFileStreams;

  /// Bitmap (PGS/VobSub) subtitle tracks of the open video the overlay can
  /// draw, the one it draws, and the selection that turns mpv's own off.
  List<BitmapSubtitleTrack> get currentBitmapSubtitleTracks;
  ValueNotifier<BitmapSubtitleTrack?> get bitmapSubtitle;
  Future<void> selectBitmapSubtitle(BitmapSubtitleTrack track);

  /// The crop applied to the open video, as fractions of the frame.
  ValueNotifier<Rect?> get appliedVideoCrop;

  /// The published current item (audio_service's mediaItem), or null.
  MediaItem? get currentMediaItem;

  /// Following someone else's session: this device reports nothing and
  /// skips nothing on its own.
  bool get followMode;

  /// True under `flutter test`: the mpv player and the audio session are not
  /// real, so collaborators skip calls that would touch them.
  bool get playerIsMocked;

  PlayQueueService get playQueueService;

  /// Restores the last music queue once per process; true when a queue is
  /// loaded afterwards.
  Future<bool> restoreLastMusicQueueOnce();

  Future<void> play();
  Future<void> playTrackById(MediaItemId mediaItemId);
  Future<void> playAlbumById(MediaItemId mediaItemId);
}
