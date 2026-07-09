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
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/MusicDetailHero.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class AlbumPage extends StatefulWidget {
  const AlbumPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('albumId') required this.albumId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String albumId;
  final String? playQueueId;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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

  /// A track can only be played/queued once it has an analyzed media file.
  static bool _trackHasFile(Fragment$fragmentTrack track) =>
      track.mediaFile?.isNotEmpty == true;

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
        final tracks = albumData?.tracks ?? [];

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
            if (album != null)
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
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
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
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (metaLine != null)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(
                    metaLine,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  final hasFile = _trackHasFile(track);
                  final trackTitle =
                      MetadataUtil.getTitle(track.metadata) ?? '${track.number}';
                  final durationMs = track.mediaFile?.firstOrNull?.durationInMilliseconds;
                  final durationText = durationMs != null
                      ? DurationUtil.format(Duration(milliseconds: durationMs))
                      : null;
                  // Not-yet-analyzed tracks have no playable file: mute them and
                  // steer the user to "Analyze media" instead of a dead tap.
                  final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
                  return Opacity(
                    opacity: hasFile ? 1.0 : 0.5,
                    child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: SizedBox(
                      width: 28,
                      child: Text(
                        '${track.number}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: mutedColor,
                            ),
                      ),
                    ),
                    title: Text(trackTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          track.artist.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: mutedColor,
                              ),
                        ),
                        if (durationText != null)
                          Text(
                            durationText,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: mutedColor,
                                ),
                          )
                        else if (!hasFile)
                          Text(
                            loc.trackNotPlayable,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: mutedColor,
                                ),
                          ),
                      ],
                    ),
                    trailing: MenuAnchor(
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
                    onTap: album != null
                        ? () {
                            if (!hasFile) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.trackNotPlayable)),
                              );
                              return;
                            }
                            _playTrack(context, album, track.id);
                          }
                        : null,
                  ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
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

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: img?.blurHash,
      title: album != null
          ? (MetadataUtil.getTitle(album.metadata) ?? album.name)
          : null,
      subtitle: album?.artist.name,
      onSubtitleTap: album != null
          ? () => AutoRouter.of(context)
              .push(PersonRoute(personId: album.artist.id))
          : null,
    );
  }
}
