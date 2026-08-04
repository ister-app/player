import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/discoverAlbums.graphql.dart';
import 'package:player/graphql/discoverBooks.graphql.dart';
import 'package:player/graphql/discoverMovies.graphql.dart';
import 'package:player/graphql/discoverPodcasts.graphql.dart';
import 'package:player/graphql/discoverSeries.graphql.dart';
import 'package:player/graphql/discoverShows.graphql.dart';
import 'package:player/graphql/fragmentPlaylist.graphql.dart';
import 'package:player/graphql/playlists.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../pages/MediaListPage.dart';
import '../utils/LoggerService.dart';
import 'RowHeader.dart';
import 'AlbumCarouselTile.dart';
import 'AlbumSlide.dart';
import 'BookCarouselTile.dart';
import 'BookSlide.dart';
import 'CarouselItemView.dart';
import 'MovieSlide.dart';
import 'PlaylistCoverMosaic.dart';
import 'PodcastCarouselTile.dart';
import 'PodcastSlide.dart';
import 'RecentCarouselView.dart';
import 'SeriesCarouselTile.dart';
import 'SeriesSlide.dart';
import 'TvShowSlide.dart';

/// The library tab's Discover view: a continue-watching row scoped to the
/// library, the newest additions, and the user's personal top-lists
/// (recently/most played, highest rated — whichever apply to the library
/// type). Rows without content hide themselves; when the server predates the
/// libraryById query the ranked rows simply stay away.
class LibraryDiscoverView extends StatefulWidget {
  final String serverName;
  final String libraryId;
  final Enum$LibraryType libraryType;

  const LibraryDiscoverView({
    super.key,
    required this.serverName,
    required this.libraryId,
    required this.libraryType,
  });

  static const int rankedRowLimit = 15;

  @override
  State<LibraryDiscoverView> createState() => _LibraryDiscoverViewState();
}

/// One ranked carousel: a header plus the items the server returned for it.
class _RankedRow {
  final String label;
  final MediaListKind kind;
  final List<Widget> tiles;
  final double tileWidth;

  _RankedRow(this.label, this.kind, this.tiles, this.tileWidth);
}

class _LibraryDiscoverViewState extends State<LibraryDiscoverView> {
  static const double _rowHeight = 200;
  static const double _landscapeTileWidth = 300;
  static const double _squareTileWidth = 200;
  static const double _portraitTileWidth =
      _rowHeight * BookCarouselTile.coverAspectRatio;

