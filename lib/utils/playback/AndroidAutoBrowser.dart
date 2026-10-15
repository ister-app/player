// The Android Auto / media-browser side of playback: the browse tree, voice
// search and the "recent" tile. It never touches the player itself — it reads
// the current item and queue through [PlaybackCore] and asks it to play.
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/utils/AutoPreferences.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LastMusicQueuePreferences.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/PlayQueueService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:rxdart/rxdart.dart';

import 'PlaybackCore.dart';
import 'QueueMediaItems.dart';

class AndroidAutoBrowser {
  AndroidAutoBrowser(this.core);

  final PlaybackCore core;

  /// What the "recent" root shows: the playing item, or the resumable last
  /// track while nothing is loaded.
  final BehaviorSubject<List<MediaItem>> recent =
      BehaviorSubject.seeded(<MediaItem>[]);

/// Keeps the Android Auto "recent" tile and its persisted backup in sync
/// with what is playing.
void rememberLastPlayed(String serverName, String albumId, String trackId) {
  if (core.followMode) return;
  unawaited(AutoPreferences.setLastPlayed(serverName, albumId, trackId));
  final nowPlaying = core.currentMediaItem;
  if (nowPlaying != null) {
    recent.add([nowPlaying]);
  }
}



Future<List<MediaItem>> getChildren(String parentMediaId,
    [Map<String, dynamic>? options]) async {
  LoggerService().logger.d('getChildren: $parentMediaId');
  // A browse request means a car (or other browser) just connected: kick
  // off the last-queue restore in the background — deliberately not
  // awaited, browse answers must return fast. Once it lands, the media
  // session publishes the paused track and the Android Auto home card
  // flips from "tap to open" to the resumable last track.
  unawaited(core.restoreLastMusicQueueOnce());
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
  if (recent.value.isNotEmpty) return recent.value;
  // A live (or already restored) session: the tile mirrors it.
  final current = core.currentMediaItem;
  if (core.playQueue != null && current != null) {
    final children = [current];
    recent.add(children);
    return children;
  }
  final tile = await _lastMusicQueueTile();
  if (tile != null) {
    final children = [tile];
    recent.add(children);
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
  recent.add(children);
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
    if (!core.playerIsMocked) {
      await LoginManager.waitForToken(last.serverName)
          .timeout(IsterMediaService.perServerTimeout);
      await StreamTokenService.ensureToken(last.serverName);
    }
    final client = ClientManager.getClientForUrl(last.serverName).value;
    final pq = await core.playQueueService.getPlayQueue(client, last.playQueueId);
    if (pq == null) return null;
    final currentId = pq.currentItemId ??
        PlayQueueService.sortedItems(pq).firstOrNull?.id;
    if (currentId == null) return null;
    final id =
        MediaItemId(last.serverName, IsterMediaTypes.track, currentId)
            .toString();
    return buildQueueMediaItems(pq, last.serverName)
        .where((m) => m.id == id)
        .firstOrNull;
  } catch (e) {
    LoggerService().logger.w('recent tile from last music queue failed: $e');
    return null;
  }
}

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

Future<void> playFromSearch(String query,
    [Map<String, dynamic>? extras]) async {
  LoggerService().logger.d('playFromSearch: $query');
  try {
    // An empty query means "play something" — resume the loaded (or
    // restored) last music queue at its recorded position, falling back to
    // restarting the last played track.
    if (query.trim().isEmpty) {
      if (await core.restoreLastMusicQueueOnce()) {
        await core.play();
        return;
      }
      final last = await AutoPreferences.getLastPlayed();
      if (last != null) {
        await core.playTrackById(MediaItemId(
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
      await core.playAlbumById(
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
      await core.playAlbumById(MediaItemId(
          firstAlbum.serverName, IsterMediaTypes.album, firstAlbum.id));
    }
  } catch (e) {
    LoggerService().logger.e('playFromSearch failed for "$query": $e');
  }
}
}
