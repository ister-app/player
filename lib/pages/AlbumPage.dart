import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/albumById.graphql.dart';
import 'package:player/graphql/analyzeDataForAlbum.graphql.dart';
import 'package:player/graphql/analyzeDataForTrack.graphql.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentTrack.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/AccentColorUtil.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/AddToSessionSheet.dart';
import '../components/SourceAttribution.dart';
import '../components/MusicDetailHero.dart';
import '../components/RatingStars.dart';
import '../components/TvFocusable.dart';
import '../dto/IsterMediaItem.dart';
import '../dto/MediaItemId.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class AlbumPage extends StatefulWidget {
  const AlbumPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('albumId') required this.albumId,
    @QueryParam('playQueueId') this.playQueueId,
    @QueryParam('trackId') this.trackId,
  });

  final String serverName;
  final String albumId;
  final String? playQueueId;

  /// When set (e.g. arriving from a search result), the page scrolls to this
  /// track and briefly highlights it.
  final String? trackId;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  // Live overrides for track ratings changed this session, so a rating set via
  // the per-track dialog shows immediately without waiting for a refetch.
  final Map<String, int?> _trackRatingOverrides = {};
  bool _showAdminActions = true;

  final GlobalKey _requestedTrackKey = GlobalKey();
  bool _scrolledToRequestedTrack = false;
  bool _requestedTrackHighlighted = false;

  /// Accent extracted from the album cover, tinting the play button and the
  /// now-playing indicator; null until extraction succeeds.
  Color? _accent;
  String? _accentUrl;

  void _updateAccent(String? url) {
    if (url == _accentUrl) return;
    _accentUrl = url;
    AccentColorUtil.fromImageUrl(url).then((color) {
      // A cover change may have superseded this load; only apply if current.
      if (!mounted || _accentUrl != url || color == null) return;
      setState(() => _accent = color);
    });
  }

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
  }

  int? _trackRating(Fragment$fragmentTrack track) =>
      _trackRatingOverrides.containsKey(track.id)
          ? _trackRatingOverrides[track.id]
          : track.rating;

  void _playTrack(BuildContext context, Fragment$fragmentAlbum album, String trackId) {
    final client = GraphQLProvider.of(context).value;
    MediaPlayerHandler.instance.startPlayQueueForAlbum(
      client,
      widget.playQueueId,
      album,
      trackId,
      widget.serverName,
    );
  }

  Future<void> _addTrackToQueue(BuildContext context, String trackId) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final added = await MediaPlayerHandler.instance
        .addToQueue(widget.serverName, Enum$MediaType.TRACK, trackId);
    if (added) {
      messenger.showSnackBar(SnackBar(content: Text(loc.addToQueue)));
    }
  }

  Future<void> _addAlbumToQueue(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final added = await MediaPlayerHandler.instance
        .addAlbumToQueue(widget.serverName, widget.albumId);
    if (added) {
      messenger.showSnackBar(SnackBar(content: Text(loc.addToQueue)));
    }
  }

  /// A track can only be played/queued once it has an analyzed media file.
  static bool _trackHasFile(Fragment$fragmentTrack track) =>
      track.mediaFile?.isNotEmpty == true;

  /// "20 songs • 1:12:30" next to the play button; drops the duration while
  /// no track has been analyzed yet (no durations known).
  static String _albumStats(
      AppLocalizations loc, List<Fragment$fragmentTrack> tracks) {
    final totalMs = tracks.fold<int>(
        0,
        (sum, t) =>
            sum + (t.mediaFile?.firstOrNull?.durationInMilliseconds ?? 0));
    final count = loc.trackCount(tracks.length);
    if (totalMs <= 0) return count;
    return loc.albumStats(
        count, DurationUtil.format(Duration(milliseconds: totalMs)));
  }

  /// The id of the track currently playing on this page's server, or null when
  /// nothing plays, the item is no track, or it belongs to another server.
  String? _playingTrackId(MediaItem? item) {
    if (item == null) return null;
    try {
      final id = MediaItemId.byStringId(item.id);
      if (id.serverName == widget.serverName &&
          id.isterMediaType == IsterMediaTypes.track) {
        return id.id;
      }
    } catch (_) {
      // Malformed/unknown id (e.g. from an older session): no indicator.
    }
    return null;
  }

  /// Scrolls to [AlbumPage.trackId] once the track list is available (e.g. when
  /// arriving from a search result) and highlights that row for a moment.
  void _maybeScrollToRequestedTrack(List<Fragment$fragmentTrack> tracks) {
    if (_scrolledToRequestedTrack ||
        widget.trackId == null ||
        !tracks.any((t) => t.id == widget.trackId)) {
      return;
    }
    _scrolledToRequestedTrack = true;
    _requestedTrackHighlighted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final targetContext = _requestedTrackKey.currentContext;
      if (targetContext != null) {
        await Scrollable.ensureVisible(
          targetContext,
          alignment: 0.3,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _requestedTrackHighlighted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MediaPlayerHandler.instance.musicPlayerOpen,
      builder: (context, musicPlayerOpen, child) => PopScope(
        canPop: !musicPlayerOpen,
        child: child!,
      ),
      child: Query(
        options: QueryOptions(
          document: documentNodeQueryalbumById,
          variables: {'id': widget.albumId},
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(result.exception.toString())),
          );
        }

        if (result.data == null) {
          return Scaffold(
            body: Skeletonizer(
              enabled: true,
              child: _buildContent(null, []),
            ),
          );
        }

        final albumData = Query$albumById.fromJson(result.data!).albumById;
        // Display order is (disc, track number); the server does not guarantee
        // its list is grouped by disc. This sorted list also feeds the play
        // button and add-to-session, so playback order matches the page.
        final tracks = [...albumData?.tracks ?? <Fragment$fragmentTrack>[]]
          ..sort((a, b) => a.discNumber != b.discNumber
              ? a.discNumber.compareTo(b.discNumber)
              : a.number.compareTo(b.number));
        _maybeScrollToRequestedTrack(tracks);

        return Scaffold(
          body: _buildContent(albumData, tracks),
        );
      },
      ),
    );
  }

  Widget _buildContent(
      Fragment$fragmentAlbum? album, List<Fragment$fragmentTrack> tracks) {
    final loc = AppLocalizations.of(context)!;
    final description = album != null ? MetadataUtil.getDescription(album.metadata) : null;
    final metaLine = album != null ? MetadataUtil.getMetaLine(album.metadata) : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          actions: [
            if (album != null && tracks.any(_trackHasFile))
              IconButton(
                icon: const Icon(Icons.playlist_add),
                tooltip: loc.addToQueue,
                onPressed: () => _addAlbumToQueue(context),
              ),
            if (album != null && tracks.any(_trackHasFile))
              IconButton(
                icon: const Icon(Icons.queue_music),
                tooltip: loc.addToSession,
                onPressed: () => showAddToSessionSheet(
                  context,
                  serverName: widget.serverName,
                  // Whole album, in the page's disc/track order.
                  loadItems: (_) async => [
                    for (final track in tracks.where(_trackHasFile))
                      (Enum$MediaType.TRACK, track.id),
                  ],
                ),
              ),
            if (album != null && _showAdminActions)
              IconButton(
                icon: const Icon(Icons.analytics),
                tooltip: loc.analyzeMedia,
                onPressed: () async {
                  final client = GraphQLProvider.of(context).value;
                  await client.mutate(MutationOptions(
                    document: documentNodeMutationanalyzeDataForAlbumMutation,
                    variables: {'albumId': album.id},
                  ));
                },
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHeader(context, album),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                // A Wrap instead of a Row: on narrow (mobile) screens the
                // stats text moves to its own line below the buttons instead
                // of being ellipsized away.
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: album != null &&
                              tracks.any(_trackHasFile)
                          ? () => _playTrack(
                              context,
                              album,
                              tracks.firstWhere(_trackHasFile).id)
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(loc.play),
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: _accent != null ? Colors.black : null,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: album != null && tracks.isNotEmpty
                          ? () {
                              final client =
                                  GraphQLProvider.of(context).value;
                              MediaPlayerHandler.instance.startAlbumShuffle(
                                client,
                                widget.serverName,
                                widget.albumId,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.shuffle),
                      label: Text(loc.shuffle),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                    if (tracks.isNotEmpty)
                      Text(
                        _albumStats(loc, tracks),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (album != null || metaLine != null)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (album != null)
                        RatingStars(
                          mediaType: Enum$RatingMediaType.ALBUM,
                          mediaId: album.id,
                          rating: album.rating,
                        ),
                      if (metaLine != null)
                        Text(
                          metaLine,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (description != null)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(description),
                      const SizedBox(height: 6),
                      SourceAttribution(
                          metadata: album?.metadata, images: album?.images),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  loc.songs,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: StreamBuilder<MediaItem?>(
                stream: MediaPlayerHandler.instance.mediaItem,
                initialData: MediaPlayerHandler.instance.mediaItem.valueOrNull,
                builder: (context, snapshot) {
                  final playingTrackId = _playingTrackId(snapshot.data);
                  return Column(
                    children:
                        _buildTrackSections(album, tracks, playingTrackId),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// The track list as a flat widget list; on multi-disc albums a disc header
  /// precedes the first track of each disc.
  List<Widget> _buildTrackSections(
      Fragment$fragmentAlbum? album,
      List<Fragment$fragmentTrack> tracks,
      String? playingTrackId) {
    final multiDisc = tracks.map((t) => t.discNumber).toSet().length > 1;
    final children = <Widget>[];
    int? currentDisc;
    for (final track in tracks) {
      if (multiDisc && track.discNumber != currentDisc) {
        currentDisc = track.discNumber;
        children.add(_discHeader(context, currentDisc));
      }
      children.add(_buildTrackRow(context, album, track, playingTrackId));
    }
    return children;
  }

  Widget _discHeader(BuildContext context, int discNumber) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        children: [
          Icon(Icons.album, size: 18, color: mutedColor),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.discHeader(discNumber),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: mutedColor,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildTrackRow(BuildContext context, Fragment$fragmentAlbum? album,
      Fragment$fragmentTrack track, String? playingTrackId) {
    final loc = AppLocalizations.of(context)!;
    final hasFile = _trackHasFile(track);
    final trackTitle =
        MetadataUtil.getTitle(track.metadata) ?? '${track.number}';
    final durationMs = track.mediaFile?.firstOrNull?.durationInMilliseconds;
    final durationText = durationMs != null
        ? DurationUtil.format(Duration(milliseconds: durationMs))
        : null;
    final trackRating = _trackRating(track);
    // Not-yet-analyzed tracks have no playable file: mute them and
    // steer the user to "Analyze media" instead of a dead tap.
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final isRequestedTrack = track.id == widget.trackId;
    final isPlaying = track.id == playingTrackId;
    final accentColor = _accent ?? Theme.of(context).colorScheme.primary;
    // Repeating the album artist under every row is noise; only per-track
    // artists (compilations, features) earn the subtitle line.
    final showArtist = album == null || track.artist.id != album.artist.id;
    final subtitleChildren = <Widget>[
      if (showArtist)
        Text(
          track.artist.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: mutedColor,
              ),
        ),
      if (!hasFile)
        Text(
          loc.trackNotPlayable,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: mutedColor,
              ),
        ),
      if (trackRating != null) RatingStarsDisplay(rating: trackRating),
    ];
    // Hoisted so the TV remote's long-press can open the same menu as the
    // trailing icon button.
    final menuController = MenuController();

    void onRowTap() {
      if (album == null) return;
      if (!hasFile) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.trackNotPlayable)),
        );
        return;
      }
      _playTrack(context, album, track.id);
    }

    return Opacity(
      opacity: hasFile ? 1.0 : 0.5,
      child: TvFocusable(
        onTap: album != null ? onRowTap : null,
        onLongPress: () => menuController.isOpen
            ? menuController.close()
            : menuController.open(),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: ListTile(
          key: isRequestedTrack ? _requestedTrackKey : null,
          tileColor: isRequestedTrack && _requestedTrackHighlighted
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.5)
              : null,
          dense: true,
          visualDensity: VisualDensity.compact,
          leading: SizedBox(
            width: 28,
            child: isPlaying
                ? Icon(Icons.graphic_eq, size: 18, color: accentColor)
                : Text(
                    '${track.number}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: mutedColor,
                        ),
                  ),
          ),
          title: Text(
            trackTitle,
            style: isPlaying
                ? TextStyle(color: accentColor, fontWeight: FontWeight.w600)
                : null,
          ),
          subtitle: subtitleChildren.isEmpty
              ? null
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: subtitleChildren,
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (durationText != null)
                Text(
                  durationText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: mutedColor,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                ),
              MenuAnchor(
                controller: menuController,
                menuChildren: [
                        MenuItemButton(
                          onPressed: hasFile
                              ? () => _addTrackToQueue(context, track.id)
                              : null,
                          child: ListTile(
                            leading: const Icon(Icons.playlist_add),
                            title: Text(loc.addToQueue),
                          ),
                        ),
                        MenuItemButton(
                          onPressed: hasFile
                              ? () => showAddToSessionSheet(
                                    context,
                                    serverName: widget.serverName,
                                    loadItems: (_) async =>
                                        [(Enum$MediaType.TRACK, track.id)],
                                  )
                              : null,
                          child: ListTile(
                            leading: const Icon(Icons.queue_music),
                            title: Text(loc.addToSession),
                          ),
                        ),
                        MenuItemButton(
                          onPressed: () => showRatingDialog(
                            context,
                            mediaType: Enum$RatingMediaType.TRACK,
                            mediaId: track.id,
                            rating: trackRating,
                            title: trackTitle,
                            onChanged: (value) => setState(
                                () => _trackRatingOverrides[track.id] = value),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.star_outline_rounded),
                            title: Text(loc.rate),
                          ),
                        ),
                        if (_showAdminActions)
                          MenuItemButton(
                            onPressed: () async {
                              final client = GraphQLProvider.of(context).value;
                              await client.mutate(MutationOptions(
                                document:
                                    documentNodeMutationanalyzeDataForTrackMutation,
                                variables: {'trackId': track.id},
                              ));
                            },
                            child: ListTile(
                              leading: const Icon(Icons.analytics),
                              title: Text(loc.analyzeMedia),
                            ),
                          ),
                ],
                builder: (_, MenuController controller, Widget? child) {
                  return IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => controller.isOpen
                        ? controller.close()
                        : controller.open(),
                  );
                },
              ),
            ],
          ),
          onTap: album != null ? onRowTap : null,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Fragment$fragmentAlbum? album) {
    final img = album != null
        ? ImageUtil.getImageByType(album.images, ImageTypes.cover)
        : null;
    final imageUrl = img != null
        ? ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(widget.serverName))
        : null;
    _updateAccent(imageUrl);

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: img?.blurHash,
      title: album != null
          ? MetadataUtil.titleWithYear(
              MetadataUtil.getTitle(album.metadata) ?? album.name,
              album.releaseYear)
          : null,
      subtitle: album?.artist.name,
      onSubtitleTap: album != null
          ? () => AutoRouter.of(context)
              .push(PersonRoute(personId: album.artist.id))
          : null,
    );
  }
}
