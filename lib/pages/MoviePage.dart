import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForMovie.graphql.dart';
import 'package:player/graphql/movieById.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/WatchTogetherButton.dart';
import '../components/AddToPlaylistSheet.dart';
import '../components/AddToSessionSheet.dart';
import '../components/DevicePickerSheet.dart';
import '../components/SourceAttribution.dart';
import '../components/CastRow.dart';
import '../components/IsterPlayer.dart';
import '../components/VideoCoverView.dart';
import '../components/RatingStars.dart';
import '../graphql/schema.graphql.dart';
import '../components/download/DownloadMenuItem.dart';
import '../utils/download/DownloadModels.dart';
import '../utils/download/DownloadService.dart';
import '../utils/download/QueueItemFactory.dart';
import '../graphql/fragmentMovie.graphql.dart';
import '../utils/ImageTypes.dart';
import '../utils/ImageUtil.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/MetadataUtil.dart';
import '../utils/PermissionsService.dart';
import '../utils/VideoAutoStart.dart';

@RoutePage()
class MoviePage extends StatefulWidget {
  const MoviePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('movieId') required this.movieId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String movieId;
  final String? playQueueId;

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool loadComplete = false;
  Fragment$fragmentMovie? movie;

  /// Timestamp of the query result [movie] was parsed from, so a rebuild
  /// doesn't re-parse the same result.
  DateTime? _parsedResultAt;
  /// Playback of this movie was kicked off (play button or auto-start); the
  /// video surface shows from then on.
  bool _playQueueStarted = false;

