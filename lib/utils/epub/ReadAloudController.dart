import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/epub/ReaderBookController.dart';
import 'package:player/utils/epub/SmilDocument.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

/// EPUB 3 media-overlay (read-aloud) playback, ported from the web reader's
/// `overlay` object.
///
/// Owns a dedicated media_kit [Player] rather than going through
/// [MediaPlayerHandler]: overlay playback is clip-scheduled (seek to a
/// sentence's clipBegin, hop or re-seek at its clipEnd) and reports progress
/// through the reading-position sync, which is at odds with the handler's
/// play-queue and heartbeat model — and read-aloud is inherently a foreground
/// activity, since the highlighting needs the page on screen. The handler's
/// own playback is paused when read-aloud starts so the two never talk over
/// each other.
class ReadAloudController extends ChangeNotifier {
  ReadAloudController({
    required this.book,
    required this.onActiveBlockChanged,
    required this.onAdvanceToSpineIndex,
  });

  final ReaderBookController book;

  /// The active sentence moved to another block: scroll it into view.
  final void Function(int blockIndex) onActiveBlockChanged;

  /// The chapter's audio finished; the reader should display [spineIndex]
  /// (whose pars are already loaded) — playback continues there.
  final void Function(int spineIndex) onAdvanceToSpineIndex;

  Player? _player;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<bool>? _completedSubscription;

  final Map<int, SmilDocument?> _smilCache = {};

  bool playing = false;
  int? _spineIndex;
  List<SmilPar> _pars = const [];
  int _activeIndex = -1;
  String? _currentAudioUrl;
  int? _lastNotifiedBlock;

  /// Id of the sentence being read, for highlighting.
  String? get activeFragment =>
      playing && _activeIndex >= 0 && _activeIndex < _pars.length
          ? _pars[_activeIndex].fragment
          : null;

  int? get spineIndex => _spineIndex;

  /// Whether a spine item has read-aloud audio (loads and caches its SMIL).
  Future<bool> hasParsFor(int spineIndex) async =>
      (await _smilFor(spineIndex))?.pars.isNotEmpty == true;

  Future<SmilDocument?> _smilFor(int spineIndex) async {
    if (_smilCache.containsKey(spineIndex)) return _smilCache[spineIndex];
    SmilDocument? smil;
    final overlay = book.package.mediaOverlayForSpineIndex(spineIndex);
    if (overlay != null) {
      try {
        smil = SmilDocument.parse(
          await book.client.text(overlay.href),
          overlay.href.contains('/')
              ? overlay.href.substring(0, overlay.href.lastIndexOf('/') + 1)
              : '',
        );
      } catch (error) {
        LoggerService().logger.w('Could not load the media overlay: $error');
      }
    }
    _smilCache[spineIndex] = smil;
    return smil;
  }

  Player _ensurePlayer() {
    if (_player != null) return _player!;
    final player = Player();
    _positionSubscription =
        player.stream.position.listen(_onPositionChanged);
    _completedSubscription = player.stream.completed.listen((completed) {
      if (completed) unawaited(_advanceToNextSection());
    });
    _player = player;
    return player;
  }

  /// Starts (or pauses) reading the given chapter aloud. [fromBlockIndex]
  /// picks the first sentence at/after that block, so playback starts at the
  /// reader's current position. Returns false when the chapter has no
  /// read-aloud audio.
  Future<bool> toggle(int spineIndex, {int? fromBlockIndex}) async {
    if (playing) {
      await pause();
      return true;
    }
    return play(spineIndex, fromBlockIndex: fromBlockIndex);
  }

  Future<bool> play(int spineIndex, {int? fromBlockIndex}) async {
    final smil = await _smilFor(spineIndex);
    if (smil == null || smil.pars.isEmpty) return false;

    if (_spineIndex != spineIndex) {
      _spineIndex = spineIndex;
      _pars = smil.pars;
      _activeIndex = -1;
    }
    var index = _activeIndex >= 0 ? _activeIndex : 0;
    if (fromBlockIndex != null) {
      index = await _parIndexForBlock(spineIndex, fromBlockIndex) ?? index;
    }
    // Other audio (music, audiobook) has to stop before read-aloud starts.
    unawaited(MediaPlayerHandler.instance.pause());
    await _playPar(index);
    return true;
  }

