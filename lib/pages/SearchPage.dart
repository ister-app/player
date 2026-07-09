import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/search.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/SearchService.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../graphql/fragmentImages.graphql.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    this.libraryId,
  });

  final String serverName;

  /// When set, results are limited to a single library.
  final String? libraryId;

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

  /// When true, ignore [SearchPage.libraryId] and search across all libraries.
  bool _allLibraries = false;

  /// The library the query is scoped to — null means every library.
  String? get _effectiveLibraryId => _allLibraries ? null : widget.libraryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
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
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 300), () => _runSearch(value));
  }

  Future<void> _runSearch(String term) async {
    final requestId = ++_requestId;
    final client = ClientManager.getClientForUrl(widget.serverName).value;
    final results = await SearchService().search(
      client,
      term,
      libraryId: _effectiveLibraryId,
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
    return ValueListenableBuilder<bool>(
      valueListenable: MediaPlayerHandler.instance.musicPlayerOpen,
      builder: (context, musicPlayerOpen, child) => PopScope(
        canPop: !musicPlayerOpen,
        child: child!,
      ),
      child: Scaffold(
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
            // Only offer the scope switch when the search was opened inside a
            // specific library; a search opened without one is already global.
            if (widget.libraryId != null) _scopeSelector(context),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _scopeSelector(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: false,
                label: Text(loc.searchThisLibrary),
                icon: const Icon(Icons.folder_outlined),
              ),
              ButtonSegment(
                value: true,
                label: Text(loc.searchAllLibraries),
                icon: const Icon(Icons.travel_explore),
              ),
            ],
            selected: {_allLibraries},
            onSelectionChanged: (selection) =>
                _setAllLibraries(selection.first),
          ),
        ),
      ),
    );
  }

  void _setAllLibraries(bool value) {
    if (value == _allLibraries) return;
    setState(() => _allLibraries = value);
    // Re-run the current query against the new scope.
    final term = _controller.text.trim();
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
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorBuilder: (_, __, ___) =>
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
            : () => AutoRouter.of(context)
                .push(ShowEpisodeRoute(showId: showId, episodeId: item.id)),
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
        onTap: () =>
            AutoRouter.of(context).push(AlbumRoute(albumId: item.album.id)),
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
  });

  final String title;
  final String typeLabel;
  final String? subtitle;
  final String? description;
  final IconData icon;
  final List<Fragment$fragmentImages>? images;
  final ImageTypes imageType;
  final VoidCallback? onTap;
}
