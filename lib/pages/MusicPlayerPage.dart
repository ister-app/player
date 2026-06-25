import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayPauseButton.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

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
    return GestureDetector(
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
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _QueueItem(
                        item: items[i],
                        onTap: () => MediaPlayerHandler.instance.skipToQueueItem(
                          _selectedTab == 0 ? currentIndex - 1 - i : currentIndex + 1 + i,
                        ),
                      ),
                  ],
                ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 32)),
    ];
  }

  /// Splits the full queue around the currently playing index into the
  /// already-played tracks (newest first) and the still-to-come tracks.
  ({List<MediaItem> previous, List<MediaItem> upNext}) _sliceQueue(
      List<MediaItem> allItems, int currentIndex) {
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
          final item = mediaSnapshot.data;
          final artUri = item?.artUri?.toString();

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                if (artUri != null)
                  Positioned(
                    left: -40,
                    top: -40,
                    right: -40,
                    bottom: -40,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Image.network(artUri, fit: BoxFit.cover),
                    ),
                  )
                else
                  ColoredBox(color: Colors.grey[900]!),
                const ColoredBox(color: Color(0xAA000000)),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isLandscape = constraints.maxWidth > constraints.maxHeight * 1.2;
                      return isLandscape
                          ? _buildLandscape(context, item, artUri, constraints)
                          : _buildPortrait(context, item, artUri, constraints);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortrait(BuildContext context, MediaItem? item, String? artUri, BoxConstraints constraints) {
    final maxImageSize = min(constraints.maxWidth - 80, constraints.maxHeight - 340).clamp(80.0, 400.0);

    return StreamBuilder<List<MediaItem>>(
      stream: MediaPlayerHandler.instance.queue,
      initialData: MediaPlayerHandler.instance.queue.value,
      builder: (context, queueSnapshot) {
        return StreamBuilder<PlaybackState>(
          stream: MediaPlayerHandler.instance.playbackState,
          initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
          builder: (context, stateSnapshot) {
            final allItems = queueSnapshot.data ?? [];
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
                        if (artUri != null)
                          SizedBox(
                            width: maxImageSize,
                            height: maxImageSize,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(imageUrl: artUri, fit: BoxFit.cover),
                            ),
                          ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, hasQueue ? 4 : 32),
                          child: _Controls(item: item),
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

  Widget _buildLandscape(BuildContext context, MediaItem? item, String? artUri, BoxConstraints constraints) {
    final imageSize = min(constraints.maxHeight - 32, constraints.maxWidth * 0.45);

    return StreamBuilder<List<MediaItem>>(
      stream: MediaPlayerHandler.instance.queue,
      initialData: MediaPlayerHandler.instance.queue.value,
      builder: (context, queueSnapshot) {
        return StreamBuilder<PlaybackState>(
          stream: MediaPlayerHandler.instance.playbackState,
          initialData: MediaPlayerHandler.instance.playbackState.valueOrNull,
          builder: (context, stateSnapshot) {
            final allItems = queueSnapshot.data ?? [];
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
                        child: Center(
                          child: artUri != null
                              ? SizedBox(
                                  width: imageSize,
                                  height: imageSize,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(imageUrl: artUri, fit: BoxFit.cover),
                                  ),
                                )
                              : const SizedBox(),
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
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 16, 32, 4),
                                    child: _Controls(item: item),
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

class _QueueItem extends StatefulWidget {
  const _QueueItem({required this.item, required this.onTap});

  final MediaItem item;
  final VoidCallback onTap;

  @override
  State<_QueueItem> createState() => _QueueItemState();
}

class _QueueItemState extends State<_QueueItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final artUri = widget.item.artUri?.toString();
    return MouseRegion(
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
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white54),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({this.item});

  final MediaItem? item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item != null) ...[
          Text(
            item!.artist ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item!.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item!.album ?? '',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 16),
        _SeekBar(),
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
                final hasPrevious = queueIndex > 0;
                final hasNext = queueIndex >= 0 && queueIndex < queueLength - 1;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous,
                          color: hasPrevious ? Colors.white : Colors.white30),
                      iconSize: 40,
                      onPressed: hasPrevious
                          ? () => MediaPlayerHandler.instance.skipToPrevious()
                          : null,
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const PlayPauseButton(
                        iconSize: 48,
                        iconColor: Colors.black,
                        spinnerColor: Colors.black,
                        spinnerStrokeWidth: 3,
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

class _SeekBar extends StatefulWidget {
  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
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
                        trackShape: _BufferedTrackShape(bufferedFraction),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white24,
                      ),
                      child: Slider(
                        value: currentMs,
                        min: 0,
                        max: maxMs,
                        onChanged: (v) => setState(() => _dragValue = v),
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
  const _BufferedTrackShape(this.bufferedFraction);

  final double bufferedFraction;

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

    // played portion (white)
    final playedRight = thumbCenter.dx.clamp(rect.left, rect.right);
    if (playedRight > rect.left) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(rect.left, rect.top, playedRight, rect.bottom), r),
        Paint()..color = Colors.white,
      );
    }
  }
}
