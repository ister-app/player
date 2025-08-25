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
import '../utils/PlayQueueService.dart';
import 'CarouselItemView.dart';

class RecentCarouselView extends StatelessWidget {

  final String serverName;
  final Function(VoidCallback?)? onRefetch;
  final Function()? onEmptyView;

  const RecentCarouselView({
    super.key,
    required this.serverName, this.onRefetch, this.onEmptyView,
  });

  @override
  Widget build(BuildContext context) {
    PlayQueueService playQueueService = PlayQueueService();
    return Query(
      options: QueryOptions(
        document: documentNodeQueryepisodesRecentWatchedQuery,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        playQueueService.getPlayQueueChangedStream().listen((event) {
          refetch != null ? refetch() : null;
        });
        if (onRefetch != null) {
          onRefetch!(refetch);
        }
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
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

        return CarouselView(
            controller: CarouselController(initialItem: 0),
            // flexWeights: const <int>[1, 1, 1, 1],
            itemExtent: 300.0,
            shrinkExtent: 300.0,
            children: episodes.map(
                (Query$episodesRecentWatchedQuery$episodesRecentWatched
                    episode) {
              List<Fragment$fragmentImages>? images = episode.images
                  ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
                  .toList();
              return CarouselItemView(
                  serverName: serverName,
                  title: MetadataUtil.getTitle(episode.metadata) ??
                      AppLocalizations.of(context)!
                          .episode(episode.number ?? 0),
                  subTitle: MetadataUtil.getDescription(episode.metadata) ?? "",
                  imageUrl:
                      ImageUtil.getImageIdByType(images, ImageTypes.background),
                  progress: episode.watchStatus != null &&
                          episode.watchStatus!.isNotEmpty &&
                          episode.watchStatus!.first.watched != true &&
                          episode.mediaFile != null &&
                          episode.mediaFile!.isNotEmpty
                      ? episode.watchStatus!.first.progressInMilliseconds /
                          episode.mediaFile!.first!.durationInMilliseconds!
                      : null);
            }).toList(),
            onTap: (value) => {
                  AutoRouter.of(context).pushPath(
                      'shows/${episodes[value].$show!.id}/episodes/${episodes[value].id}')
                });
      },
    );
  }
}
