import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/episodesRecentWatchedQuery.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/PlayQueueService.dart';
import 'CarouselItemView.dart';

class RecentCarouselView extends StatefulWidget {
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
  _RecentCarouselViewState createState() => _RecentCarouselViewState();
}

class _RecentCarouselViewState extends State<RecentCarouselView> {
  late final PlayQueueService playQueueService;
  late StreamSubscription _playQueueSubscription;
  Refetch? refetch;

  @override
  void initState() {
    super.initState();
    playQueueService = PlayQueueService();

    _playQueueSubscription =
        playQueueService.getPlayQueueChangedStream().listen((event) {
      if (refetch != null) {
        refetch!();
      }
    });
  }

  @override
  void dispose() {
    _playQueueSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryrecentlyWatched,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (widget.onRefetch != null) {
          this.refetch = refetch;
          widget.onRefetch!(refetch);
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
                      serverName: widget.serverName,
                      title: BoneMock.name,
                      subTitle: BoneMock.words(10),
                    )),
              ));
        }

        final parsedData = Query$recentlyWatched.fromJson(result.data!);
        final items = parsedData.recentlyWatched;

        if (items == null || items.isEmpty) {
          if (widget.onEmptyView != null) {
            widget.onEmptyView!();
          }
          return const Text('No recent items');
        }

        return ListView(
          itemExtent: 300.0,
          scrollDirection: Axis.horizontal,
          children: items.map((item) {
            if (item.type == Enum$MediaType.EPISODE && item.episode != null) {
              final episode = item.episode!;
              List<Fragment$fragmentImages>? images = episode.images
                  ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
                  .toList();
              var menuController = MenuController();
              var imageByType =
                  ImageUtil.getImageByType(images, ImageTypes.background);
              return MenuAnchor(
                  controller: menuController,
                  menuChildren: <Widget>[
                    MenuItemButton(
                        onPressed: () {
                          AutoRouter.of(context).push(
                              ShowOverviewRoute(showId: episode.$show!.id));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.tv),
                          title: Text(AppLocalizations.of(context)!.goToShow),
                        )),
                  ],
                  child: CarouselItemView(
                      serverName: widget.serverName,
                      title: MetadataUtil.getTitle(episode.metadata) ??
                          AppLocalizations.of(context)!
                              .episode(episode.number ?? 0),
                      subTitle:
                          MetadataUtil.getDescription(episode.metadata) ?? "",
                      imageUrl: ImageUtil.buildUrl(imageByType),
                      blurHash: imageByType?.blurHash,
                      progress: episode.watchStatus != null &&
                              episode.watchStatus!.isNotEmpty &&
                              episode.watchStatus!.first.watched != true &&
                              episode.mediaFile != null &&
                              episode.mediaFile!.isNotEmpty
                          ? episode.watchStatus!.first.progressInMilliseconds /
                              episode.mediaFile!.first.durationInMilliseconds!
                          : null,
                      onSecondaryTapDown: (TapDownDetails details) =>
                          menuController.isOpen
                              ? menuController.close()
                              : menuController.open(
                                  position: details.localPosition),
                      onLongPress: () => menuController.isOpen
                          ? menuController.close()
                          : menuController.open(),
                      onTap: () => AutoRouter.of(context).pushPath(
                          'shows/${episode.$show!.id}/episodes/${episode.id}')));
            } else if (item.type == Enum$MediaType.MOVIE &&
                item.movie != null) {
              final mv = item.movie!;
              List<Fragment$fragmentImages>? images = mv.images
                  ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
                  .toList();
              var menuController = MenuController();
              var imageByType =
                  ImageUtil.getImageByType(images, ImageTypes.background);
              return MenuAnchor(
                  controller: menuController,
                  menuChildren: const <Widget>[],
                  child: CarouselItemView(
                      serverName: widget.serverName,
                      title: MetadataUtil.getTitle(mv.metadata) ?? mv.name,
                      subTitle:
                          MetadataUtil.getDescription(mv.metadata) ?? "",
                      imageUrl: ImageUtil.buildUrl(imageByType),
                      blurHash: imageByType?.blurHash,
                      progress: mv.watchStatus != null &&
                              mv.watchStatus!.isNotEmpty &&
                              mv.watchStatus!.first.watched != true &&
                              mv.mediaFile != null &&
                              mv.mediaFile!.isNotEmpty
                          ? mv.watchStatus!.first.progressInMilliseconds /
                              mv.mediaFile!.first.durationInMilliseconds!
                          : null,
                      onSecondaryTapDown: (TapDownDetails details) =>
                          menuController.isOpen
                              ? menuController.close()
                              : menuController.open(
                                  position: details.localPosition),
                      onLongPress: () => menuController.isOpen
                          ? menuController.close()
                          : menuController.open(),
                      onTap: () => AutoRouter.of(context)
                          .push(MovieRoute(movieId: mv.id))));
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
        );
      },
    );
  }
}
