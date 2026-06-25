import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/albumById.graphql.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentTrack.graphql.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/MusicDetailHero.dart';
import '../l10n/app_localizations.dart';

final _random = Random();

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

        if (result.data == null || result.isLoading) {
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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHeader(album),
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
                        onPressed: album != null && tracks.isNotEmpty
                            ? () => _playTrack(context, album, tracks.first.id)
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
                                final randomTrack =
                                    tracks[_random.nextInt(tracks.length)];
                                _playTrack(context, album, randomTrack.id);
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
                  final trackTitle =
                      MetadataUtil.getTitle(track.metadata) ?? '${track.number}';
                  final durationMs = track.mediaFile?.firstOrNull?.durationInMilliseconds;
                  final durationText = durationMs != null
                      ? DurationUtil.format(Duration(milliseconds: durationMs))
                      : null;
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: SizedBox(
                      width: 28,
                      child: Text(
                        '${track.number}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        if (durationText != null)
                          Text(
                            durationText,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.more_vert),
                    onTap: album != null
                        ? () => _playTrack(context, album, track.id)
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Fragment$fragmentAlbum? album) {
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
    );
  }
}
