import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForEpisode.graphql.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/AddToSessionSheet.dart';
import '../components/SourceAttribution.dart';
import '../components/CastRow.dart';
import '../components/IsterPlayer.dart';
import '../components/RatingStars.dart';
import '../components/TrackSelectionWidget.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/StreamTokenService.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PermissionsService.dart';
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
  bool _videoPageOpenCounted = false;
  bool _showAdminActions = true;

  late final PlayQueueService playQueueService;
  late StreamSubscription _playQueueSubscription;

  @override
  void initState() {
    super.initState();
    playQueueService = PlayQueueService();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });

    // Hide the mini player's video bar while this page (the full player) shows.
    // Post-frame: the mini player is an ancestor listening to this notifier, and
    // notifying it while this page is being mounted mid-build throws
    // "markNeedsBuild called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MediaPlayerHandler.instance.videoPageOpen.value++;
      _videoPageOpenCounted = true;
    });

    // Subscribe to the playqueue changed stream
    _playQueueSubscription = playQueueService
        .getPlayQueueChangedStream()
        .listen(_onPlayQueueChanged);
  }

  @override
  void didUpdateWidget(ShowEpisodePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.episodeId != widget.episodeId) {
      final isAutoAdvance = widget.playQueueId != null &&
          MediaPlayerHandler.instance.playQueue?.id == widget.playQueueId;
      if (!isAutoAdvance) {
        setState(() {
          episode = null;
          _playQueueStarted = false;
          loadComplete = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_videoPageOpenCounted) {
      MediaPlayerHandler.instance.videoPageOpen.value--;
    }
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
        } else if (result.data == null || result.isLoading) {
          return Skeletonizer(
            enabled: true,
            child: getContent(
                false, null, BoneMock.name, BoneMock.words(15), context),
          );
        } else {
          final MediaPlayerHandler handler = MediaPlayerHandler.instance;
          if (episode != null && !_playQueueStarted) {
            _playQueueStarted = true;
            handler.startPlayQueue(GraphQLProvider.of(context).value,
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
          final hasVideo = episode != null &&
              loadComplete &&
              episode.mediaFile != null &&
              episode.mediaFile!.isNotEmpty;
          return Container(
            // Black behind the player, so the video's letterbox bars don't glow
            // in the (light) surface colour.
            decoration: BoxDecoration(
                color: hasVideo
                    ? Colors.black
                    : Theme.of(context).colorScheme.surfaceContainerHighest),
            height: constraints.maxWidth < 800 ? 300 : 500,
            child: episode != null && loadComplete
                ? episode.mediaFile == null ||
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
                                  imageUrl: ImageUtil.buildUrl(imageByType, token: StreamTokenService.getToken(widget.serverName))!,
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
                    if (episode != null)
                      MenuItemButton(
                        onPressed: () {
                          _dialogBuilder(context, episode.toJson().toString());
                        },
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(AppLocalizations.of(context)!.rawData),
                        ),
                      ),
                    if (episode != null && _showAdminActions)
                      MenuItemButton(
                        onPressed: () async {
                          final client = GraphQLProvider.of(context).value;
                          await client.mutate(MutationOptions(
                            document: documentNodeMutationanalyzeDataForEpisodeMutation,
                            variables: {'episodeId': episode.id},
                          ));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.analytics),
                          title: Text(AppLocalizations.of(context)!.analyzeMedia),
                        ),
                      ),
                    if (episode != null)
                      MenuItemButton(
                        onPressed: () => showAddToSessionSheet(
                          context,
                          serverName: widget.serverName,
                          loadItems: (_) async =>
                              [(Enum$MediaType.EPISODE, episode.id)],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.playlist_add),
                          title: Text(AppLocalizations.of(context)!.addToSession),
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
            if (episode != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: RatingStars(
                  mediaType: Enum$RatingMediaType.EPISODE,
                  mediaId: episode.id,
                  rating: episode.rating,
                ),
              ),
            if (MetadataUtil.getMetaLine(episode?.metadata) != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  MetadataUtil.getMetaLine(episode?.metadata)!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            Text(description),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SourceAttribution(
                  metadata: episode?.metadata, images: episode?.images),
            ),
          ])),
      PagedCastRow(serverName: widget.serverName, episodeId: widget.episodeId),
      if (loadComplete && episode != null && episode.mediaFile != null && episode.mediaFile!.isNotEmpty)
        const TrackSelectionWidget(),
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
