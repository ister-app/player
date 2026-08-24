import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForEpisode.graphql.dart';
import 'package:player/graphql/episodeById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/AddToPlaylistSheet.dart';
import '../components/AddToSessionSheet.dart';
import '../components/DevicePickerSheet.dart';
import '../components/SourceAttribution.dart';
import '../components/CastRow.dart';
import '../components/IsterPlayer.dart';
import '../components/VideoCoverView.dart';
import '../components/RatingStars.dart';
import '../graphql/fragmentEpisode.graphql.dart';
import '../graphql/schema.graphql.dart';
import '../components/download/DownloadMenuItem.dart';
import '../utils/download/DownloadLoaders.dart';
import '../utils/download/DownloadModels.dart';
import '../graphql/fragmentPlayQueue.graphql.dart';
import '../l10n/app_localizations.dart';
import '../routes/AppRouter.gr.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PermissionsService.dart';
import '../utils/PlayQueueService.dart';
import '../utils/VideoAutoStart.dart';

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

  /// Timestamp of the query result [episode] was parsed from, so a rebuild
  /// doesn't re-parse the same result.
  DateTime? _parsedResultAt;
  /// Playback of this page's episode was kicked off (by the play button or an
  /// auto-start); the video surface shows from then on. Survives the
  /// auto-advance navigation to the next episode of the same queue.
  bool _playQueueStarted = false;

  /// The user tapped the cover's play button.
  bool _playRequested = false;
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

    // Subscribe to the playqueue changed stream
    _playQueueSubscription = playQueueService
        .getPlayQueueChangedStream()
        .listen(_onPlayQueueChanged);
    MediaPlayerHandler.instance.closePlaybackRequest
        .addListener(_onPlaybackClosed);
  }

  /// Playback was torn down (the stop button, notification stop, mini-player
  /// swipe-down): drop the dead video surface and show the cover with its play
  /// button again, so watching can be resumed from this page. Pages that are
  /// closed by the teardown instead (handoff, watch-along) unmount right after
  /// this and never render the cover.
  void _onPlaybackClosed() {
    if (!mounted || !_playQueueStarted) return;
    setState(() {
      _playQueueStarted = false;
      _playRequested = false;
    });
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
          _parsedResultAt = null;
          _playQueueStarted = false;
          _playRequested = false;
          loadComplete = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _playQueueSubscription.cancel();
    MediaPlayerHandler.instance.closePlaybackRequest
        .removeListener(_onPlaybackClosed);
    super.dispose();
  }

  void _onPlay() => setState(() => _playRequested = true);

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
          // Parse the result here rather than in an `onComplete` callback: a
          // cached result (returning to this page from the mini player) is
          // handed to the very first build with `isLoading` false, while the
          // callback only fires on the *next* result from the network. Waiting
          // for it showed the "Episode 0" title fallback — and a cover without
          // its play button — for the whole round trip.
          if (result.timestamp != _parsedResultAt) {
            _parsedResultAt = result.timestamp;
            episode = Query$episodeById.fromJson(result.data!).episodeById;
            loadComplete = true;
          }
          final MediaPlayerHandler handler = MediaPlayerHandler.instance;
          // Opening an episode shows its cover with a play button; playback
          // starts on its own only for the queue that is already playing
          // (auto-advance, mini player, watch-along). An episode whose media
          // file has not been analyzed yet has nothing to play — getContent
          // renders the cover without a button, so skip the start instead of
          // crashing on mediaFile!.first.
          final autoStart = shouldAutoStartVideo(
            routeQueueId: widget.playQueueId,
            handlerQueueId: handler.playQueue?.id,
            isCurrentVideo: handler.isCurrentVideo(
                episodeId: widget.episodeId, serverName: widget.serverName),
          );
          if (episode != null &&
              episode!.mediaFile?.isNotEmpty == true &&
              !_playQueueStarted &&
              (autoStart || _playRequested)) {
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

  /// "Combined file with E7" when this episode shares its media file with
  /// other episodes (s04e06-e07.mkv); null for normal files.
  static String? _combinedFileLine(
      BuildContext context, Fragment$fragmentEpisode? episode) {
    final fileEpisodes = episode?.mediaFile?.firstOrNull?.episodes;
    if (episode == null || fileEpisodes == null || fileEpisodes.length < 2) {
      return null;
    }
    final others = (fileEpisodes
            .map((e) => e.number)
            .where((n) => n != episode.number)
            .toList()
          ..sort())
        .map((n) => AppLocalizations.of(context)!.episodePrefix(n))
        .join(", ");
    if (others.isEmpty) return null;
    return AppLocalizations.of(context)!.combinedFileWith(others);
  }

  Column getContent(bool loadComplete, Fragment$fragmentEpisode? episode,
      String title, String description, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final playable = episode != null &&
              loadComplete &&
              episode.mediaFile != null &&
              episode.mediaFile!.isNotEmpty;
          return Container(
            // Black behind the player, so the video's letterbox bars don't glow
            // in the (light) surface colour.
            decoration: BoxDecoration(
                color: _playQueueStarted
                    ? Colors.black
                    : Theme.of(context).colorScheme.surfaceContainerHighest),
            height: constraints.maxWidth < 800 ? 300 : 500,
            // Once started, the surface stays mounted — also through the
            // skeletonised refetch of an auto-advance, so the next episode's
            // cover + spinner shows on it instead of an empty box.
            child: _playQueueStarted
                ? const Skeleton.keep(child: IsterPlayer())
                : VideoCoverView(
                    image: ImageUtil.getImageByType(
                        episode?.images, ImageTypes.background),
                    serverName: widget.serverName,
                    onPlay: playable ? _onPlay : null,
                  ),
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
                    if (episode != null)
                      DownloadMenuItem(
                        action: DownloadAction(
                          serverName: widget.serverName,
                          kind: DownloadKind.episode,
                          mediaId: episode.id,
                          load: (client) async {
                            final info = await DownloadLoaders.showInfo(
                                client, widget.showId);
                            return [
                              DownloadLoaders.episodeRequest(
                                  episode.toJson(), episode.id, episode.number,
                                  groupTitle: info?.name,
                                  seasonNumber:
                                      info?.seasonNumbers[episode.season?.id]),
                            ];
                          },
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
                    if (episode != null)
                      MenuItemButton(
                        onPressed: () => playOnDevice(
                          context,
                          serverName: widget.serverName,
                          mediaType: Enum$MediaType.EPISODE,
                          mediaId: widget.showId,
                          startId: episode.id,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(AppLocalizations.of(context)!.devicePlayOn),
                        ),
                      ),
                    if (episode != null)
                      MenuItemButton(
                        onPressed: () => showAddToPlaylistSheet(
                          context,
                          serverName: widget.serverName,
                          mediaType: Enum$MediaType.EPISODE,
                          loadItemIds: (_) async => [episode.id],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.playlist_add_check),
                          title: Text(AppLocalizations.of(context)!.addToPlaylist),
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
            if (_combinedFileLine(context, episode) != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.call_merge,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _combinedFileLine(context, episode)!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ]),
              ),
            Text(description),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SourceAttribution(
                  metadata: episode?.metadata, images: episode?.images),
            ),
          ])),
      PagedCastRow(serverName: widget.serverName, episodeId: widget.episodeId),
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
