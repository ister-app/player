import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/downloadPodcastEpisode.graphql.dart';
import 'package:player/graphql/fragmentPodcast.graphql.dart';
import 'package:player/graphql/fragmentPodcastEpisode.graphql.dart';
import 'package:player/graphql/podcastById.graphql.dart';
import 'package:player/graphql/podcastEpisodesQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/setPodcastEpisodeOrder.graphql.dart';
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
import '../components/SourceAttribution.dart';
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

  /// The user's episode order, as stored on the server. Null until the podcast query answers;
  /// the episode query then falls back to the same stored order, so the first page is right
  /// either way. A local choice wins over a later server value while its save is in flight.
  Enum$SortingOrder? _order;
  bool _savingOrder = false;

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
      variables: {
        'podcastId': widget.podcastId,
        'page': _nextPage,
        'size': _pageSize,
        'sortingOrder': _order?.name,
      },
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

  /// Stores the order on the server (so every client of this user follows it) and reloads the
  /// list from page 0 — [_refreshEpisodes] clears the accumulated pages, which it has to: pages
  /// in the old and the new order must never end up in the same list.
  Future<void> _setOrder(BuildContext context, Enum$SortingOrder order) async {
    if (order == _order) return;
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final client = GraphQLProvider.of(context).value;
    final previous = _order;

    setState(() {
      _order = order;
      _savingOrder = true;
    });
    await _refreshEpisodes();

    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetPodcastEpisodeOrder,
      variables: {'podcastId': widget.podcastId, 'order': order.name},
    ));
    if (!mounted) return;
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      setState(() {
        _order = previous;
        _savingOrder = false;
      });
      messenger.showSnackBar(SnackBar(content: Text(loc.sortOrderFailed)));
      await _refreshEpisodes();
      return;
    }
    setState(() => _savingOrder = false);
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
        // Adopt the stored order, unless the user just picked one that is still being saved.
        if (!_savingOrder) {
          _order = _podcast?.episodeOrder ?? _order;
        }
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
                    _orderMenuItem(
                        context, loc.newestFirst, Enum$SortingOrder.DESCENDING),
                    _orderMenuItem(
                        context, loc.oldestFirst, Enum$SortingOrder.ASCENDING),
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
                      const SizedBox(height: 6),
                      SourceAttribution(
                          metadata: podcast?.metadata,
                          images: podcast?.images),
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

  Widget _orderMenuItem(
      BuildContext context, String label, Enum$SortingOrder order) {
    return MenuItemButton(
      onPressed: () => _setOrder(context, order),
      child: ListTile(
        leading: Icon(_order == order ? Icons.check : Icons.sort),
        title: Text(label),
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
