import 'dart:convert';
import 'dart:ui';

import 'package:player/graphql/fragmentMediafiles.graphql.dart';

/// A subtitle stream the server serves as pictures (Blu-ray PGS, DVD VobSub)
/// instead of text: `/hls/{mediaFileId}/bsub_{streamId}.json` plus the sprite
/// sheets that index names. The player draws them itself, in
/// `BitmapSubtitleOverlay` — mpv and hls.js never see these tracks.
class BitmapSubtitleTrack {
  const BitmapSubtitleTrack(
      {required this.streamId, this.language, this.title});

  final String streamId;
  final String? language;
  final String? title;

  /// Bitmap codecs the server has a parser for. `dvb_subtitle` is not one.
  static const Set<String> codecs = {
    'hdmv_pgs_subtitle', 'pgssub', 'dvd_subtitle', 'dvdsub',
  };

  /// The bitmap streams of a media file, in stream order.
  static List<BitmapSubtitleTrack> of(
      Iterable<Fragment$fragmentMediaFiles$mediaFileStreams?>? streams) {
    if (streams == null) return const [];
    return [
      for (final s in streams)
        if (s != null &&
            s.codecType == 'SUBTITLE' &&
            codecs.contains(s.codecName.toLowerCase()))
          BitmapSubtitleTrack(
              streamId: s.id, language: s.language, title: s.title),
    ];
  }

  @override
  bool operator ==(Object other) =>
      other is BitmapSubtitleTrack && other.streamId == streamId;

  @override
  int get hashCode => streamId.hashCode;
}

/// One picture of a [BitmapSubtitleIndex]: on screen from [startMs] to [endMs]
/// at [position] on the subtitle canvas, cut out of sheet [sheet] at [source].
class BitmapCue {
  const BitmapCue({
    required this.startMs,
    required this.endMs,
    required this.position,
    required this.sheet,
    required this.source,
    this.forced = false,
  });

  final int startMs;
  final int endMs;
  final Rect position;
  final int sheet;
  final Rect source;
  final bool forced;
}

/// The parsed `bsub_{streamId}.json`. Cue times are milliseconds on the same
/// zero-based timeline as the player's position; coordinates refer to a
/// [canvas]-sized frame (the video the disc was authored for).
class BitmapSubtitleIndex {
  const BitmapSubtitleIndex(
      {required this.canvas, required this.sheets, required this.cues});

  final Size canvas;
  final List<String> sheets;

  /// Sorted by start time.
  final List<BitmapCue> cues;

  static BitmapSubtitleIndex parse(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    final cues = [
      for (final c in (map['cues'] as List).cast<Map<String, dynamic>>())
        BitmapCue(
          startMs: (c['s'] as num).toInt(),
          endMs: (c['e'] as num).toInt(),
          position: Rect.fromLTWH((c['x'] as num).toDouble(),
              (c['y'] as num).toDouble(), (c['w'] as num).toDouble(),
              (c['h'] as num).toDouble()),
          sheet: (c['sheet'] as num).toInt(),
          source: Rect.fromLTWH((c['sx'] as num).toDouble(),
              (c['sy'] as num).toDouble(), (c['w'] as num).toDouble(),
              (c['h'] as num).toDouble()),
          forced: c['forced'] == true,
        ),
    ]..sort((a, b) => a.startMs.compareTo(b.startMs));
    return BitmapSubtitleIndex(
      canvas: Size((map['width'] as num).toDouble(),
          (map['height'] as num).toDouble()),
      sheets: (map['sheets'] as List).cast<String>(),
      cues: cues,
    );
  }

  /// A PGS display set can hold two pictures and DVD cues never overlap, so
  /// looking this far back from the last cue that has started is plenty.
  static const int _lookBack = 4;

  /// The cues on screen at [positionMs].
  List<BitmapCue> activeAt(int positionMs) {
    final last = _lastStartedBefore(positionMs);
    if (last < 0) return const [];
    final from = last - _lookBack + 1;
    return [
      for (var i = from < 0 ? 0 : from; i <= last; i++)
        if (cues[i].endMs > positionMs) cues[i],
    ];
  }

  /// The sheets a player at [positionMs] should have decoded: the ones of the
  /// cues on screen and of the next few, so a sheet boundary never shows late.
  Set<int> sheetsAround(int positionMs, {int ahead = 8}) {
    final last = _lastStartedBefore(positionMs);
    final from = last < 0 ? 0 : last;
    final to = from + ahead < cues.length ? from + ahead : cues.length - 1;
    return {for (var i = from; i <= to; i++) cues[i].sheet};
  }

  /// Index of the last cue with `startMs <= positionMs`, or -1.
  int _lastStartedBefore(int positionMs) {
    var lo = 0;
    var hi = cues.length - 1;
    var found = -1;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      if (cues[mid].startMs <= positionMs) {
        found = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return found;
  }

  /// Where [cue] lands inside [videoRect], the rectangle the *uncropped*
  /// subtitle canvas occupies on screen.
  Rect destinationFor(BitmapCue cue, Rect videoRect) {
    if (canvas.isEmpty) return Rect.zero;
    final sx = videoRect.width / canvas.width;
    final sy = videoRect.height / canvas.height;
    return Rect.fromLTWH(
      videoRect.left + cue.position.left * sx,
      videoRect.top + cue.position.top * sy,
      cue.position.width * sx,
      cue.position.height * sy,
    );
  }
}

/// The on-screen rectangle of the full subtitle canvas, given where the
/// displayed video sits ([displayed], what `applyBoxFit` yields for the
/// surface) and the [crop] the player applied to the source frame, in source
/// pixels. With a crop the displayed video is only a window onto the canvas:
/// the canvas extends beyond it by the cropped-off margins, so a subtitle that
/// sat in a black bar is pulled up to the picture's edge by [clampInto].
Rect canvasRectFor(Rect displayed, Size canvas, Rect? crop) {
  if (crop == null || crop.isEmpty || canvas.isEmpty) return displayed;
  final scaleX = displayed.width / crop.width;
  final scaleY = displayed.height / crop.height;
  return Rect.fromLTWH(
    displayed.left - crop.left * scaleX,
    displayed.top - crop.top * scaleY,
    canvas.width * scaleX,
    canvas.height * scaleY,
  );
}

/// Shifts [rect] so it lies inside [bounds] where it can (a cue drawn in a
/// cropped-off letterbox bar would otherwise fall outside the visible video).
Rect clampInto(Rect rect, Rect bounds) {
  var dx = 0.0;
  var dy = 0.0;
  if (rect.bottom > bounds.bottom) dy = bounds.bottom - rect.bottom;
  if (rect.top + dy < bounds.top) dy = bounds.top - rect.top;
  if (rect.right > bounds.right) dx = bounds.right - rect.right;
  if (rect.left + dx < bounds.left) dx = bounds.left - rect.left;
  return rect.shift(Offset(dx, dy));
}
