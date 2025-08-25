import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../routes/AppRouter.gr.dart';
import '../utils/MetadataUtil.dart';
import 'CarouselItemView.dart';

class Tvshowslide extends StatelessWidget {
  final String serverName;
  final Function(VoidCallback?)? onRefetch;
  final Function()? onEmptyView;

  const Tvshowslide({
    super.key,
    required this.serverName, this.onRefetch, this.onEmptyView,
  });

  // final String getEpisodesRecentWatched = Query$episodesRecentWatchedQuery();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          // document: gql(getEpisodesRecentWatched),
          document: documentNodeQueryshowsRecentAdded),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
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
                shrinkExtent: 100.0,
                children: List.filled(
                    7,
                    CarouselItemView(
                      serverName: serverName,
                      title: BoneMock.name,
                      subTitle: BoneMock.words(10),
                    )),
              ));
        }

        final parsedData = Query$showsRecentAdded.fromJson(result.data!);

        List<Query$showsRecentAdded$showsRecentAdded>? shows =
            parsedData.showsRecentAdded;

        if (shows == null) {
          if (onEmptyView != null) {
            onEmptyView!();
          }
          return const Text('No shows');
        }

        return CarouselView(
          controller: CarouselController(initialItem: 0),
          itemExtent: 300.0,
          shrinkExtent: 300.0,
          children: shows.map((Query$showsRecentAdded$showsRecentAdded show) {
            return CarouselItemView(
                serverName: serverName,
                title: MetadataUtil.getTitle(show.metadata) ?? "",
                subTitle: MetadataUtil.getDescription(show.metadata) ?? "",
                imageUrl: ImageUtil.getImageIdByType(
                    show.images, ImageTypes.background));
          }).toList(),
          onTap: (value) => AutoRouter.of(context).push(ShowOverviewRoute(
              showId: shows[value].id)),
        );
      },
    );
  }
}
