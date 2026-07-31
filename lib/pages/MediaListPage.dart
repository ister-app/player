import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentBook.graphql.dart';
import 'package:player/graphql/fragmentPodcast.graphql.dart';
import 'package:player/graphql/fragmentSeries.graphql.dart';
import 'package:player/graphql/rankedAlbums.graphql.dart';
import 'package:player/graphql/rankedBooks.graphql.dart';
import 'package:player/graphql/rankedMovies.graphql.dart';
import 'package:player/graphql/rankedPodcasts.graphql.dart';
import 'package:player/graphql/rankedSeries.graphql.dart';
import 'package:player/graphql/rankedShows.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../components/AlbumCarouselTile.dart';
import '../components/AlbumScroll.dart';
import '../components/BookCarouselTile.dart';
import '../components/BookScroll.dart';
import '../components/CarouselItemView.dart';
import '../components/MovieScroll.dart';
import '../components/PagedContentView.dart';
import '../components/PodcastCarouselTile.dart';
import '../components/PodcastScroll.dart';
import '../components/RecentCarouselView.dart';
import '../components/SeriesCarouselTile.dart';
import '../components/SeriesScroll.dart';
import '../components/TvShowScroll.dart';
import '../l10n/app_localizations.dart';

/// Which carousel a [MediaListPage] shows in full.
enum MediaListKind { watchNext, recentlyAdded, recentlyPlayed, mostPlayed, highestRated }

/// URL round-trip for [MediaListKind]: kebab-case in the `kind` query param,
/// unknown/absent values fall back to watch-next so a bare or hand-mangled
/// URL still renders something sensible.
extension MediaListKindUrl on MediaListKind {
  String get urlValue {
    switch (this) {
      case MediaListKind.watchNext:
        return 'watch-next';
      case MediaListKind.recentlyAdded:
        return 'recently-added';
      case MediaListKind.recentlyPlayed:
        return 'recently-played';
      case MediaListKind.mostPlayed:
        return 'most-played';
      case MediaListKind.highestRated:
        return 'highest-rated';
    }
  }

  static MediaListKind parse(String? value) =>
      MediaListKind.values.firstWhere((k) => k.urlValue == value,
          orElse: () => MediaListKind.watchNext);
}

