import 'dart:async';

import 'package:auto_route/auto_route.dart';
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

import '../components/CarouselItemView.dart';
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
      libraryId: widget.libraryId,
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
        body: _buildBody(context),
      ),
    );
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.0,
          ),
          itemCount: _results.length,
          itemBuilder: (context, index) => _buildTile(context, _results[index]),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, Query$search$search item) {
    final serverName = widget.serverName;
    final token = StreamTokenService.getToken(serverName);

    if (item is Query$search$search$$Movie) {
      final img = ImageUtil.getImageByType(item.images, ImageTypes.cover);
      return CarouselItemView(
        serverName: serverName,
        title: item.name,
        subTitle: AppLocalizations.of(context)!.movie,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.movie,
        onTap: () => AutoRouter.of(context).push(MovieRoute(movieId: item.id)),
      );
    }
    if (item is Query$search$search$$Show) {
      final img = ImageUtil.getImageByType(item.images, ImageTypes.background);
      return CarouselItemView(
        serverName: serverName,
        title: item.name,
        subTitle: AppLocalizations.of(context)!.show,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.tv,
        onTap: () =>
            AutoRouter.of(context).push(ShowOverviewRoute(showId: item.id)),
      );
    }
    if (item is Query$search$search$$Episode) {
      final img = ImageUtil.getImageByType(item.images, ImageTypes.background);
      final showId = item.$show?.id;
      return CarouselItemView(
        serverName: serverName,
        title: MetadataUtil.getTitle(item.metadata) ??
            '${item.$show?.name ?? ''} ${item.number ?? ''}',
        subTitle: item.$show?.name ?? AppLocalizations.of(context)!.show,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.tv,
        onTap: showId == null
            ? null
            : () => AutoRouter.of(context)
                .push(ShowEpisodeRoute(showId: showId, episodeId: item.id)),
      );
    }
    if (item is Query$search$search$$Person) {
      final img = ImageUtil.getImageByType(item.images, ImageTypes.cover);
      return CarouselItemView(
        serverName: serverName,
        title: item.name,
        subTitle: AppLocalizations.of(context)!.artist,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.person,
        onTap: () => AutoRouter.of(context).push(ArtistRoute(artistId: item.id)),
      );
    }
    if (item is Query$search$search$$Album) {
      final img = ImageUtil.getImageByType(item.images, ImageTypes.cover);
      return CarouselItemView(
        serverName: serverName,
        title: item.name,
        subTitle: item.artist.name,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.album,
        onTap: () => AutoRouter.of(context).push(AlbumRoute(albumId: item.id)),
      );
    }
    if (item is Query$search$search$$Track) {
      final img = ImageUtil.getImageByType(item.album.images, ImageTypes.cover);
      return CarouselItemView(
        serverName: serverName,
        title: MetadataUtil.getTitle(item.metadata) ?? '${item.number}',
        subTitle: item.artist.name,
        imageUrl: ImageUtil.buildUrl(img, token: token),
        blurHash: img?.blurHash,
        placeholderIcon: Icons.music_note,
        onTap: () =>
            AutoRouter.of(context).push(AlbumRoute(albumId: item.album.id)),
      );
    }
    return const SizedBox.shrink();
  }
}
