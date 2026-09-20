import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/AppMessenger.dart';
import '../../utils/LoggerService.dart';
import '../../utils/MediaPlayerHandler.dart';
import '../../utils/subtitles/BitmapSubtitleLoader.dart';
import '../../utils/subtitles/BitmapSubtitles.dart';

/// Draws the selected bitmap subtitle track (Blu-ray PGS, DVD VobSub) over the
/// video: the pictures the disc shipped, positioned where the disc put them.
///
/// These tracks exist for neither mpv nor hls.js — the server serves them as a
/// cue index plus sprite sheets (see [BitmapSubtitleLoader]) — so this is the
/// one subtitle renderer the app owns, identical on every platform.
///
/// The player reports its position only every ~250 ms on web (`timeupdate`),
/// far too coarse for a cue change, so a [Ticker] extrapolates between reports
/// while playing and the painter only repaints when the set of cues changes.
class BitmapSubtitleOverlay extends StatefulWidget {
  const BitmapSubtitleOverlay({super.key, required this.state});

  final VideoState state;

  @override
  State<BitmapSubtitleOverlay> createState() => _BitmapSubtitleOverlayState();
}

class _BitmapSubtitleOverlayState extends State<BitmapSubtitleOverlay>
    with SingleTickerProviderStateMixin {
  /// Decoded sheets kept at once; a sheet is a few MB of RGBA once decoded.
  static const int _maxSheets = 3;

  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;
  late final Ticker _ticker = createTicker(_onTick);
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  BitmapSubtitleLoader? _loader;
  BitmapSubtitleIndex? _index;
  int _generation = 0;

  final Map<int, ui.Image> _sheets = {};
  final Set<int> _sheetsLoading = {};

  final Stopwatch _sincePosition = Stopwatch();
  int _reportedMs = 0;
  bool _playing = false;
  double _rate = 1.0;

  final ValueNotifier<List<BitmapCue>> _active = ValueNotifier(const []);

  @override
  void initState() {
    super.initState();
    final player = widget.state.widget.controller.player;
    _playing = player.state.playing;
    _rate = player.state.rate;
    _reportedMs = player.state.position.inMilliseconds;
    _subscriptions.addAll([
      player.stream.position.listen((p) {
        _reportedMs = p.inMilliseconds;
        _sincePosition
          ..reset()
          ..start();
      }),
      player.stream.playing.listen((playing) {
        _reportedMs = _positionMs();
        _sincePosition.reset();
        _playing = playing;
      }),
      player.stream.rate.listen((rate) {
        _reportedMs = _positionMs();
        _sincePosition.reset();
        _rate = rate;
      }),
    ]);
    _handler.bitmapSubtitle.addListener(_onTrackChanged);
    _onTrackChanged();
  }

  @override
  void dispose() {
    _handler.bitmapSubtitle.removeListener(_onTrackChanged);
    for (final s in _subscriptions) {
      s.cancel();
    }
    _ticker.dispose();
    _clearSheets();
    _active.dispose();
    super.dispose();
  }

  /// The reported position, extrapolated while playing. Capped: after a stall
  /// the player simply stops reporting, and the cues must not run on alone.
  int _positionMs() {
    if (!_playing) return _reportedMs;
    final elapsed = _sincePosition.elapsedMilliseconds.clamp(0, 1000);
    return _reportedMs + (elapsed * _rate).round();
  }

  Future<void> _onTrackChanged() async {
    final track = _handler.bitmapSubtitle.value;
    final generation = ++_generation;
    _index = null;
    _active.value = const [];
    _clearSheets();
    if (track == null) {
      _ticker.stop();
      return;
    }
    final loader = _handler.bitmapSubtitleLoader();
    if (loader == null) return;
    _loader = loader;
    try {
      final index = await loader.loadIndex(track.streamId);
      if (!mounted || generation != _generation) return;
      _index = index;
      if (!_ticker.isActive) _ticker.start();
    } catch (e) {
      LoggerService().logger.w('bitmap subtitle index failed: $e');
      if (!mounted || generation != _generation) return;
      // Most likely a server without the endpoint: say so instead of showing
      // a selected track that never draws anything.
      if (_handler.bitmapSubtitle.value == track) {
        _handler.bitmapSubtitle.value = null;
      }
      final context = this.context;
      if (context.mounted) {
        showAppSnackBar(AppLocalizations.of(context)!.subtitlesBitmapLoadFailed);
      }
    }
  }

  void _onTick(Duration _) {
    final index = _index;
    if (index == null) return;
    final position = _positionMs();
    _ensureSheets(index, position);
    final cues = index.activeAt(position);
    if (!_sameCues(cues, _active.value)) _active.value = cues;
  }

  static bool _sameCues(List<BitmapCue> a, List<BitmapCue> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }

  void _ensureSheets(BitmapSubtitleIndex index, int position) {
    final wanted = index.sheetsAround(position);
    for (final sheet in wanted) {
      if (_sheets.containsKey(sheet) || _sheetsLoading.contains(sheet)) continue;
      if (sheet < 0 || sheet >= index.sheets.length) continue;
      _sheetsLoading.add(sheet);
      final generation = _generation;
      _loader!.loadSheet(index.sheets[sheet]).then((image) {
        _sheetsLoading.remove(sheet);
        if (!mounted || generation != _generation) {
          image.dispose();
          return;
        }
        _sheets[sheet] = image;
        // Evict what the playhead left behind, oldest sheet numbers first.
        final stale = _sheets.keys.where((k) => !wanted.contains(k)).toList()
          ..sort();
        while (_sheets.length > _maxSheets && stale.isNotEmpty) {
          _sheets.remove(stale.removeAt(0))?.dispose();
        }
        // The cue may already be "active" with nothing to draw: repaint.
        _active.value = List.of(_active.value);
      }).catchError((Object e) {
        _sheetsLoading.remove(sheet);
        LoggerService().logger.w('bitmap subtitle sheet $sheet failed: $e');
      });
    }
  }

  void _clearSheets() {
    for (final image in _sheets.values) {
      image.dispose();
    }
    _sheets.clear();
    _sheetsLoading.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.state.widget.controller;
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: _BitmapSubtitlePainter(
            overlay: this,
            repaint: Listenable.merge([
              _active,
              controller.rect,
              widget.state.videoViewParametersNotifier,
              _handler.appliedVideoCrop,
            ]),
          ),
        ),
      ),
    );
  }
}

