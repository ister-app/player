import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/castByParent.graphql.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../l10n/app_localizations.dart';

/// Fixed height reserved for the horizontal cast strip; a bounded height is
/// required so the lazy [ListView] in [PagedCastRow] can scroll horizontally.
const double _kCastRowHeight = 190;

/// Width of a single cast avatar tile (used as the list item extent).
const double _kCastTileWidth = 104;

/// Sorts credits by [Credit.castOrder] (unordered entries last) and merges
/// people who hold several credits into one entry listing every character
/// they play. Shared by the eager [CastRow] and the paged [PagedCastRow].
List<_CastEntry> _mergeCredits(List<Fragment$fragmentCastMember> cast) {
  final sorted = [...cast]..sort((a, b) {
      final ao = a.castOrder;
      final bo = b.castOrder;
      if (ao == null && bo == null) return 0;
      if (ao == null) return 1;
      if (bo == null) return -1;
      return ao.compareTo(bo);
    });

  final merged = <String, _CastEntry>{};
  for (final credit in sorted) {
    final entry = merged.putIfAbsent(
      credit.person.id,
      () => _CastEntry(credit.person),
    );
    final character = (credit.characterName ?? '').trim();
    if (character.isNotEmpty && !entry.characters.contains(character)) {
      entry.characters.add(character);
    }
  }

  return merged.values.toList();
}

/// The section header shown above every cast strip.
Widget _castHeader(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        AppLocalizations.of(context)!.cast,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );

/// Horizontal strip of the people credited on a movie, show or episode built
/// from an already-loaded list. Used for the loading skeleton; live pages use
/// [PagedCastRow], which fetches the cast as a separate paged call.
class CastRow extends StatelessWidget {
  const CastRow({
    super.key,
    required this.serverName,
    required this.cast,
  });

  final String serverName;
  final List<Fragment$fragmentCastMember> cast;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    final entries = _mergeCredits(cast);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _castHeader(context),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in entries)
                    _CastMemberTile(serverName: serverName, entry: entry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal cast strip that fetches the cast as its own paged query
/// (`castByParent`) and lazily loads further pages as they scroll into view,
/// mirroring the home page's slides. Supply exactly one of
/// [showId]/[movieId]/[episodeId].
class PagedCastRow extends StatefulWidget {
  const PagedCastRow({
    super.key,
    required this.serverName,
    this.showId,
    this.movieId,
    this.episodeId,
  });

  final String serverName;
  final String? showId;
  final String? movieId;
  final String? episodeId;

  @override
  State<PagedCastRow> createState() => _PagedCastRowState();
}

class _PagedCastRowState extends State<PagedCastRow> {
  static const int _pageSize = 20;

  // Per-page storage: page 0 comes from the main query, later pages from
  // fetchMore. A single flat list would let a racing page-0 rebuild wipe
  // pages that already arrived.
  final Map<int, List<Fragment$fragmentCastMember>> _pageData = {};
  int? _totalItems;
  DateTime? _lastResultTimestamp;
  final Set<int> _requestedPages = {0};

  Map<String, dynamic> get _idVariables => {
        if (widget.showId != null) 'showId': widget.showId,
        if (widget.movieId != null) 'movieId': widget.movieId,
        if (widget.episodeId != null) 'episodeId': widget.episodeId,
      };

  List<Fragment$fragmentCastMember> get _orderedItems {
    final out = <Fragment$fragmentCastMember>[];
    for (var page = 0; _pageData.containsKey(page); page++) {
      out.addAll(_pageData[page]!);
    }
    return out;
  }

  void _requestPage(int page, FetchMore fetchMore) {
    if (_requestedPages.contains(page)) return;
    _requestedPages.add(page);

    fetchMore(
      FetchMoreOptions(
        variables: {'page': page, 'size': _pageSize},
        updateQuery: (previous, fetchMoreResult) {
          if (fetchMoreResult == null ||
              fetchMoreResult['cast']?['content'] == null) {
            _requestedPages.remove(page);
            return previous!;
          }

          final fresh = (fetchMoreResult['cast']['content'] as List<dynamic>)
              .map((e) =>
                  Fragment$fragmentCastMember.fromJson(e as Map<String, dynamic>))
              .toList();

          if (mounted) {
            setState(() => _pageData[page] = fresh);
          }

          return previous!;
        },
      ),
    ).then<void>((_) {}, onError: (_) => _requestedPages.remove(page));
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerycastByParent,
        variables: {
          'page': 0,
          'size': _pageSize,
          ..._idVariables,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        // Parse every new emission (cache, network) exactly once — an
        // "initialized" latch would pin the UI to the first (cached) result.
        if (result.data != null && result.timestamp != _lastResultTimestamp) {
          _lastResultTimestamp = result.timestamp;
          final parsed = Query$castByParent.fromJson(result.data!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _pageData[0] = parsed.cast?.content ?? [];
              _totalItems = parsed.cast?.totalElements;
            });
          });
        }

        final loadedCredits = _orderedItems.length;

        // Definitely empty: collapse entirely rather than reserve a blank row.
        if (_totalItems == 0 && loadedCredits == 0) {
          return const SizedBox.shrink();
        }

        if (result.hasException && loadedCredits == 0) {
          return const SizedBox.shrink();
        }

        final entries = _mergeCredits(_orderedItems);

        final int placeholderCount = _totalItems == null
            ? 8
            : (_totalItems! - loadedCredits).clamp(0, _pageSize);

        return Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _castHeader(context),
                SizedBox(
                  height: _kCastRowHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemExtent: _kCastTileWidth,
                    itemCount: entries.length + placeholderCount,
                    itemBuilder: (context, index) {
                      if (index < entries.length) {
                        return _CastMemberTile(
                          serverName: widget.serverName,
                          entry: entries[index],
                        );
                      }

                      // Placeholders map back to credit indices (not merged
                      // tile indices) so the page they trigger stays aligned
                      // with the server's paging.
                      final creditIndex =
                          loadedCredits + (index - entries.length);
                      final page = creditIndex ~/ _pageSize;
                      return VisibilityDetector(
                        key: ValueKey('cast-placeholder-$index'),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction > 0 && fetchMore != null) {
                            _requestPage(page, fetchMore);
                          }
                        },
                        child: const _CastSkeletonTile(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CastEntry {
  _CastEntry(this.person);

  final Fragment$fragmentCastMember$person person;
  final List<String> characters = [];
}

class _CastMemberTile extends StatelessWidget {
  const _CastMemberTile({required this.serverName, required this.entry});

  final String serverName;
  final _CastEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final person = entry.person;
    final img = ImageUtil.getImageByType(person.images, ImageTypes.cover);
    final imageUrl =
        ImageUtil.buildUrl(img, token: StreamTokenService.getToken(serverName));
    final placeholder = Icon(
      Icons.person,
      size: 40,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return SizedBox(
      width: _kCastTileWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            AutoRouter.of(context).push(PersonRoute(personId: person.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  width: 76,
                  height: 76,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: (imageUrl != null && imageUrl != '')
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorBuilder: (_, __, ___) => Center(child: placeholder),
                        )
                      : Center(child: placeholder),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                person.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              if (entry.characters.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  entry.characters.join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton stand-in matching [_CastMemberTile]'s footprint, shown while a
/// page of cast is still loading.
class _CastSkeletonTile extends StatelessWidget {
  const _CastSkeletonTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        width: _kCastTileWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  width: 76,
                  height: 76,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                BoneMock.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
