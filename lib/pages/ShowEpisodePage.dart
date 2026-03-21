import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/IsterPlayer.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoginManager.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PlayQueueService.dart';

@RoutePage()
class ShowEpisodePage extends StatefulWidget {
  const ShowEpisodePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
    @PathParam('episodeId') required this.episodeId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String showId;
  final String episodeId;
  final String? playQueueId;

  @override
  _ShowEpisodePageState createState() => _ShowEpisodePageState();
}

class _ShowEpisodePageState extends State<ShowEpisodePage> {
  bool loadComplete = false;
  Fragment$fragmentEpisode? episode;
  bool _playQueueStarted = false;

  late final PlayQueueService playQueueService;
  late StreamSubscription _playQueueSubscription;

  @override
  void initState() {
    super.initState();
    playQueueService = PlayQueueService();

    // Subscribe to the playqueue changed stream
    _playQueueSubscription = playQueueService
        .getPlayQueueChangedStream()
        .listen(_onPlayQueueChanged);
  }

  @override
  void dispose() {
    _playQueueSubscription.cancel();
    super.dispose();
  }

  void _onPlayQueueChanged(Fragment$fragmentPlayQueue playQueue) {
    final episode =
        PlayQueueService.getCurrentPlayQueueItem(playQueue)?.episode;
    if (episode == null) return;
    if (episode.id == widget.episodeId) return;
    if (episode.$show?.id != widget.showId) return;

    if (!mounted) return; // widget disposed → abort

    AutoRouter.of(context).navigate(
      ShowEpisodeRoute(
        playQueueId: playQueue.id,
        showId: episode.$show!.id,
        episodeId: episode.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryepisodeById,
        onComplete: (data) {
          setState(() {
            loadComplete = true;
            episode = Query$episodeById.fromJson(data!).episodeById;
          });
        },
        variables: Map.of({"id": widget.episodeId}),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Center(child: Text(result.exception.toString()));
        } else if (result.data == null && result.isLoading) {
          return Skeletonizer(
            enabled: true,
            child: getContent(
                false, null, BoneMock.name, BoneMock.words(15), context),
          );
        } else {
          final MediaPlayerHandler _handler = MediaPlayerHandler.instance;
          if (episode != null && !_playQueueStarted) {
            _playQueueStarted = true;
            _handler.startPlayQueue(GraphQLProvider.of(context).value,
                widget.playQueueId, episode!, widget.serverName);
          }
          return getContent(
            loadComplete,
            episode,
            MetadataUtil.getTitle(episode?.metadata) ??
                AppLocalizations.of(context)!.episode(episode?.number ?? 0),
            MetadataUtil.getDescription(episode?.metadata) ?? "",
            context,
          );
        }
      },
    );
  }

  Column getContent(bool loadComplete, Fragment$fragmentEpisode? episode,
      String title, String description, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
            height: constraints.maxWidth < 800 ? 300 : 500,
            child: episode != null && loadComplete
                ? kIsWeb ||
                        episode.mediaFile == null ||
                        episode.mediaFile!.isEmpty
                    ? LayoutBuilder(builder: (context, constraints) {
                        var imageByType = ImageUtil.getImageByType(
                            episode.images, ImageTypes.background);
                        return Container(
                          height: constraints.maxWidth < 800 ? 300 : 500,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                          child: (imageByType?.id != null)
                              ? CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      imageByType?.blurHash != null
                                          ? BlurHash(
                                              hash: imageByType!.blurHash!,
                                              optimizationMode:
                                                  BlurHashOptimizationMode
                                                      .standard,
                                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                              duration: Duration.zero,
                                            )
                                          : Container(),
                                  fit: BoxFit.cover,
                                  httpHeaders: LoginManager.getHeaders(
                                      widget.serverName),
                                  imageUrl: ImageUtil.buildUrl(imageByType)!,
                                )
                              : Container(),
                        );
                      })
                    : IsterPlayer()
                : Container(),
          );
        },
      ),
      Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                MenuAnchor(
                  menuChildren: <Widget>[
                    MenuItemButton(
                      onPressed: () {
                        _dialogBuilder(context, episode!.toJson().toString());
                      },
                      child: ListTile(
                        leading: const Icon(Icons.info),
                        title: Text(AppLocalizations.of(context)!.rawData),
                      ),
                    ),
                  ],
                  builder: (_, MenuController controller, Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                    );
                  },
                ),
              ],
            ),
            Text(description),
          ])),
    ]);
  }

  Future<void> _dialogBuilder(BuildContext context, String json) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.json),
          content: SelectableText(json),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
