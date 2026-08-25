import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/AddToSessionSheet.dart';
import 'package:player/components/DevicePickerSheet.dart';
import 'package:player/components/CastRow.dart';
import 'package:player/components/MediaMetaLine.dart';
import 'package:player/components/RatingStars.dart';
import 'package:player/components/SourceAttribution.dart';
import 'package:player/graphql/analyzeDataForShow.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/graphql/seasonById.graphql.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:flutter/foundation.dart';
import 'package:player/components/download/AutoNextDialog.dart';
import 'package:player/components/download/DownloadMenuItem.dart';
import 'package:player/utils/download/DownloadLoaders.dart';
import 'package:player/utils/download/DownloadPreferences.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/NextUnwatched.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Placeholder cast so the skeleton reserves the same height as the real
/// [CastRow]; without it the page grows by a whole row once data lands.
final _skeletonCast = List.generate(
  6,
  (i) => Fragment$fragmentCastMember(
    id: 'skeleton-$i',
    characterName: BoneMock.name,
    creditType: Enum$CreditType.CAST,
    castOrder: i,
    person: Fragment$fragmentCastMember$person(
      id: 'skeleton-person-$i',
      name: BoneMock.name,
    ),
  ),
);

@RoutePage()
class ShowOverviewContentPage extends StatefulWidget {
  const ShowOverviewContentPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
  });

  final String serverName;
  final String showId;

  @override
  State<ShowOverviewContentPage> createState() =>
      _ShowOverviewContentPageState();
}

class _ShowOverviewContentPageState extends State<ShowOverviewContentPage> {
  String get serverName => widget.serverName;
  String get showId => widget.showId;