  bool _recentEmpty = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      // Attach to ShowHomePage's NestedScrollView so the view-selector header
      // scrolls away with the rows (desktop does not inherit it implicitly).
      primary: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        if (!_recentEmpty) ...[
          RowHeader(
            label: loc.watchNext,
            onTap: () => _pushList(context, MediaListKind.watchNext),
          ),
          SizedBox(
            height: _rowHeight,
            child: RecentCarouselView(
              serverName: widget.serverName,
              libraryId: widget.libraryId,
              onEmptyView: () {
                Future.microtask(() {
                  if (mounted) setState(() => _recentEmpty = true);
                });
              },
            ),
          ),
        ],
        RowHeader(
          label: loc.recentlyAdded,
          onTap: () => _pushList(context, MediaListKind.recentlyAdded),
        ),
        SizedBox(height: _rowHeight, child: _recentlyAddedSlide()),
        _playlistsRow(context),
        _rankedRowsQuery(context),
      ],
    );
  }

  void _pushList(BuildContext context, MediaListKind kind) {
    AutoRouter.of(context).push(MediaListRoute(
      kindName: kind.urlValue,
      libraryId: widget.libraryId,
      libraryTypeName: widget.libraryType.name,
    ));
  }

  /// The newest items of the library — the existing home-page carousels,
  /// which also work against servers without the discover top-lists.
  Widget _recentlyAddedSlide() {
    switch (widget.libraryType) {
      case Enum$LibraryType.SHOW:
        return TvShowSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
      case Enum$LibraryType.MUSIC:
        return AlbumSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
      case Enum$LibraryType.BOOK:
        return BookSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
      case Enum$LibraryType.COMIC:
        return SeriesSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
      case Enum$LibraryType.PODCAST:
        return PodcastSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
      default:
        return MovieSlide(
            serverName: widget.serverName, libraryId: widget.libraryId);
    }
  }

  DocumentNode get _rankedDocument {
    switch (widget.libraryType) {
      case Enum$LibraryType.SHOW:
        return documentNodeQuerydiscoverShows;
      case Enum$LibraryType.MUSIC:
        return documentNodeQuerydiscoverAlbums;
      case Enum$LibraryType.BOOK:
        return documentNodeQuerydiscoverBooks;
      case Enum$LibraryType.COMIC:
        return documentNodeQuerydiscoverSeries;
      case Enum$LibraryType.PODCAST:
        return documentNodeQuerydiscoverPodcasts;
      default:
        return documentNodeQuerydiscoverMovies;
    }
  }

  /// The user's playlists in this library. Hidden when empty, and silently
  /// absent against an older server without the playlists query. COMIC
  /// libraries cannot have playlists, so the query is skipped there.
  Widget _playlistsRow(BuildContext context) {
    if (widget.libraryType == Enum$LibraryType.COMIC) {
      return const SizedBox.shrink();
    }
    final loc = AppLocalizations.of(context)!;
    return Query(
      options: QueryOptions(
        document: documentNodeQueryplaylists,
        variables:
            Variables$Query$playlists(libraryId: widget.libraryId).toJson(),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (result.hasException || result.data == null) {
          if (result.hasException) {
            LoggerService()
                .logger
                .w('Playlists unavailable: ${result.exception}');
          }
          return const SizedBox.shrink();
        }
        final playlists = Query$playlists.fromJson(result.data!).playlists;
        // No playlists, no row: an empty carousel (or a header with a hint)
        // is dead space between the rows that do have content. The first
        // playlist is made from the add-to-playlist sheet or by saving a
        // browse filter, both of which lead here afterwards.
        if (playlists.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowHeader(
              label: loc.playlists,
              onTap: () => AutoRouter.of(context).push(PlaylistListRoute(
                libraryId: widget.libraryId,
                libraryTypeName: widget.libraryType.name,
              )),
            ),
            SizedBox(
              height: _rowHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: _squareTileWidth,
                itemCount: playlists.length,
                itemBuilder: (context, index) =>
                    _playlistTile(context, playlists[index]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _playlistTile(
      BuildContext context, Fragment$fragmentPlaylist playlist) {
    final loc = AppLocalizations.of(context)!;
    final placeholderIcon = widget.libraryType == Enum$LibraryType.MUSIC
        ? Icons.queue_music
        : Icons.playlist_play;
    return CarouselItemView(
      serverName: widget.serverName,
      title: playlist.name,
      subTitle: playlist.type == Enum$PlaylistType.SMART
          ? loc.smartPlaylist
          : loc.playlistItemCount(playlist.itemCount ?? 0),
      placeholderIcon: placeholderIcon,
      // A playlist has no cover of its own: it wears the covers of its first
      // items, so it does not read as a hole next to the album art around it.
      artwork: PlaylistCoverMosaic(
        serverName: widget.serverName,
        covers: playlist.coverImages,
        placeholderIcon: placeholderIcon,
        borderRadius: 0,
      ),
      onTap: () => AutoRouter.of(context)
          .push(PlaylistRoute(playlistId: playlist.id)),
    );
  }

  Widget _rankedRowsQuery(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: _rankedDocument,
        variables: {
          'libraryId': widget.libraryId,
          'limit': LibraryDiscoverView.rankedRowLimit,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          // An older server has no libraryById query yet: keep the rows that
          // do work (continue watching, recently added) and log the rest away.
          LoggerService()
              .logger
              .w('Discover top-lists unavailable: ${result.exception}');
          return const SizedBox.shrink();
        }
        if (result.data == null) {
          return _skeletonRow(context);
        }
        final rows = _parseRows(context, result.data!)
            .where((row) => row.tiles.isNotEmpty)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final row in rows) ...[
              RowHeader(
                label: row.label,
                onTap: () => _pushList(context, row.kind),
              ),
              SizedBox(
                height: _rowHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemExtent: row.tileWidth,
                  itemCount: row.tiles.length,
                  itemBuilder: (context, index) => row.tiles[index],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _skeletonRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowHeader(label: AppLocalizations.of(context)!.recentlyPlayed),
        SizedBox(
          height: _rowHeight,
          child: Skeletonizer(
            enabled: true,
            child: ListView(
              scrollDirection: Axis.horizontal,
              itemExtent: _landscapeTileWidth,
              children: List.filled(
                  7,
                  CarouselItemView(
                    serverName: widget.serverName,
                    title: BoneMock.name,
                    subTitle: BoneMock.words(10),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  List<_RankedRow> _parseRows(BuildContext context, Map<String, dynamic> data) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.libraryType) {
      case Enum$LibraryType.SHOW:
        final library = Query$discoverShows.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyPlayed,
              MediaListKind.recentlyPlayed,
              library.recentlyPlayedShows.map(_showTile).toList(),
              _landscapeTileWidth),
          _RankedRow(
              loc.mostPlayed,
              MediaListKind.mostPlayed,
              library.mostPlayedShows.map(_showTile).toList(),
              _landscapeTileWidth),
          _RankedRow(
              loc.highestRated,
              MediaListKind.highestRated,
              library.highestRatedShows.map(_showTile).toList(),
              _landscapeTileWidth),
        ];
      case Enum$LibraryType.MUSIC:
        final library = Query$discoverAlbums.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyPlayed,
              MediaListKind.recentlyPlayed,
              library.recentlyPlayedAlbums.map(_albumTile).toList(),
              _squareTileWidth),
          _RankedRow(
              loc.mostPlayed,
              MediaListKind.mostPlayed,
              library.mostPlayedAlbums.map(_albumTile).toList(),
              _squareTileWidth),
          _RankedRow(
              loc.highestRated,
              MediaListKind.highestRated,
              library.highestRatedAlbums.map(_albumTile).toList(),
              _squareTileWidth),
        ];
      case Enum$LibraryType.BOOK:
        final library = Query$discoverBooks.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyRead,
              MediaListKind.recentlyPlayed,
              library.recentlyReadBooks.map(_bookTile).toList(),
              _portraitTileWidth),
          _RankedRow(
              loc.highestRated,
              MediaListKind.highestRated,
              library.highestRatedBooks.map(_bookTile).toList(),
              _portraitTileWidth),
        ];
      case Enum$LibraryType.COMIC:
        final library = Query$discoverSeries.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyRead,
              MediaListKind.recentlyPlayed,
              library.recentlyReadSeries.map(_seriesTile).toList(),
              _portraitTileWidth),
        ];
      case Enum$LibraryType.PODCAST:
        final library = Query$discoverPodcasts.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyPlayed,
              MediaListKind.recentlyPlayed,
              library.recentlyPlayedPodcasts.map(_podcastTile).toList(),
              _squareTileWidth),
          _RankedRow(
              loc.mostPlayed,
              MediaListKind.mostPlayed,
              library.mostPlayedPodcasts.map(_podcastTile).toList(),
              _squareTileWidth),
          _RankedRow(
              loc.highestRated,
              MediaListKind.highestRated,
              library.highestRatedPodcasts.map(_podcastTile).toList(),
              _squareTileWidth),
        ];
      default:
        final library = Query$discoverMovies.fromJson(data).libraryById;
        if (library == null) return [];
        return [
          _RankedRow(
              loc.recentlyPlayed,
              MediaListKind.recentlyPlayed,
              library.recentlyPlayedMovies.map(_movieTile).toList(),
              _landscapeTileWidth),
          _RankedRow(
              loc.mostPlayed,
              MediaListKind.mostPlayed,
              library.mostPlayedMovies.map(_movieTile).toList(),
              _landscapeTileWidth),
          _RankedRow(
              loc.highestRated,
              MediaListKind.highestRated,
              library.highestRatedMovies.map(_movieTile).toList(),
              _landscapeTileWidth),
        ];
    }
  }

  // The generated classes differ per top-list field (recentlyPlayedMovies,
  // mostPlayedMovies, ... each get their own type with identical fields), so
  // the tile builders take them dynamically.
  Widget _movieTile(dynamic movie) {
    final img = ImageUtil.getImageByType(movie.images, ImageTypes.background);
    return CarouselItemView(
      serverName: widget.serverName,
      title: MetadataUtil.getTitle(movie.metadata) ?? movie.name,
      subTitle: MetadataUtil.getDescription(movie.metadata) ?? '',
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(widget.serverName)),
      blurHash: img?.blurHash,
      onTap: () => AutoRouter.of(context).push(MovieRoute(movieId: movie.id)),
    );
  }

  Widget _showTile(dynamic show) {
    final img = ImageUtil.getImageByType(show.images, ImageTypes.background);
    return CarouselItemView(
      serverName: widget.serverName,
      title: MetadataUtil.getTitle(show.metadata) ?? show.name,
      subTitle: MetadataUtil.getDescription(show.metadata) ?? '',
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(widget.serverName)),
      blurHash: img?.blurHash,
      onTap: () =>
          AutoRouter.of(context).push(ShowOverviewRoute(showId: show.id)),
    );
  }

  Widget _albumTile(album) =>
      AlbumCarouselTile(serverName: widget.serverName, album: album);

  Widget _bookTile(book) =>
      BookCarouselTile(serverName: widget.serverName, book: book);

  Widget _seriesTile(series) =>
      SeriesCarouselTile(serverName: widget.serverName, series: series);

  Widget _podcastTile(podcast) =>
      PodcastCarouselTile(serverName: widget.serverName, podcast: podcast);
}
