import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/downloadPodcastEpisode.graphql.dart';
import 'package:player/graphql/fragmentPodcast.graphql.dart';
import 'package:player/graphql/fragmentPodcastEpisode.graphql.dart';
import 'package:player/graphql/podcastById.graphql.dart';
import 'package:player/graphql/podcastEpisodesQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/unsubscribePodcast.graphql.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/MusicDetailHero.dart';
import '../components/RatingStars.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class PodcastPage extends StatefulWidget {
  const PodcastPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('podcastId') required this.podcastId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String podcastId;
  final String? playQueueId;

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  static const int _pageSize = 25;

  Fragment$fragmentPodcast? _podcast;
  final List<Fragment$fragmentPodcastEpisode> _episodes = [];
  int _nextPage = 0;
  int? _totalPages;
  bool _loadingEpisodes = false;

  bool get _hasMoreEpisodes => _totalPages == null || _nextPage < _totalPages!;

  void _scheduleLoadMoreEpisodes() {
    if (_loadingEpisodes || !_hasMoreEpisodes) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMoreEpisodes());
  }

  Future<void> _loadMoreEpisodes() async {
    if (_loadingEpisodes || !_hasMoreEpisodes || !mounted) return;
    setState(() => _loadingEpisodes = true);
    final client = GraphQLProvider.of(context).value;
    final result = await client.query(QueryOptions(
      document: documentNodeQuerypodcastEpisodes,
      variables: {'podcastId': widget.podcastId, 'page': _nextPage, 'size': _pageSize},
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (!mounted) return;
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      setState(() => _loadingEpisodes = false);
      return;
    }
    final page = Query$podcastEpisodes.fromJson(result.data!).podcastEpisodes;
    setState(() {
      _episodes.addAll(page.content);
      _totalPages = page.totalPages;
      _nextPage++;
      _loadingEpisodes = false;
    });
  }

  Future<void> _refreshEpisodes() async {
    setState(() {
      _episodes.clear();
      _nextPage = 0;
      _totalPages = null;
    });
    await _loadMoreEpisodes();
  }

  void _play(BuildContext context, {String? episodeId}) {
    final client = GraphQLProvider.of(context).value;
    MediaPlayerHandler.instance.startPlayQueueForPodcast(
      client,
      widget.playQueueId,
      widget.podcastId,
      episodeId,
      widget.serverName,
    );
  }

  Future<void> _download(BuildContext context, String episodeId) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationdownloadPodcastEpisode,
      variables: {'episodeId': episodeId},
    ));
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(
        content: Text(result.hasException
            ? loc.downloadFailed
            : loc.downloadStarted)));
  }

  Future<void> _unsubscribe(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;
    final router = AutoRouter.of(context);
    await client.mutate(MutationOptions(
      document: documentNodeMutationunsubscribePodcast,
      variables: {'id': widget.podcastId},
    ));
    router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerypodcastById,
        variables: {'id': widget.podcastId},
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
            body: Skeletonizer(enabled: true, child: _buildContent()),
          );
        }

        _podcast = Query$podcastById.fromJson(result.data!).podcastById;
        return Scaffold(body: _buildContent());
      },
    );
  }

  Widget _buildContent() {
    final loc = AppLocalizations.of(context)!;
    final podcast = _podcast;
    final description =
        podcast != null ? MetadataUtil.getDescription(podcast.metadata) : null;

    return RefreshIndicator(
      onRefresh: _refreshEpisodes,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            foregroundColor: Colors.white,
            actions: [
              if (podcast != null)
                MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () => _unsubscribe(context),
                      child: ListTile(
                        leading: const Icon(Icons.unsubscribe),
                        title: Text(loc.unsubscribe),
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildHeader(context, podcast),
            ),
          ),
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: FilledButton.icon(
                  onPressed: podcast != null &&
                          _episodes.any((e) => e.downloaded)
                      ? () => _play(context)
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(loc.play),
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                  ),
                ),
              ),
            ),
          ),
          if (podcast != null)
            SliverToBoxAdapter(
              child: _constrained(
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: RatingStars(
                    mediaType: Enum$RatingMediaType.PODCAST,
                    mediaId: podcast.id,
                    rating: podcast.rating,
                  ),
                ),
              ),
            ),
          if (description != null)
            SliverToBoxAdapter(
              child: _constrained(
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.description,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(description),
                    ],
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(loc.episodes,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: _episodes.length + (_hasMoreEpisodes ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _episodes.length) {
                _scheduleLoadMoreEpisodes();
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: _buildEpisodeTile(context, _episodes[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeTile(
      BuildContext context, Fragment$fragmentPodcastEpisode episode) {
    final loc = AppLocalizations.of(context)!;
    final title = MetadataUtil.getTitle(episode.metadata) ?? '';
    final durationMs = episode.durationInMilliseconds;
    final durationText = durationMs != null && durationMs > 0
        ? DurationUtil.format(Duration(milliseconds: durationMs))
        : null;
    final publishedAt = episode.publishedAt?.split('T').firstOrNull;
    final status = episode.watchStatus?.firstOrNull;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final subtitleParts = [
      if (publishedAt != null) publishedAt,
      if (durationText != null) durationText,
    ];

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        status?.watched == true
            ? Icons.check
            : episode.downloaded
                ? Icons.play_circle_outline
                : Icons.cloud_download_outlined,
        color: mutedColor,
      ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(
              subtitleParts.join(' · '),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: mutedColor),
            ),
      trailing: episode.downloaded
          ? null
          : IconButton(
              icon: const Icon(Icons.download),
              tooltip: loc.download,
              onPressed: () => _download(context, episode.id),
            ),
      onTap: () {
        if (episode.downloaded) {
          _play(context, episodeId: episode.id);
        } else {
          _download(context, episode.id);
        }
      },
    );
  }

  Widget _constrained(Widget child) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Fragment$fragmentPodcast? podcast) {
    final img = podcast != null
        ? ImageUtil.getImageByType(podcast.images, ImageTypes.cover)
        : null;
    final imageUrl = img != null
        ? ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(widget.serverName))
        : null;

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: img?.blurHash,
      title: podcast != null
          ? (MetadataUtil.getTitle(podcast.metadata) ?? podcast.title)
          : null,
      subtitle: podcast?.author,
    );
  }
}
