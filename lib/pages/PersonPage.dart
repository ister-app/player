import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/albumsQuery.graphql.dart';
import 'package:player/graphql/refreshPerson.graphql.dart';
import 'package:player/graphql/appearsOnAlbums.graphql.dart';
import 'package:player/graphql/artistById.graphql.dart';
import 'package:player/graphql/booksQuery.graphql.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentBook.graphql.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/recentlyAddedTracksByArtist.graphql.dart';
import 'package:player/graphql/recentlyPlayedTracksByArtist.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/topPlayedTracksByArtist.graphql.dart';
import 'package:player/graphql/topRatedTracksByArtist.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/AccentColorUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/ArtistTrackList.dart';
import '../components/BookCarouselTile.dart';
import '../components/CarouselItemView.dart';
import '../components/ExpandableText.dart';
import '../components/MediaGrid.dart';
import '../components/MusicDetailHero.dart';
import '../components/PlaybackHistorySheet.dart';
import '../components/SourceAttribution.dart';
import '../components/TvFocusable.dart';
import '../l10n/app_localizations.dart';
import '../utils/ServerTaskRunner.dart';

final _random = Random();

@RoutePage()
class PersonPage extends StatefulWidget {
  const PersonPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('personId') required this.personId,
  });

  final String serverName;
  final String personId;

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  /// Filmography rows the skeleton reserves.
  static const int _skeletonCreditCount = 4;

  String get serverName => widget.serverName;
  String get personId => widget.personId;

  bool _showAdminActions = true;

  /// Accent extracted from the hero image, tinting the play button; null
  /// until extraction succeeds.
  Color? _accent;
  String? _accentUrl;

  void _updateAccent(String? url) {
    if (url == _accentUrl) return;
    _accentUrl = url;
    AccentColorUtil.fromImageUrl(url).then((color) {
      // A hero-image change may have superseded this load; only apply if current.
      if (!mounted || _accentUrl != url || color == null) return;
      setState(() => _accent = color);
    });
  }

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MediaPlayerHandler.instance.musicPlayerOpen,
      builder: (context, musicPlayerOpen, child) =>
          PopScope(canPop: !musicPlayerOpen, child: child!),
      child: Query(
        options: QueryOptions(
          document: documentNodeQueryartistById,
          variables: {'id': personId},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(result.exception.toString())),
            );
          }

          // Only show the skeleton on a cold load. With cacheAndNetwork
          // `isLoading` stays true while cached data is already available, and
          // a loaded-but-null person (hidden library, bad id) must show a
          // not-found message instead of skeletonizing forever.
          final loading = result.data == null && result.isLoading;
          final artist = result.data == null
              ? null
              : Query$artistById.fromJson(result.data!).artistById;

          // Albums, appears-on albums and books are fetched through their own
          // top-level, server-sorted queries (newest first) instead of the
          // person's unsorted association. All of them key off personId, which
          // is known up-front, so these nested Query widgets fire their network
          // requests in parallel.
          return Query(
            options: QueryOptions(
              document: documentNodeQueryalbums,
              variables: {
                'artistId': personId,
                'sorting': Enum$SortingEnum.RELEASE_YEAR,
                'sortingOrder': Enum$SortingOrder.DESCENDING,
                'page': 0,
                'size': 200,
              },
              fetchPolicy: FetchPolicy.cacheAndNetwork,
            ),
            builder:
                (
                  QueryResult albumsResult, {
                  VoidCallback? refetch,
                  FetchMore? fetchMore,
                }) {
                  final albums = albumsResult.data == null
                      ? const <Fragment$fragmentAlbum>[]
                      : (Query$albums.fromJson(albumsResult.data!)
                                .albums
                                ?.content ??
                            const <Fragment$fragmentAlbum>[]);
                  // The albums grid is part of the skeleton too: without this it
                  // pops in on its own once this query lands, after the person's
                  // own data already rendered.
                  final albumsLoading =
                      albumsResult.data == null && albumsResult.isLoading;

                  // Compilations and guest appearances: albums the person is
                  // credited on without owning them (disjoint from the query above).
                  return Query(
                    options: QueryOptions(
                      document: documentNodeQueryappearsOnAlbums,
                      variables: {'id': personId},
                      fetchPolicy: FetchPolicy.cacheAndNetwork,
                    ),
                    builder:
                        (
                          QueryResult appearsOnResult, {
                          VoidCallback? refetch,
                          FetchMore? fetchMore,
                        }) {
                          final appearsOn = appearsOnResult.data == null
                              ? const <Fragment$fragmentAlbum>[]
                              : (Query$appearsOnAlbums.fromJson(
                                      appearsOnResult.data!,
                                    ).albums?.content ??
                                    const <Fragment$fragmentAlbum>[]);

                          return Query(
                            options: QueryOptions(
                              document: documentNodeQuerybooks,
                              variables: {
                                'authorId': personId,
                                'sorting': Enum$SortingEnum.RELEASE_YEAR,
                                'sortingOrder': Enum$SortingOrder.DESCENDING,
                                'page': 0,
                                'size': 200,
                              },
                              fetchPolicy: FetchPolicy.cacheAndNetwork,
                            ),
                            builder:
                                (
                                  QueryResult booksResult, {
                                  VoidCallback? refetch,
                                  FetchMore? fetchMore,
                                }) {
                                  final books = booksResult.data == null
                                      ? const <Fragment$fragmentBook>[]
                                      : (Query$books.fromJson(booksResult.data!)
                                                .books
                                                ?.content ??
                                            const <Fragment$fragmentBook>[]);

                                  if (!loading && artist == null) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .personNotFound,
                                        ),
                                      ),
                                    );
                                  }

                                  final skeleton = loading || albumsLoading;
                                  final content = _buildContent(
                                    context,
                                    artist,
                                    albums,
                                    appearsOn,
                                    books,
                                    skeleton,
                                  );

                                  return Scaffold(
                                    body: skeleton
                                        ? Skeletonizer(
                                            enabled: true,
                                            child: content,
                                          )
                                        : content,
                                  );
                                },
                          );
                        },
                  );
                },
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Query$artistById$artistById? artist,
    List<Fragment$fragmentAlbum> albums,
    List<Fragment$fragmentAlbum> appearsOn,
    List<Fragment$fragmentBook> books,
    bool skeleton,
  ) {
    final loc = AppLocalizations.of(context)!;
    final credits = artist?.credits ?? [];
    final description = artist != null
        ? MetadataUtil.getDescription(artist.metadata)
        : null;
    // While the albums query is still out we don't know whether this person has
    // any, so the grid is drawn with placeholder tiles: reserving the space is
    // what keeps everything below it from jumping when the albums arrive.
    final albumPlaceholders = skeleton && albums.isEmpty ? 6 : 0;
    final hasAlbums = albums.isNotEmpty || albumPlaceholders > 0;
    final hasAppearsOn = appearsOn.isNotEmpty;
    final hasBooks = books.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          actions: [
            // Reserved while loading, so the app bar doesn't grow an icon.
            if (skeleton)
              const IconButton(onPressed: null, icon: Icon(Icons.history)),
            if (artist != null)
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: loc.playbackHistory,
                onPressed: () => showTrackScopePlaybackHistorySheet(
                  context,
                  serverName: serverName,
                  scope: Enum$TrackHistoryScope.ARTIST,
                  id: artist.id,
                ),
              ),
            if (skeleton && _showAdminActions)
              const IconButton(onPressed: null, icon: Icon(Icons.analytics)),
            if (artist != null && _showAdminActions)
              IconButton(
                icon: const Icon(Icons.analytics),
                tooltip: loc.refreshMetadataItem,
                onPressed: () => runServerTask(
                  context,
                  documentNodeMutationrefreshPerson,
                  loc.refreshMetadataItem,
                  variables: {'personId': artist.id},
                ),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHero(
              context,
              loc,
              artist,
              albums,
              appearsOn,
              books,
              skeleton: skeleton,
            ),
          ),
        ),
        if (hasAlbums)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: albums.isNotEmpty
                            ? () => AutoRouter.of(context)
                                  .push(AlbumRoute(albumId: albums.first.id))
                            : null,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(loc.play),
                        style: FilledButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: _accent != null
                              ? Colors.black
                              : null,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: albums.isNotEmpty
                            ? () {
                                final randomAlbum =
                                    albums[_random.nextInt(albums.length)];
                                AutoRouter.of(context)
                                    .push(AlbumRoute(albumId: randomAlbum.id));
                              }
                            : null,
                        icon: const Icon(Icons.shuffle),
                        label: Text(loc.shuffle),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSurface,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (description != null || skeleton)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ExpandableText(text: description ?? BoneMock.paragraph),
                      const SizedBox(height: 6),
                      SourceAttribution(
                        metadata: artist?.metadata,
                        images: artist?.images,
                        skeleton: skeleton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // The three top-track lists fetch through their own queries and share
        // one tab bar; only non-empty lists get a tab, and the whole section
        // stays away when every list is empty.
        SliverToBoxAdapter(
          child: _ArtistTrackTabs(
            serverName: serverName,
            personId: personId,
            reserveSpace: skeleton || albums.isNotEmpty || hasAppearsOn,
          ),
        ),
        if (hasAlbums) ...[
          _sectionHeader(context, loc.albums),
          _albumGrid(context, albums, placeholderCount: albumPlaceholders),
        ],
        // Compilations and guest appearances, newest added first; the tile
        // subtitle (the album artist) is what tells these apart.
        if (hasAppearsOn) ...[
          _sectionHeader(context, loc.appearsOn),
          _albumGrid(context, appearsOn),
        ],
        if (hasBooks) ...[
          _sectionHeader(context, loc.books),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: LayoutBuilder(
                  builder: (context, constraints) => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: mediaGridDelegate(
                      context,
                      constraints.maxWidth,
                      artAspectRatio: BookCarouselTile.coverAspectRatio,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) => BookCarouselTile(
                      serverName: serverName,
                      book: books[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (credits.isNotEmpty || skeleton)
          _buildFilmography(context, loc, credits, skeleton: skeleton),
      ],
    );
  }

  /// The album grid; with [placeholderCount] set it renders that many empty
  /// tiles instead — the page-level [Skeletonizer] turns those into bones.
  Widget _albumGrid(
    BuildContext context,
    List<Fragment$fragmentAlbum> albums, {
    int placeholderCount = 0,
  }) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1600),
          child: LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: mediaGridDelegate(
                context,
                constraints.maxWidth,
                artAspectRatio: 1.0,
              ),
              itemCount: placeholderCount > 0
                  ? placeholderCount
                  : albums.length,
              itemBuilder: (context, index) {
                if (placeholderCount > 0) {
                  return CarouselItemView(
                    serverName: serverName,
                    title: BoneMock.name,
                    subTitle: BoneMock.words(3),
                    placeholderIcon: Icons.music_note,
                  );
                }
                final album = albums[index];
                final img = ImageUtil.getImageByType(
                  album.images,
                  ImageTypes.cover,
                );
                return CarouselItemView(
                  serverName: serverName,
                  title: MetadataUtil.getTitle(album.metadata) ?? album.name,
                  subTitle: album.artist.name,
                  imageUrl: ImageUtil.buildUrl(
                    img,
                    token: StreamTokenService.getToken(serverName),
                  ),
                  blurHash: img?.blurHash,
                  placeholderIcon: Icons.music_note,
                  onTap: () =>
                      AutoRouter.of(context)
                          .push(AlbumRoute(albumId: album.id)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildFilmography(
    BuildContext context,
    AppLocalizations loc,
    List<Fragment$fragmentPersonCredit> credits, {
    bool skeleton = false,
  }) {
    // A person can hold several credits for the same title — a show-level credit
    // (with a role) plus one credit per episode. Merge everything per title so a
    // show shows up exactly once, with its episode count and role combined.
    final movies = <String, _MovieEntry>{};
    final shows = <String, _ShowEntry>{};

    for (final credit in credits) {
      final movie = credit.movie;
      final show = credit.$show;
      final episode = credit.episode;
      if (movie != null) {
        movies.putIfAbsent(
          movie.id,
          () => _MovieEntry(
            id: movie.id,
            name: movie.name,
            releaseYear: movie.releaseYear,
            images: movie.images,
            role: credit.characterName,
          ),
        );
      } else if (show != null) {
        final entry = shows.putIfAbsent(show.id, () => _ShowEntry(show.id));
        entry.name = show.name;
        entry.releaseYear = show.releaseYear;
        entry.images ??= show.images;
        entry.showRole ??= credit.characterName;
      } else if (episode != null && episode.$show != null) {
        final s = episode.$show!;
        final entry = shows.putIfAbsent(s.id, () => _ShowEntry(s.id));
        entry.name = s.name;
        entry.releaseYear = s.releaseYear;
        entry.images ??= s.images;
        entry.addEpisode(episode, credit.characterName);
      }
      // Credits without a resolvable media reference are skipped.
    }

    // Movies and shows share one list, sorted by release year (newest first).
    // This client-side sort is the authoritative filmography ordering: the server
    // returns credits by castOrder, but episode credits collapse into their show
    // here, so raw credit order can't express chronology. Unknown year (0) sorts
    // last under descending, matching the newest-first albums/books sections.
    // Tapping a movie opens the movie; tapping a show opens a sheet listing its
    // episodes, whose header links to the show and whose rows link to episodes.
    final entries = <({int releaseYear, Widget row})>[
      for (final m in movies.values)
        (
          releaseYear: m.releaseYear,
          row: _entryRow(
            context,
            name: m.name,
            subtitle: _subtitle(loc, year: m.releaseYear, role: m.role),
            images: m.images,
            onTap: () => AutoRouter.of(context).push(MovieRoute(movieId: m.id)),
          ),
        ),
      for (final s in shows.values)
        (
          releaseYear: s.releaseYear,
          row: _entryRow(
            context,
            name: s.name,
            subtitle: _subtitle(
              loc,
              year: s.releaseYear,
              episodeCount: s.episodeCount > 0 ? s.episodeCount : null,
              role: s.role,
            ),
            images: s.images,
            onTap: () => _showEpisodesSheet(context, s),
            placeholderIcon: Icons.tv,
          ),
        ),
    ]..sort((a, b) => b.releaseYear.compareTo(a.releaseYear));

    // Placeholder rows while the person is still loading: the filmography is
    // usually the tallest section on an actor page, and leaving it out meant
    // the whole thing dropped in at once.
    final rows = skeleton && entries.isEmpty
        ? [
            for (int i = 0; i < _skeletonCreditCount; i++)
              _entryRow(
                context,
                name: BoneMock.name,
                subtitle: BoneMock.words(2),
                images: null,
                onTap: null,
              ),
          ]
        : [for (final e in entries) e.row];

    if (rows.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  loc.appearsIn,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...rows,
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Joins the release year, episode count and role into a single subtitle
  /// line, e.g. "1984 · 65 afleveringen · Johnny Lawrence". Any part may be
  /// absent (a year of 0 means unknown and is dropped).
  String? _subtitle(
    AppLocalizations loc, {
    int? year,
    int? episodeCount,
    String? role,
  }) {
    final parts = <String>[
      if (year != null && year > 0) '$year',
      if (episodeCount != null) loc.episodeCount(episodeCount),
      if ((role ?? '').isNotEmpty) role!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Widget _entryRow(
    BuildContext context, {
    required String name,
    String? subtitle,
    List<Fragment$fragmentImages>? images,
    required VoidCallback? onTap,
    IconData placeholderIcon = Icons.movie,
  }) {
    // Prefer the portrait poster/cover so it isn't cropped into a landscape
    // frame; fall back to the wide background art.
    final img =
        ImageUtil.getImageByType(images, ImageTypes.cover) ??
        ImageUtil.getImageByType(images, ImageTypes.background);
    final imageUrl = ImageUtil.buildUrl(
      img,
      token: StreamTokenService.getToken(serverName),
    );
    final placeholder = Icon(
      placeholderIcon,
      size: 32,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: 108 * BookCarouselTile.coverAspectRatio,
                height: 108,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: (imageUrl != null && imageUrl != '')
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          cacheKey: ImageUtil.cacheKeyFor(imageUrl),
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorBuilder: (_, __, ___) =>
                              Center(child: placeholder),
                        )
                      : Center(child: placeholder),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if ((subtitle ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showEpisodesSheet(BuildContext context, _ShowEntry entry) {
    // Resolve the router from the page context, lazily at tap time; inside
    // the modal the sheet's own context can't resolve the server-scoped route
    // tree reliably.
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PersonShowEpisodesSheet(
        serverName: serverName,
        resolveRouter: () => AutoRouter.of(context),
        showId: entry.showId,
        showName: entry.name,
        episodes: entry.episodes,
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    AppLocalizations loc,
    Query$artistById$artistById? artist,
    List<Fragment$fragmentAlbum> albums,
    List<Fragment$fragmentAlbum> appearsOn,
    List<Fragment$fragmentBook> books, {
    bool skeleton = false,
  }) {
    final backgroundImg = artist != null
        ? ImageUtil.getImageByType(artist.images, ImageTypes.background)
        : null;
    // Actors have no background art and no albums — their photo is a COVER
    // image (the TMDB profile). Fall back to that so the person still gets a
    // portrait in the hero instead of the placeholder icon.
    final personCoverImg = artist != null
        ? ImageUtil.getImageByType(artist.images, ImageTypes.cover)
        : null;
    // Guest artists without an album of their own still get a cover: the
    // newest album they appear on.
    final firstAlbum = albums.isNotEmpty ? albums.first : appearsOn.firstOrNull;
    final firstAlbumCoverImg = firstAlbum != null
        ? ImageUtil.getImageByType(firstAlbum.images, ImageTypes.cover)
        : null;
    final heroImg = backgroundImg ?? personCoverImg ?? firstAlbumCoverImg;
    final imageUrl = heroImg != null
        ? ImageUtil.buildUrl(
            heroImg,
            token: StreamTokenService.getToken(serverName),
          )
        : null;
    _updateAccent(imageUrl);

    final name = artist != null
        ? MetadataUtil.titleWithYear(
            MetadataUtil.getTitle(artist.metadata) ?? artist.name,
            artist.birthYear,
          )
        : null;

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: heroImg?.blurHash,
      title: name,
      subtitle: artist != null
          ? _heroSubtitle(loc, artist, albums.length, books.length)
          : null,
      backgroundAlignment: Alignment.topCenter,
      placeholderIcon: Icons.person,
      // Person photos (TMDB profiles) are portraits, not square album art.
      coverAspectRatio: BookCarouselTile.coverAspectRatio,
      skeleton: skeleton,
    );
  }

  /// Summarises what a person has, showing only the categories they actually
  /// appear in — e.g. "2 films" or "3 albums · 1 serie", never "0 albums".
  String? _heroSubtitle(
    AppLocalizations loc,
    Query$artistById$artistById artist,
    int albumCount,
    int bookCount,
  ) {
    // Count distinct movies and shows across the credits, mirroring how the
    // filmography merges episode credits back onto their show.
    final movieIds = <String>{};
    final showIds = <String>{};
    for (final credit in artist.credits ?? const []) {
      final movie = credit.movie;
      final show = credit.$show;
      final episode = credit.episode;
      if (movie != null) {
        movieIds.add(movie.id);
      } else if (show != null) {
        showIds.add(show.id);
      } else if (episode?.$show != null) {
        showIds.add(episode!.$show!.id);
      }
    }

    final genre = MetadataUtil.getGenre(artist.metadata);
    final parts = <String>[
      if ((genre ?? '').isNotEmpty) genre!,
      if (albumCount > 0) loc.albumCount(albumCount),
      if (bookCount > 0) loc.bookCount(bookCount),
      if (movieIds.isNotEmpty) loc.movieCount(movieIds.length),
      if (showIds.isNotEmpty) loc.showCount(showIds.length),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// A movie a person is credited in.
class _MovieEntry {
  _MovieEntry({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.images,
    required this.role,
  });

  final String id;
  final String name;
  final int releaseYear;
  final List<Fragment$fragmentImages>? images;
  final String? role;
}

/// All of a person's credits for one show, merged: a show-level credit (with a
/// role) and any per-episode credits. Episodes are de-duplicated by id (a person
/// can hold more than one credit on the same episode, e.g. cast + guest star).
class _ShowEntry {
  _ShowEntry(this.showId);

  final String showId;
  String name = '';
  int releaseYear = 0;
  List<Fragment$fragmentImages>? images;

  /// Role from a show-level credit; wins over per-episode roles when present.
  String? showRole;
  String? _episodeRole;
  final Map<String, Fragment$fragmentPersonCredit$episode> _episodesById = {};

  void addEpisode(
    Fragment$fragmentPersonCredit$episode episode,
    String? character,
  ) {
    _episodesById[episode.id] = episode;
    if ((_episodeRole ?? '').isEmpty && (character ?? '').isNotEmpty) {
      _episodeRole = character;
    }
  }

  List<Fragment$fragmentPersonCredit$episode> get episodes =>
      _episodesById.values.toList();

  int get episodeCount => _episodesById.length;

  String? get role => (showRole ?? '').isNotEmpty ? showRole : _episodeRole;
}

/// One season's worth of a person's episodes, ready to render in the sheet.
class _SeasonBucket {
  _SeasonBucket({required this.id, this.number});

  final String id;
  final int? number;
  final List<Fragment$fragmentPersonCredit$episode> episodes = [];
}

/// Bottom sheet listing the episodes a person appears in for one show, grouped
/// under the same expandable season bar used on the show overview page.
class _PersonShowEpisodesSheet extends StatefulWidget {
  const _PersonShowEpisodesSheet({
    required this.serverName,
    required this.resolveRouter,
    required this.showId,
    required this.showName,
    required this.episodes,
  });

  final String serverName;
  final StackRouter Function() resolveRouter;
  final String showId;
  final String showName;
  final List<Fragment$fragmentPersonCredit$episode> episodes;

  @override
  State<_PersonShowEpisodesSheet> createState() =>
      _PersonShowEpisodesSheetState();
}

class _PersonShowEpisodesSheetState extends State<_PersonShowEpisodesSheet> {
  late final List<_SeasonBucket> _seasons;
  String? _expandedSeasonId;

  @override
  void initState() {
    super.initState();
    _seasons = _groupBySeason(widget.episodes);
    // Auto-expand when there is only a single season to save a tap.
    if (_seasons.length == 1) {
      _expandedSeasonId = _seasons.first.id;
    }
  }

  List<_SeasonBucket> _groupBySeason(
    List<Fragment$fragmentPersonCredit$episode> episodes,
  ) {
    const noSeasonKey = '__none__';
    final buckets = <String, _SeasonBucket>{};
    for (final episode in episodes) {
      final season = episode.season;
      final key = season?.id ?? noSeasonKey;
      buckets
          .putIfAbsent(
            key,
            () => _SeasonBucket(id: key, number: season?.number),
          )
          .episodes
          .add(episode);
    }
    // Unknown seasons sort last; episodes within a season sort by number.
    const last = 1 << 30;
    final ordered = buckets.values.toList()
      ..sort((a, b) => (a.number ?? last).compareTo(b.number ?? last));
    for (final bucket in ordered) {
      bucket.episodes.sort((a, b) => a.number.compareTo(b.number));
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The header links to the show itself; episodes below link to
              // their episode. Pop the sheet first so the page can navigate.
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.resolveRouter().push(
                    ShowOverviewRoute(showId: widget.showId),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.showName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    _expandedSeasonId = isExpanded ? _seasons[index].id : null;
                  });
                },
                children: _seasons.map<ExpansionPanel>((bucket) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(
                        bucket.number != null
                            ? loc.season(bucket.number!)
                            : widget.showName,
                      ),
                      subtitle: Text(loc.episodeCount(bucket.episodes.length)),
                    ),
                    body: Column(
                      children: bucket.episodes
                          .map((episode) => _episodeTile(context, loc, episode))
                          .toList(),
                    ),
                    isExpanded: _expandedSeasonId == bucket.id,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _episodeTile(
    BuildContext context,
    AppLocalizations loc,
    Fragment$fragmentPersonCredit$episode episode,
  ) {
    final metaTitle = MetadataUtil.getTitle(episode.metadata);
    final title = metaTitle ?? loc.episode(episode.number);
    final img =
        ImageUtil.getImageByType(episode.images, ImageTypes.background) ??
        ImageUtil.getImageByType(episode.images, ImageTypes.cover);
    final imageUrl = ImageUtil.buildUrl(
      img,
      token: StreamTokenService.getToken(widget.serverName),
    );
    final showId = episode.$show?.id;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 80,
          height: 56,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: (imageUrl != null && imageUrl != '')
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  cacheKey: ImageUtil.cacheKeyFor(imageUrl),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: metaTitle != null ? Text(loc.episode(episode.number)) : null,
      onTap: showId == null
          ? null
          : () {
              Navigator.of(context).pop();
              // ShowEpisodeRoute is a child of ShowOverviewRoute, so from
              // outside the show shell it must be pushed through its parent.
              widget.resolveRouter().push(
                ShowOverviewRoute(
                  showId: showId,
                  children: [
                    ShowEpisodeRoute(showId: showId, episodeId: episode.id),
                  ],
                ),
              );
            },
    );
  }
}

/// One tab's worth of top-track list: its label, list variant and the query
/// that fills it.
class _ArtistTrackTabConfig {
  const _ArtistTrackTabConfig({
    required this.title,
    required this.variant,
    required this.document,
    required this.parse,
  });

  final String title;
  final ArtistTrackListVariant variant;
  final DocumentNode document;
  final List<ArtistTrackListItem> Function(Map<String, dynamic> data) parse;
}

/// The top-track section on the artist page: most played, last played and
/// highest rated behind the same underline tabs as the play-queue overlay.
/// Each list runs its own GraphQL query; empty (or failed) lists get no tab,
/// and the section renders nothing at all while every list is empty — it is
/// additive and must never block the page.
///
/// These per-user rankings aggregate over the whole play history server-side
/// and land well after the albums, so with [reserveSpace] the section holds a
/// skeleton of its own footprint while they are in flight instead of shoving
/// the albums grid down when the first one arrives.
class _ArtistTrackTabs extends StatefulWidget {
  const _ArtistTrackTabs({
    required this.serverName,
    required this.personId,
    required this.reserveSpace,
  });

  final String serverName;
  final String personId;

  /// Whether this person is known to have music at all — only then is a track
  /// list likely enough to be worth reserving space for. An actor would
  /// otherwise get a phantom list that vanishes again.
  final bool reserveSpace;

  @override
  State<_ArtistTrackTabs> createState() => _ArtistTrackTabsState();
}

class _ArtistTrackTabsState extends State<_ArtistTrackTabs> {
  // Keyed by variant, not by index: the queries resolve at different times,
  // so an earlier tab can appear after the user already picked a later one.
  ArtistTrackListVariant? _selectedVariant;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final configs = <_ArtistTrackTabConfig>[
      _ArtistTrackTabConfig(
        title: loc.mostPlayedTracks,
        variant: ArtistTrackListVariant.plays,
        document: documentNodeQuerytopPlayedTracksByArtist,
        parse: (data) =>
            (Query$topPlayedTracksByArtist.fromJson(data)
                        .personById
                        ?.topPlayedTracks ??
                    const [])
                .map(
                  (t) => ArtistTrackListItem(
                    track: t,
                    album: t.album,
                    playCount: t.playCount,
                  ),
                )
                .toList(),
      ),
      _ArtistTrackTabConfig(
        title: loc.recentlyPlayedTracks,
        variant: ArtistTrackListVariant.recency,
        document: documentNodeQueryrecentlyPlayedTracksByArtist,
        parse: (data) =>
            (Query$recentlyPlayedTracksByArtist.fromJson(data)
                        .personById
                        ?.recentlyPlayedTracks ??
                    const [])
                .map(
                  (t) => ArtistTrackListItem(
                    track: t,
                    album: t.album,
                    lastPlayedAt: t.lastPlayedAt != null
                        ? DateTime.tryParse(t.lastPlayedAt!)?.toLocal()
                        : null,
                  ),
                )
                .toList(),
      ),
      _ArtistTrackTabConfig(
        title: loc.highestRatedTracks,
        variant: ArtistTrackListVariant.rating,
        document: documentNodeQuerytopRatedTracksByArtist,
        parse: (data) =>
            (Query$topRatedTracksByArtist.fromJson(data)
                        .personById
                        ?.topRatedTracks ??
                    const [])
                .map((t) => ArtistTrackListItem(track: t, album: t.album))
                .toList(),
      ),
      // Not a per-user ranking: the newest tracks by this artist (incl. guest
      // spots) by the date they were added to the library.
      _ArtistTrackTabConfig(
        title: loc.recentlyAdded,
        variant: ArtistTrackListVariant.added,
        document: documentNodeQueryrecentlyAddedTracksByArtist,
        parse: (data) =>
            (Query$recentlyAddedTracksByArtist.fromJson(data)
                        .personById
                        ?.recentlyAddedTracks ??
                    const [])
                .map(
                  (t) => ArtistTrackListItem(
                    track: t,
                    album: t.album,
                    dateAdded: t.dateAdded != null
                        ? DateTime.tryParse(t.dateAdded!)?.toLocal()
                        : null,
                  ),
                )
                .toList(),
      ),
    ];

    return _TrackListQuery(
      personId: widget.personId,
      config: configs[0],
      builder: (plays) => _TrackListQuery(
        personId: widget.personId,
        config: configs[1],
        builder: (recency) => _TrackListQuery(
          personId: widget.personId,
          config: configs[2],
          builder: (rating) => _TrackListQuery(
            personId: widget.personId,
            config: configs[3],
            builder: (added) => _buildTabs(context, [
              (config: configs[0], section: plays),
              (config: configs[1], section: recency),
              (config: configs[2], section: rating),
              (config: configs[3], section: added),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(
    BuildContext context,
    List<({_ArtistTrackTabConfig config, _TrackSection section})> sections,
  ) {
    final visible = sections.where((s) => s.section.items.isNotEmpty).toList();
    if (visible.isEmpty) {
      // Nothing yet: hold the footprint while a query is still coming, so the
      // sections below don't shift once it lands.
      final stillLoading = sections.any((s) => s.section.loading);
      if (!widget.reserveSpace || !stillLoading) {
        return const SizedBox.shrink();
      }
      // The labels are known up-front, so the placeholder tab bar is the real
      // one — greyed out with the rows by the skeletonizer.
      return _sectionFrame(
        tabs: Skeletonizer(
          enabled: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final s in sections)
                _buildTab(
                  s.config.title,
                  s.config.variant,
                  selected: s.config.variant == sections.first.config.variant,
                  enabled: false,
                ),
            ],
          ),
        ),
        list: const ArtistTrackListSkeleton(),
      );
    }

    final selected =
        visible
            .where((s) => s.config.variant == _selectedVariant)
            .firstOrNull ??
        visible.first;

    return _sectionFrame(
      tabs: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final section in visible)
            _buildTab(
              section.config.title,
              section.config.variant,
              selected: section.config.variant == selected.config.variant,
            ),
        ],
      ),
      list: ArtistTrackList(
        // A fresh list per variant, so ArtistTrackList's expand state
        // and rating overrides don't leak between tabs.
        key: ValueKey(selected.config.variant),
        items: selected.section.items,
        serverName: widget.serverName,
        personId: widget.personId,
        variant: selected.config.variant,
      ),
    );
  }

  /// The section's shell — the same tab bar + divider + list layout for the
  /// real lists and for the loading placeholder, so swapping one for the other
  /// changes nothing about the page's geometry.
  Widget _sectionFrame({required Widget tabs, required Widget list}) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: tabs,
                  ),
                  const Divider(height: 1, thickness: 1),
                ],
              ),
            ),
            list,
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    String label,
    ArtistTrackListVariant variant, {
    required bool selected,
    bool enabled = true,
  }) {
    final colors = Theme.of(context).colorScheme;
    void select() {
      if (enabled) setState(() => _selectedVariant = variant);
    }

    return TvFocusable(
      onTap: select,
      borderRadius: BorderRadius.circular(4),
      child: GestureDetector(
        onTap: select,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? colors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// One top-track query's outcome: the rows it produced, and whether it is
/// still on its first (cold) trip to the server.
typedef _TrackSection = ({List<ArtistTrackListItem> items, bool loading});

/// Runs one top-track query and hands the parsed rows to [builder] — an empty
/// list on error or while loading, so the tabs simply appear as data arrives.
class _TrackListQuery extends StatelessWidget {
  const _TrackListQuery({
    required this.personId,
    required this.config,
    required this.builder,
  });

  final String personId;
  final _ArtistTrackTabConfig config;
  final Widget Function(_TrackSection section) builder;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: config.document,
        variables: {'id': personId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder:
          (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
            final items = (result.hasException || result.data == null)
                ? const <ArtistTrackListItem>[]
                : config.parse(result.data!);
            // Cold load only: with cacheAndNetwork `isLoading` stays true while
            // revalidating on top of cached data, and re-skeletonizing then would
            // make the page jump — the very thing this reserves space against.
            final loading =
                result.data == null && result.isLoading && !result.hasException;
            return builder((items: items, loading: loading));
          },
    );
  }
}
