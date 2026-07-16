import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/comic/ComicLocator.dart';
import 'package:player/utils/comic/ComicPageSource.dart';
import 'package:player/utils/comic/ComicPreferences.dart';
import 'package:player/utils/comic/ComicResourceClient.dart';
import 'package:player/utils/comic/ComicSyncService.dart';

/// The comic reader: page images in a swiping [PageView], one *spread* per
/// view — a single page, or two side by side on a wide viewport. Handles
/// pinch-zoom, right-to-left reading (persisted per series), a thumbnail
/// strip, D-pad/keyboard paging and progress sync. Format-blind through
/// [ComicPageSource]: cbz pages stream off the node, pdf pages are rendered
/// locally.
@RoutePage()
class ComicReaderPage extends StatefulWidget {
  const ComicReaderPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('bookId') required this.bookId,
    @PathParam('mediaFileId') required this.mediaFileId,
    @QueryParam('nodeUrl') this.nodeUrl,
    @QueryParam('title') this.title,
    @QueryParam('seriesId') this.seriesId,
    @QueryParam('page') this.page,
  });

  final String serverName;
  final String bookId;
  final String mediaFileId;

  /// URL of the node that stores the volume (mediaFile.directory.node.url).
  final String? nodeUrl;
  final String? title;

  /// Scope for the persisted reading direction/fit; falls back to the book.
  final String? seriesId;

  /// Zero-based page to open at, instead of resuming.
  final int? page;

  @override
  State<ComicReaderPage> createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<ComicReaderPage>
    with WidgetsBindingObserver {
  ComicResourceClient? _client;
  ComicPageSource? _source;
  ComicSyncService? _sync;

  bool _loading = true;
  bool _loadFailed = false;

  bool _rtl = false;
  ComicFitMode _fit = ComicFitMode.fitPage;
  bool _chromeVisible = true;

  /// Spreads in reading order; each is one or two logical page indexes.
  List<List<int>> _spreads = const [];
  int _spreadIndex = 0;
  PageController? _pageController;

  /// Pages known to be wider than tall (a scanned double-page): they always
  /// get a spread of their own.
  final Set<int> _widePages = {};
  final Set<int> _probedPages = {};
  bool _doublePageLayout = false;

  /// The resolved start page. Nothing is reported to the server until the
  /// position actually moves away from it: merely opening the reader must not
  /// write a round-tripped position back.
  int _startPage = 0;
  bool _hasReported = false;

  String get _prefsScope => widget.seriesId ?? widget.bookId;

  int get _pageCount => _source?.pageCount ?? 0;

  int get _currentPage =>
      _spreads.isEmpty ? 0 : _spreads[_spreadIndex.clamp(0, _spreads.length - 1)].first;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sync?.dispose(); // flushes the pending position
    _source?.dispose();
    _client?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_sync?.flush());
    }
  }

  @override
  void didChangeMetrics() {
    // Orientation / window size change: single ↔ double page may flip.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateLayout();
    });
  }

  Future<void> _load() async {
    final rtl = await ComicPreferences.getRightToLeft(_prefsScope);
    final fit = await ComicPreferences.getFitMode(_prefsScope);
    if (mounted) {
      setState(() {
        _rtl = rtl;
        _fit = fit;
      });
    }

    final nodeUrl = widget.nodeUrl;
    if (nodeUrl == null || nodeUrl.isEmpty) {
      _failLoad('Comic reader opened without a node url');
      return;
    }
    try {
      final client = ComicResourceClient(
        nodeUrl: nodeUrl,
        mediaFileId: widget.mediaFileId,
        serverName: widget.serverName,
      );
      final manifest = await client.manifest();
      final source = switch (manifest.format) {
        'CBZ' => CbzPageSource(client: client, manifest: manifest),
        _ => null,
      };
      if (source == null || source.pageCount <= 0) {
        client.dispose();
        _failLoad('No reader for comic format ${manifest.format}');
        return;
      }
      final sync = ComicSyncService(
        serverName: widget.serverName,
        bookId: widget.bookId,
        mediaFileId: widget.mediaFileId,
      );
      await sync.init();

      _client = client;
      _source = source;
      _sync = sync;
      _startPage = _resolveStartPage(source, sync);
      if (!mounted) return;
      setState(() {
        _doublePageLayout = _wantsDoublePage(MediaQuery.of(context).size);
        _spreads = _buildSpreads();
        _spreadIndex = _spreadForPage(_startPage);
        _pageController = PageController(initialPage: _spreadIndex);
        _loading = false;
      });
      _precacheAround(_spreadIndex);
    } catch (error) {
      _failLoad('Could not load the comic: $error');
    }
  }

  void _failLoad(String message) {
    LoggerService().logger.e(message);
    if (mounted) {
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  /// A requested page wins over the saved position; the saved locator over
  /// the plain fraction (a position written by another file of the book).
  int _resolveStartPage(ComicPageSource source, ComicSyncService sync) {
    final last = source.pageCount - 1;
    final requested = widget.page;
    if (requested != null && requested >= 0) {
      return math.min(requested, last);
    }
    final locator = sync.savedLocator();
    if (locator != null) {
      return math.min(locator.pageIndex, last);
    }
    final fraction = sync.savedFraction();
    if (fraction >= 0.97) return 0; // finished: reread from the start
    if (fraction > 0) {
      return math.min((fraction * source.pageCount).floor(), last);
    }
    return 0;
  }

  /* ------------------------------- spreads ------------------------------- */

  bool _wantsDoublePage(Size size) => size.width > size.height && size.width >= 900;

  /// Spread 0 is the cover alone; then pairs, except that a page wider than
  /// tall (an already-joined double page) stands alone.
  List<List<int>> _buildSpreads() {
    final count = _pageCount;
    if (!_doublePageLayout) {
      return [
        for (var page = 0; page < count; page++) [page],
      ];
    }
    final spreads = <List<int>>[];
    var page = 0;
    while (page < count) {
      if (page == 0 || _widePages.contains(page)) {
        spreads.add([page]);
        page++;
        continue;
      }
      if (page + 1 < count && !_widePages.contains(page + 1)) {
        spreads.add([page, page + 1]);
        page += 2;
      } else {
        spreads.add([page]);
        page++;
      }
    }
    return spreads;
  }

  int _spreadForPage(int pageIndex) {
    for (var index = 0; index < _spreads.length; index++) {
      if (_spreads[index].contains(pageIndex)) return index;
    }
    return _spreads.isEmpty ? 0 : _spreads.length - 1;
  }

  /// Rebuilds the spread list (viewport or wide-page knowledge changed) while
  /// staying on the current logical page.
  void _updateLayout() {
    final source = _source;
    if (source == null) return;
    final wantsDouble = _wantsDoublePage(MediaQuery.of(context).size);
    final current = _currentPage;
    final spreads = _buildSpreadsFor(wantsDouble);
    if (wantsDouble == _doublePageLayout && spreads.length == _spreads.length) {
      return;
    }
    setState(() {
      _doublePageLayout = wantsDouble;
      _spreads = spreads;
      _spreadIndex = _spreadForPage(current);
      _pageController?.dispose();
      _pageController = PageController(initialPage: _spreadIndex);
    });
  }

  List<List<int>> _buildSpreadsFor(bool doublePage) {
    final previous = _doublePageLayout;
    _doublePageLayout = doublePage;
    final spreads = _buildSpreads();
    _doublePageLayout = previous;
    return spreads;
  }

  /// Records whether a page is wider than tall, once its image resolves; a
  /// wide scan must not be paired with a second page.
  void _probeAspect(int pageIndex) {
    final source = _source;
    if (source == null || !_probedPages.add(pageIndex)) return;
    final stream = source
        .pageImage(pageIndex)
        .resolve(createLocalImageConfiguration(context));
    late final ImageStreamListener listener;
    listener = ImageStreamListener((info, _) {
      stream.removeListener(listener);
      final wide = info.image.width > info.image.height;
      info.dispose();
      if (wide && _widePages.add(pageIndex) && mounted && _doublePageLayout) {
        _updateSpreadsForWidePage();
      }
    }, onError: (_, __) => stream.removeListener(listener));
    stream.addListener(listener);
  }

  void _updateSpreadsForWidePage() {
    final current = _currentPage;
    setState(() {
      _spreads = _buildSpreads();
      _spreadIndex = _spreadForPage(current);
      _pageController?.dispose();
      _pageController = PageController(initialPage: _spreadIndex);
    });
  }

  /* ----------------------------- page changes ---------------------------- */

  void _onSpreadChanged(int spreadIndex) {
    if (spreadIndex < 0 || spreadIndex >= _spreads.length) return;
    setState(() => _spreadIndex = spreadIndex);
    _precacheAround(spreadIndex);
    _reportCurrentPosition();
  }

  void _reportCurrentPosition() {
    final sync = _sync;
    if (sync == null || _pageCount == 0) return;
    final page = _currentPage;
    if (!_hasReported && page == _startPage) return;
    _hasReported = true;
    final lastVisible = _spreads[_spreadIndex].last;
    sync.reportPosition(ComicLocator(
      pageIndex: page,
      fraction: ((lastVisible + 1) / _pageCount).clamp(0.0, 1.0),
    ));
  }

  void _precacheAround(int spreadIndex) {
    final source = _source;
    if (source == null || !mounted) return;
    for (final offset in const [0, 1, -1, 2]) {
      final index = spreadIndex + offset;
      if (index < 0 || index >= _spreads.length) continue;
      for (final page in _spreads[index]) {
        unawaited(precacheImage(_resized(page, _spreads[index].length), context,
            onError: (_, __) {}));
        _probeAspect(page);
      }
    }
  }

  /// Decode capped at what the viewport can show, so a 4000-px scan doesn't
  /// blow the image cache on a 1080p screen.
  ImageProvider _resized(int pageIndex, int pagesInSpread) {
    final source = _source!;
    final media = MediaQuery.of(context);
    final width = (media.size.width * media.devicePixelRatio / pagesInSpread)
        .round()
        .clamp(240, 4096);
    return ResizeImage(source.pageImage(pageIndex),
        width: width, allowUpscaling: false);
  }

  void _goToPage(int pageIndex) {
    final spread = _spreadForPage(pageIndex.clamp(0, _pageCount - 1));
    _pageController?.jumpToPage(spread);
  }

  void _step(int direction) {
    final target = _spreadIndex + direction;
    if (target < 0 || target >= _spreads.length) return;
    unawaited(_pageController?.animateToPage(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    ));
  }

  /* -------------------------------- input -------------------------------- */

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight) {
      _step(_rtl ? -1 : 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      _step(_rtl ? 1 : -1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.pageDown ||
        key == LogicalKeyboardKey.space) {
      _step(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.pageUp) {
      _step(-1);
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent &&
        (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter)) {
      setState(() => _chromeVisible = !_chromeVisible);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /* ------------------------------- settings ------------------------------ */

  void _toggleRtl() {
    setState(() => _rtl = !_rtl);
    unawaited(ComicPreferences.setRightToLeft(_prefsScope, _rtl));
  }

  void _toggleFit() {
    setState(() => _fit = _fit == ComicFitMode.fitPage
        ? ComicFitMode.fitWidth
        : ComicFitMode.fitPage);
    unawaited(ComicPreferences.setFitMode(_prefsScope, _fit));
  }

  void _openThumbnails() {
    final source = _source;
    if (source == null) return;
    final current = _currentPage;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.grey.shade900,
      builder: (sheetContext) => SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: _rtl,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: source.pageCount,
          controller: ScrollController(
              initialScrollOffset: math.max(0.0, (current - 2) * 116.0)),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(4),
            child: TvFocusable(
              autofocus: index == current,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _goToPage(index);
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _goToPage(index);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 108,
                        decoration: index == current
                            ? BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 3))
                            : null,
                        child: Image(
                          image: source.thumbnail(index),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white38)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${index + 1}',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* -------------------------------- build -------------------------------- */

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final source = _source;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _chromeVisible
          ? AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(widget.title ?? '',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              actions: [
                IconButton(
                  tooltip: loc.readingDirectionRtl,
                  icon: Icon(_rtl
                      ? Icons.format_textdirection_r_to_l
                      : Icons.format_textdirection_l_to_r),
                  isSelected: _rtl,
                  onPressed: _toggleRtl,
                ),
                IconButton(
                  tooltip: _fit == ComicFitMode.fitPage
                      ? loc.fitWidth
                      : loc.fitPage,
                  icon: Icon(_fit == ComicFitMode.fitPage
                      ? Icons.fit_screen
                      : Icons.fullscreen),
                  onPressed: _toggleFit,
                ),
                IconButton(
                  tooltip: loc.pageOverview,
                  icon: const Icon(Icons.grid_view),
                  onPressed: _openThumbnails,
                ),
              ],
            )
          : null,
      bottomNavigationBar: _chromeVisible && source != null
          ? BottomAppBar(
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection:
                          _rtl ? TextDirection.rtl : TextDirection.ltr,
                      child: Slider(
                        value: (_currentPage + 1)
                            .clamp(1, _pageCount)
                            .toDouble(),
                        min: 1,
                        max: math.max(1, _pageCount).toDouble(),
                        divisions: math.max(1, _pageCount - 1),
                        onChanged: (value) => _goToPage(value.round() - 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      loc.pageOfPages(_currentPage + 1, _pageCount),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKeyEvent,
        child: Builder(
          builder: (context) {
            if (_loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_loadFailed || source == null || _pageController == null) {
              return Center(
                child: Text(loc.couldNotLoadComic,
                    style: const TextStyle(color: Colors.white)),
              );
            }
            return PageView.builder(
              controller: _pageController,
              reverse: _rtl,
              onPageChanged: _onSpreadChanged,
              itemCount: _spreads.length,
              itemBuilder: (context, index) {
                final spread = _spreads[index];
                final visualOrder =
                    _rtl ? spread.reversed.toList() : spread;
                return _SpreadView(
                  key: ValueKey('spread-${spread.first}-${spread.length}'),
                  images: [
                    for (final page in visualOrder)
                      _resized(page, spread.length),
                  ],
                  fit: _fit,
                  onTap: () =>
                      setState(() => _chromeVisible = !_chromeVisible),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// One spread: its page images side by side, tap-to-toggle chrome, and
/// pinch-zoom/pan. Panning is only enabled while zoomed in, so a horizontal
/// drag at rest turns the page instead of fighting the [PageView]; in
/// fit-width mode the spread scrolls vertically instead of zooming.
class _SpreadView extends StatefulWidget {
  const _SpreadView({
    super.key,
    required this.images,
    required this.fit,
    required this.onTap,
  });

  final List<ImageProvider> images;
  final ComicFitMode fit;
  final VoidCallback onTap;

  @override
  State<_SpreadView> createState() => _SpreadViewState();
}

class _SpreadViewState extends State<_SpreadView> {
  final TransformationController _transform = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transform.removeListener(_onTransformChanged);
    _transform.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
  }

  void _onDoubleTap() {
    if (_zoomed) {
      _transform.value = Matrix4.identity();
      return;
    }
    final position = _doubleTapDetails?.localPosition;
    if (position == null) return;
    const scale = 2.5;
    _transform.value = Matrix4.identity()
      ..translateByDouble(-position.dx * (scale - 1),
          -position.dy * (scale - 1), 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  Widget _image(ImageProvider provider) => Image(
        image: provider,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image, color: Colors.white38, size: 48)),
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const Center(
                child: CircularProgressIndicator(color: Colors.white38)),
      );

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final provider in widget.images)
          Flexible(child: _image(provider)),
      ],
    );

    if (widget.fit == ComicFitMode.fitWidth) {
      return GestureDetector(
        onTap: widget.onTap,
        child: SingleChildScrollView(
          child: Row(
            children: [
              for (final provider in widget.images)
                Expanded(
                    child: Image(
                  image: provider,
                  fit: BoxFit.fitWidth,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => const SizedBox(
                      height: 200,
                      child: Icon(Icons.broken_image,
                          color: Colors.white38, size: 48)),
                )),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transform,
        maxScale: 6,
        panEnabled: _zoomed,
        clipBehavior: Clip.none,
        child: SizedBox.expand(child: row),
      ),
    );
  }
}
