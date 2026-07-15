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
import '../utils/StreamTokenService.dart';
import 'BookCarouselTile.dart';
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
        // Always capture refetch — the play-queue stream listener needs it for
        // live progress updates, independent of the parent's callback.
        this.refetch = refetch;
        widget.onRefetch?.call(refetch);
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.data == null || result.isLoading) {
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
          return Text(AppLocalizations.of(context)!.noRecentItems);
        }

        // No itemExtent: book covers are portrait, so their tiles are narrower
        // than the landscape episode/movie tiles next to them.
        return ListView(
          scrollDirection: Axis.horizontal,
          children: items.map((item) {
            final bool portraitCover = item.type == Enum$MediaType.BOOK ||
                item.type == Enum$MediaType.CHAPTER;
            return SizedBox(
              width:
                  portraitCover ? 200 * BookCarouselTile.coverAspectRatio : 300,
              child: _buildTile(context, item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTile(
      BuildContext context, Query$recentlyWatched$recentlyWatched item) {
    if (item.type == Enum$MediaType.EPISODE && item.episode != null) {
      final episode = item.episode!;
      List<Fragment$fragmentImages>? images = episode.images
          ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
          .toList();
      var menuController = MenuController();
      var imageByType = ImageUtil.getImageByType(images, ImageTypes.background);
      final showId = episode.$show?.id;
      return MenuAnchor(
          controller: menuController,
          menuChildren: <Widget>[
            if (showId != null)
              MenuItemButton(
                  onPressed: () {
                    AutoRouter.of(context)
                        .push(ShowOverviewRoute(showId: showId));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.tv),
                    title: Text(AppLocalizations.of(context)!.goToShow),
                  )),
          ],
          child: CarouselItemView(
              serverName: widget.serverName,
              title: MetadataUtil.getTitle(episode.metadata) ??
                  AppLocalizations.of(context)!.episode(episode.number),
              subTitle: MetadataUtil.getDescription(episode.metadata) ?? "",
              imageUrl: ImageUtil.buildUrl(imageByType,
                  token: StreamTokenService.getToken(widget.serverName)),
              blurHash: imageByType?.blurHash,
              progress: episode.watchStatus != null &&
                      episode.watchStatus!.isNotEmpty &&
                      episode.watchStatus!.first.watched != true &&
                      (episode.mediaFile?.firstOrNull?.durationInMilliseconds ??
                              0) >
                          0
                  ? episode.watchStatus!.first.progressInMilliseconds /
                      episode.mediaFile!.first.durationInMilliseconds!
                  : null,
              onSecondaryTapDown: (TapDownDetails details) =>
                  menuController.isOpen
                      ? menuController.close()
                      : menuController.open(position: details.localPosition),
              onLongPress: () => menuController.isOpen
                  ? menuController.close()
                  : menuController.open(),
              onTap: showId == null
                  ? null
                  : () => AutoRouter.of(context).push(ShowOverviewRoute(
                        showId: showId,
                        children: [
                          ShowEpisodeRoute(
                            showId: showId,
                            episodeId: episode.id,
                          ),
                        ],
                      ))));
    } else if (item.type == Enum$MediaType.MOVIE && item.movie != null) {
      final mv = item.movie!;
      List<Fragment$fragmentImages>? images = mv.images
          ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
          .toList();
      var menuController = MenuController();
      var imageByType = ImageUtil.getImageByType(images, ImageTypes.background);
      return MenuAnchor(
          controller: menuController,
          menuChildren: const <Widget>[],
          child: CarouselItemView(
              serverName: widget.serverName,
              title: MetadataUtil.getTitle(mv.metadata) ?? mv.name,
              subTitle: MetadataUtil.getDescription(mv.metadata) ?? "",
              imageUrl: ImageUtil.buildUrl(imageByType,
                  token: StreamTokenService.getToken(widget.serverName)),
              blurHash: imageByType?.blurHash,
              progress: mv.watchStatus != null &&
                      mv.watchStatus!.isNotEmpty &&
                      mv.watchStatus!.first.watched != true &&
                      (mv.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0) >
                          0
                  ? mv.watchStatus!.first.progressInMilliseconds /
                      mv.mediaFile!.first.durationInMilliseconds!
                  : null,
              onSecondaryTapDown: (TapDownDetails details) =>
                  menuController.isOpen
                      ? menuController.close()
                      : menuController.open(position: details.localPosition),
              onLongPress: () => menuController.isOpen
                  ? menuController.close()
                  : menuController.open(),
              onTap: () =>
                  AutoRouter.of(context).push(MovieRoute(movieId: mv.id))));
    } else if (item.type == Enum$MediaType.CHAPTER && item.chapter != null) {
      // Continue listening: the next unfinished audiobook chapter.
      final chapter = item.chapter!;
      final book = chapter.book;
      List<Fragment$fragmentImages>? images = book.images
          ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
          .toList();
      var imageByType = ImageUtil.getImageByType(images, ImageTypes.cover);
      final chapterTitle = MetadataUtil.getTitle(chapter.metadata) ??
          '${AppLocalizations.of(context)!.chapter} ${chapter.number}';
      return CarouselItemView(
          serverName: widget.serverName,
          title: MetadataUtil.getTitle(book.metadata) ?? book.name,
          subTitle: chapterTitle,
          imageUrl: ImageUtil.buildUrl(imageByType,
              token: StreamTokenService.getToken(widget.serverName)),
          blurHash: imageByType?.blurHash,
          placeholderIcon: Icons.headphones,
          portraitArtwork: true,
          progress: chapter.watchStatus != null &&
                  chapter.watchStatus!.isNotEmpty &&
                  chapter.watchStatus!.first.watched != true &&
                  (chapter.mediaFile?.firstOrNull?.durationInMilliseconds ??
                          0) >
                      0
              ? chapter.watchStatus!.first.progressInMilliseconds /
                  chapter.mediaFile!.first.durationInMilliseconds!
              : null,
          onTap: () => AutoRouter.of(context).push(BookRoute(bookId: book.id)));
    } else if (item.type == Enum$MediaType.PODCAST_EPISODE &&
        item.podcastEpisode != null) {
      // Continue listening: a partially played podcast episode.
      final episode = item.podcastEpisode!;
      final podcast = episode.podcast;
      List<Fragment$fragmentImages>? images = podcast.images
          ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
          .toList();
      var imageByType = ImageUtil.getImageByType(images, ImageTypes.cover);
      return CarouselItemView(
          serverName: widget.serverName,
          title: podcast.title,
          subTitle: MetadataUtil.getTitle(episode.metadata) ?? '',
          imageUrl: ImageUtil.buildUrl(imageByType,
              token: StreamTokenService.getToken(widget.serverName)),
          blurHash: imageByType?.blurHash,
          placeholderIcon: Icons.podcasts,
          progress: episode.watchStatus != null &&
                  episode.watchStatus!.isNotEmpty &&
                  episode.watchStatus!.first.watched != true &&
                  (episode.mediaFile?.firstOrNull?.durationInMilliseconds ??
                          0) >
                      0
              ? episode.watchStatus!.first.progressInMilliseconds /
                  episode.mediaFile!.first.durationInMilliseconds!
              : null,
          onTap: () =>
              AutoRouter.of(context).push(PodcastRoute(podcastId: podcast.id)));
    } else if (item.type == Enum$MediaType.BOOK && item.book != null) {
      // One entry per book, carrying a reading target (epub) and/or a listening target (chapter).
      // Show whichever format the user is actually in: reading if there is reading progress,
      // otherwise the audiobook chapter they were listening to.
      final book = item.book!;
      List<Fragment$fragmentImages>? images = book.images
          ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
          .toList();
      var imageByType = ImageUtil.getImageByType(images, ImageTypes.cover);
      final readingProgress = book.watchStatus
          ?.where((status) => status.readingProgress != null)
          .firstOrNull
          ?.readingProgress;
      final bool reading = readingProgress != null && readingProgress > 0;

      final chapter = item.chapter;
      final double? chapterProgress = !reading &&
              chapter != null &&
              chapter.watchStatus != null &&
              chapter.watchStatus!.isNotEmpty &&
              chapter.watchStatus!.first.watched != true &&
              (chapter.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0) > 0
          ? chapter.watchStatus!.first.progressInMilliseconds /
              chapter.mediaFile!.first.durationInMilliseconds!
          : null;
      final bool listening = chapterProgress != null;

      final subTitle = listening
          ? (MetadataUtil.getTitle(chapter!.metadata) ??
              '${AppLocalizations.of(context)!.chapter} ${chapter.number}')
          : (MetadataUtil.getDescription(book.metadata) ?? "");
      return CarouselItemView(
          serverName: widget.serverName,
          title: MetadataUtil.getTitle(book.metadata) ?? book.name,
          subTitle: subTitle,
          imageUrl: ImageUtil.buildUrl(imageByType,
              token: StreamTokenService.getToken(widget.serverName)),
          blurHash: imageByType?.blurHash,
          placeholderIcon: listening ? Icons.headphones : Icons.menu_book,
          portraitArtwork: true,
          progress: reading ? readingProgress.clamp(0.0, 1.0) : chapterProgress,
          onTap: () => AutoRouter.of(context).push(BookRoute(bookId: book.id)));
    } else {
      return const SizedBox.shrink();
    }
  }
}
