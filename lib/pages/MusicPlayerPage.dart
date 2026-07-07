import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/dto/MediaItemId.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 1; // 0 = TERUG NAAR, 1 = HIERNA
  bool _isDismissing = false;
  bool _isDismissed = false;

  /// Optimistic queue order held during a reorder so the list doesn't snap back
  /// while the server move is in flight. Cleared once the move round-trips.
  List<MediaItem>? _localQueue;

  /// Accent colour extracted from the current album art. Drives the progress
  /// bar, play button and background glow so each track carries its own mood.
  /// Falls back to a neutral grey while nothing is loaded.
  static const Color _defaultAccent = Color(0xFF6C6C74);
  final ValueNotifier<Color> _accent = ValueNotifier(_defaultAccent);
  String? _accentUri;

  /// Extracts an accent from [uri]'s artwork. Deduped on the uri so track skips
  /// don't re-run the (relatively costly) quantisation for art already shown.
  void _updateAccent(String? uri) {
    if (uri == _accentUri) return;
    _accentUri = uri;
    if (uri == null) {
      _accent.value = _defaultAccent;
      return;
    }
    PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(uri),
      size: const Size(180, 180),
      maximumColorCount: 12,
    ).then((palette) {
      // A newer skip may have superseded this load; only apply if still current.
      if (!mounted || _accentUri != uri) return;
      _accent.value = _pickAccent(palette);
    }).catchError((_) {
      if (mounted && _accentUri == uri) _accent.value = _defaultAccent;
    });
  }

  /// Picks the liveliest available swatch, then nudges it into a range that
  /// reads well both as a thin progress fill on a dark backdrop and as a filled
  /// button that carries black text.
  Color _pickAccent(PaletteGenerator palette) {
    final color = palette.vibrantColor?.color ??
        palette.lightVibrantColor?.color ??
        palette.dominantColor?.color ??
        _defaultAccent;
    var hsl = HSLColor.fromColor(color);
    if (hsl.lightness < 0.45) hsl = hsl.withLightness(0.55);
    if (hsl.lightness > 0.78) hsl = hsl.withLightness(0.7);
    if (hsl.saturation < 0.3) hsl = hsl.withSaturation(0.45);
    return hsl.toColor();
  }

  @override
  void initState() {
    super.initState();
    MediaPlayerHandler.instance.dismissMusicPlayer = _dismiss;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) MediaPlayerHandler.instance.musicPlayerOpen.value = true;
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: MediaPlayerHandler.instance.playerInitialControllerValue,
    );
    MediaPlayerHandler.instance.playerInitialControllerValue = 0.0;
    _controller.animateTo(1.0, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    MediaPlayerHandler.instance.dismissMusicPlayer = null;
    Future.microtask(() => MediaPlayerHandler.instance.musicPlayerOpen.value = false);
    _controller.dispose();
    _scrollController.dispose();
    _accent.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_isDismissed) return;
    _isDismissed = true;
    await _controller.animateTo(
      0.0,
      duration: Duration(milliseconds: (_controller.value * 320).round().clamp(100, 320)),
      curve: Curves.easeInCubic,
    );
    if (mounted) context.router.pop();
  }

  bool _onScrollNotification(ScrollNotification n, double height) {
    if (n is OverscrollNotification && n.overscroll < 0) {
      _isDismissing = true;
      _controller.value = (_controller.value + n.overscroll / height).clamp(0.0, 1.0);
    } else if (n is ScrollEndNotification && _isDismissing) {
      _isDismissing = false;
      final velocity = n.dragDetails?.velocity.pixelsPerSecond.dy ?? 0;
      if (_controller.value < 0.7 || velocity > 600) {
        _dismiss();
      } else {
        _controller.animateTo(
          1.0,
          duration: Duration(milliseconds: ((1.0 - _controller.value) * 300).round().clamp(50, 300)),
          curve: Curves.easeOutCubic,
        );
      }
    }
    return false;
  }

  void _onDragUpdate(DragUpdateDetails d, double height) {
    if (d.delta.dy > 0) {
      _controller.value = (_controller.value - d.delta.dy / height).clamp(0.0, 1.0);
    }
  }

  void _onDragEnd(DragEndDetails d) {
    final velocity = d.primaryVelocity ?? 0;
    if (_controller.value < 0.7 || velocity > 600) {
      _dismiss();
    } else {
      _controller.animateTo(
        1.0,
        duration: Duration(milliseconds: ((1.0 - _controller.value) * 300).round().clamp(50, 300)),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildTab(String label, int index) {
    final selected = _selectedTab == index;
    return TvFocusable(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(4),
      child: GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.45),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
      ),
      ),
    );
  }

  List<Widget> _buildQueueSlivers(
    List<MediaItem> previous,
    List<MediaItem> upNext,
    int currentIndex, {
    EdgeInsets tabPadding = const EdgeInsets.fromLTRB(4, 8, 4, 0),
    double viewportHeight = 400,
  }) {
    if (previous.isEmpty && upNext.isEmpty) return [];

    final loc = AppLocalizations.of(context)!;
    final items = _selectedTab == 0 ? previous : upNext;

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: tabPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildTab(loc.previousTracks, 0),
                  _buildTab(loc.upNext, 1),
                ],
              ),
              const Divider(color: Colors.white24, height: 1, thickness: 1),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: (viewportHeight - 88).clamp(0.0, double.infinity)),
          child: items.isEmpty
              ? Center(
                  child: Text(
                    _selectedTab == 0 ? loc.noPreviousTracks : loc.noNextTracks,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                  ),
                )
              : _selectedTab == 1
                  ? _buildUpNextList(items, currentIndex)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < items.length; i++)
                          _dismissible(
                            items[i],
                            _QueueItem(
                              item: items[i],
                              onTap: () => MediaPlayerHandler.instance
                                  .skipToQueueItem(currentIndex - 1 - i),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 32)),
    ];
  }

  /// Reorderable "up next" list with swipe-to-remove and a drag handle.
  Widget _buildUpNextList(List<MediaItem> upNext, int currentIndex) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: upNext.length,
      onReorder: (oldIndex, newIndex) =>
          _onReorder(upNext, currentIndex, oldIndex, newIndex),
      itemBuilder: (context, i) => _dismissible(
        upNext[i],
        _QueueItem(
          key: ValueKey('content_${upNext[i].id}'),
          item: upNext[i],
          onTap: () =>
              MediaPlayerHandler.instance.skipToQueueItem(currentIndex + 1 + i),
          trailing: ReorderableDragStartListener(
            index: i,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.drag_handle, color: Colors.white38),
            ),
          ),
        ),
      ),
      proxyDecorator: (child, index, animation) =>
          Material(color: Colors.transparent, child: child),
    );
  }

  Widget _dismissible(MediaItem item, Widget child) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.withValues(alpha: 0.7),
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeFromQueue(item),
      child: child,
    );
  }

  Future<void> _onReorder(List<MediaItem> upNext, int currentIndex,
      int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex == oldIndex) return;
    final handler = MediaPlayerHandler.instance;

    final reordered = List<MediaItem>.of(upNext);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final full = _localQueue ?? handler.queue.value;
    final head =
        currentIndex >= 0 ? full.sublist(0, currentIndex + 1) : <MediaItem>[];
    setState(() => _localQueue = [...head, ...reordered]);

    final movedId = MediaItemId.byStringId(moved.id).id;
    final afterId = newIndex == 0
        ? handler.playQueue?.currentItemId
        : MediaItemId.byStringId(reordered[newIndex - 1].id).id;
    await handler.moveQueueItem(movedId, afterId);
    if (mounted) setState(() => _localQueue = null);
  }

  Future<void> _removeFromQueue(MediaItem item) async {
    final handler = MediaPlayerHandler.instance;
    final id = MediaItemId.byStringId(item.id).id;
    final full = List<MediaItem>.of(_localQueue ?? handler.queue.value)
      ..removeWhere((e) => e.id == item.id);
    setState(() => _localQueue = full);
    await handler.removeFromQueue(id);
    if (mounted) setState(() => _localQueue = null);
  }

  /// Splits the full queue around the currently playing index into the
  /// already-played tracks (newest first) and the still-to-come tracks.
  ({List<MediaItem> previous, List<MediaItem> upNext}) _sliceQueue(
      List<MediaItem> allItems, int currentIndex) {
    // queueIndex can briefly be stale (e.g. right after switching to a shorter
    // album); clamp so sublist can never reach past the queue.
    if (currentIndex >= allItems.length) currentIndex = allItems.length - 1;
    final previous = currentIndex > 0
        ? allItems.sublist(0, currentIndex).reversed.toList()
        : <MediaItem>[];
    final upNext = currentIndex >= 0 && currentIndex + 1 < allItems.length
        ? allItems.sublist(currentIndex + 1)
        : <MediaItem>[];
    return (previous: previous, upNext: upNext);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final h = MediaQuery.sizeOf(context).height;
        return Transform.translate(
          offset: Offset(0, (1.0 - _controller.value) * h),
          child: child,
        );
      },
      child: StreamBuilder<MediaItem?>(
        stream: MediaPlayerHandler.instance.mediaItem,
        initialData: MediaPlayerHandler.instance.mediaItem.valueOrNull,
        builder: (context, mediaSnapshot) {
          return ValueListenableBuilder<bool>(
            valueListenable: MediaPlayerHandler.instance.mediaLoading,
            builder: (context, loading, _) {
              // While a freshly-tapped track loads, show a skeleton with mock
              // text instead of the previous track's cover/title/album.
              final item = loading ? _boneItem : mediaSnapshot.data;
              final artUri = loading ? null : item?.artUri?.toString();
              // Refresh the accent after this frame so we never mutate the
              // notifier mid-build; deduped inside on the uri.
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _updateAccent(artUri));

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Drop the previous blurred cover while loading — a neutral
                    // backdrop reads as "new track incoming".
                    if (loading)
                      const ColoredBox(color: Color(0xFF101014))
                    else
                      _BlurredBackground(artUri: artUri),
                    ValueListenableBuilder<Color>(
                      valueListenable: _accent,
                      builder: (context, accent, _) => DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.alphaBlend(
                                  accent.withValues(alpha: 0.28), Colors.black)
                                .withValues(alpha: 0.62),
                              const Color(0xE6000000),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isLandscape = constraints.maxWidth > constraints.maxHeight * 1.2;
                          return isLandscape
                              ? _buildLandscape(context, item, artUri, constraints, loading)
                              : _buildPortrait(context, item, artUri, constraints, loading);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Mock metadata rendered under the skeleton so title/artist/album bones have
  /// text to size themselves against while the real track loads.
  static final MediaItem _boneItem = MediaItem(
    id: 'bone',
    title: 'Loading track title',
    artist: 'Artist name',
    album: 'Album name here',
  );

  /// Album artwork, or the same music-note placeholder the queue list uses
  /// when a track has no (loadable) artwork.
  Widget _artworkOrPlaceholder(String? artUri, double size, {bool loading = false}) {
    return Skeletonizer(
      enabled: loading,
      child: ValueListenableBuilder<Color>(
      valueListenable: _accent,
      builder: (context, accent, child) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: loading
              ? const []
              : [
            // Deep neutral drop shadow for lift…
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 40,
              offset: const Offset(0, 18),
            ),
            // …plus a faint accent glow so the art feels lit by its own colour.
            BoxShadow(
              color: accent.withValues(alpha: 0.30),
              blurRadius: 60,
              spreadRadius: -12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: artUri != null
            ? CachedNetworkImage(
                imageUrl: artUri,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _artPlaceholder(size),
              )
            : _artPlaceholder(size),
      ),
      ),
    );
  }

  Widget _artPlaceholder(double size) {
    return Container(
      color: Colors.white12,
      child: Icon(Icons.music_note, color: Colors.white54, size: size * 0.4),
    );
  }

  Widget _buildPortrait(BuildContext context, MediaItem? item, String? artUri, BoxConstraints constraints, bool loading) {
    final maxImageSize = min(constraints.maxWidth - 80, constraints.maxHeight - 340).clamp(80.0, 400.0);

    return StreamBuilder<List<MediaItem>>(
      stream: MediaPlayerHandler.instance.queue,
      initialData: MediaPlayerHandler.instance.queue.value,
      builder: (context, queueSnapshot) {
        return StreamBuilder<PlaybackState>(
          stream: MediaPlayerHandler.instance.playbackState,
          initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
          builder: (context, stateSnapshot) {
            final allItems = _localQueue ?? queueSnapshot.data ?? [];
            final currentIndex = stateSnapshot.data?.queueIndex ?? -1;
            final (:previous, :upNext) = _sliceQueue(allItems, currentIndex);
            final hasQueue = previous.isNotEmpty || upNext.isNotEmpty;

            return NotificationListener<ScrollNotification>(
              onNotification: (n) => _onScrollNotification(n, constraints.maxHeight),
              child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                                onPressed: _dismiss,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _artworkOrPlaceholder(artUri, maxImageSize, loading: loading),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, hasQueue ? 4 : 32),
                          child: _Controls(item: item, accent: _accent, loading: loading),
                        ),
                        if (hasQueue)
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 28),
                            onPressed: () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                ..._buildQueueSlivers(previous, upNext, currentIndex,
                    viewportHeight: constraints.maxHeight),
              ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLandscape(BuildContext context, MediaItem? item, String? artUri, BoxConstraints constraints, bool loading) {
    // Leave a side margin inside the 45%-wide art column so the cover doesn't
    // touch the screen edge and its drop shadow/accent glow has room to fall.
    const artSideMargin = 40.0;
    const artBottomMargin = 32.0;
    final imageSize = min(
      constraints.maxHeight - 48 - artBottomMargin,
      constraints.maxWidth * 0.45 - artSideMargin * 2,
    );

    return StreamBuilder<List<MediaItem>>(
      stream: MediaPlayerHandler.instance.queue,
      initialData: MediaPlayerHandler.instance.queue.value,
      builder: (context, queueSnapshot) {
        return StreamBuilder<PlaybackState>(
          stream: MediaPlayerHandler.instance.playbackState,
          initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
          builder: (context, stateSnapshot) {
            final allItems = _localQueue ?? queueSnapshot.data ?? [];
            final currentIndex = stateSnapshot.data?.queueIndex ?? -1;
            final (:previous, :upNext) = _sliceQueue(allItems, currentIndex);
            final hasQueue = previous.isNotEmpty || upNext.isNotEmpty;

            return Row(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (d) => _onDragUpdate(d, constraints.maxHeight),
                  onVerticalDragEnd: _onDragEnd,
                  child: SizedBox(
                  width: constraints.maxWidth * 0.45,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                              onPressed: _dismiss,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: artBottomMargin),
                          child: Center(
                            child: _artworkOrPlaceholder(artUri, imageSize, loading: loading),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                  onNotification: (n) => _onScrollNotification(n, constraints.maxHeight),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 560),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(32, 16, 32, 4),
                                      child: _Controls(item: item, accent: _accent, loading: loading),
                                    ),
                                  ),
                                ),
                              ),
                              if (hasQueue)
                                IconButton(
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 28),
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      ..._buildQueueSlivers(
                        previous,
                        upNext,
                        currentIndex,
                        tabPadding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                        viewportHeight: constraints.maxHeight,
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Blurred album-art backdrop that only swaps once the new artwork is fully
/// loaded, cross-fading into place. While the next track's art is still
/// loading (or briefly null mid-switch) the previous backdrop stays up, so the
/// background never flashes to grey when skipping tracks.
class _BlurredBackground extends StatefulWidget {
  const _BlurredBackground({required this.artUri});

  final String? artUri;

  @override
  State<_BlurredBackground> createState() => _BlurredBackgroundState();
}

class _BlurredBackgroundState extends State<_BlurredBackground> {
  String? _shownUri; // uri currently painted as the backdrop
  ImageProvider? _shown; // its provider, kept until the next one is ready
  String? _loadingUri; // uri whose precache is in flight, to dedupe rebuilds

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeLoad();
  }

  @override
  void didUpdateWidget(covariant _BlurredBackground old) {
    super.didUpdateWidget(old);
    if (old.artUri != widget.artUri) _maybeLoad();
  }

  void _maybeLoad() {
    final uri = widget.artUri;
    // Keep the current backdrop if the incoming track has no art yet or its
    // art is unchanged / already loading — avoids a mid-switch flash to grey.
    if (uri == null || uri == _shownUri || uri == _loadingUri) return;
    _loadingUri = uri;
    final provider = NetworkImage(uri);
    precacheImage(provider, context).then((_) {
      // A newer switch may have superseded this load; only swap if still current.
      if (mounted && widget.artUri == uri) {
        setState(() {
          _shownUri = uri;
          _shown = provider;
        });
      }
      if (_loadingUri == uri) _loadingUri = null;
    }).catchError((_) {
      // Keep the old backdrop on failure rather than clearing it.
      if (_loadingUri == uri) _loadingUri = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _shown == null
          ? ColoredBox(key: const ValueKey('empty'), color: Colors.grey[900]!)
          : SizedBox.expand(
              key: ValueKey(_shownUri),
              child: ClipRect(
                // Scale up slightly so the blur samples image pixels at the
                // edges instead of bleeding transparency in.
                child: Transform.scale(
                  scale: 1.2,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Image(image: _shown!, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
    );
  }
}

class _QueueItem extends StatefulWidget {
  const _QueueItem({super.key, required this.item, required this.onTap, this.trailing});

  final MediaItem item;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  State<_QueueItem> createState() => _QueueItemState();
}

class _QueueItemState extends State<_QueueItem> {
  bool _hovered = false;

  Widget _queueArtPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.music_note, color: Colors.white54),
    );
  }

  @override
  Widget build(BuildContext context) {
    final artUri = widget.item.artUri?.toString();
    return TvFocusable(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(4),
      child: MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _hovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              artUri != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: artUri,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _queueArtPlaceholder(),
                      ),
                    )
                  : _queueArtPlaceholder(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.item.title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.item.artist != null && widget.item.artist!.isNotEmpty)
                      Text(
                        widget.item.artist!,
                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({this.item, required this.accent, this.loading = false});

  final MediaItem? item;
  final ValueListenable<Color> accent;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item != null)
          Skeletonizer(
            enabled: loading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item!.artist ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item!.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item!.album ?? '',
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        _SeekBar(accent: accent),
        const SizedBox(height: 8),
        StreamBuilder<List<MediaItem>>(
          stream: MediaPlayerHandler.instance.queue,
          initialData: MediaPlayerHandler.instance.queue.value,
          builder: (context, queueSnapshot) {
            return StreamBuilder<PlaybackState>(
              stream: MediaPlayerHandler.instance.playbackState,
              initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
              builder: (context, stateSnapshot) {
                final queueIndex = stateSnapshot.data?.queueIndex ?? -1;
                final queueLength = queueSnapshot.data?.length ?? 0;
                final repeatMode =
                    stateSnapshot.data?.repeatMode ?? AudioServiceRepeatMode.none;
                final repeatAll = repeatMode == AudioServiceRepeatMode.all;
                // With repeat-all the queue is a loop, so the ends are reachable.
                final hasPrevious =
                    queueIndex > 0 || (repeatAll && queueLength > 1);
                final hasNext = (queueIndex >= 0 && queueIndex < queueLength - 1) ||
                    (repeatAll && queueLength > 1);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RepeatButton(repeatMode: repeatMode, accent: accent),
                    IconButton(
                      icon: Icon(Icons.skip_previous,
                          color: hasPrevious ? Colors.white : Colors.white30),
                      iconSize: 40,
                      onPressed: hasPrevious
                          ? () => MediaPlayerHandler.instance.skipToPrevious()
                          : null,
                    ),
                    ValueListenableBuilder<Color>(
                      valueListenable: accent,
                      builder: (context, color, _) => Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.45),
                              blurRadius: 24,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: const PlayPauseButton(
                          iconSize: 48,
                          iconColor: Colors.black,
                          spinnerColor: Colors.black,
                          spinnerStrokeWidth: 3,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next,
                          color: hasNext ? Colors.white : Colors.white30),
                      iconSize: 40,
                      onPressed: hasNext
                          ? () => MediaPlayerHandler.instance.skipToNext()
                          : null,
                    ),
                    // Balances the row so the play button stays centred now that
                    // a repeat toggle sits on the far left.
                    const SizedBox(width: 48),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// Repeat toggle cycling none → all → one. Tinted with the album accent when
/// active; the "one" state carries a small badge on the loop icon.
class _RepeatButton extends StatelessWidget {
  const _RepeatButton({required this.repeatMode, required this.accent});

  final AudioServiceRepeatMode repeatMode;
  final ValueListenable<Color> accent;

  @override
  Widget build(BuildContext context) {
    final active = repeatMode != AudioServiceRepeatMode.none;
    return ValueListenableBuilder<Color>(
      valueListenable: accent,
      builder: (context, color, _) => IconButton(
        icon: Icon(
          repeatMode == AudioServiceRepeatMode.one
              ? Icons.repeat_one
              : Icons.repeat,
          color: active ? color : Colors.white54,
        ),
        iconSize: 24,
        tooltip: 'Repeat',
        onPressed: () => MediaPlayerHandler.instance.cycleRepeatMode(),
      ),
    );
  }
}

class _SeekBar extends StatefulWidget {
  const _SeekBar({required this.accent});

  final ValueListenable<Color> accent;

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.accent,
      builder: (context, accent, _) => _buildBar(context, accent),
    );
  }

  Widget _buildBar(BuildContext context, Color accent) {
    return StreamBuilder<Duration>(
      stream: MediaPlayerHandler.instance.positionSecondsStream,
      initialData: MediaPlayerHandler.instance.player.state.position,
      builder: (context, posSnapshot) {
        final position = posSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: MediaPlayerHandler.instance.player.stream.duration,
          initialData: MediaPlayerHandler.instance.player.state.duration,
          builder: (context, durSnapshot) {
            final duration = durSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration>(
              stream: MediaPlayerHandler.instance.player.stream.buffer,
              initialData: MediaPlayerHandler.instance.player.state.buffer,
              builder: (context, bufSnapshot) {
                final buffer = bufSnapshot.data ?? Duration.zero;
                final maxMs = duration.inMilliseconds > 0 ? duration.inMilliseconds.toDouble() : 1.0;
                final currentMs = (_dragValue ?? position.inMilliseconds.toDouble()).clamp(0.0, maxMs);
                final bufferedFraction = duration.inMilliseconds > 0
                    ? (buffer.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
                    : 0.0;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackShape:
                            _BufferedTrackShape(bufferedFraction, accent),
                        thumbColor: Colors.white,
                        overlayColor: accent.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: currentMs,
                        min: 0,
                        max: maxMs,
                        // Disabled until the duration is known (HLS reports it
                        // late) — seeking in an unknown range is meaningless.
                        onChanged: duration.inMilliseconds > 0
                            ? (v) => setState(() => _dragValue = v)
                            : null,
                        onChangeEnd: (v) {
                          MediaPlayerHandler.instance.seek(Duration(milliseconds: v.toInt()));
                          setState(() => _dragValue = null);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DurationUtil.format(Duration(milliseconds: currentMs.toInt())),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            DurationUtil.format(duration),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

}

class _BufferedTrackShape extends SliderTrackShape {
  const _BufferedTrackShape(this.bufferedFraction, this.playedColor);

  final double bufferedFraction;
  final Color playedColor;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final h = sliderTheme.trackHeight ?? 4.0;
    return Rect.fromLTWH(
      offset.dx,
      offset.dy + (parentBox.size.height - h) / 2,
      parentBox.size.width,
      h,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final rect = getPreferredRect(parentBox: parentBox, offset: offset, sliderTheme: sliderTheme);
    final r = Radius.circular(rect.height / 2);
    final canvas = context.canvas;

    // unbuffered background
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, r),
      Paint()..color = Colors.white12,
    );

    // buffered portion (grey)
    final bufferedRight = (rect.left + rect.width * bufferedFraction).clamp(rect.left, rect.right);
    if (bufferedRight > rect.left) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(rect.left, rect.top, bufferedRight, rect.bottom), r),
        Paint()..color = Colors.white30,
      );
    }

    // played portion (accent)
    final playedRight = thumbCenter.dx.clamp(rect.left, rect.right);
    if (playedRight > rect.left) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(rect.left, rect.top, playedRight, rect.bottom), r),
        Paint()..color = playedColor,
      );
    }
  }
}
