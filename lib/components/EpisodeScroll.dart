import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:player/utils/EpisodeParts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/episodesQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentImages.graphql.dart';
import 'BrowseListRow.dart';
import 'CarouselItemView.dart';
import 'PagedContentView.dart';

/// Scrollable grid or list of every episode in a show library, loaded page by
/// page. Tapping an episode opens its episode page (which owns playback).
class EpisodeScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final bool listLayout;
  final Input$MediaFilterInput? filter;
  final void Function(Refetch?)? onRefetch;

  const EpisodeScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.DATE_CREATED,
    this.sortingOrder = Enum$SortingOrder.DESCENDING,
    this.listLayout = false,
    this.filter,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  /// The episode's own still when it has one, else the show's cover.
  Fragment$fragmentImages? _image(Query$episodes$episodes$content episode) {
    return ImageUtil.getImageByType(episode.images, ImageTypes.background) ??
        ImageUtil.getImageByType(episode.images, ImageTypes.cover) ??
        ImageUtil.getImageByType(episode.$show?.images, ImageTypes.cover);
  }

  String _subtitle(Query$episodes$episodes$content episode) {
    final show = episode.$show?.name ?? '';
    final season = episode.season?.number;
    var marker =
        season != null ? 'S${season}E${episode.number}' : 'E${episode.number}';
    // Mark episodes that share one media file with others (s04e06-e07.mkv).
    final numbers = EpisodeParts.sharedNumbers(
        episode.mediaFile?.firstOrNull?.episodes?.map((e) => e.number));
    if (numbers != null) {
      marker = '$marker ⧉ ${numbers.map((n) => 'E$n').join('+')}';
    }
    return show.isEmpty ? marker : '$show • $marker';
  }

  /// Watched fraction for the row's progress bar; null when never started.
  double? _progress(Query$episodes$episodes$content episode) {
    final status = episode.watchStatus?.firstOrNull;
    if (status == null) return null;
    if (status.watched) return 1.0;
    final durationMs = episode.mediaFile
        ?.map((f) => f.durationInMilliseconds)
        .whereType<int>()
        .firstOrNull;
    if (durationMs == null || durationMs <= 0) return null;
    if (status.progressInMilliseconds <= 0) return null;
    return status.progressInMilliseconds / durationMs;
  }

  void _open(BuildContext context, Query$episodes$episodes$content episode) {
    final showId = episode.$show?.id;
    if (showId == null) return;
    // ShowEpisodeRoute is a child of ShowOverviewRoute, so from outside the
    // show shell it must be pushed through its parent.
    AutoRouter.of(context).push(ShowOverviewRoute(
          showId: showId,
          children: [
            ShowEpisodeRoute(showId: showId, episodeId: episode.id),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Query$episodes$episodes$content>(
      document: documentNodeQueryepisodes,
      rootField: 'episodes',
      fromJson: Query$episodes$episodes$content.fromJson,
      sorting: sorting,
      sortingOrder: sortingOrder,
      libraryId: libraryId,
      extraVariables:
          filter == null ? null : {'filter': filter!.toJson()},
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final itemCount = data.totalItems ?? (_pageSize * 2);

        if (listLayout) {
          return ListView.builder(
            primary: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final episode = data.itemAt(index);
              if (episode == null) {
                return pagedSkeletonRow(
                  key: ValueKey('episode-list-skeleton-$index'),
                  onVisible: () => requestPage(index ~/ _pageSize),
                );
              }
              final img = _image(episode);
              return BrowseListRow(
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                placeholderIcon: Icons.tv,
                title: MetadataUtil.getTitle(episode.metadata) ?? '',
                subtitle: _subtitle(episode),
                progress: _progress(episode),
                onTap: () => _open(context, episode),
              );
            },
          );
        }

        return GridView.builder(
          // Attach to ShowHomePage's NestedScrollView so the view-selector header
          // scrolls away with the grid (desktop does not inherit it implicitly).
          primary: true,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final episode = data.itemAt(index);
            if (episode != null) {
              final img = _image(episode);
              return CarouselItemView(
                serverName: serverName,
                title: MetadataUtil.getTitle(episode.metadata) ?? '',
                subTitle: _subtitle(episode),
                imageUrl: ImageUtil.buildUrl(img,
                    token: StreamTokenService.getToken(serverName)),
                blurHash: img?.blurHash,
                placeholderIcon: Icons.tv,
                progress: _progress(episode),
                onTap: () => _open(context, episode),
              );
            }

            return pagedSkeletonSlot(
              key: ValueKey('episode-scroll-skeleton-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
