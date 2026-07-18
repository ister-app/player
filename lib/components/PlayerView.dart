import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/components/SessionSharingSheet.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// One row in the previous/up-next queue lists of a [PlayerView].
class PlayerQueueEntry {
  const PlayerQueueEntry({
    required this.id,
    required this.title,
    this.subtitle,
    this.artUrl,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? artUrl;
}

/// Notifier for position/duration/buffer ticks, kept separate from the
/// structural [PlayerViewController] notifications so only the seek bar
/// rebuilds once per second instead of the whole player.
class PositionTicker extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Backing state and actions for a [PlayerView]. Implemented by the local
/// media_kit player (music page) and by the party-mode remote control, so both
/// share the exact same player UI.
abstract class PlayerViewController extends ChangeNotifier {
  final PositionTicker positionTicker = PositionTicker();

  /// True while the current item is still loading; the view renders a
  /// skeleton with mock metadata instead of stale/absent info.
  bool get loading;

  /// False when the transport can no longer be operated (e.g. the remote
  /// session has ended).
  bool get enabled => true;

  String? get artUri;

  /// True when the current item's artwork is a portrait cover (audiobook/book)
  /// rather than a square album cover, so the view renders it 2:3 instead of
  /// cropping it into a square.
  bool get portraitArtwork => false;

  String? get artistLine;
  String? get titleLine;
  String? get albumLine;

  int get positionMs;
  int? get durationMs;
  double get bufferedFraction => 0;
  bool get canSeek;

  bool get hasPrevious;
  bool get hasNext;
  List<PlayerQueueEntry> get previous;
  List<PlayerQueueEntry> get upNext;

  bool get supportsRepeat => false;
  bool get repeatActive => false;
  bool get repeatOne => false;
  void cycleRepeatMode() {}

  /// The inner play/pause button; the view wraps it in the accent-coloured
  /// circle. Local playback plugs in [PlayPauseButton] (with its spinner),
  /// the remote a plain toggle driven by the session state.
  Widget buildPlayPauseButton(BuildContext context);

  /// Optional rating control rendered centred under the album line, so the
  /// playing track can be rated in place. Null when rating isn't applicable
  /// (non-track media) or unsupported (e.g. the remote controller). Local
  /// playback plugs in a [RatingStars] for the current track.
  Widget? buildRating(BuildContext context) => null;

  /// When non-null, the owner is watching their own session and may edit its per-session
  /// remote-control sharing; the view then shows a "share this session" action. Null for a remote
  /// controller (you cannot change someone else's session's sharing).
  String? get sessionSharingQueueId => null;

  /// Server that owns the session referenced by [sessionSharingQueueId].
  String? get sessionSharingServerName => null;

  /// The session's current per-session remote-control override (null = the account default applies).
  Enum$RemoteControlScope? get sessionControlOverride => null;

  /// The session's own control allowlist (grantee user ids), used when the override is ALLOWLIST.
  List<String> get sessionControlAllowedUserIds => const [];

  void skipToPrevious();
  void skipToNext();
  void seek(Duration position);

  /// Tap on the i-th entry of [previous] / [upNext].
  void tapPrevious(int index);
  void tapUpNext(int index);

  /// Raw [ReorderableListView] indices within [upNext]; implementations hold
  /// the optimistic order themselves while the move is in flight.
  Future<void> moveUpNext(int oldIndex, int newIndex);
  Future<void> removeEntry(PlayerQueueEntry entry);

  @override
  void dispose() {
    positionTicker.dispose();
    super.dispose();
  }
}

/// Full-screen music-player UI shared by [MusicPlayerPage] and
/// [RemoteControlPage]: blurred artwork backdrop with an accent extracted from
/// the cover, portrait/landscape layouts, seek bar, transport controls and the
/// previous/up-next queue tabs — presented as a slide-up overlay that can be
/// dismissed with a downward drag or overscroll.
class PlayerView extends StatefulWidget {
  const PlayerView({
    super.key,
    required this.controller,
    required this.onDismissed,
    this.initialSlideValue = 0.0,
    this.headerTitle,
    this.bannerBuilder,
  });

  final PlayerViewController controller;

  /// Called after the dismiss animation completes; pops the hosting route.
  final VoidCallback onDismissed;

  /// Starting value of the slide-up animation (mini-player drag hand-off).
  final double initialSlideValue;

  /// Optional line next to the dismiss chevron (e.g. "user · device").
  final String? headerTitle;

  /// Optional banners (live-feed broken, session ended) rendered above the
  /// artwork; evaluated inside the controller listener so they stay current.
  final WidgetBuilder? bannerBuilder;

  /// Dismiss handler of the top-most open [PlayerView], for the root router
  /// delegate: the back button should play the slide-down animation instead of
  /// popping the transparent overlay route instantly.
  static VoidCallback? get activeBackHandler =>
      _PlayerViewState._open.isEmpty ? null : _PlayerViewState._open.last.dismiss;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView>
    with SingleTickerProviderStateMixin {
  static final List<_PlayerViewState> _open = [];

  late final AnimationController _slide;
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 1; // 0 = previous, 1 = up next
  bool _isDismissing = false;
  bool _isDismissed = false;

  /// Accent colour extracted from the current artwork. Drives the progress
  /// bar, play button and background glow so each item carries its own mood.
  /// Falls back to a neutral grey while nothing is loaded.
  static const Color _defaultAccent = Color(0xFF6C6C74);
  final ValueNotifier<Color> _accent = ValueNotifier(_defaultAccent);
  String? _accentUri;

  @override
  void initState() {
    super.initState();
    _open.add(this);
    _slide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: widget.initialSlideValue,
    );
    _slide.animateTo(1.0, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _open.remove(this);
    _slide.dispose();
    _scrollController.dispose();
    _accent.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_isDismissed) return;
    _isDismissed = true;
    await _slide.animateTo(
      0.0,
      duration: Duration(milliseconds: (_slide.value * 320).round().clamp(100, 320)),
      curve: Curves.easeInCubic,
    );
    if (mounted) widget.onDismissed();
  }

  /// Extracts an accent from [uri]'s artwork. Deduped on the uri so item skips
  /// don't re-run the (relatively costly) quantisation for art already shown.
  void _updateAccent(String? uri) {
    if (uri == _accentUri) return;
    _accentUri = uri;
    if (uri == null) {
      _accent.value = _defaultAccent;
      return;
    }
    // `content` keeps the source artwork's hue and chroma instead of pulling it
    // towards a muted tonal palette, which is what we want for an accent.
    ColorScheme.fromImageProvider(
      provider: CachedNetworkImageProvider(uri),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.content,
    ).then((scheme) {
      // A newer skip may have superseded this load; only apply if still current.
      if (!mounted || _accentUri != uri) return;
      _accent.value = _pickAccent(scheme);
    }).catchError((_) {
      if (mounted && _accentUri == uri) _accent.value = _defaultAccent;
    });
  }

  /// Nudges the extracted colour into a range that reads well both as a thin
  /// progress fill on a dark backdrop and as a filled button that carries black
  /// text.
  Color _pickAccent(ColorScheme scheme) {
    var hsl = HSLColor.fromColor(scheme.primary);
    if (hsl.lightness < 0.45) hsl = hsl.withLightness(0.55);
    if (hsl.lightness > 0.78) hsl = hsl.withLightness(0.7);
    if (hsl.saturation < 0.3) hsl = hsl.withSaturation(0.45);
    return hsl.toColor();
  }

  bool _onScrollNotification(ScrollNotification n, double height) {
    if (n is OverscrollNotification && n.overscroll < 0) {
      _isDismissing = true;
      _slide.value = (_slide.value + n.overscroll / height).clamp(0.0, 1.0);
    } else if (n is ScrollEndNotification && _isDismissing) {
      _isDismissing = false;
      final velocity = n.dragDetails?.velocity.pixelsPerSecond.dy ?? 0;
      if (_slide.value < 0.7 || velocity > 600) {
        dismiss();
      } else {
        _slide.animateTo(
          1.0,
          duration: Duration(milliseconds: ((1.0 - _slide.value) * 300).round().clamp(50, 300)),
          curve: Curves.easeOutCubic,
        );
      }
    }
    return false;
  }

  void _onDragUpdate(DragUpdateDetails d, double height) {
    if (d.delta.dy > 0) {
      _slide.value = (_slide.value - d.delta.dy / height).clamp(0.0, 1.0);
    }
  }

  void _onDragEnd(DragEndDetails d) {
    final velocity = d.primaryVelocity ?? 0;
    if (_slide.value < 0.7 || velocity > 600) {
      dismiss();
    } else {
      _slide.animateTo(
        1.0,
        duration: Duration(milliseconds: ((1.0 - _slide.value) * 300).round().clamp(50, 300)),
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
    List<PlayerQueueEntry> previous,
    List<PlayerQueueEntry> upNext, {
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
                  ? _buildUpNextList(items)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < items.length; i++)
                          _dismissible(
                            items[i],
                            _QueueItem(
                              entry: items[i],
                              onTap: () => widget.controller.tapPrevious(i),
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
  Widget _buildUpNextList(List<PlayerQueueEntry> upNext) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: upNext.length,
      onReorder: (oldIndex, newIndex) =>
          widget.controller.moveUpNext(oldIndex, newIndex),
      itemBuilder: (context, i) => _dismissible(
        upNext[i],
        _QueueItem(
          key: ValueKey('content_${upNext[i].id}'),
          entry: upNext[i],
          onTap: () => widget.controller.tapUpNext(i),
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

  Widget _dismissible(PlayerQueueEntry entry, Widget child) {
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.withValues(alpha: 0.7),
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => widget.controller.removeEntry(entry),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slide,
      builder: (context, child) {
        final h = MediaQuery.sizeOf(context).height;
        return Transform.translate(
          offset: Offset(0, (1.0 - _slide.value) * h),
          child: child,
        );
      },
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final loading = widget.controller.loading;
          final artUri = loading ? null : widget.controller.artUri;
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
                // backdrop reads as "new item incoming".
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
                          ? _buildLandscape(context, artUri, constraints, loading)
                          : _buildPortrait(context, artUri, constraints, loading);
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

  Widget _buildHeader() {
    final loc = AppLocalizations.of(context)!;
    final sessionQueueId = widget.controller.sessionSharingQueueId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
            onPressed: dismiss,
          ),
          Expanded(
            child: widget.headerTitle != null
                ? Text(
                    widget.headerTitle!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          ),
          if (sessionQueueId != null)
            IconButton(
              icon: const Icon(Icons.ios_share, color: Colors.white70),
              tooltip: loc.shareThisSession,
              onPressed: () => _openSessionSharing(sessionQueueId),
            ),
        ],
      ),
    );
  }

  Future<void> _openSessionSharing(String playQueueId) async {
    final controller = widget.controller;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SessionSharingSheet(
        serverName: controller.sessionSharingServerName,
        playQueueId: playQueueId,
        currentOverride: controller.sessionControlOverride,
        currentAllowedUserIds: controller.sessionControlAllowedUserIds,
      ),
    );
  }

  Widget? _buildBanner() {
    final banner = widget.bannerBuilder?.call(context);
    if (banner == null) return null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: banner,
    );
  }

  /// Artwork, or the same music-note placeholder the queue list uses when an
  /// item has no (loadable) artwork.
  Widget _artworkOrPlaceholder(String? artUri, double size, {bool loading = false}) {
    // Audiobook/book covers are portrait (~2:3); fit them inside the same
    // `size` budget as a square cover rather than cropping them square.
    final bool portrait = widget.controller.portraitArtwork;
    final double width = portrait ? size * 2 / 3 : size;
    final double height = size;
    return Skeletonizer(
      enabled: loading,
      child: ValueListenableBuilder<Color>(
      valueListenable: _accent,
      builder: (context, accent, child) => Container(
        width: width,
        height: height,
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

  Widget _buildPortrait(BuildContext context, String? artUri, BoxConstraints constraints, bool loading) {
    final maxImageSize = min(constraints.maxWidth - 80, constraints.maxHeight - 340).clamp(80.0, 400.0);
    final previous = widget.controller.previous;
    final upNext = widget.controller.upNext;
    final hasQueue = previous.isNotEmpty || upNext.isNotEmpty;
    final banner = _buildBanner();

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
                _buildHeader(),
                if (banner != null) banner,
                const Spacer(),
                _artworkOrPlaceholder(artUri, maxImageSize, loading: loading),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, hasQueue ? 4 : 32),
                  child: _Controls(controller: widget.controller, accent: _accent, loading: loading),
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
        ..._buildQueueSlivers(previous, upNext,
            viewportHeight: constraints.maxHeight),
      ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, String? artUri, BoxConstraints constraints, bool loading) {
    // Leave a side margin inside the 45%-wide art column so the cover doesn't
    // touch the screen edge and its drop shadow/accent glow has room to fall.
    const artSideMargin = 40.0;
    const artBottomMargin = 32.0;
    final imageSize = min(
      constraints.maxHeight - 48 - artBottomMargin,
      constraints.maxWidth * 0.45 - artSideMargin * 2,
    );
    final previous = widget.controller.previous;
    final upNext = widget.controller.upNext;
    final hasQueue = previous.isNotEmpty || upNext.isNotEmpty;
    final banner = _buildBanner();

    return Row(
      children: [
        GestureDetector(
          onVerticalDragUpdate: (d) => _onDragUpdate(d, constraints.maxHeight),
          onVerticalDragEnd: _onDragEnd,
          child: SizedBox(
          width: constraints.maxWidth * 0.45,
          child: Column(
            children: [
              _buildHeader(),
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
                      if (banner != null) banner,
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 560),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 16, 32, 4),
                              child: _Controls(controller: widget.controller, accent: _accent, loading: loading),
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
                tabPadding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                viewportHeight: constraints.maxHeight,
              ),
            ],
          ),
          ),
        ),
      ],
    );
  }
}

/// Blurred artwork backdrop that only swaps once the new artwork is fully
/// loaded, cross-fading into place. While the next item's art is still
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
    // Keep the current backdrop if the incoming item has no art yet or its
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
  const _QueueItem({super.key, required this.entry, required this.onTap, this.trailing});

  final PlayerQueueEntry entry;
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
    final artUrl = widget.entry.artUrl;
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
              artUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: artUrl,
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
                      widget.entry.title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.entry.subtitle != null && widget.entry.subtitle!.isNotEmpty)
                      Text(
                        widget.entry.subtitle!,
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
  const _Controls({required this.controller, required this.accent, this.loading = false});

  final PlayerViewController controller;
  final ValueListenable<Color> accent;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    // Mock metadata rendered under the skeleton so title/artist/album bones
    // have text to size themselves against while the real item loads.
    final artist = loading ? 'Artist name' : controller.artistLine;
    final title = loading ? 'Loading track title' : controller.titleLine;
    final album = loading ? 'Album name here' : controller.albumLine;
    final enabled = controller.enabled;
    final hasPrevious = controller.hasPrevious && enabled;
    final hasNext = controller.hasNext && enabled;
    // Rating for the playing track (local playback only); rendered under the
    // album line like the reference design. Hidden while loading so the
    // skeleton doesn't flash empty stars.
    final rating = loading ? null : controller.buildRating(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Skeletonizer(
          enabled: loading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (artist != null)
                Text(
                  artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4),
              Text(
                title ?? '',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (album != null) ...[
                const SizedBox(height: 4),
                Text(
                  album,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (rating != null) ...[
          const SizedBox(height: 12),
          rating,
        ],
        const SizedBox(height: 20),
        _SeekBar(controller: controller, accent: accent),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (controller.supportsRepeat)
              _RepeatButton(controller: controller, accent: accent),
            IconButton(
              icon: Icon(Icons.skip_previous,
                  color: hasPrevious ? Colors.white : Colors.white30),
              iconSize: 40,
              onPressed: hasPrevious ? controller.skipToPrevious : null,
            ),
            ValueListenableBuilder<Color>(
              valueListenable: accent,
              builder: (context, color, child) => Container(
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
                child: child,
              ),
              child: controller.buildPlayPauseButton(context),
            ),
            IconButton(
              icon: Icon(Icons.skip_next,
                  color: hasNext ? Colors.white : Colors.white30),
              iconSize: 40,
              onPressed: hasNext ? controller.skipToNext : null,
            ),
            // Balances the row so the play button stays centred now that a
            // repeat toggle sits on the far left.
            if (controller.supportsRepeat) const SizedBox(width: 48),
          ],
        ),
      ],
    );
  }
}

/// Repeat toggle cycling none → all → one. Tinted with the album accent when
/// active; the "one" state carries a small badge on the loop icon.
class _RepeatButton extends StatelessWidget {
  const _RepeatButton({required this.controller, required this.accent});

  final PlayerViewController controller;
  final ValueListenable<Color> accent;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: accent,
      builder: (context, color, _) => IconButton(
        icon: Icon(
          controller.repeatOne ? Icons.repeat_one : Icons.repeat,
          color: controller.repeatActive ? color : Colors.white54,
        ),
        iconSize: 24,
        tooltip: 'Repeat',
        onPressed: controller.cycleRepeatMode,
      ),
    );
  }
}

class _SeekBar extends StatefulWidget {
  const _SeekBar({required this.controller, required this.accent});

  final PlayerViewController controller;
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
      builder: (context, accent, _) => ListenableBuilder(
        listenable: widget.controller.positionTicker,
        builder: (context, _) => _buildBar(context, accent),
      ),
    );
  }

  Widget _buildBar(BuildContext context, Color accent) {
    final c = widget.controller;
    final durationMs = c.durationMs;
    final maxMs = durationMs != null && durationMs > 0 ? durationMs.toDouble() : 1.0;
    final currentMs = (_dragValue ?? c.positionMs.toDouble()).clamp(0.0, maxMs);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: _BufferedTrackShape(c.bufferedFraction, accent),
            thumbColor: Colors.white,
            overlayColor: accent.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: currentMs,
            min: 0,
            max: maxMs,
            // Disabled until the duration is known (HLS reports it late) —
            // seeking in an unknown range is meaningless.
            onChanged: c.canSeek
                ? (v) => setState(() => _dragValue = v)
                : null,
            onChangeEnd: (v) {
              c.seek(Duration(milliseconds: v.toInt()));
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
                DurationUtil.format(Duration(milliseconds: durationMs ?? 0)),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
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
