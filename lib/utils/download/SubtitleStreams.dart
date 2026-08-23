import 'package:player/graphql/fragmentMediafiles.graphql.dart';

/// Which of a media file's subtitle streams the server can serve as a whole
/// SRT sidecar (`/hls/{id}/sub_{streamId}.srt`). Shared by the player's
/// side-loading and the downloader so both mirror the same set.
class SubtitleStreams {
  SubtitleStreams._();

  /// Subtitle codecs ffmpeg can convert to SRT; image codecs (DVD/PGS
  /// bitmaps) have no SRT endpoint — the server OCRs those at scan time into
  /// EXTERNAL_SUBTITLE rows.
  static const Set<String> textSubtitleCodecs = {
    'subrip', 'ass', 'ssa', 'mov_text', 'webvtt', 'text', 'subtitle srt',
  };

  /// Embedded cover art is stored as a VIDEO stream by the analyzer.
  static const Set<String> artworkCodecs = {'mjpeg', 'png', 'bmp', 'gif', 'webp'};

  /// One entry per stream index: the OCR'd/extracted EXTERNAL_SUBTITLE row
  /// wins over the raw embedded row it was derived from.
  static List<Fragment$fragmentMediaFiles$mediaFileStreams> sideloadable(
      List<Fragment$fragmentMediaFiles$mediaFileStreams?>? streams) {
    if (streams == null) return const [];
    final byIndex = <int, Fragment$fragmentMediaFiles$mediaFileStreams>{};
    for (final s in streams) {
      final index = s?.streamIndex;
      if (s == null || index == null) continue;
      final codec = s.codecName.toLowerCase();
      if (s.codecType == 'EXTERNAL_SUBTITLE') {
        byIndex[index] = s;
      } else if (s.codecType == 'SUBTITLE' &&
          textSubtitleCodecs.contains(codec)) {
        byIndex.putIfAbsent(index, () => s);
      }
    }
    return byIndex.values.toList();
  }

  /// Whether the file carries a real (non-artwork) video stream.
  static bool hasVideo(
          List<Fragment$fragmentMediaFiles$mediaFileStreams?>? streams) =>
      streams?.any((s) =>
          s != null &&
          s.codecType == 'VIDEO' &&
          !artworkCodecs.contains(s.codecName.toLowerCase())) ??
      false;
}