  /// The user tapped the cover's play button.
  bool _playRequested = false;
  bool _showAdminActions = true;

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
    MediaPlayerHandler.instance.closePlaybackRequest
        .addListener(_onPlaybackClosed);
  }

  @override
  void dispose() {
    MediaPlayerHandler.instance.closePlaybackRequest
        .removeListener(_onPlaybackClosed);
    super.dispose();
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
  void didUpdateWidget(MoviePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movieId != widget.movieId) {
      setState(() {
        movie = null;
        _parsedResultAt = null;
        _playQueueStarted = false;
        _playRequested = false;
        loadComplete = false;
      });
    }
  }

  void _onPlay() => setState(() => _playRequested = true);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerymovieById,
        variables: Map.of({"id": widget.movieId}),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(result.exception.toString())),
          );
        } else if (result.data == null || result.isLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Skeletonizer(
                enabled: true,
                child: _buildContent(false, null, BoneMock.name, BoneMock.words(15), context),
              ),
            ),
          );
        } else {
          // Parse here rather than in an `onComplete` callback: a cached
          // result (returning from the mini player) reaches the first build
          // with `isLoading` false, while the callback only fires on the next
          // result from the network — until then the page rendered an empty
          // title and a cover without its play button.
          if (result.timestamp != _parsedResultAt) {
            _parsedResultAt = result.timestamp;
            movie = Query$movieById.fromJson(result.data!).movieById;
            loadComplete = true;
          }
          final MediaPlayerHandler handler = MediaPlayerHandler.instance;
          // Opening a movie shows its cover with a play button; playback
          // starts on its own only for the queue that is already playing
          // (mini player, watch-along, handoff). A movie without an analyzed
          // media file has nothing to play — the page renders the cover
          // without a button, so skip the start instead of crashing on
          // mediaFile!.first.
          final autoStart = shouldAutoStartVideo(
            routeQueueId: widget.playQueueId,
            handlerQueueId: handler.playQueue?.id,
            isCurrentVideo: handler.isCurrentVideo(
                movieId: widget.movieId, serverName: widget.serverName),
          );
          if (movie != null &&
              movie!.mediaFile?.isNotEmpty == true &&
              !_playQueueStarted &&
              (autoStart || _playRequested)) {
            _playQueueStarted = true;
            handler.startPlayQueueForMovie(
              GraphQLProvider.of(context).value,
              widget.playQueueId,
              movie!,
              widget.serverName,
            );
          }
          final title = MetadataUtil.titleWithYear(
              MetadataUtil.getTitle(movie?.metadata) ?? movie?.name ?? '',
              movie?.releaseYear);
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                WatchTogetherButton(
                    matches: (handler) => handler.movie?.id == widget.movieId),
              ],
            ),
            body: SingleChildScrollView(
              child: _buildContent(
                loadComplete,
                movie,
                title,
                MetadataUtil.getDescription(movie?.metadata) ?? '',
                context,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildContent(bool loadComplete, Fragment$fragmentMovie? movie,
      String title, String description, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(
        builder: (context, constraints) {
          final playable = movie != null &&
              loadComplete &&
              movie.mediaFile != null &&
              movie.mediaFile!.isNotEmpty;
          return Container(
            // Black behind the player, so the video's letterbox bars don't glow
            // in the (light) surface colour.
            decoration: BoxDecoration(
                color: _playQueueStarted
                    ? Colors.black
                    : Theme.of(context).colorScheme.surfaceContainerHighest),
            height: constraints.maxWidth < 800 ? 300 : 500,
            // Once started the surface stays mounted; before that the cover
            // with the play button (no button without a playable file).
            child: _playQueueStarted
                ? const Skeleton.keep(child: IsterPlayer())
                : VideoCoverView(
                    image: ImageUtil.getImageByType(
                        movie?.images, ImageTypes.background),
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
                    if (movie != null)
                      MenuItemButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.rawData),
                              content: SelectableText(movie.toJson().toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(AppLocalizations.of(context)!.close),
                                ),
                              ],
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(AppLocalizations.of(context)!.rawData),
                        ),
                      ),
                    if (movie != null)
                      DownloadMenuItem(
                        action: DownloadAction(
                          serverName: widget.serverName,
                          kind: DownloadKind.movie,
                          mediaId: movie.id,
                          load: (_) async => [
                            DownloadRequest(
                                item: QueueItemFactory.fromJsonParts(
                                    kind: DownloadKind.movie,
                                    mediaId: movie.id,
                                    json: movie.toJson())),
                          ],
                        ),
                      ),
                    if (movie != null && _showAdminActions)
                      MenuItemButton(
                        onPressed: () async {
                          final client = GraphQLProvider.of(context).value;
                          await client.mutate(MutationOptions(
                            document: documentNodeMutationanalyzeDataForMovieMutation,
                            variables: {'movieId': movie.id},
                          ));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.analytics),
                          title: Text(AppLocalizations.of(context)!.analyzeMedia),
                        ),
                      ),
                    if (movie != null)
                      MenuItemButton(
                        onPressed: () => showAddToSessionSheet(
                          context,
                          serverName: widget.serverName,
                          loadItems: (_) async =>
                              [(Enum$MediaType.MOVIE, movie.id)],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.playlist_add),
                          title: Text(AppLocalizations.of(context)!.addToSession),
                        ),
                      ),
                    if (movie != null)
                      MenuItemButton(
                        onPressed: () => playOnDevice(
                          context,
                          serverName: widget.serverName,
                          mediaType: Enum$MediaType.MOVIE,
                          mediaId: movie.id,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(AppLocalizations.of(context)!.devicePlayOn),
                        ),
                      ),
                    if (movie != null)
                      MenuItemButton(
                        onPressed: () => showAddToPlaylistSheet(
                          context,
                          serverName: widget.serverName,
                          mediaType: Enum$MediaType.MOVIE,
                          loadItemIds: (_) async => [movie.id],
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
            if (movie != null && loadComplete)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: RatingStars(
                  mediaType: Enum$RatingMediaType.MOVIE,
                  mediaId: movie.id,
                  rating: movie.rating,
                ),
              ),
            if (MetadataUtil.getMetaLine(movie?.metadata) != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  MetadataUtil.getMetaLine(movie?.metadata)!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            Text(description),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SourceAttribution(
                  metadata: movie?.metadata, images: movie?.images),
            ),
          ])),
      PagedCastRow(serverName: widget.serverName, movieId: widget.movieId),
    ]);
  }
}
