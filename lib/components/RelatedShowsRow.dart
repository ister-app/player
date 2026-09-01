import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/relatedShows.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import 'CarouselItemView.dart';
import 'MediaGrid.dart';
import 'RowHeader.dart';
import 'SkeletonPlaceholder.dart';

/// Artwork height of the strip and width of a single tile — the same backdrop
/// tiles the home-page carousels use, so the row reads as one of them. The
/// strip itself is taller by the caption under the artwork.
const double _kRelatedArtHeight = 200;
const double _kRelatedTileWidth = 300;
double _kRelatedRowHeight(BuildContext context) =>
    _kRelatedArtHeight + CarouselItemView.captionHeightOf(context);

/// How many tiles the strip reserves while the query is in flight. Shared with
/// [RelatedShowsRowSkeleton] so the show page's own skeleton reserves exactly
/// what the live row will show.
const int kRelatedPlaceholderCount = 6;

/// How many shows the "show all" page asks for. The server returns one ranked
/// top-N, so this is the whole list rather than the first page of one.
const int kRelatedShowsPageLimit = 60;

/// The section header above every related-shows strip.
Widget _relatedHeader(BuildContext context, {VoidCallback? onTap}) => RowHeader(
  label: AppLocalizations.of(context)!.relatedShows,
  style: Theme.of(context).textTheme.titleMedium,
  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
  trailingColon: false,
  onTap: onTap,
);

/// The strip's outer shell: full width, capped like the rest of the page.
Widget _relatedShell(BuildContext context, List<Widget> children) => Center(
  child: Container(
    width: double.infinity,
    constraints: const BoxConstraints(maxWidth: 1600),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  ),
);

/// The loading stand-in for the strip: the same header and the same tiles the
/// live row shows while its query is in flight.
///
/// The show page hands this to its own page-level skeleton, so the related row
/// is reserved from the first frame instead of appearing once everything else
/// has already settled.
class RelatedShowsRowSkeleton extends StatelessWidget {
  const RelatedShowsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _relatedShell(context, [
      _relatedHeader(context),
      SizedBox(
        height: _kRelatedRowHeight(context),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemExtent: _kRelatedTileWidth,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kRelatedPlaceholderCount,
          itemBuilder: (context, index) => const _RelatedSkeletonTile(),
        ),
      ),
    ]);
  }
}

/// Skeleton stand-in matching a related tile's footprint.
class _RelatedSkeletonTile extends StatelessWidget {
  const _RelatedSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return SkeletonPlaceholder(
      child: CarouselItemView(
        serverName: '',
        title: BoneMock.name,
        subTitle: BoneMock.words(1),
        placeholderIcon: Icons.tv,
      ),
    );
  }
}

/// Horizontal strip of shows comparable to the one on screen, served by the
/// `Show.related` field (scored server-side on shared keywords, genres and
/// cast). Shown at the bottom of the show page, under the cast; the header
/// opens [RelatedShowsPage] with the same list as a grid.
///
/// Unlike the cast strip this is a single unpaged query — the server returns
/// one ranked top-N — so there is no per-page state to keep and the result can
/// simply be read on every build. While the query runs the row skeletonizes
/// rather than collapsing: the show page reserves the strip in its own
/// skeleton, and collapsing here would drop that reservation for a frame
/// before the answer lands. A show with no related shows still collapses
/// entirely — no bare header over an empty strip.
class RelatedShowsRow extends StatelessWidget {
  const RelatedShowsRow({
    super.key,
    required this.serverName,
    required this.showId,
    this.limit = 12,
    this.scrollDirection = Axis.horizontal,
  });

  final String serverName;
  final String showId;
  final int limit;

  /// [Axis.horizontal] is the strip with its tappable header;
  /// [Axis.vertical] is the full grid ([RelatedShowsPage]'s body, headerless —
  /// the page's app bar carries the title).
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryrelatedShows,
        variables: {'id': showId, 'limit': limit},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        final asGrid = scrollDirection == Axis.vertical;

        if (result.data == null) {
          // Still waiting: bones. An error without data collapses — an older
          // server simply has no `related` field.
          if (result.hasException) return const SizedBox.shrink();
          return asGrid
              ? const _RelatedShowsGridSkeleton()
              : const RelatedShowsRowSkeleton();
        }
        final shows =
            Query$relatedShows.fromJson(result.data!).showById?.related ??
            const [];
        // An older server without the field, or simply a show that shares
        // nothing with its neighbours: collapse instead of showing a bare
        // header.
        if (shows.isEmpty) {
          return const SizedBox.shrink();
        }

        Widget tile(int index) =>
            _RelatedTile(serverName: serverName, show: shows[index]);

        if (asGrid) {
          return LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: mediaGridDelegate(
                context,
                constraints.maxWidth,
                artAspectRatio: _kRelatedTileWidth / _kRelatedArtHeight,
              ),
              itemCount: shows.length,
              itemBuilder: (context, index) => tile(index),
            ),
          );
        }

        return _relatedShell(context, [
          _relatedHeader(
            context,
            onTap: () =>
                AutoRouter.of(context).push(RelatedShowsRoute(showId: showId)),
          ),
          SizedBox(
            height: _kRelatedRowHeight(context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemExtent: _kRelatedTileWidth,
              itemCount: shows.length,
              itemBuilder: (context, index) => tile(index),
            ),
          ),
        ]);
      },
    );
  }
}

/// The grid's loading stand-in — the page opens on bones instead of a blank
/// screen with only an app bar.
class _RelatedShowsGridSkeleton extends StatelessWidget {
  const _RelatedShowsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: mediaGridDelegate(
          context,
          constraints.maxWidth,
          artAspectRatio: _kRelatedTileWidth / _kRelatedArtHeight,
        ),
        itemCount: kRelatedPlaceholderCount,
        itemBuilder: (context, index) => const _RelatedSkeletonTile(),
      ),
    );
  }
}

/// One related show, in the strip as well as in the grid.
class _RelatedTile extends StatelessWidget {
  const _RelatedTile({required this.serverName, required this.show});

  final String serverName;
  final Query$relatedShows$showById$related show;

  @override
  Widget build(BuildContext context) {
    final image = ImageUtil.getImageByType(show.images, ImageTypes.background);
    return CarouselItemView(
      serverName: serverName,
      title: MetadataUtil.getTitle(show.metadata) ?? show.name,
      subTitle: show.releaseYear > 0 ? '${show.releaseYear}' : '',
      imageUrl: ImageUtil.buildUrl(
        image,
        token: StreamTokenService.getToken(serverName),
      ),
      blurHash: image?.blurHash,
      placeholderIcon: Icons.tv,
      onTap: () =>
          AutoRouter.of(context).push(ShowOverviewRoute(showId: show.id)),
    );
  }
}
