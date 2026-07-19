import 'dart:ui';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/albumById.graphql.dart';
import 'package:player/graphql/albumsQuery.graphql.dart';
import 'package:player/graphql/artistsQuery.graphql.dart';
import 'package:player/graphql/bookById.graphql.dart';
import 'package:player/graphql/booksQuery.graphql.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/podcastById.graphql.dart';
import 'package:player/graphql/podcastEpisodesQuery.graphql.dart';
import 'package:player/graphql/podcastsQuery.graphql.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/trackById.graphql.dart';

import '../graphql/fragmentImages.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../l10n/app_localizations.dart';
import '../utils/AutoPreferences.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';
import '../utils/StreamTokenService.dart';
import '../utils/MetadataUtil.dart';
import '../utils/WellKnownService.dart';

/// Media lookups for the audio-service browse tree (Android Auto). The tree
/// exposes music, audiobooks and podcasts; movies and TV episodes are still
/// resolvable by id for playFromMediaId, but are not browsable.
///
/// Browse node ids are [MediaItemId] strings. `list` nodes use structured ids:
/// - `libraries`            → every audio library (music/book/podcast) on every
///                            configured server
/// - `library:<libraryId>`  → the categories of one MUSIC library (persists it
///                            as the default Android Auto library)
/// - `albums:<libraryId>`   → all albums in a music library
/// - `artists:<libraryId>`  → all artists in a music library
/// - `books:<libraryId>`    → all audiobooks in a BOOK library
/// - `podcasts:<libraryId>` → all podcasts in a PODCAST library
///
/// Composite leaf ids carry the two ids their play queue needs, joined by `~`:
/// - `chapter`        id `bookId~chapterId`      → BOOK play queue
/// - `podcastEpisode` id `podcastId~episodeId`   → PODCAST play queue
class IsterMediaService {
  /// Separator inside a composite leaf id (`bookId~chapterId`). A `~` never
  /// appears in the server's UUIDs, and [MediaItemId] only splits on `;`.
  static const String compositeIdSeparator = '~';

  /// Audio library types the car can browse and play. Movies, shows and comics
  /// are deliberately excluded — they are not audio.
  static const Set<Enum$LibraryType> browsableLibraryTypes = {
    Enum$LibraryType.MUSIC,
    Enum$LibraryType.BOOK,
    Enum$LibraryType.PODCAST,
  };

  static const int pageSize = 100;

  /// Upper bound on items returned for one browse node. Android Auto lists
  /// degrade (and transfers slow down) far before this.
  static const int maxItemsPerNode = 500;

  /// How long to wait on one server while building a multi-server list. An
  /// unreachable or not-logged-in server must not hang the whole picker: the
  /// surrounding try/catch only catches *errors*, not a login that never
  /// completes (getClient → waitForToken → OIDC init has no timeout of its
  /// own), so we bound each server here and skip the ones that stall.
  static const Duration perServerTimeout = Duration(seconds: 8);

  // androidx.media content-style hints: render children of a node as a grid
  // (2) instead of the default list (1).
  static const String contentStyleBrowsableHint =
      'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT';
  static const int contentStyleGrid = 2;

