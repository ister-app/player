import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/search.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:player/utils/SearchService.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentImages.graphql.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam() this.libraryId,
    @QueryParam('q') this.query,
  });

  final String serverName;

  /// The library the search opens scoped to (the library page's search
  /// button passes its own); absent means every library.
  final String? libraryId;

  /// The search term from the URL, so a search is bookmarkable; kept in sync
  /// with the field via replaceState while typing.
  final String? query;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  /// Monotonic request id so a slow earlier response can't overwrite the
  /// results of a later query.
  int _requestId = 0;
  List<Query$search$search> _results = const [];
  bool _loading = false;

  /// The library the query is scoped to — null means every library.
  String? _libraryId;

  @override
  void initState() {
    super.initState();
    _libraryId = widget.libraryId;
    final seed = widget.query?.trim();
    if (seed != null && seed.isNotEmpty) {
      _controller.text = seed;
      _loading = true;
      _runSearch(seed);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusField());
  }

  /// Puts the cursor in the field — except on TV, where that would pop the
  /// on-screen keyboard before the D-pad has reached anything.
  void _focusField() {
    if (!mounted || PlatformService.isTvModeSync) return;
    _focusNode.requestFocus();
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Browser back/forward between ?q=/?libraryId= states arrives as an
    // in-place update, and so does the library page's search button (its
    // library, no term: a fresh search there). Our own _reflectUrl round-trip
    // comes back equal to the state → no-op.
    final scopeChanged = widget.libraryId != oldWidget.libraryId &&
        widget.libraryId != _libraryId;
    final incoming = widget.query?.trim() ?? '';
    final termChanged =
        widget.query != oldWidget.query && incoming != _controller.text.trim();
    if (!scopeChanged && !termChanged) return;
    _debounce?.cancel();
    _controller.text = incoming;
    setState(() {
      _libraryId = widget.libraryId;
      if (incoming.isEmpty) {
        _results = const [];
        _loading = false;
      } else {
        _loading = true;
      }
    });
    if (incoming.isNotEmpty) _runSearch(incoming);
    if (scopeChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusField());
    }
  }

  /// Mirrors the current term into the address bar (replaceState, so typing
  /// doesn't spam the browser history).
  void _reflectUrl(String term) {
    final scope = context.findAncestorWidgetOfExactType<RouteDataScope>();
    if (scope == null || !scope.routeData.isActive) return;
    final router = context.router;
    router.markUrlStateForReplace();
    router.navigate(SearchRoute(
      libraryId: _libraryId,
      query: term.trim().isEmpty ? null : term.trim(),
    ));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _results = const [];
        _loading = false;
      });
      _reflectUrl('');
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _reflectUrl(value);
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String term) async {
    final requestId = ++_requestId;
    final client = ClientManager.getClientForUrl(widget.serverName).value;
    final results = await SearchService().search(
      client,
      term,
      libraryId: _libraryId,
      size: 50,
    );
    if (!mounted || requestId != _requestId) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.search,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onChanged('');
                _focusNode.requestFocus();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _scopeSelector(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  /// "All libraries" plus one chip per library; the search starts on all.
  Widget _scopeSelector(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Query(
      options: QueryOptions(
        document: documentNodeQuerylibraries,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {refetch, fetchMore}) {
        final libraries = result.data == null
            ? const <Query$libraries$libraries>[]
            : (Query$libraries.fromJson(result.data!).libraries ??
                const <Query$libraries$libraries>[]);
        Widget chip(Key key, String label, String? libraryId) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: key,
                label: Text(label),
                selected: _libraryId == libraryId,
                onSelected: (_) => _setLibrary(libraryId),
              ),
            );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 4),
          child: Row(
            children: [
              chip(const ValueKey('search-scope-all'), loc.searchAllLibraries,
                  null),
              for (final library in libraries)
                chip(ValueKey('search-scope-${library.id}'), library.name,
                    library.id),
            ],
          ),
        );
      },
    );
  }

  /// Scopes the search to [libraryId] (null = every library) and re-runs the
  /// current term there.
  void _setLibrary(String? libraryId) {
    if (libraryId == _libraryId) return;
    setState(() => _libraryId = libraryId);
    final term = _controller.text.trim();
    _reflectUrl(term);
    if (term.isNotEmpty) {
      setState(() => _loading = true);
      _runSearch(term);
    }
  }

  Widget _buildBody(BuildContext context) {
    if (_loading && _results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          _controller.text.trim().isEmpty
              ? AppLocalizations.of(context)!.search
              : AppLocalizations.of(context)!.noResults,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final tokens = _searchTokens();
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _results.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) =>
              _resultRow(context, _describe(context, _results[index]), tokens),
        ),
      ),
    );
  }

  /// Lowercased, ≥2-char words of the current query, used both for the match
  /// hints and for highlighting the matching parts of a result.
  List<String> _searchTokens() => _controller.text
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.length >= 2)
      .toList();

  bool _matches(String? text, List<String> tokens) {
    if (text == null || tokens.isEmpty) return false;
    final lower = text.toLowerCase();
    return tokens.any(lower.contains);
  }

  Widget _resultRow(BuildContext context, _ResultView v, List<String> tokens) {
    final theme = Theme.of(context);
    final img = ImageUtil.getImageByType(v.images, v.imageType) ??
        ImageUtil.getImageByType(v.images, ImageTypes.background) ??
        ImageUtil.getImageByType(v.images, ImageTypes.cover);
    final imageUrl = ImageUtil.buildUrl(img,
        token: StreamTokenService.getToken(widget.serverName));

    final titleMatched = _matches(v.title, tokens);
    final descMatched = _matches(v.description, tokens);
    // Only call out the description match when the title itself doesn't already
    // explain the hit — that's the interesting "why did this show up" case.
    final showDescriptionHint = descMatched && !titleMatched;

    final baseStyle = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final highlightStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.14),
    );

    return InkWell(
      // Locale-independent handle for tests: 'search-<kind>-<id>'.
      key: v.rowKey,
      onTap: v.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 96,
                height: 64,
                child: Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: (imageUrl != null && imageUrl != '')
                      ? ArtworkImage(
                          url: imageUrl,
                          logicalWidth: 96,
                          errorBuilder: (_) =>
                              Center(child: Icon(v.icon, color: theme.colorScheme.onSurfaceVariant)),
                        )
                      : Center(child: Icon(v.icon, color: theme.colorScheme.onSurfaceVariant)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _typeBadge(context, v.typeLabel, v.icon),
                      if (showDescriptionHint) ...[
                        const SizedBox(width: 6),
                        _matchHint(context),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      children: _highlightSpans(
                        v.title,
                        tokens,
                        theme.textTheme.titleMedium,
                        (theme.textTheme.titleMedium ?? const TextStyle())
                            .merge(highlightStyle),
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((v.subtitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: _highlightSpans(v.subtitle!, tokens, baseStyle,
                            (baseStyle ?? const TextStyle()).merge(highlightStyle)),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if ((v.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: _highlightSpans(
                          _snippet(v.description!, tokens),
                          tokens,
                          baseStyle,
                          (baseStyle ?? const TextStyle()).merge(highlightStyle),
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _typeBadge(BuildContext context, String label, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: cs.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: cs.onSecondaryContainer),
          ),
        ],
      ),
    );
  }

  Widget _matchHint(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 13, color: cs.onTertiaryContainer),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context)!.searchInDescription,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: cs.onTertiaryContainer),
          ),
        ],
      ),
    );
  }

  /// Splits [text] into spans, wrapping each occurrence of any query token in
  /// [highlight] so the matching parts stand out.
  List<InlineSpan> _highlightSpans(
      String text, List<String> tokens, TextStyle? base, TextStyle highlight) {
    if (tokens.isEmpty) return [TextSpan(text: text, style: base)];
    final lower = text.toLowerCase();
    final spans = <InlineSpan>[];
    var i = 0;
    while (i < text.length) {
      var bestIdx = -1;
      var bestLen = 0;
      for (final t in tokens) {
        final idx = lower.indexOf(t, i);
        if (idx >= 0 && (bestIdx == -1 || idx < bestIdx)) {
          bestIdx = idx;
          bestLen = t.length;
        }
      }
      if (bestIdx == -1) {
        spans.add(TextSpan(text: text.substring(i), style: base));
        break;
      }
      if (bestIdx > i) {
        spans.add(TextSpan(text: text.substring(i, bestIdx), style: base));
      }
      spans.add(TextSpan(
          text: text.substring(bestIdx, bestIdx + bestLen), style: highlight));
      i = bestIdx + bestLen;
    }
    return spans;
  }

  /// Window a long description around the first match so the highlighted part is
  /// visible within the two shown lines; the trailing ellipsis handles overflow.
  String _snippet(String text, List<String> tokens, {int lead = 24}) {
    if (tokens.isEmpty) return text;
    final lower = text.toLowerCase();
    var first = -1;
    for (final t in tokens) {
      final idx = lower.indexOf(t);
      if (idx >= 0 && (first == -1 || idx < first)) first = idx;
    }
    if (first <= lead) return text;
    return '…${text.substring(first - lead)}';
  }

  _ResultView _describe(BuildContext context, Query$search$search item) {
    final loc = AppLocalizations.of(context)!;
    if (item is Query$search$search$$Movie) {
      return _ResultView(
        title: item.name,
        typeLabel: loc.movie,
        subtitle: '${item.releaseYear}',
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.movie,
        images: item.images,
        imageType: ImageTypes.cover,
        onTap: () => AutoRouter.of(context).push(MovieRoute(movieId: item.id)),
        rowKey: ValueKey('search-movie-${item.id}'),
      );
    }
    if (item is Query$search$search$$Show) {
      return _ResultView(
        title: item.name,
        typeLabel: loc.show,
        subtitle: '${item.releaseYear}',
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.tv,
        images: item.images,
        imageType: ImageTypes.background,
        onTap: () =>
            AutoRouter.of(context).push(ShowOverviewRoute(showId: item.id)),
        rowKey: ValueKey('search-show-${item.id}'),
      );
    }
    if (item is Query$search$search$$Episode) {
      final showId = item.$show?.id;
      return _ResultView(
        title: MetadataUtil.getTitle(item.metadata) ??
            loc.episode(item.number),
        typeLabel: loc.typeEpisode,
        subtitle: item.$show?.name,
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.tv,
        images: item.images,
        imageType: ImageTypes.background,
        onTap: showId == null
            ? null
            // ShowEpisodeRoute is a child of ShowOverviewRoute, so from outside
            // the show shell it must be pushed through its parent.
            : () => AutoRouter.of(context).push(ShowOverviewRoute(
                  showId: showId,
                  children: [
                    ShowEpisodeRoute(showId: showId, episodeId: item.id),
                  ],
                )),
        rowKey: ValueKey('search-episode-${item.id}'),
      );
    }
    if (item is Query$search$search$$Person) {
      return _ResultView(
        title: item.name,
        typeLabel: loc.typePerson,
        subtitle: null,
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.person,
        images: item.images,
        imageType: ImageTypes.cover,
        onTap: () => AutoRouter.of(context).push(PersonRoute(personId: item.id)),
        rowKey: ValueKey('search-person-${item.id}'),
      );
    }
    if (item is Query$search$search$$Album) {
      return _ResultView(
        title: item.name,
        typeLabel: loc.typeAlbum,
        subtitle: '${item.artist.name} · ${item.releaseYear}',
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.album,
        images: item.images,
        imageType: ImageTypes.cover,
        onTap: () => AutoRouter.of(context).push(AlbumRoute(albumId: item.id)),
        rowKey: ValueKey('search-album-${item.id}'),
      );
    }
    if (item is Query$search$search$$Track) {
      return _ResultView(
        title: MetadataUtil.getTitle(item.metadata) ?? '${item.number}',
        typeLabel: loc.typeTrack,
        subtitle: item.artist.name,
        description: MetadataUtil.getDescription(item.metadata),
        icon: Icons.music_note,
        images: item.album.images,
        imageType: ImageTypes.cover,
        onTap: () => AutoRouter.of(context)
            .push(AlbumRoute(albumId: item.album.id, trackId: item.id)),
        rowKey: ValueKey('search-track-${item.id}'),
      );
    }
    return const _ResultView(
      title: '',
      typeLabel: '',
      subtitle: null,
      description: null,
      icon: Icons.help_outline,
      images: null,
      imageType: ImageTypes.cover,
      onTap: null,
    );
  }
}

/// Normalised view of one search result so the row widget stays type-agnostic.
class _ResultView {
  const _ResultView({
    required this.title,
    required this.typeLabel,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.images,
    required this.imageType,
    required this.onTap,
    this.rowKey,
  });

  final String title;
  final String typeLabel;
  final String? subtitle;
  final String? description;
  final IconData icon;
  final List<Fragment$fragmentImages>? images;
  final ImageTypes imageType;
  final VoidCallback? onTap;
  final Key? rowKey;
}
