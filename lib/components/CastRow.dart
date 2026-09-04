import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/graphql/castByParent.graphql.dart';
import 'package:player/graphql/fragmentCredit.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../l10n/app_localizations.dart';
import 'RowHeader.dart';
import 'SkeletonPlaceholder.dart';

/// Fixed height reserved for the horizontal cast strip; a bounded height is
/// required so the lazy [ListView] in [PagedCastRow] can scroll horizontally.
/// Just enough for the tile's tallest form (a two-line name over a one-line
/// character) — any surplus shows up as a band of empty page under the strip.
const double _kCastRowHeight = 138;

/// Width of a single cast avatar tile (used as the list item extent).
const double _kCastTileWidth = 108;

/// Diameter of the portrait in the horizontal strip.
const double _kCastTileAvatar = 64;

/// Cell size of the compact rows on the full-cast page: an avatar beside the
/// name and character, several columns wide on a desktop window. The column
/// count divides down (never up), so a phone gets a single full-width column
/// instead of two that ellipsise every longer name.
const double _kCastRowMinTileWidth = 240;
const double _kCastRowTileHeight = 72;

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
Widget _castHeader(BuildContext context, {VoidCallback? onTap}) => RowHeader(
      label: AppLocalizations.of(context)!.cast,
      style: Theme.of(context).textTheme.titleMedium,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      trailingColon: false,
      onTap: onTap,
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
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

/// How many cast placeholders a strip reserves before it knows the real count.
/// Shared so a page that skeletonizes a [CastRow] itself reserves exactly what
/// [PagedCastRow] will show while it loads.
const int kCastPlaceholderCount = 8;

/// The loading stand-in for a cast strip: the same header and the same tiles
/// [PagedCastRow] shows for a page it hasn't fetched yet.
///
/// Pages used to hand [CastRow] a list of fake `Fragment$fragmentCastMember`s
/// instead, which reserved a different number of tiles than the real strip and
/// had to be kept in step with the schema by hand.
class CastRowSkeleton extends StatelessWidget {
  const CastRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < kCastPlaceholderCount; i++)
                    const _CastSkeletonTile(),
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
    this.scrollDirection = Axis.horizontal,
  });

  final String serverName;
  final String? showId;
  final String? movieId;
  final String? episodeId;

  /// [Axis.horizontal] is the strip with its tappable header;
  /// [Axis.vertical] is the full-cast grid ([CastListPage]'s body, headerless
  /// — the page's app bar carries the title).
  final Axis scrollDirection;

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
            ? kCastPlaceholderCount
            : (_totalItems! - loadedCredits).clamp(0, _pageSize);

        // Placeholders map back to credit indices (not merged tile indices)
        // so the page they trigger stays aligned with the server's paging.
        final bool asRows = widget.scrollDirection == Axis.vertical;

        Widget itemBuilder(BuildContext context, int index) {
          if (index < entries.length) {
            return asRows
                ? _CastMemberRow(
                    serverName: widget.serverName,
                    entry: entries[index],
                  )
                : _CastMemberTile(
                    serverName: widget.serverName,
                    entry: entries[index],
                  );
          }
          final creditIndex = loadedCredits + (index - entries.length);
          final page = creditIndex ~/ _pageSize;
          return VisibilityDetector(
            key: ValueKey('cast-placeholder-$index'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0 && fetchMore != null) {
                _requestPage(page, fetchMore);
              }
            },
            child: asRows ? const _CastSkeletonRow() : const _CastSkeletonTile(),
          );
        }

        if (asRows) {
          return LayoutBuilder(builder: (context, constraints) {
            final columns =
                (constraints.maxWidth / _kCastRowMinTileWidth).floor().clamp(1, 6);
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              // A fixed main-axis extent, not an aspect ratio derived from the
              // horizontal strip's constants: the cell then follows the row's
              // real height instead of reserving a tile's worth of dead space.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: _kCastRowTileHeight,
                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
              ),
              itemCount: entries.length + placeholderCount,
              itemBuilder: itemBuilder,
            );
          });
        }

        return Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _castHeader(
                  context,
                  onTap: () => AutoRouter.of(context).push(CastListRoute(
                    showId: widget.showId,
                    movieId: widget.movieId,
                    episodeId: widget.episodeId,
                  )),
                ),
                SizedBox(
                  height: _kCastRowHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemExtent: _kCastTileWidth,
                    itemCount: entries.length + placeholderCount,
                    itemBuilder: itemBuilder,
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

/// The circular portrait shared by every cast tile, with the person icon as
/// the fallback for people without artwork (or a failing image).
class _CastAvatar extends StatelessWidget {
  const _CastAvatar({
    required this.serverName,
    required this.person,
    required this.size,
  });

  final String serverName;
  final Fragment$fragmentCastMember$person person;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final img = ImageUtil.getImageByType(person.images, ImageTypes.cover);
    final imageUrl =
        ImageUtil.buildUrl(img, token: StreamTokenService.getToken(serverName));
    final placeholder = Icon(
      Icons.person,
      size: size * 0.53,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return _castAvatarShell(
      context,
      size,
      child: (imageUrl != null && imageUrl != '')
          ? ArtworkImage(
              url: imageUrl,
              logicalWidth: size,
              errorBuilder: (_) => Center(child: placeholder),
            )
          : Center(child: placeholder),
    );
  }
}

/// The round tinted frame every cast avatar sits in. Shared with the skeleton
/// stand-ins so a change to the frame cannot drift away from its placeholder.
Widget _castAvatarShell(BuildContext context, double size, {Widget? child}) {
  return ClipOval(
    child: Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: child,
    ),
  );
}

/// Compact list row — avatar beside the name and character — used by the
/// full-cast grid on [CastListPage]. The tall centred [_CastMemberTile] is
/// for the horizontal strip only.
class _CastMemberRow extends StatelessWidget {
  const _CastMemberRow({required this.serverName, required this.entry});

  final String serverName;
  final _CastEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final person = entry.person;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => AutoRouter.of(context).push(PersonRoute(personId: person.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            _CastAvatar(serverName: serverName, person: person, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  if (entry.characters.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      entry.characters.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}

/// Skeleton stand-in matching [_CastMemberRow]'s footprint.
class _CastSkeletonRow extends StatelessWidget {
  const _CastSkeletonRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkeletonPlaceholder(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            _castAvatarShell(context, 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    BoneMock.name,
                    maxLines: 1,
                    style: theme.textTheme.labelLarge?.copyWith(height: 1.2),
                  ),
                  // Most cast entries carry a character, and the real row is
                  // two lines high when they do; a one-line skeleton made the
                  // list settle a line shorter than it had reserved.
                  const SizedBox(height: 2),
                  Text(
                    BoneMock.words(2),
                    maxLines: 1,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CastMemberTile extends StatelessWidget {
  const _CastMemberTile({required this.serverName, required this.entry});

  final String serverName;
  final _CastEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final person = entry.person;

    return SizedBox(
      width: _kCastTileWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            AutoRouter.of(context).push(PersonRoute(personId: person.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CastAvatar(
                serverName: serverName,
                person: person,
                size: _kCastTileAvatar,
              ),
              const SizedBox(height: 6),
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
                  maxLines: 1,
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
    return SkeletonPlaceholder(
      child: SizedBox(
        width: _kCastTileWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _castAvatarShell(context, _kCastTileAvatar),
              const SizedBox(height: 6),
              Text(
                BoneMock.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(height: 1.2),
              ),
              // See [_CastSkeletonRow]: the character line is the common case.
              const SizedBox(height: 2),
              Text(
                BoneMock.words(2),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
