import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/relatedShows.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../l10n/app_localizations.dart';
import 'CarouselItemView.dart';
import 'RowHeader.dart';

/// Height of the strip and width of a single tile — the same backdrop tiles
/// the home-page carousels use, so the row reads as one of them.
const double _kRelatedRowHeight = 200;
const double _kRelatedTileWidth = 300;

/// Horizontal strip of shows comparable to the one on screen, served by the
/// `Show.related` field (scored server-side on shared keywords, genres and
/// cast). Shown at the bottom of the show page, under the cast.
///
/// Unlike the cast strip this is a single unpaged query — the server returns
/// one ranked top-N — so there is no per-page state to keep and the result can
/// simply be read on every build. Nothing is drawn until the answer is in: a
/// skeleton row would flash on the many shows that have no related shows at
/// all, only to disappear again.
class RelatedShowsRow extends StatelessWidget {
  const RelatedShowsRow({
    super.key,
    required this.serverName,
    required this.showId,
    this.limit = 12,
  });

  final String serverName;
  final String showId;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryrelatedShows,
        variables: {'id': showId, 'limit': limit},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (result.data == null) {
          return const SizedBox.shrink();
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

        return Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RowHeader(
                  label: AppLocalizations.of(context)!.relatedShows,
                  style: Theme.of(context).textTheme.titleMedium,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  trailingColon: false,
                ),
                SizedBox(
                  height: _kRelatedRowHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemExtent: _kRelatedTileWidth,
                    itemCount: shows.length,
                    itemBuilder: (context, index) {
                      final show = shows[index];
                      final image = ImageUtil.getImageByType(
                        show.images,
                        ImageTypes.background,
                      );
                      return CarouselItemView(
                        serverName: serverName,
                        title: MetadataUtil.getTitle(show.metadata) ?? show.name,
                        subTitle:
                            show.releaseYear > 0 ? '${show.releaseYear}' : '',
                        imageUrl: ImageUtil.buildUrl(image,
                            token: StreamTokenService.getToken(serverName)),
                        blurHash: image?.blurHash,
                        placeholderIcon: Icons.tv,
                        onTap: () => AutoRouter.of(context)
                            .push(ShowOverviewRoute(showId: show.id)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
