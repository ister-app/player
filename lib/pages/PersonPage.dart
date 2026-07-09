import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForPerson.graphql.dart';
import 'package:player/graphql/artistById.graphql.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
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
class PersonPage extends StatelessWidget {
  const PersonPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('personId') required this.personId,
  });

  final String serverName;
  final String personId;

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
          variables: {'id': personId},
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
    final credits = artist?.credits ?? [];
    final description = artist != null ? MetadataUtil.getDescription(artist.metadata) : null;
    final hasAlbums = albums.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          actions: [
            if (artist != null)
              IconButton(
                icon: const Icon(Icons.analytics),
                tooltip: loc.analyzeMedia,
                onPressed: () async {
                  final client = GraphQLProvider.of(context).value;
                  await client.mutate(MutationOptions(
                    document: documentNodeMutationanalyzeDataForPersonMutation,
                    variables: {'personId': artist.id},
                  ));
                },
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHero(context, loc, artist),
          ),
        ),
        if (hasAlbums)
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
        if (hasAlbums)
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
        if (hasAlbums)
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
                    placeholderIcon: Icons.music_note,
                    onTap: () => AutoRouter.of(context)
                        .push(AlbumRoute(albumId: album.id)),
                  );
                },
              ),
            ),
          ),
        ),
        if (credits.isNotEmpty) _buildFilmography(context, loc, credits),
      ],
    );
  }

  Widget _buildFilmography(BuildContext context, AppLocalizations loc,
      List<Fragment$fragmentPersonCredit> credits) {
    // A person can hold several credits for the same title — a show-level credit
    // (with a role) plus one credit per episode. Merge everything per title so a
    // show shows up exactly once, with its episode count and role combined.
    final movies = <String, _MovieEntry>{};
    final shows = <String, _ShowEntry>{};

    for (final credit in credits) {
      final movie = credit.movie;
      final show = credit.$show;
      final episode = credit.episode;
      if (movie != null) {
        movies.putIfAbsent(
          movie.id,
          () => _MovieEntry(
            id: movie.id,
            name: movie.name,
            releaseYear: movie.releaseYear,
            images: movie.images,
            role: credit.characterName,
          ),
        );
      } else if (show != null) {
        final entry = shows.putIfAbsent(show.id, () => _ShowEntry(show.id));
        entry.name = show.name;
        entry.releaseYear = show.releaseYear;
        entry.images ??= show.images;
        entry.showRole ??= credit.characterName;
      } else if (episode != null && episode.$show != null) {
        final s = episode.$show!;
        final entry = shows.putIfAbsent(s.id, () => _ShowEntry(s.id));
        entry.name = s.name;
        entry.releaseYear = s.releaseYear;
        entry.images ??= s.images;
        entry.addEpisode(episode, credit.characterName);
      }
      // Credits without a resolvable media reference are skipped.
    }

    // Movies and shows share one list, sorted by release date (newest first).
    // Tapping a movie opens the movie; tapping a show opens a sheet listing its
    // episodes, whose header links to the show and whose rows link to episodes.
    final entries = <({int releaseYear, Widget row})>[
      for (final m in movies.values)
        (
          releaseYear: m.releaseYear,
          row: _entryRow(
            context,
            name: m.name,
            subtitle: _subtitle(loc, year: m.releaseYear, role: m.role),
            images: m.images,
            onTap: () =>
                AutoRouter.of(context).push(MovieRoute(movieId: m.id)),
          ),
        ),
      for (final s in shows.values)
        (
          releaseYear: s.releaseYear,
          row: _entryRow(
            context,
            name: s.name,
            subtitle: _subtitle(
              loc,
              year: s.releaseYear,
              episodeCount: s.episodeCount > 0 ? s.episodeCount : null,
              role: s.role,
            ),
            images: s.images,
            onTap: () => _showEpisodesSheet(context, s),
          ),
        ),
    ]..sort((a, b) => b.releaseYear.compareTo(a.releaseYear));

    final rows = [for (final e in entries) e.row];

    if (rows.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  loc.appearsIn,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...rows,
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Joins the release year, episode count and role into a single subtitle
  /// line, e.g. "1984 · 65 afleveringen · Johnny Lawrence". Any part may be
  /// absent (a year of 0 means unknown and is dropped).
  String? _subtitle(AppLocalizations loc,
      {int? year, int? episodeCount, String? role}) {
    final parts = <String>[
      if (year != null && year > 0) '$year',
      if (episodeCount != null) loc.episodeCount(episodeCount),
      if ((role ?? '').isNotEmpty) role!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Widget _entryRow(
    BuildContext context, {
    required String name,
    String? subtitle,
    List<Fragment$fragmentImages>? images,
    required VoidCallback? onTap,
  }) {
    // Prefer the wide background art; fall back to the poster/cover.
    final img = ImageUtil.getImageByType(images, ImageTypes.background) ??
        ImageUtil.getImageByType(images, ImageTypes.cover);
    final imageUrl =
        ImageUtil.buildUrl(img, token: StreamTokenService.getToken(serverName));
    final placeholder = Icon(
      Icons.movie,
      size: 32,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: 160,
                height: 90,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: (imageUrl != null && imageUrl != '')
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorBuilder: (_, __, ___) =>
                              Center(child: placeholder),
                        )
                      : Center(child: placeholder),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if ((subtitle ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showEpisodesSheet(BuildContext context, _ShowEntry entry) {
    // Capture the router from the page context; inside the modal the sheet's
    // own context can't resolve the server-scoped route tree reliably.
    final router = AutoRouter.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PersonShowEpisodesSheet(
        serverName: serverName,
        router: router,
        showId: entry.showId,
        showName: entry.name,
        episodes: entry.episodes,
      ),
    );
  }

  Widget _buildHero(BuildContext context, AppLocalizations loc,
      Query$artistById$artistById? artist) {
    final backgroundImg = artist != null
        ? ImageUtil.getImageByType(artist.images, ImageTypes.background)
        : null;
    // Actors have no background art and no albums — their photo is a COVER
    // image (the TMDB profile). Fall back to that so the person still gets a
    // portrait in the hero instead of the placeholder icon.
    final personCoverImg = artist != null
        ? ImageUtil.getImageByType(artist.images, ImageTypes.cover)
        : null;
    final firstAlbum = artist?.albums?.isNotEmpty == true ? artist!.albums!.first : null;
    final firstAlbumCoverImg = firstAlbum != null
        ? ImageUtil.getImageByType(firstAlbum.images, ImageTypes.cover)
        : null;
    final heroImg = backgroundImg ?? personCoverImg ?? firstAlbumCoverImg;
    final imageUrl = heroImg != null
        ? ImageUtil.buildUrl(heroImg,
            token: StreamTokenService.getToken(serverName))
        : null;

    final name = artist != null
        ? MetadataUtil.getTitle(artist.metadata) ?? artist.name
        : null;

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: heroImg?.blurHash,
      title: name,
      subtitle: artist != null ? _heroSubtitle(loc, artist) : null,
      backgroundAlignment: Alignment.topCenter,
      placeholderIcon: Icons.person,
    );
  }

  /// Summarises what a person has, showing only the categories they actually
  /// appear in — e.g. "2 films" or "3 albums · 1 serie", never "0 albums".
  String? _heroSubtitle(
      AppLocalizations loc, Query$artistById$artistById artist) {
    final albumCount = artist.albums?.length ?? 0;

    // Count distinct movies and shows across the credits, mirroring how the
    // filmography merges episode credits back onto their show.
    final movieIds = <String>{};
    final showIds = <String>{};
    for (final credit in artist.credits ?? const []) {
      final movie = credit.movie;
      final show = credit.$show;
      final episode = credit.episode;
      if (movie != null) {
        movieIds.add(movie.id);
      } else if (show != null) {
        showIds.add(show.id);
      } else if (episode?.$show != null) {
        showIds.add(episode!.$show!.id);
      }
    }

    final parts = <String>[
      if (albumCount > 0) loc.albumCount(albumCount),
      if (movieIds.isNotEmpty) loc.movieCount(movieIds.length),
      if (showIds.isNotEmpty) loc.showCount(showIds.length),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// A movie a person is credited in.
class _MovieEntry {
  _MovieEntry({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.images,
    required this.role,
  });

  final String id;
  final String name;
  final int releaseYear;
  final List<Fragment$fragmentImages>? images;
  final String? role;
}

/// All of a person's credits for one show, merged: a show-level credit (with a
/// role) and any per-episode credits. Episodes are de-duplicated by id (a person
/// can hold more than one credit on the same episode, e.g. cast + guest star).
class _ShowEntry {
  _ShowEntry(this.showId);

  final String showId;
  String name = '';
  int releaseYear = 0;
  List<Fragment$fragmentImages>? images;

  /// Role from a show-level credit; wins over per-episode roles when present.
  String? showRole;
  String? _episodeRole;
  final Map<String, Fragment$fragmentPersonCredit$episode> _episodesById = {};

  void addEpisode(
      Fragment$fragmentPersonCredit$episode episode, String? character) {
    _episodesById[episode.id] = episode;
    if ((_episodeRole ?? '').isEmpty && (character ?? '').isNotEmpty) {
      _episodeRole = character;
    }
  }

  List<Fragment$fragmentPersonCredit$episode> get episodes =>
      _episodesById.values.toList();

  int get episodeCount => _episodesById.length;

  String? get role =>
      (showRole ?? '').isNotEmpty ? showRole : _episodeRole;
}

/// One season's worth of a person's episodes, ready to render in the sheet.
class _SeasonBucket {
  _SeasonBucket({required this.id, this.number});

  final String id;
  final int? number;
  final List<Fragment$fragmentPersonCredit$episode> episodes = [];
}

/// Bottom sheet listing the episodes a person appears in for one show, grouped
/// under the same expandable season bar used on the show overview page.
class _PersonShowEpisodesSheet extends StatefulWidget {
  const _PersonShowEpisodesSheet({
    required this.serverName,
    required this.router,
    required this.showId,
    required this.showName,
    required this.episodes,
  });

  final String serverName;
  final StackRouter router;
  final String showId;
  final String showName;
  final List<Fragment$fragmentPersonCredit$episode> episodes;

  @override
  State<_PersonShowEpisodesSheet> createState() =>
      _PersonShowEpisodesSheetState();
}

class _PersonShowEpisodesSheetState extends State<_PersonShowEpisodesSheet> {
  late final List<_SeasonBucket> _seasons;
  String? _expandedSeasonId;

  @override
  void initState() {
    super.initState();
    _seasons = _groupBySeason(widget.episodes);
    // Auto-expand when there is only a single season to save a tap.
    if (_seasons.length == 1) {
      _expandedSeasonId = _seasons.first.id;
    }
  }

  List<_SeasonBucket> _groupBySeason(
      List<Fragment$fragmentPersonCredit$episode> episodes) {
    const noSeasonKey = '__none__';
    final buckets = <String, _SeasonBucket>{};
    for (final episode in episodes) {
      final season = episode.season;
      final key = season?.id ?? noSeasonKey;
      buckets
          .putIfAbsent(key, () => _SeasonBucket(id: key, number: season?.number))
          .episodes
          .add(episode);
    }
    // Unknown seasons sort last; episodes within a season sort by number.
    const last = 1 << 30;
    final ordered = buckets.values.toList()
      ..sort((a, b) => (a.number ?? last).compareTo(b.number ?? last));
    for (final bucket in ordered) {
      bucket.episodes.sort((a, b) => a.number.compareTo(b.number));
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The header links to the show itself; episodes below link to
              // their episode. Pop the sheet first so the page can navigate.
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.router.push(ShowOverviewRoute(showId: widget.showId));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.showName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    _expandedSeasonId =
                        isExpanded ? _seasons[index].id : null;
                  });
                },
                children: _seasons.map<ExpansionPanel>((bucket) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(bucket.number != null
                          ? loc.season(bucket.number!)
                          : widget.showName),
                      subtitle: Text(loc.episodeCount(bucket.episodes.length)),
                    ),
                    body: Column(
                      children: bucket.episodes
                          .map((episode) => _episodeTile(context, loc, episode))
                          .toList(),
                    ),
                    isExpanded: _expandedSeasonId == bucket.id,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _episodeTile(BuildContext context, AppLocalizations loc,
      Fragment$fragmentPersonCredit$episode episode) {
    final metaTitle = MetadataUtil.getTitle(episode.metadata);
    final title = metaTitle ?? loc.episode(episode.number);
    final img = ImageUtil.getImageByType(episode.images, ImageTypes.background) ??
        ImageUtil.getImageByType(episode.images, ImageTypes.cover);
    final imageUrl = ImageUtil.buildUrl(img,
        token: StreamTokenService.getToken(widget.serverName));
    final showId = episode.$show?.id;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 80,
          height: 56,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: (imageUrl != null && imageUrl != '')
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle:
          metaTitle != null ? Text(loc.episode(episode.number)) : null,
      onTap: showId == null
          ? null
          : () {
              Navigator.of(context).pop();
              widget.router
                  .push(ShowEpisodeRoute(showId: showId, episodeId: episode.id));
            },
    );
  }
}
