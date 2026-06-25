import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/artistById.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/CarouselItemView.dart';
import '../components/MusicDetailHero.dart';
import '../l10n/app_localizations.dart';

final _random = Random();

@RoutePage()
class ArtistPage extends StatelessWidget {
  const ArtistPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('artistId') required this.artistId,
  });

  final String serverName;
  final String artistId;

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
          document: documentNodeQueryartistById,
          variables: {'id': artistId},
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
              child: _buildContent(context, null),
            ),
          );
        }

        final artist = Query$artistById.fromJson(result.data!).artistById;

        return Scaffold(
          body: _buildContent(context, artist),
        );
      },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, Query$artistById$artistById? artist) {
    final loc = AppLocalizations.of(context)!;
    final albums = artist?.albums ?? [];
    final description = artist != null ? MetadataUtil.getDescription(artist.metadata) : null;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHero(context, artist),
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
                        onPressed: albums.isNotEmpty
                            ? () => AutoRouter.of(context)
                                .push(AlbumRoute(albumId: albums.first.id))
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
                        onPressed: albums.isNotEmpty
                            ? () {
                                final randomAlbum =
                                    albums[_random.nextInt(albums.length)];
                                AutoRouter.of(context)
                                    .push(AlbumRoute(albumId: randomAlbum.id));
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
                  loc.albums,
                  style: Theme.of(context).textTheme.titleMedium,
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final img =
                      ImageUtil.getImageByType(album.images, ImageTypes.cover);
                  return CarouselItemView(
                    serverName: serverName,
                    title: MetadataUtil.getTitle(album.metadata) ?? album.name,
                    subTitle: album.artist.name,
                    imageUrl: ImageUtil.buildUrl(img,
                        token: StreamTokenService.getToken(serverName)),
                    blurHash: img?.blurHash,
                    onTap: () => AutoRouter.of(context)
                        .push(AlbumRoute(albumId: album.id)),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(
      BuildContext context, Query$artistById$artistById? artist) {
    final backgroundImg = artist != null
        ? ImageUtil.getImageByType(artist.images, ImageTypes.background)
        : null;
    final firstAlbum = artist?.albums?.isNotEmpty == true ? artist!.albums!.first : null;
    final firstAlbumCoverImg = firstAlbum != null
        ? ImageUtil.getImageByType(firstAlbum.images, ImageTypes.cover)
        : null;
    final heroImg = backgroundImg ?? firstAlbumCoverImg;
    final imageUrl = heroImg != null
        ? ImageUtil.buildUrl(heroImg,
            token: StreamTokenService.getToken(serverName))
        : null;

    final name = artist != null
        ? MetadataUtil.getTitle(artist.metadata) ?? artist.name
        : null;
    final albumCount = artist?.albums?.length;

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: heroImg?.blurHash,
      title: name,
      subtitle: albumCount != null
          ? '$albumCount ${albumCount == 1 ? 'album' : 'albums'}'
          : null,
      backgroundAlignment: Alignment.topCenter,
    );
  }
}