/// The vertical "show all" page behind a carousel header: the same items as
/// the row it was opened from, as a paged grid. All context travels as query
/// params so the page is bookmarkable.
@RoutePage()
class MediaListPage extends StatelessWidget {
  const MediaListPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam('kind') this.kindName,
    @QueryParam('libraryId') this.libraryId,
    @QueryParam('libraryType') this.libraryTypeName,
  });

  final String serverName;
  final String? kindName;

  /// The library the row was scoped to; null only for the home page's
  /// server-wide continue-watching row.
  final String? libraryId;
  final String? libraryTypeName;

  MediaListKind get kind => MediaListKindUrl.parse(kindName);

  Enum$LibraryType? get libraryType {
    if (libraryTypeName == null) return null;
    final parsed = Enum$LibraryType.values.firstWhere(
        (t) => t.name == libraryTypeName,
        orElse: () => Enum$LibraryType.$unknown);
    return parsed == Enum$LibraryType.$unknown ? null : parsed;
  }

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title(context))),
      body: _body(context),
    );
  }

  String _title(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final reads = libraryType == Enum$LibraryType.BOOK ||
        libraryType == Enum$LibraryType.COMIC;
    switch (kind) {
      case MediaListKind.watchNext:
        return loc.watchNext;
      case MediaListKind.recentlyAdded:
        return loc.recentlyAdded;
      case MediaListKind.recentlyPlayed:
        return reads ? loc.recentlyRead : loc.recentlyPlayed;
      case MediaListKind.mostPlayed:
        return loc.mostPlayed;
      case MediaListKind.highestRated:
        return loc.highestRated;
    }
  }

  Widget _body(BuildContext context) {
    switch (kind) {
      case MediaListKind.watchNext:
        return RecentCarouselView(
          serverName: serverName,
          libraryId: libraryId,
          scrollDirection: Axis.vertical,
        );
      case MediaListKind.recentlyAdded:
        return _recentlyAddedGrid();
      case MediaListKind.recentlyPlayed:
      case MediaListKind.mostPlayed:
      case MediaListKind.highestRated:
        return _rankedGrid(context);
    }
  }

  /// The newest items: the Browse grids already query exactly this, only
  /// sorted by creation date.
  Widget _recentlyAddedGrid() {
    switch (libraryType) {
      case Enum$LibraryType.SHOW:
        return TvShowScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
      case Enum$LibraryType.MUSIC:
        return AlbumScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
      case Enum$LibraryType.BOOK:
        return BookScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
      case Enum$LibraryType.COMIC:
        return SeriesScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
      case Enum$LibraryType.PODCAST:
        return PodcastScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
      default:
        return MovieScroll(
            serverName: serverName,
            libraryId: libraryId,
            sorting: Enum$SortingEnum.DATE_CREATED,
            sortingOrder: Enum$SortingOrder.DESCENDING);
    }
  }

  Enum$RankKind get _rankKind {
    switch (kind) {
      case MediaListKind.mostPlayed:
        return Enum$RankKind.MOST_PLAYED;
      case MediaListKind.highestRated:
        return Enum$RankKind.HIGHEST_RATED;
      default:
        return Enum$RankKind.RECENTLY_PLAYED;
    }
  }

  Widget _rankedGrid(BuildContext context) {
    switch (libraryType) {
      case Enum$LibraryType.SHOW:
        return _rankedContentView(
          document: documentNodeQueryrankedShows,
          field: 'rankedShows',
          fromJson: Query$rankedShows$libraryById$rankedShows$content.fromJson,
          childAspectRatio: 0.65,
          tile: (dynamic show) => _landscapeTile(
              context, show, () => ShowOverviewRoute(showId: show.id)),
        );
      case Enum$LibraryType.MUSIC:
        return _rankedContentView(
          document: documentNodeQueryrankedAlbums,
          field: 'rankedAlbums',
          fromJson: Fragment$fragmentAlbum.fromJson,
          childAspectRatio: 1.0,
          tile: (album) => AlbumCarouselTile(serverName: serverName, album: album),
        );
      case Enum$LibraryType.BOOK:
        return _rankedContentView(
          document: documentNodeQueryrankedBooks,
          field: 'rankedBooks',
          fromJson: Fragment$fragmentBook.fromJson,
          childAspectRatio: BookCarouselTile.coverAspectRatio,
          tile: (book) => BookCarouselTile(serverName: serverName, book: book),
        );
      case Enum$LibraryType.COMIC:
        return _rankedContentView(
          document: documentNodeQueryrankedSeries,
          field: 'rankedSeries',
          fromJson: Fragment$fragmentSeries.fromJson,
          childAspectRatio: SeriesCarouselTile.coverAspectRatio,
          tile: (series) =>
              SeriesCarouselTile(serverName: serverName, series: series),
        );
      case Enum$LibraryType.PODCAST:
        return _rankedContentView(
          document: documentNodeQueryrankedPodcasts,
          field: 'rankedPodcasts',
          fromJson: Fragment$fragmentPodcast.fromJson,
          childAspectRatio: 1.0,
          tile: (podcast) =>
              PodcastCarouselTile(serverName: serverName, podcast: podcast),
        );
      default:
        return _rankedContentView(
          document: documentNodeQueryrankedMovies,
          field: 'rankedMovies',
          fromJson:
              Query$rankedMovies$libraryById$rankedMovies$content.fromJson,
          childAspectRatio: 0.65,
          tile: (dynamic movie) => _landscapeTile(
              context, movie, () => MovieRoute(movieId: movie.id)),
        );
    }
  }

  Widget _rankedContentView<T>({
    required DocumentNode document,
    required String field,
    required ItemFromJson<T> fromJson,
    required double childAspectRatio,
    required Widget Function(T item) tile,
  }) {
    return PagedContentView<T>(
      document: document,
      rootField: field,
      rootFieldPath: ['libraryById', field],
      fromJson: fromJson,
      extraVariables: {'libraryId': libraryId, 'kind': _rankKind},
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final itemCount = data.totalItems ?? (_pageSize * 2);
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final item = data.itemAt(index);
            if (item != null) return tile(item);
            return pagedSkeletonSlot(
              key: ValueKey('ranked-$field-skeleton-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }

  // The generated ranked movie/show content classes are distinct types with
  // identical fields, so the tile takes them dynamically (the LibraryDiscoverView
  // rows do the same).
  Widget _landscapeTile(
      BuildContext context, dynamic item, PageRouteInfo Function() route) {
    final img = ImageUtil.getImageByType(item.images, ImageTypes.cover);
    return CarouselItemView(
      serverName: serverName,
      title: MetadataUtil.getTitle(item.metadata) ?? item.name,
      subTitle: MetadataUtil.getDescription(item.metadata) ?? '',
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(serverName)),
      blurHash: img?.blurHash,
      onTap: () => AutoRouter.of(context).push(route()),
    );
  }
}