  bool _showAdminActions = true;

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          // document: gql(getEpisodesRecentWatched),
          document: documentNodeQueryshowById,
          variables: Map.of({"id": showId})),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        Widget body = Text("Body");

        // `isLoading` alone would re-skeletonize whenever cacheAndNetwork
        // revalidates on top of cached data, which makes the page jump.
        final loading = result.data == null && result.isLoading;

        if (loading) {
          body = Skeletonizer(
              enabled: true,
              child: _buildContent(null, null, BoneMock.name,
                  BoneMock.paragraph, null, null, context, '',
                  CastRow(serverName: serverName, cast: _skeletonCast), null));
        } else if (result.hasException) {
          body = Text(result.exception.toString());
        } else {
          final parsedData = Query$showById.fromJson(result.data!);

          Query$showById$showById? show = parsedData.showById;

          if (show == null) {
            body = Text(AppLocalizations.of(context)!.noShowFound);
          } else {
            var imageByType =
                ImageUtil.getImageByType(show.images, ImageTypes.background);
            body = _buildContent(
                ImageUtil.buildUrl(imageByType, token: StreamTokenService.getToken(serverName)),
                imageByType?.blurHash,
                MetadataUtil.titleWithYear(
                    MetadataUtil.getTitle(show.metadata) ?? "",
                    show.releaseYear),
                MetadataUtil.getDescription(show.metadata) ?? "",
                show.metadata,
                show.images,
                context,
                show.toJson().toString(),
                PagedCastRow(serverName: serverName, showId: showId),
                RatingStars(
                  mediaType: Enum$RatingMediaType.SHOW,
                  mediaId: show.id,
                  rating: show.rating,
                ),
                show: show);
          }
        }

        return body;
      },
    );
  }

  SingleChildScrollView _buildContent(
      String? imageUrl,
      String? blurHash,
      String title,
      String description,
      List<Fragment$fragmentMetadata>? metadata,
      List<Fragment$fragmentImages?>? images,
      BuildContext context,
      String? rawJson,
      Widget castRow,
      Widget? ratingRow,
      {Query$showById$showById? show}) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth < 800 ? 300 : 500,
          width: constraints.maxWidth,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          child: (imageUrl != null && imageUrl != '')
              ? CachedNetworkImage(
                  placeholder: (context, url) => blurHash != null
                      ? BlurHash(
                          hash: blurHash,
                          optimizationMode: BlurHashOptimizationMode.standard,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          duration: Duration.zero,
                        )
                      : Container(),
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                  fadeOutDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                )
              : Container(),
        );
      }),
      Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.headlineSmall)),
                if (rawJson != null)
                  MenuAnchor(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          _dialogBuilder(context, rawJson);
                        },
                        child: ListTile(
                          leading: const Icon(Icons.info),
                          title: Text(AppLocalizations.of(context)!.rawData),
                        ),
                      ),
                      if (!kIsWeb)
                        MenuItemButton(
                          onPressed: () => _downloadNextUnwatched(context),
                          child: ListTile(
                            leading: const Icon(Icons.download_for_offline_outlined),
                            title: Text(AppLocalizations.of(context)!.downloadNextUnwatched),
                          ),
                        ),
                      if (!kIsWeb)
                        MenuItemButton(
                          onPressed: () => configureAutoNext(context,
                              serverName: serverName,
                              showId: showId,
                              title: title),
                          child: ListTile(
                            leading: const Icon(Icons.autorenew),
                            title: Text(AppLocalizations.of(context)!.autoNextTitle),
                          ),
                        ),
                      if (_showAdminActions)
                        MenuItemButton(
                          onPressed: () async {
                            final client = GraphQLProvider.of(context).value;
                            await client.mutate(MutationOptions(
                              document: documentNodeMutationanalyzeDataForShowMutation,
                              variables: {'showId': showId},
                            ));
                          },
                          child: ListTile(
                            leading: const Icon(Icons.analytics),
                            title: Text(AppLocalizations.of(context)!.analyzeMedia),
                          ),
                        ),
                      MenuItemButton(
                        onPressed: () => showAddToSessionSheet(
                          context,
                          serverName: serverName,
                          loadItems: _loadShowEpisodes,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.playlist_add),
                          title: Text(AppLocalizations.of(context)!.addToSession),
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () => playOnDevice(
                          context,
                          serverName: serverName,
                          mediaType: Enum$MediaType.EPISODE,
                          mediaId: showId,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(AppLocalizations.of(context)!.devicePlayOn),
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
            if (ratingRow != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ratingRow,
                    CommunityRating(
                      voteAverage: show?.voteAverage,
                      voteCount: show?.voteCount,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: MediaMetaLine(
                released: MetadataUtil.getReleased(metadata),
                contentRating: show?.contentRating,
                genres: MetadataUtil.getGenre(metadata),
                networks: show?.networks,
                status: show?.status,
              ),
            ),
            if (MetadataUtil.getTagline(metadata) != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  MetadataUtil.getTagline(metadata)!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            Text(description),
            if (show?.trailerKey != null && show?.trailerSite == 'YouTube')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TrailerButton(trailerKey: show!.trailerKey!),
              ),
            if ((show?.studios ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  show!.studios!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            if ((show?.keywords ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  show!.keywords!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SourceAttribution(metadata: metadata, images: images),
            ),
          ])),
      castRow,
    ]));
  }

  /// All playable episodes of the show in season/episode order, for "add to
  /// session". showById only carries season ids, so the episodes are fetched
  /// per season — sequentially, seasons in order — once a session was chosen.
  Future<List<AddToSessionItem>> _loadShowEpisodes(GraphQLClient client) async {
    final (_, episodes, _) = await _loadShowEpisodeList(client);
    return [
      for (final episode in episodes)
        if (episode.mediaFile != null && episode.mediaFile!.isNotEmpty)
          (Enum$MediaType.EPISODE, episode.id),
    ];
  }

  /// The show's name, every episode in season/episode order, and each
  /// episode's season number.
  Future<(String?, List<Query$seasonById$seasonById$episodes>, Map<String, int>)>
      _loadShowEpisodeList(GraphQLClient client) async {
    final show = await DownloadLoaders.showEpisodes(client, showId);
    return (show.title, show.episodes, show.seasonNumbers);
  }

  /// "Download the next N unwatched": continues from the last episode that
  /// was watched or started (a started one counts as the first of the N).
  Future<void> _downloadNextUnwatched(BuildContext context) async {
    final n = await showDownloadNextDialog(context,
        defaultCount:
            await DownloadPreferences.getDefaultNextCount(widget.serverName));
    if (n == null || n <= 0 || !context.mounted) return;
    await enqueueDownloads(context, widget.serverName, (client) async {
      final (title, episodes, seasonNumbers) = await _loadShowEpisodeList(client);
      final picked = NextUnwatched.select(episodes, n);
      final requests = <DownloadRequest>[];
      for (final e in picked) {
        requests.addAll(await DownloadLoaders.episode(client, e.id,
            groupTitle: title, seasonNumber: seasonNumbers[e.id]));
      }
      return requests;
    });
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
