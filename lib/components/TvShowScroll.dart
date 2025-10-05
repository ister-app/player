import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/MetadataUtil.dart';
import 'CarouselItemView.dart';

class TvShowScroll extends StatefulWidget {
  final String serverName;
  final Function(Refetch?)? onRefetch;
  final Function()? onEmptyView;

  const TvShowScroll({
    super.key,
    required this.serverName,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<TvShowScroll> createState() => _TvShowScrollState();
}

class _TvShowScrollState extends State<TvShowScroll> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    int fetched = 0;

    return Query(
      options: QueryOptions(document: documentNodeQueryshows, variables: {
        "page": 0,
        "size": 15,
        "sorting": Enum$SortingEnum.NAME,
        "sortingOrder": Enum$SortingOrder.ASCENDING
      }),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (widget.onRefetch != null) {
          widget.onRefetch!(refetch);
        }
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.data == null && result.isLoading) {
          return Skeletonizer(
              enabled: true,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.65,
                  maxCrossAxisExtent: 300, // Adjust aspect ratio as needed
                ),
                itemCount: 7, // Number of placeholders
                itemBuilder: (context, index) {
                  return CarouselItemView(
                    serverName: widget.serverName,
                    title: BoneMock.name,
                    subTitle: BoneMock.words(10),
                  );
                },
              ));
        }

        final parsedData = Query$shows.fromJson(result.data!);
        Query$shows$shows? showPage = parsedData.shows;
        List<Query$shows$shows$content>? shows = showPage?.content;

        if (shows == null) {
          if (widget.onEmptyView != null) {
            widget.onEmptyView!();
          }
          return const Text('No shows');
        }

        return NotificationListener<ScrollUpdateNotification>(
            onNotification: (ScrollUpdateNotification notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 500) {
                LoggerService()
                    .logger
                    .t("End of Tvshowslide reached page: ${showPage!.number}");
                if (result.isLoading == false &&
                    _loading == false &&
                    fetched != showPage.number + 1 &&
                    fetchMore != null &&
                    showPage.totalPages > showPage.number) {
                  setState(() {
                    _loading = true;
                  });
                  fetched = showPage.number + 1;
                  LoggerService().logger.d(
                      "Fetching more page: ${showPage.number + 1}, size: ${showPage.size}");
                  fetchMore(FetchMoreOptions(
                    variables: {
                      "page": showPage.number + 1,
                      "size": showPage.size
                    },
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      final List<dynamic> content = [
                        ...previousResultData!['shows']['content']
                            as List<dynamic>,
                        ...fetchMoreResultData!['shows']['content']
                            as List<dynamic>
                      ];

                      fetchMoreResultData['shows']['content'] = content;
                      setState(() {
                        _loading = false;
                      });
                      return fetchMoreResultData;
                    },
                  ));
                }
              }
              return true;
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 0.65,
                maxCrossAxisExtent: 300, // Adjust aspect ratio as needed
              ),
              itemCount: shows.length + (_loading ? 1 : 0), // Add 1 if loading
              itemBuilder: (context, index) {
                if (index < shows.length) {
                  final show = shows[index];
                  return CarouselItemView(
                    serverName: widget.serverName,
                    title: MetadataUtil.getTitle(show.metadata) ?? "",
                    subTitle: MetadataUtil.getDescription(show.metadata) ?? "",
                    imageUrl: ImageUtil.getImageIdByType(
                        show.images, ImageTypes.cover),
                    onTap: () => AutoRouter.of(context)
                        .push(ShowOverviewRoute(showId: show.id)),
                  );
                } else {
                  // Return a loading spinner if loading more items
                  return Center(
                    child: CircularProgressIndicator(), // Spinner
                  );
                }
              },
            ));
      },
    );
  }
}