class _BitmapSubtitlePainter extends CustomPainter {
  _BitmapSubtitlePainter({required this.overlay, required Listenable repaint})
      : super(repaint: repaint);

  final _BitmapSubtitleOverlayState overlay;

  static final Paint _paint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void paint(Canvas canvas, Size size) {
    final index = overlay._index;
    final cues = overlay._active.value;
    if (index == null || cues.isEmpty || size.isEmpty) return;

    final state = overlay.widget.state;
    final video = state.widget.controller.rect.value;
    final videoSize = video == null || video.isEmpty ? index.canvas : video.size;
    final fit = state.videoViewParametersNotifier.value.fit;
    final fitted = applyBoxFit(fit, videoSize, size);
    final displayed =
        Alignment.center.inscribe(fitted.destination, Offset.zero & size);

    final crop = overlay._handler.appliedVideoCrop.value;
    final canvasRect = canvasRectFor(
      displayed,
      index.canvas,
      crop == null
          ? null
          : Rect.fromLTWH(
              crop.left * index.canvas.width,
              crop.top * index.canvas.height,
              crop.width * index.canvas.width,
              crop.height * index.canvas.height),
    );
    // What is actually visible of the video: zoom-to-fill overflows the surface.
    final visible = displayed.intersect(Offset.zero & size);

    for (final cue in cues) {
      final image = overlay._sheets[cue.sheet];
      if (image == null) continue;
      final destination =
          clampInto(index.destinationFor(cue, canvasRect), visible);
      canvas.drawImageRect(image, cue.source, destination, _paint);
    }
  }

  @override
  bool shouldRepaint(_BitmapSubtitlePainter oldDelegate) => false;
}