  /// Localizations without a BuildContext — the handler runs without UI.
  static AppLocalizations get loc {
    try {
      return lookupAppLocalizations(PlatformDispatcher.instance.locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  Future<List<IsterMediaItem>> getItemsByParentId(String id) async {
    MediaItemId mediaItemId = MediaItemId.byStringId(id);

    return switch (mediaItemId.isterMediaType) {
      IsterMediaTypes.episode => getEpisode(mediaItemId),
      IsterMediaTypes.show => List.empty(),
      IsterMediaTypes.list => getList(mediaItemId),
      IsterMediaTypes.movie => List.empty(),
      IsterMediaTypes.track => List.empty(),
      IsterMediaTypes.album =>
        getTracksForAlbum(mediaItemId.serverName, mediaItemId.id),
      IsterMediaTypes.artist =>
        getAlbumsForArtist(mediaItemId.serverName, mediaItemId.id),
      IsterMediaTypes.book =>
        getChaptersForBook(mediaItemId.serverName, mediaItemId.id),
      IsterMediaTypes.podcast =>
        getEpisodesForPodcast(mediaItemId.serverName, mediaItemId.id),
      IsterMediaTypes.chapter => List.empty(),
      IsterMediaTypes.podcastEpisode => List.empty(),
    };
  }

  Future<List<IsterMediaItem>> getList(MediaItemId mediaItemId) async {
    final id = mediaItemId.id;
    if (id == "libraries") {
      return getBrowsableLibraries();
    } else if (id.startsWith("library:")) {
      final libraryId = id.substring("library:".length);
      // Browsing into a MUSIC library makes it the default the car opens into.
      // Book/podcast libraries deliberately do not touch the default, so the
      // music-centric root stays stable.
      await AutoPreferences.setDefaultLibrary(
          mediaItemId.serverName, libraryId);
      return getLibraryCategories(mediaItemId.serverName, libraryId);
    } else if (id.startsWith("albums:")) {
      return getAlbums(mediaItemId.serverName,
          libraryId: id.substring("albums:".length));
    } else if (id.startsWith("artists:")) {
      return getArtists(
          mediaItemId.serverName, id.substring("artists:".length));
    } else if (id.startsWith("books:")) {
      return getBooks(mediaItemId.serverName, id.substring("books:".length));
    } else if (id.startsWith("podcasts:")) {
      return getPodcasts(
          mediaItemId.serverName, id.substring("podcasts:".length));
    }
    LoggerService().logger.w(
        'getList: unsupported list type "$id" for ${mediaItemId.serverName}');
    return List.empty();
  }

  /// Every browsable audio library (music, audiobooks, podcasts) on every
  /// configured server. Servers that are unreachable or not logged in are
  /// skipped so one dead server cannot empty the whole picker.
  Future<List<IsterMediaItem>> getBrowsableLibraries() async {
    final servers = await WellKnownService.getServers();
    final multiServer = servers.length > 1;
    // Query every server concurrently and independently. A slow or unreachable
    // server times out and is skipped instead of blocking the others, so a
    // single dead server can no longer hang the "switch library" node forever.
    final perServer = await Future.wait(servers.map((server) async {
      try {
        final libraries = await getBrowsableLibrariesForServer(server)
            .timeout(perServerTimeout);
        final serverLabel = multiServer
            ? WellKnownService.getCached(server)?.name ?? server
            : null;
        return libraries
            .map((library) => IsterMediaItem(
                  id: _libraryNodeId(library),
                  serverName: server,
                  isterMediaType: IsterMediaTypes.list,
                  title: serverLabel != null
                      ? '${library.name} ($serverLabel)'
                      : library.name,
                ))
            .toList();
      } catch (e) {
        LoggerService().logger.w('getBrowsableLibraries: skipping $server: $e');
        return <IsterMediaItem>[];
      }
    }));
    return perServer.expand((libraries) => libraries).toList();
  }

  /// The browse-node id for a library, encoding its type so [getList] knows
  /// how to open it (music has Albums/Artists categories; book and podcast
  /// libraries list their content directly).
  static String _libraryNodeId(Query$libraries$libraries library) {
    return switch (library.type) {
      Enum$LibraryType.BOOK => "books:${library.id}",
      Enum$LibraryType.PODCAST => "podcasts:${library.id}",
      _ => "library:${library.id}",
    };
  }

  Future<List<Query$libraries$libraries>> getBrowsableLibrariesForServer(
      String serverName) async {
    return _librariesForServer(serverName, browsableLibraryTypes);
  }

  Future<List<Query$libraries$libraries>> getMusicLibrariesForServer(
      String serverName) async {
    return _librariesForServer(serverName, const {Enum$LibraryType.MUSIC});
  }

  Future<List<Query$libraries$libraries>> _librariesForServer(
      String serverName, Set<Enum$LibraryType> types) async {
    final client = await getClient(serverName);
    final result = await client.query(QueryOptions(
      document: documentNodeQuerylibraries,
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return [];
    }
    final libraries = Query$libraries.fromJson(result.data!).libraries ?? [];
    return libraries
        .where((library) => types.contains(library.type))
        .toList();
  }

  /// The browse categories of one music library.
  Future<List<IsterMediaItem>> getLibraryCategories(
      String serverName, String libraryId) async {
    return [
      IsterMediaItem(
        id: "albums:$libraryId",
        serverName: serverName,
        isterMediaType: IsterMediaTypes.list,
        title: loc.albums,
        extras: const {contentStyleBrowsableHint: contentStyleGrid},
      ),
      IsterMediaItem(
        id: "artists:$libraryId",
        serverName: serverName,
        isterMediaType: IsterMediaTypes.list,
        title: loc.artists,
        extras: const {contentStyleBrowsableHint: contentStyleGrid},
      ),
    ];
  }

  Future<List<IsterMediaItem>> getAlbums(String serverName,
      {String? libraryId, String? artistId}) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQueryalbums,
        variables: {
          'page': page,
          'size': pageSize,
          'sorting': Enum$SortingEnum.NAME,
          'sortingOrder': Enum$SortingOrder.ASCENDING,
          if (libraryId != null) 'libraryId': libraryId,
          if (artistId != null) 'artistId': artistId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final albumPage = Query$albums.fromJson(result.data!).albums;
      if (albumPage == null) break;

      items.addAll(albumPage.content.map((album) => IsterMediaItem(
            id: album.id,
            serverName: serverName,
            isterMediaType: IsterMediaTypes.album,
            title: MetadataUtil.getTitle(album.metadata) ?? album.name,
            artist: album.artist.name,
            artUri: coverArtUri(album.images, serverName),
          )));

      page++;
      if (page >= albumPage.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            'getAlbums: capped at ${items.length} of ${albumPage.totalElements} albums for $serverName');
        break;
      }
    }
    return items;
  }

  Future<List<IsterMediaItem>> getArtists(
      String serverName, String libraryId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQueryartists,
        variables: {
          'page': page,
          'size': pageSize,
          'sorting': Enum$SortingEnum.NAME,
          'sortingOrder': Enum$SortingOrder.ASCENDING,
          'libraryId': libraryId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final artistPage = Query$artists.fromJson(result.data!).artists;
      if (artistPage == null) break;

      items.addAll(artistPage.content.map((artist) => IsterMediaItem(
            id: artist.id,
            serverName: serverName,
            isterMediaType: IsterMediaTypes.artist,
            title: artist.name,
            artUri: coverArtUri(artist.images, serverName),
          )));

      page++;
      if (page >= artistPage.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            'getArtists: capped at ${items.length} of ${artistPage.totalElements} artists for $serverName');
        break;
      }
    }
    return items;
  }

  Future<List<IsterMediaItem>> getAlbumsForArtist(
      String serverName, String artistId) {
    return getAlbums(serverName, artistId: artistId);
  }

  /// All audiobooks in a BOOK library. Each is browsable into its chapters.
  Future<List<IsterMediaItem>> getBooks(
      String serverName, String libraryId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerybooks,
        variables: {
          'page': page,
          'size': pageSize,
          'sorting': Enum$SortingEnum.NAME,
          'sortingOrder': Enum$SortingOrder.ASCENDING,
          'libraryId': libraryId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final bookPage = Query$books.fromJson(result.data!).books;
      if (bookPage == null) break;

      items.addAll(bookPage.content.map((book) => IsterMediaItem(
            id: book.id,
            serverName: serverName,
            isterMediaType: IsterMediaTypes.book,
            title: MetadataUtil.getTitle(book.metadata) ?? book.title,
            artist: book.author?.name,
            artUri: coverArtUri(book.images, serverName),
          )));

      page++;
      if (page >= bookPage.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            'getBooks: capped at ${items.length} of ${bookPage.totalElements} books for $serverName');
        break;
      }
    }
    return items;
  }

