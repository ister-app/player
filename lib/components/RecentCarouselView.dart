import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/episodesRecentWatchedQuery.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/PlayQueueService.dart';
import 'CarouselItemView.dart';

class RecentCarouselView extends StatelessWidget {
  final String serverName;
  final Function(Refetch?)? onRefetch;
  final Function()? onEmptyView;

  const RecentCarouselView({
    super.key,
    required this.serverName,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  Widget build(BuildContext context) {
    PlayQueueService playQueueService = PlayQueueService();
    return Query(
      options: QueryOptions(
        document: documentNodeQueryepisodesRecentWatchedQuery,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        playQueueService.getPlayQueueChangedStream().listen((event) {
          refetch != null ? refetch() : null;
        });
        if (onRefetch != null) {
          onRefetch!(refetch);
        }
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.data == null && result.isLoading) {
          return Skeletonizer(
              enabled: true,
              child: CarouselView(
                controller: CarouselController(initialItem: 0),
                itemExtent: 300.0,
                shrinkExtent: 300.0,
                children: List.filled(
                    7,
                    CarouselItemView(
                      serverName: serverName,
                      title: BoneMock.name,
                      subTitle: BoneMock.words(10),
                    )),
              ));
        }

        final parsedData =
            Query$episodesRecentWatchedQuery.fromJson(result.data!);

        List<Query$episodesRecentWatchedQuery$episodesRecentWatched>? episodes =
            parsedData.episodesRecentWatched;

        if (episodes == null || episodes.isEmpty) {
          if (onEmptyView != null) {
            onEmptyView!();
          }
          return const Text('No episodes');
        }

        return ListView(
          // controller: CarouselController(initialItem: 0),
          itemExtent: 300.0,
          scrollDirection: Axis.horizontal,
          children: episodes.map(
              (Query$episodesRecentWatchedQuery$episodesRecentWatched episode) {
            List<Fragment$fragmentImages>? images = episode.images
                ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
                .toList();
            var _menuController = MenuController();
            var imageByType =
                ImageUtil.getImageByType(images, ImageTypes.background);
            return MenuAnchor(
                controller: _menuController,
                menuChildren: <Widget>[
                  MenuItemButton(
                      onPressed: () {
                        AutoRouter.of(context)
                            .push(ShowOverviewRoute(showId: episode.$show!.id));
                      },
                      child: ListTile(
                        leading: const Icon(Icons.tv),
                        title: Text(AppLocalizations.of(context)!.goToShow),
                      )),
                ],
                child: CarouselItemView(
                    serverName: serverName,
                    title: MetadataUtil.getTitle(episode.metadata) ??
                        AppLocalizations.of(context)!
                            .episode(episode.number ?? 0),
                    subTitle:
                        MetadataUtil.getDescription(episode.metadata) ?? "",
                    imageUrl: imageByType?.id,
                    blurHash: imageByType?.blurHash,
                    progress: episode.watchStatus != null &&
                            episode.watchStatus!.isNotEmpty &&
                            episode.watchStatus!.first.watched != true &&
                            episode.mediaFile != null &&
                            episode.mediaFile!.isNotEmpty
                        ? episode.watchStatus!.first.progressInMilliseconds /
                            episode.mediaFile!.first!.durationInMilliseconds!
                        : null,
                    onSecondaryTapDown: (TapDownDetails details) =>
                        _menuController.isOpen
                            ? _menuController.close()
                            : _menuController.open(
                                position: details.localPosition),
                    onLongPress: () => _menuController.isOpen
                        ? _menuController.close()
                        : _menuController.open(),
                    onTap: () => {
                          AutoRouter.of(context).pushPath(
                              'shows/${episode.$show!.id}/episodes/${episode.id}')
                        }));
          }).toList(),
        );
      },
    );
  }
}
