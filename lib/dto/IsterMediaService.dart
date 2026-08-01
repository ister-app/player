import 'dart:ui';

import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/graphql/albumById.graphql.dart';
import 'package:player/graphql/albumsQuery.graphql.dart';
import 'package:player/graphql/artistsQuery.graphql.dart';
import 'package:player/graphql/bookById.graphql.dart';
import 'package:player/graphql/booksQuery.graphql.dart';
import 'package:player/graphql/discoverAlbums.graphql.dart';
import 'package:player/graphql/discoverBooks.graphql.dart';
import 'package:player/graphql/discoverPodcasts.graphql.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:player/graphql/fragmentBook.graphql.dart';
import 'package:player/graphql/fragmentPodcast.graphql.dart';
import 'package:player/graphql/rankedAlbums.graphql.dart';
import 'package:player/graphql/rankedBooks.graphql.dart';
import 'package:player/graphql/rankedPodcasts.graphql.dart';
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
/// - `albums:<libraryId>`   → the albums tab of a music library: the discover
///                            groups (recently played, most played, …) closed
///                            by an "All albums" folder
/// - `all-albums:<libraryId>` → all albums in a music library, alphabetical
/// - `artists:<libraryId>`  → all artists in a music library
/// - `books:<libraryId>`    → a BOOK library: the discover groups followed by
///                            every audiobook under an "All books" section
///                            (playable leaves that resume where the listener
///                            left off)
/// - `podcasts:<libraryId>` → a PODCAST library: the discover groups followed
///                            by every podcast under an "All podcasts" section
/// - `discover:<kind>:<libraryId>` → the discover groups of one library
///                            (kind ∈ albums|books|podcasts): titled sections
///                            each closed by a "show all" folder. No longer
///                            emitted, but kept resolvable for head units that
///                            cached the node id
/// - `ranked:<kind>:<libraryId>:<rank>` → the full list behind one discover
///                            group (rank ∈ RECENTLY_PLAYED | MOST_PLAYED |
///                            HIGHEST_RATED | RECENTLY_ADDED)
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
  static const int contentStyleList = 1;

  // androidx.media content-style hint: overrides the layout of one item, so a
  // single browse node can mix full-width list rows and grid tiles.
  static const String contentStyleSingleItemHint =
      'android.media.browse.CONTENT_STYLE_SINGLE_ITEM_HINT';

  // androidx.media content-style hint: items sharing a group title render as
  // one titled section, so a single browse node shows several groups.
  static const String contentStyleGroupTitleHint =
      'android.media.browse.CONTENT_STYLE_GROUP_TITLE_HINT';

  /// Cover-art tiles inside a mixed node: rendered as grid items next to each
  /// other instead of full-width rows.
  static const Map<String, dynamic> _gridTileExtras = {
    contentStyleSingleItemHint: contentStyleGrid,
  };

  /// A clickable section-header row inside a mixed node; opening it shows its
  /// full list as a grid of covers.
  static const Map<String, dynamic> _headerExtras = {
    contentStyleSingleItemHint: contentStyleList,
    contentStyleBrowsableHint: contentStyleGrid,
  };

  /// Items per group on a discover screen; the leading header row opens the
  /// full ranked list.
  static const int discoverGroupSize = 6;

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
      return getAlbumsTab(mediaItemId.serverName, libraryId);
    } else if (id.startsWith("albums:")) {
      return getAlbumsTab(
          mediaItemId.serverName, id.substring("albums:".length));
    } else if (id.startsWith("all-albums:")) {
      return getAlbums(mediaItemId.serverName,
          libraryId: id.substring("all-albums:".length));
    } else if (id.startsWith("artists:")) {
      return getArtists(
          mediaItemId.serverName, id.substring("artists:".length));
    } else if (id.startsWith("books:")) {
      final libraryId = id.substring("books:".length);
      return [
        ...await getDiscoverGroups(mediaItemId.serverName,
            DiscoverNodeId(DiscoverKind.books, libraryId)),
        ...await getBooks(mediaItemId.serverName, libraryId,
            extras: _groupExtras(loc.allBooks)),
      ];
    } else if (id.startsWith("podcasts:")) {
      final libraryId = id.substring("podcasts:".length);
      return [
        ...await getDiscoverGroups(mediaItemId.serverName,
            DiscoverNodeId(DiscoverKind.podcasts, libraryId)),
        ...await getPodcasts(mediaItemId.serverName, libraryId,
            extras: _groupExtras(loc.allPodcasts)),
      ];
    } else if (id.startsWith("discover:")) {
      final node = DiscoverNodeId.parse(id);
      if (node != null) return getDiscoverGroups(mediaItemId.serverName, node);
    } else if (id.startsWith("ranked:")) {
      final node = RankedNodeId.parse(id);
      if (node != null) return getRankedList(mediaItemId.serverName, node);
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

  /// The albums tab of a music library: the discover groups, closed by an
  /// "All albums" header row into the full alphabetical cover grid.
  Future<List<IsterMediaItem>> getAlbumsTab(
      String serverName, String libraryId) async {
    return [
      ...await getDiscoverGroups(
          serverName, DiscoverNodeId(DiscoverKind.albums, libraryId)),
      IsterMediaItem(
        id: "all-albums:$libraryId",
        serverName: serverName,
        isterMediaType: IsterMediaTypes.list,
        title: loc.allAlbums,
        extras: _headerExtras,
      ),
    ];
  }

  Future<List<IsterMediaItem>> getAlbums(String serverName,
      {String? libraryId,
      String? artistId,
      Enum$SortingEnum sorting = Enum$SortingEnum.NAME,
      Enum$SortingOrder sortingOrder = Enum$SortingOrder.ASCENDING,
      int? limit,
      Map<String, dynamic>? extras}) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final cap = limit ?? maxItemsPerNode;
    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQueryalbums,
        variables: {
          'page': page,
          'size': cap < pageSize ? cap : pageSize,
          'sorting': sorting,
          'sortingOrder': sortingOrder,
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

      items.addAll(albumPage.content
          .map((album) => _albumItem(album, serverName, extras: extras)));

      page++;
      if (page >= albumPage.totalPages) break;
      if (items.length >= cap) {
        if (limit == null) {
          LoggerService().logger.w(
              'getAlbums: capped at ${items.length} of ${albumPage.totalElements} albums for $serverName');
        }
        break;
      }
    }
    return items.length > cap ? items.sublist(0, cap) : items;
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

  /// All audiobooks in a BOOK library. Each is a playable leaf: selecting one
  /// in the car resumes it where the listener left off ([playFromMediaId]
  /// resolves the resume chapter) instead of opening a chapter list.
  Future<List<IsterMediaItem>> getBooks(String serverName, String libraryId,
      {Enum$SortingEnum sorting = Enum$SortingEnum.NAME,
      Enum$SortingOrder sortingOrder = Enum$SortingOrder.ASCENDING,
      int? limit,
      Map<String, dynamic>? extras}) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final cap = limit ?? maxItemsPerNode;
    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerybooks,
        variables: {
          'page': page,
          'size': cap < pageSize ? cap : pageSize,
          'sorting': sorting,
          'sortingOrder': sortingOrder,
          'libraryId': libraryId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final bookPage = Query$books.fromJson(result.data!).books;
      if (bookPage == null) break;

      items.addAll(bookPage.content
          .map((book) => _bookItem(book, serverName, extras: extras)));

      page++;
      if (page >= bookPage.totalPages) break;
      if (items.length >= cap) {
        if (limit == null) {
          LoggerService().logger.w(
              'getBooks: capped at ${items.length} of ${bookPage.totalElements} books for $serverName');
        }
        break;
      }
    }
    return items.length > cap ? items.sublist(0, cap) : items;
  }

  /// All podcasts in a PODCAST library. Each is browsable into its episodes.
  Future<List<IsterMediaItem>> getPodcasts(String serverName, String libraryId,
      {Enum$SortingEnum sorting = Enum$SortingEnum.NAME,
      Enum$SortingOrder sortingOrder = Enum$SortingOrder.ASCENDING,
      int? limit,
      Map<String, dynamic>? extras}) async {
    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);

    final cap = limit ?? maxItemsPerNode;
    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: documentNodeQuerypodcasts,
        variables: {
          'page': page,
          'size': cap < pageSize ? cap : pageSize,
          'sorting': sorting,
          'sortingOrder': sortingOrder,
          'libraryId': libraryId,
        },
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final podcastPage = Query$podcasts.fromJson(result.data!).podcasts;
      if (podcastPage == null) break;

      items.addAll(podcastPage.content
          .map((podcast) => _podcastItem(podcast, serverName, extras: extras)));

      page++;
      if (page >= podcastPage.totalPages) break;
      if (items.length >= cap) {
        if (limit == null) {
          LoggerService().logger.w(
              'getPodcasts: capped at ${items.length} of ${podcastPage.totalElements} podcasts for $serverName');
        }
        break;
      }
    }
    return items.length > cap ? items.sublist(0, cap) : items;
  }

  IsterMediaItem _albumItem(Fragment$fragmentAlbum album, String serverName,
      {Map<String, dynamic>? extras}) {
    return IsterMediaItem(
      id: album.id,
      serverName: serverName,
      isterMediaType: IsterMediaTypes.album,
      title: MetadataUtil.getTitle(album.metadata) ?? album.name,
      artist: album.artist.name,
      artUri: coverArtUri(album.images, serverName),
      extras: extras,
    );
  }

  IsterMediaItem _bookItem(Fragment$fragmentBook book, String serverName,
      {Map<String, dynamic>? extras}) {
    return IsterMediaItem(
      id: book.id,
      serverName: serverName,
      isterMediaType: IsterMediaTypes.book,
      title: MetadataUtil.getTitle(book.metadata) ?? book.title,
      artist: book.author?.name,
      artUri: coverArtUri(book.images, serverName),
      playable: true,
      extras: extras,
    );
  }

  IsterMediaItem _podcastItem(Fragment$fragmentPodcast podcast,
      String serverName,
      {Map<String, dynamic>? extras}) {
    return IsterMediaItem(
      id: podcast.id,
      serverName: serverName,
      isterMediaType: IsterMediaTypes.podcast,
      title: MetadataUtil.getTitle(podcast.metadata) ?? podcast.title,
      artist: podcast.author,
      artUri: coverArtUri(podcast.images, serverName),
      extras: extras,
    );
  }

  /// A titled grid section for inline full lists that have no browse node of
  /// their own (all books / all podcasts): a plain text header above tiles.
  static Map<String, dynamic> _groupExtras(String label) => {
        contentStyleGroupTitleHint: label,
        ..._gridTileExtras,
      };

  /// The discover sections rendered inline in a library's browse node: each a
  /// clickable header row into the full ranked list, followed by up to
  /// [discoverGroupSize] cover tiles rendered as a grid. The top lists need a
  /// server with the `libraryById` discover fields; on an older server only
  /// the recently-added group remains.
  Future<List<IsterMediaItem>> getDiscoverGroups(
      String serverName, DiscoverNodeId node) async {
    await StreamTokenService.ensureToken(serverName);
    final groups = <IsterMediaItem>[];

    List<IsterMediaItem> group(
            String label, DiscoverRank rank, List<IsterMediaItem> items) =>
        _discoverGroup(
            serverName: serverName,
            node: node,
            label: label,
            rank: rank,
            items: items);

    switch (node.kind) {
      case DiscoverKind.albums:
        final data = await _discoverData(
            serverName, documentNodeQuerydiscoverAlbums, node.libraryId);
        final library =
            data == null ? null : Query$discoverAlbums.fromJson(data).libraryById;
        List<IsterMediaItem> albums(List<Fragment$fragmentAlbum> list) => list
            .map((album) =>
                _albumItem(album, serverName, extras: _gridTileExtras))
            .toList();
        if (library != null) {
          groups
            ..addAll(group(loc.recentlyPlayed, DiscoverRank.recentlyPlayed,
                albums(library.recentlyPlayedAlbums)))
            ..addAll(group(loc.mostPlayed, DiscoverRank.mostPlayed,
                albums(library.mostPlayedAlbums)))
            ..addAll(group(loc.highestRated, DiscoverRank.highestRated,
                albums(library.highestRatedAlbums)));
        }
        groups.addAll(group(
            loc.recentlyAdded,
            DiscoverRank.recentlyAdded,
            await getAlbums(serverName,
                libraryId: node.libraryId,
                sorting: Enum$SortingEnum.DATE_CREATED,
                sortingOrder: Enum$SortingOrder.DESCENDING,
                limit: discoverGroupSize,
                extras: _gridTileExtras)));
      case DiscoverKind.books:
        final data = await _discoverData(
            serverName, documentNodeQuerydiscoverBooks, node.libraryId);
        final library =
            data == null ? null : Query$discoverBooks.fromJson(data).libraryById;
        List<IsterMediaItem> books(List<Fragment$fragmentBook> list) => list
            .map((book) => _bookItem(book, serverName, extras: _gridTileExtras))
            .toList();
        if (library != null) {
          groups
            // "Recently read" clicks through as RECENTLY_PLAYED, mirroring
            // LibraryDiscoverView's mapping for the same row.
            ..addAll(group(loc.recentlyRead, DiscoverRank.recentlyPlayed,
                books(library.recentlyReadBooks)))
            ..addAll(group(loc.highestRated, DiscoverRank.highestRated,
                books(library.highestRatedBooks)));
        }
        groups.addAll(group(
            loc.recentlyAdded,
            DiscoverRank.recentlyAdded,
            await getBooks(serverName, node.libraryId,
                sorting: Enum$SortingEnum.DATE_CREATED,
                sortingOrder: Enum$SortingOrder.DESCENDING,
                limit: discoverGroupSize,
                extras: _gridTileExtras)));
      case DiscoverKind.podcasts:
        final data = await _discoverData(
            serverName, documentNodeQuerydiscoverPodcasts, node.libraryId);
        final library = data == null
            ? null
            : Query$discoverPodcasts.fromJson(data).libraryById;
        List<IsterMediaItem> podcasts(List<Fragment$fragmentPodcast> list) =>
            list
                .map((podcast) =>
                    _podcastItem(podcast, serverName, extras: _gridTileExtras))
                .toList();
        if (library != null) {
          groups
            ..addAll(group(loc.recentlyPlayed, DiscoverRank.recentlyPlayed,
                podcasts(library.recentlyPlayedPodcasts)))
            ..addAll(group(loc.mostPlayed, DiscoverRank.mostPlayed,
                podcasts(library.mostPlayedPodcasts)))
            ..addAll(group(loc.highestRated, DiscoverRank.highestRated,
                podcasts(library.highestRatedPodcasts)));
        }
        groups.addAll(group(
            loc.recentlyAdded,
            DiscoverRank.recentlyAdded,
            await getPodcasts(serverName, node.libraryId,
                sorting: Enum$SortingEnum.DATE_CREATED,
                sortingOrder: Enum$SortingOrder.DESCENDING,
                limit: discoverGroupSize,
                extras: _gridTileExtras)));
    }
    return groups;
  }

  /// One section: a leading clickable header row (titled after the section,
  /// opening the full ranked list as a grid) followed by its cover tiles.
  /// Empty groups vanish entirely.
  List<IsterMediaItem> _discoverGroup({
    required String serverName,
    required DiscoverNodeId node,
    required String label,
    required DiscoverRank rank,
    required List<IsterMediaItem> items,
  }) {
    if (items.isEmpty) return const [];
    return [
      IsterMediaItem(
        id: RankedNodeId(node.kind, node.libraryId, rank).id,
        serverName: serverName,
        isterMediaType: IsterMediaTypes.list,
        title: label,
        extras: _headerExtras,
      ),
      ...items,
    ];
  }

  /// Runs one discover top-lists query; null when the server predates the
  /// discover fields, so the screen degrades to the recently-added group.
  Future<Map<String, dynamic>?> _discoverData(
      String serverName, DocumentNode document, String libraryId) async {
    try {
      final client = await getClient(serverName);
      final result = await client.query(QueryOptions(
        document: document,
        variables: {'libraryId': libraryId, 'limit': discoverGroupSize},
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.w(
            'discover top lists unavailable for $serverName: ${result.exception}');
        return null;
      }
      return result.data;
    } catch (e) {
      LoggerService()
          .logger
          .w('discover top lists unavailable for $serverName: $e');
      return null;
    }
  }

  /// The full list behind one discover group. Recently-added runs the
  /// ordinary list query newest-first (works on any server); the other ranks
  /// page the server's ranked queries up to [maxItemsPerNode].
  Future<List<IsterMediaItem>> getRankedList(
      String serverName, RankedNodeId node) async {
    final rankKind = node.rank.rankKind;
    if (rankKind == null) {
      return switch (node.kind) {
        DiscoverKind.albums => getAlbums(serverName,
            libraryId: node.libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING),
        DiscoverKind.books => getBooks(serverName, node.libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING),
        DiscoverKind.podcasts => getPodcasts(serverName, node.libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING),
      };
    }

    final client = await getClient(serverName);
    await StreamTokenService.ensureToken(serverName);
    final variables = {'libraryId': node.libraryId, 'kind': rankKind};
    return switch (node.kind) {
      DiscoverKind.albums => _pagedRanked(
          client: client,
          document: documentNodeQueryrankedAlbums,
          variables: variables,
          logLabel: 'getRankedList(albums)',
          parsePage: (data) {
            final rankedPage =
                Query$rankedAlbums.fromJson(data).libraryById?.rankedAlbums;
            if (rankedPage == null) return null;
            return (
              items: rankedPage.content
                  .map((album) => _albumItem(album, serverName))
                  .toList(),
              totalPages: rankedPage.totalPages,
              totalElements: rankedPage.totalElements,
            );
          }),
      DiscoverKind.books => _pagedRanked(
          client: client,
          document: documentNodeQueryrankedBooks,
          variables: variables,
          logLabel: 'getRankedList(books)',
          parsePage: (data) {
            final rankedPage =
                Query$rankedBooks.fromJson(data).libraryById?.rankedBooks;
            if (rankedPage == null) return null;
            return (
              items: rankedPage.content
                  .map((book) => _bookItem(book, serverName))
                  .toList(),
              totalPages: rankedPage.totalPages,
              totalElements: rankedPage.totalElements,
            );
          }),
      DiscoverKind.podcasts => _pagedRanked(
          client: client,
          document: documentNodeQueryrankedPodcasts,
          variables: variables,
          logLabel: 'getRankedList(podcasts)',
          parsePage: (data) {
            final rankedPage =
                Query$rankedPodcasts.fromJson(data).libraryById?.rankedPodcasts;
            if (rankedPage == null) return null;
            return (
              items: rankedPage.content
                  .map((podcast) => _podcastItem(podcast, serverName))
                  .toList(),
              totalPages: rankedPage.totalPages,
              totalElements: rankedPage.totalElements,
            );
          }),
    };
  }

  /// Pages one ranked query up to [maxItemsPerNode]. A server without ranked
  /// queries errors on the first page and yields an empty list.
  Future<List<IsterMediaItem>> _pagedRanked({
    required GraphQLClient client,
    required DocumentNode document,
    required Map<String, dynamic> variables,
    required String logLabel,
    required ({
      List<IsterMediaItem> items,
      int totalPages,
      int totalElements
    })?
        Function(Map<String, dynamic> data) parsePage,
  }) async {
    final items = <IsterMediaItem>[];
    var page = 0;
    while (true) {
      final result = await client.query(QueryOptions(
        document: document,
        variables: {...variables, 'page': page, 'size': pageSize},
      ));
      if (result.hasException || result.data == null) {
        LoggerService().logger.e(result.exception);
        break;
      }
      final parsed = parsePage(result.data!);
      if (parsed == null) break;
      items.addAll(parsed.items);

      page++;
      if (page >= parsed.totalPages) break;
      if (items.length >= maxItemsPerNode) {
        LoggerService().logger.w(
            '$logLabel: capped at ${items.length} of ${parsed.totalElements} items');
        break;
      }
    }
    return items;
  }

  /// The chapter a book should start (or resume) at: the server's resume
  /// chapter, or the first chapter that has audio. Null when the book has no
  /// playable chapters (the play queue then starts at its first item).
  Future<String?> getBookStartChapterId(
      String serverName, String bookId) async {
    final client = await getClient(serverName);
    final result = await client.query(QueryOptions(
      document: documentNodeQuerybookById,
      variables: {'id': bookId},
    ));
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      return null;
    }
    return startChapterIdFor(Query$bookById.fromJson(result.data!).bookById);
  }

  /// The resume-chapter fallback chain, split out pure so it can be
  /// unit-tested: the server's resume chapter wins; a never-started (or
  /// finished) book starts at its first chapter that has audio.
  static String? startChapterIdFor(Query$bookById$bookById? book) {
    return book?.resumeChapter?.id ??
        book?.chapters
            ?.where((chapter) => chapter.mediaFile?.isNotEmpty == true)
            .firstOrNull
            ?.id;
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

/// The content kind a `discover:`/`ranked:` node covers — one per browsable
/// library type.
enum DiscoverKind { albums, books, podcasts }

/// One discover group's rank. [rankKind] is the server's ranked-query kind;
/// recently-added has none and runs the ordinary list query newest-first
/// instead, so it also works on servers without the ranked queries.
enum DiscoverRank {
  recentlyPlayed('RECENTLY_PLAYED', Enum$RankKind.RECENTLY_PLAYED),
  mostPlayed('MOST_PLAYED', Enum$RankKind.MOST_PLAYED),
  highestRated('HIGHEST_RATED', Enum$RankKind.HIGHEST_RATED),
  recentlyAdded('RECENTLY_ADDED', null);

  const DiscoverRank(this.wireName, this.rankKind);

  /// The rank token inside a `ranked:` node id.
  final String wireName;

  final Enum$RankKind? rankKind;
}

/// Parsed `discover:<kind>:<libraryId>` inner id.
class DiscoverNodeId {
  const DiscoverNodeId(this.kind, this.libraryId);

  final DiscoverKind kind;
  final String libraryId;

  String get id => 'discover:${kind.name}:$libraryId';

  static DiscoverNodeId? parse(String id) {
    final parts = id.split(':');
    if (parts.length != 3 || parts[0] != 'discover' || parts[2].isEmpty) {
      return null;
    }
    final kind =
        DiscoverKind.values.where((kind) => kind.name == parts[1]).firstOrNull;
    return kind == null ? null : DiscoverNodeId(kind, parts[2]);
  }
}

/// Parsed `ranked:<kind>:<libraryId>:<rank>` inner id.
class RankedNodeId {
  const RankedNodeId(this.kind, this.libraryId, this.rank);

  final DiscoverKind kind;
  final String libraryId;
  final DiscoverRank rank;

  String get id => 'ranked:${kind.name}:$libraryId:${rank.wireName}';

  static RankedNodeId? parse(String id) {
    final parts = id.split(':');
    if (parts.length != 4 || parts[0] != 'ranked' || parts[2].isEmpty) {
      return null;
    }
    final kind =
        DiscoverKind.values.where((kind) => kind.name == parts[1]).firstOrNull;
    final rank = DiscoverRank.values
        .where((rank) => rank.wireName == parts[3])
        .firstOrNull;
    if (kind == null || rank == null) return null;
    return RankedNodeId(kind, parts[2], rank);
  }
}