  /// The first par whose fragment sits at or after [blockIndex], or null when
  /// the chapter's pars don't intersect that part of the text.
  Future<int?> _parIndexForBlock(int spineIndex, int blockIndex) async {
    try {
      final content = await book.contentFor(spineIndex);
      int? best;
      for (var index = 0; index < _pars.length; index++) {
        final parBlock = content.blockIndexForId(_pars[index].fragment);
        if (parBlock == null) continue;
        if (parBlock >= blockIndex) return index;
        best = index;
      }
      return best;
    } catch (_) {
      return null;
    }
  }

  /// Seeks to the sentence in [blockIndex] (tap-to-seek). Only reacts while
  /// this chapter is the playing one.
  Future<void> seekToBlock(int spineIndex, int blockIndex) async {
    if (_spineIndex != spineIndex || _pars.isEmpty) return;
    try {
      final content = await book.contentFor(spineIndex);
      for (var index = 0; index < _pars.length; index++) {
        if (content.blockIndexForId(_pars[index].fragment) == blockIndex) {
          await _playPar(index);
          return;
        }
      }
    } catch (_) {
      // Best effort: a failed lookup only means no seek.
    }
  }

  Future<void> _playPar(int index) async {
    final spineIndex = _spineIndex;
    if (spineIndex == null) return;
    if (index < 0 || index >= _pars.length) {
      await _advanceToNextSection();
      return;
    }
    final par = _pars[index];
    _activeIndex = index;
    final player = _ensurePlayer();
    final url = book.client.url(par.audioHref);
    try {
      if (_currentAudioUrl != url) {
        _currentAudioUrl = url;
        await player.open(Media(url, start: par.clipBegin));
      } else {
        await player.seek(par.clipBegin);
        await player.play();
      }
      playing = true;
    } catch (error) {
      LoggerService().logger.e('Read-aloud playback failed: $error');
      playing = false;
    }
    _notifyActiveBlock();
    notifyListeners();
  }

  void _onPositionChanged(Duration position) {
    if (!playing || _activeIndex < 0 || _activeIndex >= _pars.length) return;
    final current = _pars[_activeIndex];
    if (position < current.clipEnd - const Duration(milliseconds: 50)) return;

    final nextIndex = _activeIndex + 1;
    if (nextIndex >= _pars.length) {
      unawaited(_advanceToNextSection());
      return;
    }
    final next = _pars[nextIndex];
    // Same audio file and contiguous: let it run. Otherwise seek explicitly.
    if (next.audioHref == current.audioHref &&
        (next.clipBegin - current.clipEnd).abs() <
            const Duration(milliseconds: 300)) {
      _activeIndex = nextIndex;
      _notifyActiveBlock();
      notifyListeners();
    } else {
      unawaited(_playPar(nextIndex));
    }
  }

  /// Tells the reader which block is being read — but only when the block
  /// actually changed: sentences advance every few seconds, and re-notifying
  /// the same block would re-trigger the auto-scroll on every one of them.
  void _notifyActiveBlock() {
    final spineIndex = _spineIndex;
    final fragment = activeFragment;
    if (spineIndex == null || fragment == null) return;
    unawaited(book.contentFor(spineIndex).then((content) {
      final blockIndex = content.blockIndexForId(fragment);
      if (blockIndex == null || blockIndex == _lastNotifiedBlock || !playing) {
        return;
      }
      _lastNotifiedBlock = blockIndex;
      onActiveBlockChanged(blockIndex);
    }));
  }

  Future<void> _advanceToNextSection() async {
    final current = _spineIndex;
    if (current == null) return;
    for (var next = current + 1; next < book.package.spine.length; next++) {
      if (!book.package.spine[next].linear) continue;
      final smil = await _smilFor(next);
      if (smil != null && smil.pars.isNotEmpty) {
        _spineIndex = next;
        _pars = smil.pars;
        _activeIndex = -1;
        onAdvanceToSpineIndex(next);
        await _playPar(0);
        return;
      }
      break;
    }
    await pause();
  }

  /// A manual chapter change while paused invalidates the loaded pars, so a
  /// later play starts at the new position instead of the stale chapter.
  void invalidateSection() {
    if (playing) return;
    _spineIndex = null;
    _pars = const [];
    _activeIndex = -1;
    _lastNotifiedBlock = null;
    notifyListeners();
  }

  Future<void> pause() async {
    playing = false;
    await _player?.pause();
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _completedSubscription?.cancel();
    final player = _player;
    _player = null;
    if (player != null) unawaited(player.dispose());
    super.dispose();
  }
}
