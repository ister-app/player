// What a playback collaborator may see of MediaPlayerHandler.
//
// The handler owns all shared playback state (tests set it directly); the
// collaborators under lib/utils/playback/ get this narrow view of it instead
// of the handler itself, so every dependency between them is named here and
// grep-able. Grow it per collaborator; a collaborator that needs a large
// slice of it is cut at the wrong seam.
import 'package:audio_service/audio_service.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
import 'package:player/utils/PlayQueueService.dart';

abstract class PlaybackCore {
  /// The loaded play queue, or null while nothing is loaded.
  Fragment$fragmentPlayQueue? get playQueue;

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
