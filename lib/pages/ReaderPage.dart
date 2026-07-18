import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/components/reader/ChapterView.dart';
import 'package:player/components/reader/ReaderChrome.dart';
import 'package:player/components/reader/ReaderSettingsSheet.dart';
import 'package:player/components/reader/ReaderTocDrawer.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/epub/ChapterContent.dart';
import 'package:player/utils/epub/EpubLocator.dart';
import 'package:player/utils/epub/EpubPackage.dart';
import 'package:player/utils/epub/EpubResourceClient.dart';
import 'package:player/utils/epub/ReadAloudController.dart';
import 'package:player/utils/epub/ReaderBookController.dart';
import 'package:player/utils/epub/ReaderPreferences.dart';
import 'package:player/utils/epub/ReadingSyncService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// The native epub reader. Loads the book's structure through the node's
/// `/epub` resource endpoint, renders one chapter at a time as a scrolling
/// block list, keeps the reading position synced with the server (including
/// the audiobook mapping) and plays EPUB 3 read-aloud audio.
///
/// Without [chapter] the book opens at the saved reading position — or at the
/// audiobook position when that one is newer; with it, at that chapter
/// (matched against the TOC, falling back to the spine, like the old web
/// reader). [readAloud] starts the media-overlay audio as soon as the chapter
/// is displayed.
@RoutePage()
class ReaderPage extends StatefulWidget {
  const ReaderPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('bookId') required this.bookId,
    @PathParam('mediaFileId') required this.mediaFileId,
    @QueryParam('nodeUrl') this.nodeUrl,
    @QueryParam('title') this.title,
    @QueryParam('chapter') this.chapter,
    @QueryParam('readAloud') this.readAloud = false,
  });

  final String serverName;
  final String bookId;
  final String mediaFileId;

  /// URL of the node that stores the epub file (epubFile.directory.node.url).
  final String? nodeUrl;
  final String? title;

  /// Index into the book's chapter list, to open there instead of resuming.
  final int? chapter;
  final bool readAloud;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with WidgetsBindingObserver {
  ReaderBookController? _book;
  ReadingSyncService? _sync;
  ReadAloudController? _readAloud;

  bool _loading = true;
  bool _loadFailed = false;

  int _spineIndex = 0;
  int _initialBlockIndex = 0;
  ChapterContent? _content;

  /// Bumped on every chapter change: gives the list a fresh key (so
  /// initialScrollIndex applies) and fresh scroll controllers.
  int _chapterGeneration = 0;
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  ScrollOffsetController _scrollOffsetController = ScrollOffsetController();

  int _topBlockIndex = 0;
  bool _suppressSync = true;
  bool _chromeVisible = true;
  bool _autoScrolling = false;

  /// The resolved start position. Nothing is reported to the server until the
  /// position actually moves away from it: merely *opening* the reader must
  /// not write a round-tripped (and slightly lossy) position back — the
  /// server mirrors every save onto the audiobook chapters, so a mapping
  /// that lands one chapter early would silently rewind the listening resume
  /// point.
  ({int spineIndex, int blockIndex})? _startPosition;
  bool _hasReported = false;

  double _fontScale = 1.0;
  ReaderTheme _theme = ReaderTheme.light;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      unawaited(
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky));
    }
    // Tolerates platforms/tests without the wakelock plugin.
    unawaited(WakelockPlus.enable().catchError((_) {}));
    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(WakelockPlus.disable().catchError((_) {}));
    if (!kIsWeb) {
      unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    }
    _readAloud?.dispose();
    _sync?.dispose(); // flushes the pending position
    _book?.removeListener(_onBookChanged);
    _book?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      unawaited(_readAloud?.pause());
      unawaited(_sync?.flush());
    }
  }

  Future<void> _load() async {
    final fontScale = await ReaderPreferences.getFontScale();
    final theme = await ReaderPreferences.getTheme();
    if (mounted) {
      setState(() {
        _fontScale = fontScale;
        _theme = theme;
      });
    }

    final nodeUrl = widget.nodeUrl;
    if (nodeUrl == null || nodeUrl.isEmpty) {
      _failLoad('Reader opened without a node url');
      return;
    }
    try {
      final client = EpubResourceClient(
        nodeUrl: nodeUrl,
        mediaFileId: widget.mediaFileId,
        serverName: widget.serverName,
      );
      final package = await EpubPackage.load(client);
      final book = ReaderBookController(client: client, package: package);
      book.addListener(_onBookChanged);
      final sync = ReadingSyncService(
        serverName: widget.serverName,
        bookId: widget.bookId,
        mediaFileId: widget.mediaFileId,
        book: book,
      );
      await sync.init();

      _book = book;
      _sync = sync;
      if (package.hasMediaOverlays) {
        _readAloud = ReadAloudController(
          book: book,
          onActiveBlockChanged: _scrollToActiveBlock,
          onAdvanceToSpineIndex: (spineIndex) =>
              unawaited(_showChapter(spineIndex, blockIndex: 0)),
        )..addListener(_onReadAloudChanged);
      }

      final start = await _resolveStartPosition(book, sync);
      _startPosition = start;
      await _showChapter(start.spineIndex, blockIndex: start.blockIndex);
      if (mounted) setState(() => _loading = false);
      // Saving stays suppressed until every chapter is weighed: before that
      // the whole-book fraction (and the proportional audiobook mapping for
      // unaligned books) is based on uniform guesses. The web reader did the
      // same by waiting for locations.generate().
      unawaited(book.refineWeights().then((_) {
        _suppressSync = false;
      }));

      if (widget.readAloud) {
        unawaited(_toggleReadAloud());
      }
    } catch (error) {
      _failLoad('Could not load the book: $error');
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

  /// A requested chapter wins over the saved position; otherwise resume at
  /// the reading or listening position, whichever was touched last.
  Future<({int spineIndex, int blockIndex})> _resolveStartPosition(
      ReaderBookController book, ReadingSyncService sync) async {
    final package = book.package;

    final chapterIndex = widget.chapter;
    if (chapterIndex != null && chapterIndex >= 0) {
      // The chapter's spine position, matched against the TOC and falling
      // back to the spine order.
      if (chapterIndex < package.toc.length) {
        final entry = package.toc[chapterIndex];
        final spineIndex = package.spineIndexForTocEntry(entry);
        if (spineIndex >= 0) {
          var blockIndex = 0;
          if (entry.fragment != null) {
            try {
              blockIndex = (await book.contentFor(spineIndex))
                      .blockIndexForId(entry.fragment!) ??
                  0;
            } catch (_) {
              // Start of the chapter, then.
            }
          }
          return (spineIndex: spineIndex, blockIndex: blockIndex);
        }
      }
      if (chapterIndex < package.spine.length) {
        return (spineIndex: chapterIndex, blockIndex: 0);
      }
    }

    final reading = sync.progress?.reading;
    final locator = sync.savedLocator();
    final readingTime = locator != null ? reading?.updatedAt : null;

    // The audiobook position wins when it is meaningfully newer. The margin
    // matters: every save writes the reading row first and the mirrored
    // chapter row last (that order is load-bearing server-side), so after a
    // reading session the listening timestamp is always a moment "newer" —
    // without the margin the exact locator would lose to its own lossy
    // audiobook round-trip on every reopen.
    final listening = sync.listeningPosition();
    if (listening != null &&
        (readingTime == null ||
            listening.updatedAt
                .isAfter(readingTime.add(const Duration(seconds: 30))))) {
      final position = await sync.audioToText(
          listening.chapterIndex, listening.positionInMilliseconds);
      if (position != null) return position;
    }

    if (locator != null) {
      final spineIndex = package.spineIndexForIdref(locator.spineIdref);
      if (spineIndex >= 0) {
        return (spineIndex: spineIndex, blockIndex: locator.blockIndex);
      }
    }

    // A position from the other epub edition (or the retired web reader's
    // epubcfi) still lands us on roughly the right page via its fraction.
    if (reading != null && reading.progress > 0) {
      final position = book.positionForFraction(reading.progress);
      try {
        final content = await book.contentFor(position.spineIndex);
        final blockIndex = content.blocks.isEmpty
            ? 0
            : (position.withinChapter * (content.blocks.length - 1)).round();
        return (spineIndex: position.spineIndex, blockIndex: blockIndex);
      } catch (_) {
        return (spineIndex: position.spineIndex, blockIndex: 0);
      }
    }

    final firstLinear = package.spine.indexWhere((item) => item.linear);
    return (spineIndex: firstLinear < 0 ? 0 : firstLinear, blockIndex: 0);
  }

  Future<void> _showChapter(int spineIndex, {required int blockIndex}) async {
    final book = _book;
    if (book == null) return;
    if (spineIndex < 0 || spineIndex >= book.package.spine.length) return;
    try {
      final content = await book.contentFor(spineIndex);
      if (!mounted) return;
      setState(() {
        _spineIndex = spineIndex;
        _content = content;
        _initialBlockIndex = blockIndex;
        _topBlockIndex = blockIndex;
        _chapterGeneration++;
        _itemScrollController = ItemScrollController();
        _itemPositionsListener.itemPositions
            .removeListener(_onPositionsChanged);
        _itemPositionsListener = ItemPositionsListener.create()
          ..itemPositions.addListener(_onPositionsChanged);
        _scrollOffsetController = ScrollOffsetController();
      });
      _readAloud?.invalidateSection();
      _reportCurrentPosition();
    } catch (error) {
      LoggerService().logger.e('Could not load chapter $spineIndex: $error');
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.couldNotLoadBook)));
      }
    }
  }

  void _onBookChanged() {
    // Chapter weights got refined: the progress label may shift.
    if (mounted) setState(() {});
  }

  void _onReadAloudChanged() {
    if (mounted) setState(() {});
  }

  void _onPositionsChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;
    // The topmost block that is (partly) visible.
    int? top;
    double? topEdge;
    for (final position in positions) {
      if (position.itemTrailingEdge <= 0) continue;
      if (topEdge == null || position.itemLeadingEdge < topEdge) {
        topEdge = position.itemLeadingEdge;
        top = position.index;
      }
    }
    if (top == null || top == _topBlockIndex) return;
    _topBlockIndex = top;
    _reportCurrentPosition();
    // Only the progress label needs a rebuild, and only while visible.
    if (_chromeVisible && mounted) setState(() {});
  }

  void _reportCurrentPosition() {
    if (_suppressSync) return;
    final book = _book;
    final sync = _sync;
    final content = _content;
    if (book == null || sync == null || content == null) return;
    // Still sitting where the book was opened: nothing to save.
    final start = _startPosition;
    if (!_hasReported &&
        start != null &&
        start.spineIndex == _spineIndex &&
        start.blockIndex == _topBlockIndex) {
      return;
    }
    _hasReported = true;
    final block =
        _topBlockIndex < content.blocks.length ? content.blocks[_topBlockIndex] : null;
    sync.reportPosition(EpubLocator(
      spineIdref: book.package.spine[_spineIndex].idref,
      blockIndex: _topBlockIndex,
      fragment: block?.ids.firstOrNull,
      bookFraction: _currentBookFraction(),
    ));
  }

  double _currentBookFraction() {
    final book = _book;
    final content = _content;
    if (book == null) return 0;
    final blockCount = content?.blocks.length ?? 0;
    final within = blockCount > 1 ? _topBlockIndex / (blockCount - 1) : 0.0;
    return book.bookFraction(_spineIndex, within);
  }

  /* ------------------------------ navigation ----------------------------- */

  bool get _atChapterEnd {
    final content = _content;
    if (content == null || content.blocks.isEmpty) return true;
    return _itemPositionsListener.itemPositions.value.any((position) =>
        position.index == content.blocks.length - 1 &&
        position.itemTrailingEdge <= 1.001);
  }

  bool get _atChapterStart {
    final content = _content;
    if (content == null || content.blocks.isEmpty) return true;
    return _itemPositionsListener.itemPositions.value.any((position) =>
        position.index == 0 && position.itemLeadingEdge >= -0.001);
  }

  int? _adjacentLinearSpineIndex(int direction) {
    final book = _book;
    if (book == null) return null;
    for (var index = _spineIndex + direction;
        index >= 0 && index < book.package.spine.length;
        index += direction) {
      if (book.package.spine[index].linear) return index;
    }
    return null;
  }

  Future<void> _nextChapter() async {
    final next = _adjacentLinearSpineIndex(1);
    if (next != null) await _showChapter(next, blockIndex: 0);
  }

  Future<void> _previousChapter({bool atEnd = false}) async {
    final book = _book;
    final previous = _adjacentLinearSpineIndex(-1);
    if (book == null || previous == null) return;
    var blockIndex = 0;
    if (atEnd) {
      try {
        final content = await book.contentFor(previous);
        blockIndex = content.blocks.isEmpty ? 0 : content.blocks.length - 1;
      } catch (_) {
        // Start of the chapter, then.
      }
    }
    await _showChapter(previous, blockIndex: blockIndex);
  }

  void _pageStep(int direction) {
    if (direction > 0 && _atChapterEnd) {
      unawaited(_nextChapter());
      return;
    }
    if (direction < 0 && _atChapterStart) {
      unawaited(_previousChapter(atEnd: true));
      return;
    }
    final viewport = MediaQuery.of(context).size.height;
    unawaited(_scrollOffsetController.animateScroll(
      offset: direction * viewport * 0.9,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    ));
  }

  void _openTocEntry(EpubTocEntry entry) {
    final book = _book;
    if (book == null) return;
    _scaffoldKey.currentState?.closeEndDrawer();
    final spineIndex = book.package.spineIndexForHref(entry.href);
    if (spineIndex < 0) return;
    unawaited(() async {
      var blockIndex = 0;
      final fragment = entry.fragment;
      if (fragment != null) {
        try {
          blockIndex =
              (await book.contentFor(spineIndex)).blockIndexForId(fragment) ??
                  0;
        } catch (_) {
          // Start of the chapter, then.
        }
      }
      if (spineIndex == _spineIndex && _itemScrollController.isAttached) {
        _itemScrollController.jumpTo(index: blockIndex);
      } else {
        await _showChapter(spineIndex, blockIndex: blockIndex);
      }
    }());
  }

  /// An internal link inside a chapter (`epub:///entry#fragment` after the
  /// content rewrite, or a relative href fwfh left alone).
  void _openLink(String url) {
    final book = _book;
    if (book == null) return;
    if (url.startsWith('http://') || url.startsWith('https://')) return;
    final hashIndex = url.indexOf('#');
    final path = hashIndex >= 0 ? url.substring(0, hashIndex) : url;
    final fragment = hashIndex >= 0 ? url.substring(hashIndex + 1) : null;
    final entryPath = ChapterContent.entryPathFromUrl(path) ??
        EpubPackage.resolveHref(
            _dirOfCurrentChapter(), path.isEmpty ? '' : path);
    final spineIndex = path.isEmpty
        ? _spineIndex
        : book.package.spineIndexForHref(entryPath);
    if (spineIndex < 0) return;
    _openTocEntry(EpubTocEntry(
      label: '',
      href: book.package.spine[spineIndex].href,
      fragment: fragment,
    ));
  }

  String _dirOfCurrentChapter() {
    final href = _book?.package.spine[_spineIndex].href ?? '';
    return href.contains('/')
        ? href.substring(0, href.lastIndexOf('/') + 1)
        : '';
  }

  /* ------------------------------ read-aloud ----------------------------- */

  Future<void> _toggleReadAloud() async {
    final readAloud = _readAloud;
    if (readAloud == null) return;
    final started =
        await readAloud.toggle(_spineIndex, fromBlockIndex: _topBlockIndex);
    if (!started && mounted) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loc.noReadAloudForChapter)));
    }
  }

  void _scrollToActiveBlock(int blockIndex) {
    if (!mounted || _autoScrolling || !_itemScrollController.isAttached) {
      return;
    }
    // Leave the view alone while a decent part of the block is on screen: a
    // paragraph taller than the viewport is never *fully* visible, and
    // re-scrolling it on every sentence is exactly the jumping this guards
    // against. Only pull the block back when it (nearly) left the screen.
    final position = _itemPositionsListener.itemPositions.value
        .where((position) => position.index == blockIndex)
        .firstOrNull;
    final comfortablyVisible = position != null &&
        position.itemTrailingEdge > 0.15 &&
        position.itemLeadingEdge < 0.85;
    if (comfortablyVisible) return;
    // One scroll at a time: starting a new animation while the previous one
    // is still running makes the list thrash between the two targets.
    _autoScrolling = true;
    unawaited(_itemScrollController
        .scrollTo(
          index: blockIndex,
          alignment: 0.15,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        )
        .whenComplete(() => _autoScrolling = false));
  }

  void _onBlockTap(int blockIndex, ChapterBlock block) {
    final readAloud = _readAloud;
    // While reading aloud, tapping a sentence jumps the audio there.
    if (readAloud != null && readAloud.playing && block.ids.isNotEmpty) {
      unawaited(readAloud.seekToBlock(_spineIndex, blockIndex));
      return;
    }
    setState(() => _chromeVisible = !_chromeVisible);
  }

  /* -------------------------------- input -------------------------------- */

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.pageDown) {
      _pageStep(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.pageUp) {
      _pageStep(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.mediaPlayPause) {
      if (_readAloud != null) {
        unawaited(_toggleReadAloud());
        return KeyEventResult.handled;
      }
    }
    if (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter) {
      setState(() => _chromeVisible = !_chromeVisible);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /* ------------------------------- settings ------------------------------ */

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => ReaderSettingsSheet(
        fontScale: _fontScale,
        theme: _theme,
        onFontScaleChanged: (value) {
          setState(() => _fontScale = value);
          unawaited(ReaderPreferences.setFontScale(value));
        },
        onThemeChanged: (value) {
          setState(() => _theme = value);
          unawaited(ReaderPreferences.setTheme(value));
        },
      ),
    );
  }

  /* -------------------------------- build -------------------------------- */

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final book = _book;
    final content = _content;
    final title = book?.package.title ?? widget.title ?? '';

    return Theme(
      data: Theme.of(context).copyWith(
        brightness: _theme.brightness,
        scaffoldBackgroundColor: _theme.background,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _theme.background,
        endDrawer: book != null
            ? ReaderTocDrawer(
                package: book.package,
                currentSpineIndex: _spineIndex,
                onEntryTap: _openTocEntry,
              )
            : null,
        // The bars overlay the text in a Stack (never resizing it); the
        // system bars are hidden by the immersive mode set in initState. The
        // endDrawer stays a Scaffold feature and is unaffected.
        body: Focus(
          autofocus: true,
          onKeyEvent: _onKeyEvent,
          child: Stack(
            children: [
              Positioned.fill(
                child: Builder(
                  builder: (context) {
                    if (_loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_loadFailed || book == null || content == null) {
                      return Center(
                        child: Text(
                          loc.couldNotLoadBook,
                          style: TextStyle(color: _theme.foreground),
                        ),
                      );
                    }
                    return SafeArea(
                      child: ChapterView(
                        key: ValueKey('chapter-$_chapterGeneration'),
                        content: content,
                        theme: _theme,
                        fontScale: _fontScale,
                        resourceUrl: book.client.url,
                        itemScrollController: _itemScrollController,
                        itemPositionsListener: _itemPositionsListener,
                        scrollOffsetController: _scrollOffsetController,
                        initialBlockIndex: _initialBlockIndex,
                        highlightFragment: _readAloud?.activeFragment,
                        onBlockTap: _onBlockTap,
                        onLinkTap: _openLink,
                      ),
                    );
                  },
                ),
              ),
              ReaderChrome(
                visible: _chromeVisible,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Constrained: outside a Scaffold slot an AppBar expands
                    // to fill loose constraints and would cover the page.
                    SizedBox(
                        height: kToolbarHeight,
                        child: AppBar(
                      backgroundColor:
                          _theme.background.withValues(alpha: 0.85),
                      foregroundColor: _theme.foreground,
                      title: Text(title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      actions: [
                        if (_readAloud != null)
                          IconButton(
                            tooltip: loc.readAloud,
                            icon: Icon(_readAloud!.playing
                                ? Icons.pause_circle_outline
                                : Icons.record_voice_over),
                            onPressed: () => unawaited(_toggleReadAloud()),
                          ),
                        IconButton(
                          tooltip: loc.readerSettings,
                          icon: const Icon(Icons.text_fields),
                          onPressed: _openSettings,
                        ),
                        IconButton(
                          tooltip: loc.tableOfContents,
                          icon: const Icon(Icons.toc),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openEndDrawer(),
                        ),
                      ],
                    )),
                    if (book != null && book.package.fixedLayout)
                      MaterialBanner(
                        content: Text(loc.bookMayNotDisplayCorrectly),
                        actions: const [SizedBox.shrink()],
                      ),
                  ],
                ),
              ),
              ReaderChrome(
                visible: _chromeVisible && book != null,
                alignment: Alignment.bottomCenter,
                child: BottomAppBar(
                  color: _theme.background.withValues(alpha: 0.85),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: loc.previousChapter,
                        color: _theme.foreground,
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _adjacentLinearSpineIndex(-1) != null
                            ? () => unawaited(_previousChapter())
                            : null,
                      ),
                      Expanded(
                        child: Text(
                          '${(_currentBookFraction() * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _theme.foreground),
                        ),
                      ),
                      IconButton(
                        tooltip: loc.nextChapter,
                        color: _theme.foreground,
                        icon: const Icon(Icons.skip_next),
                        onPressed: _adjacentLinearSpineIndex(1) != null
                            ? () => unawaited(_nextChapter())
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