  /// All podcasts in a PODCAST library. Each is browsable into its episodes.
  Future<List<IsterMediaItem>> getPodcasts(
      String serverName, String libraryId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerypodcasts,
        variables: {
          'page': page,
          'size': pageSize,
          'sorting': Enum$SortingEnum.NAME,
          'sortingOrder': Enum$SortingOrder.ASCENDING,
          'libraryId': libraryId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final podcastPage = Query$podcasts.fromJson(result.data!).podcasts;
      if (podcastPage == null) break;

      items.addAll(podcastPage.content.map((podcast) => IsterMediaItem(
            id: podcast.id,
            serverName: serverName,
            isterMediaType: IsterMediaTypes.podcast,
            title: MetadataUtil.getTitle(podcast.metadata) ?? podcast.title,
            artist: podcast.author,
            artUri: coverArtUri(podcast.images, serverName),
          )));

      page++;
      if (page >= podcastPage.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            'getPodcasts: capped at ${items.length} of ${podcastPage.totalElements} podcasts for $serverName');
        break;
      }
    }
    return items;
  }

  /// The chapters of one audiobook, as playable leaves. Their composite id
  /// (`bookId~chapterId`) carries what the BOOK play queue needs.
  Future<List<IsterMediaItem>> getChaptersForBook(
      String serverName, String bookId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final result = await client.query(QueryOptions(
      document: documentNodeQuerybookById,
      variables: {'id': bookId},
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return List.empty();
    }
    final book = Query$bookById.fromJson(result.data!).bookById;
    if (book == null) return List.empty();

    final bookTitle = MetadataUtil.getTitle(book.metadata) ?? book.title;
    final artUri = coverArtUri(book.images, serverName);
    return (book.chapters ?? []).map((chapter) {
      final durationMs = chapter.mediaFile?.firstOrNull?.durationInMilliseconds;
      return IsterMediaItem(
        id: '$bookId$compositeIdSeparator${chapter.id}',
        serverName: serverName,
        isterMediaType: IsterMediaTypes.chapter,
        title: MetadataUtil.getTitle(chapter.metadata) ??
            '${loc.chapter} ${chapter.number}',
        album: bookTitle,
        artist: book.author?.name,
        duration:
            durationMs != null ? Duration(milliseconds: durationMs) : null,
        artUri: artUri,
        playable: true,
      );
    }).toList();
  }

  /// The episodes of one podcast, newest first, as playable leaves. Their
  /// composite id (`podcastId~episodeId`) carries what the PODCAST play queue
  /// needs.
  Future<List<IsterMediaItem>> getEpisodesForPodcast(
      String serverName, String podcastId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    // One lookup for the podcast's cover art and title — the episode query
    // carries neither.
    final podcastResult = await client.query(QueryOptions(
      document: documentNodeQuerypodcastById,
      variables: {'id': podcastId},
    ));
    final podcast = podcastResult.hasException || podcastResult.data == null
        ? null
        : Query$podcastById.fromJson(podcastResult.data!).podcastById;
    final artUri =
        podcast != null ? coverArtUri(podcast.images, serverName) : null;
    final podcastTitle =
        podcast != null ? (MetadataUtil.getTitle(podcast.metadata) ?? podcast.title) : null;

    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerypodcastEpisodes,
        variables: {
          'podcastId': podcastId,
          'page': page,
          'size': pageSize,
          'sortingOrder': Enum$SortingOrder.DESCENDING,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final episodePage =
          Query$podcastEpisodes.fromJson(result.data!).podcastEpisodes;

      items.addAll(episodePage.content.map((episode) {
        final durationMs = episode.durationInMilliseconds;
        final episodeNumber = episode.episodeNumber;
        return IsterMediaItem(
          id: '$podcastId$compositeIdSeparator${episode.id}',
          serverName: serverName,
          isterMediaType: IsterMediaTypes.podcastEpisode,
          title: MetadataUtil.getTitle(episode.metadata) ??
              (episodeNumber != null
                  ? loc.episode(episodeNumber)
                  : (podcastTitle ?? '')),
          album: podcastTitle,
          duration:
              durationMs != null ? Duration(milliseconds: durationMs) : null,
          artUri: artUri,
          playable: true,
        );
      }));

      page++;
      if (page >= episodePage.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            'getEpisodesForPodcast: capped at ${items.length} of ${episodePage.totalElements} episodes for $serverName');
        break;
      }
    }
    return items;
  }

  Future<List<IsterMediaItem>> getTracksForAlbum(
      String serverName, String albumId) async {
    final album = await getAlbumWithTracks(serverName, albumId);
    if (album == null) return List.empty();

    final albumTitle = MetadataUtil.getTitle(album.metadata) ?? album.name;
    final artUri = coverArtUri(album.images, serverName);
    return (album.tracks ?? []).map((track) {
      final durationMs = track.mediaFile?.firstOrNull?.durationInMilliseconds;
      return IsterMediaItem(
        id: track.id,
        serverName: serverName,
        isterMediaType: IsterMediaTypes.track,
        title: MetadataUtil.getTitle(track.metadata) ?? '${track.number}',
        artist: track.artist.name,
        album: albumTitle,
        duration:
            durationMs != null ? Duration(milliseconds: durationMs) : null,
        artUri: artUri,
        playable: true,
      );
    }).toList();
  }

  Future<Query$albumById$albumById?> getAlbumWithTracks(
      String serverName, String albumId) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final result = await client.query(QueryOptions(
      document: documentNodeQueryalbumById,
      variables: {'id': albumId},
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$albumById.fromJson(result.data!).albumById;
  }

  /// Resolves the album a track belongs to — playFromMediaId only receives a
  /// track id, but playback always starts from an album play queue.
  Future<Fragment$fragmentAlbum?> getTrackAlbum(
      String serverName, String trackId) async {
    final client = await getClient(serverName);
    final result = await client.query(QueryOptions(
      document: documentNodeQuerytrackById,
      variables: {'id': trackId},
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$trackById.fromJson(result.data!).trackById?.album;
  }

  /// Client-side search over album and artist names — the server has no
  /// search API (yet), so this filters the same capped lists the browse tree
  /// shows. Albums first: they are directly playable via their first track.
  Future<List<IsterMediaItem>> searchMusic(
      String serverName, String libraryId, String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return List.empty();

    final albums = await getAlbums(serverName, libraryId: libraryId);
    final artists = await getArtists(serverName, libraryId);

    final matchingAlbums = albums.where((album) =>
        album.title.toLowerCase().contains(q) ||
        (album.artist?.toLowerCase().contains(q) ?? false));
    final matchingArtists =
        artists.where((artist) => artist.title.toLowerCase().contains(q));
    return [...matchingAlbums, ...matchingArtists];
  }

  Future<Fragment$fragmentEpisode?> getEpisodeFragmentById(
      MediaItemId mediaItemId) async {
    GraphQLClient client = await getClient(mediaItemId.serverName);

    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryepisodeById,
      variables: {'id': mediaItemId.id},
    ));

    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return Query$episodeById.fromJson(result.data!).episodeById;
  }

  Future<List<IsterMediaItem>> getEpisode(MediaItemId mediaItemId) async {
    final data = await getEpisodeFragmentById(mediaItemId);
    if (data == null) return List.empty();
    IsterMediaItem isterMediaItem = IsterMediaItem(
      id: data.id,
      title: MetadataUtil.getTitle(data.metadata) ?? "unknown",
      duration: Duration(
          milliseconds:
              data.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0),
      serverName: mediaItemId.serverName,
      isterMediaType: mediaItemId.isterMediaType,
      artUri: artUriFromImages(data.images, mediaItemId.serverName),
      playable: true,
    );
    return {isterMediaItem}.toList();
  }

  /// Cover art with a background fallback, as URI with stream token.
  static Uri? coverArtUri(
      List<Fragment$fragmentImages>? images, String serverName) {
    final image = ImageUtil.getImageByType(images, ImageTypes.cover) ??
        ImageUtil.getImageByType(images, ImageTypes.background);
    final url = ImageUtil.buildUrl(image,
        token: StreamTokenService.getToken(serverName));
    return url != null ? Uri.parse(url) : null;
  }

  static Uri? artUriFromImages(
      List<Fragment$fragmentImages>? images, String serverName) {
    final imageByType = ImageUtil.getImageByType(images, ImageTypes.background);
    final url = ImageUtil.buildUrl(imageByType,
        token: StreamTokenService.getToken(serverName));
    return url != null ? Uri.parse(url) : null;
  }

  static Future<GraphQLClient> getClient(String serverName) async {
    await LoginManager.waitForToken(serverName);
    return ClientManager.getClientForUrl(serverName).value;
  }
}
