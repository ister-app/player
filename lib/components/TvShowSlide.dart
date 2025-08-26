import 'package:auto_route/auto_route.dart' show AutoRouter;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showsRecentAdded.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/MetadataUtil.dart';
import 'CarouselItemView.dart';

class Tvshowslide extends StatefulWidget {
  final String serverName;
  final Function(VoidCallback?)? onRefetch;
  final Function()? onEmptyView;

  const Tvshowslide({
    super.key,
    required this.serverName,
    this.onRefetch,
    this.onEmptyView,
  });

  @override
  State<Tvshowslide> createState() => _TvshowslideState();
}

class _TvshowslideState extends State<Tvshowslide> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      LoggerService().logger.t("End of Tvshowslide reached");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: documentNodeQueryshowsRecentAdded),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (widget.onRefetch != null) {
          widget.onRefetch!(refetch);
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
                      serverName: widget.serverName,
                      title: BoneMock.name,
                      subTitle: BoneMock.words(10),
                    )),
              ));
        }

        final parsedData = Query$showsRecentAdded.fromJson(result.data!);
        List<Query$showsRecentAdded$showsRecentAdded>? shows =
            parsedData.showsRecentAdded;

        if (shows == null) {
          if (widget.onEmptyView != null) {
            widget.onEmptyView!();
          }
          return const Text('No shows');
        }

        return ListView(
          controller: _scrollController,
          itemExtent: 300.0,
          scrollDirection: Axis.horizontal,
          children: shows.map((Query$showsRecentAdded$showsRecentAdded show) {
            return CarouselItemView(
                serverName: widget.serverName,
                title: MetadataUtil.getTitle(show.metadata) ?? "",
                subTitle: MetadataUtil.getDescription(show.metadata) ?? "",
                imageUrl: ImageUtil.getImageIdByType(
                    show.images, ImageTypes.background),
                onTap: () => AutoRouter.of(context)
                    .push(ShowOverviewRoute(showId: show.id)));
          }).toList(),
        );
      },
    );
  }
}
