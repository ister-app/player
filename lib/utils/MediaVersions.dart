import 'package:player/graphql/fragmentMediafiles.graphql.dart';

/// An item (movie, episode, …) can come with several media files: a 4K and a
/// 1080p version, another container, another cut. Which one plays is decided
/// here and nowhere else — every "the item's file" in the app used to be
/// `mediaFile.first`, each on its own, which is how the subtitles, crop and
/// intro of one file ended up on the stream of another.
///
/// Pure and stateless on purpose: the rules are what the unit tests cover.
class MediaVersions {
  MediaVersions._();

  /// The file to open for an item: [preferredId] when the item has it (the
  /// user's pick for this session, the file a leader or another device is
  /// playing), else [pickDefault].
  static Fragment$fragmentMediaFiles? resolve(
    List<Fragment$fragmentMediaFiles>? files, {
    String? preferredId,
    bool Function(Fragment$fragmentMediaFiles file)? isLocal,
    int? maxHeight,
    bool directPlay = true,
    bool Function(String codec)? canDecode,
  }) {
    if (files == null || files.isEmpty) return null;
    if (preferredId != null) {
      final preferred = files.where((f) => f.id == preferredId).firstOrNull;
      if (preferred != null) return preferred;
    }
    return pickDefault(files,
        isLocal: isLocal,
        maxHeight: maxHeight,
        directPlay: directPlay,
        canDecode: canDecode);
  }

  /// The best version that plays directly:
  ///  1. a file that is downloaded on this device ([isLocal]) — it plays
  ///     offline and costs the server nothing;
  ///  2. within [maxHeight], when set and anything fits;
  ///  3. with direct play on, a codec this platform decodes ([canDecode])
  ///     before one that has to be transcoded anyway;
  ///  4. the highest resolution, then the biggest file (bitrate), then the
  ///     lowest id — so the answer never depends on the order of the list.
  static Fragment$fragmentMediaFiles? pickDefault(
    List<Fragment$fragmentMediaFiles> files, {
    bool Function(Fragment$fragmentMediaFiles file)? isLocal,
    int? maxHeight,
    bool directPlay = true,
    bool Function(String codec)? canDecode,
  }) {
    if (files.isEmpty) return null;
    if (files.length == 1) return files.first;

    var candidates = files;
    if (isLocal != null) {
      final local = files.where(isLocal).toList();
      if (local.isNotEmpty) candidates = local;
    }
    if (maxHeight != null) {
      final fitting =
          candidates.where((f) => heightOf(f) <= maxHeight).toList();
      if (fitting.isNotEmpty) candidates = fitting;
    }
    if (directPlay && canDecode != null) {
      final playable = candidates.where((f) {
        final codec = videoCodecOf(f);
        return codec == null || canDecode(codec);
      }).toList();
      if (playable.isNotEmpty) candidates = playable;
    }
    final sorted = List.of(candidates)
      ..sort((a, b) {
        final byHeight = heightOf(b).compareTo(heightOf(a));
        if (byHeight != 0) return byHeight;
        final bySize = b.size.compareTo(a.size);
        if (bySize != 0) return bySize;
        return a.id.compareTo(b.id);
      });
    return sorted.first;
  }

  static Fragment$fragmentMediaFiles$mediaFileStreams? _videoStream(
          Fragment$fragmentMediaFiles file) =>
      file.mediaFileStreams
          ?.where((s) => s != null && s.codecType.toUpperCase() == 'VIDEO')
          .firstOrNull;

  /// Height of the file's video stream; 0 for audio or a file that was not
  /// analysed yet.
  static int heightOf(Fragment$fragmentMediaFiles file) =>
      _videoStream(file)?.height ?? 0;

  static String? videoCodecOf(Fragment$fragmentMediaFiles file) =>
      _videoStream(file)?.codecName.toLowerCase();

  /// Two files that can share a position: a resume point or a follower's
  /// timeline only carries over when they are the same cut. Within 2 % — a
  /// remux or re-encode of one film differs by frames, an extended cut by
  /// minutes. Unknown durations (not analysed) are given the benefit of the
  /// doubt.
  static bool sameTimeline(
      Fragment$fragmentMediaFiles a, Fragment$fragmentMediaFiles b) {
    if (a.id == b.id) return true;
    final da = a.durationInMilliseconds ?? 0;
    final db = b.durationInMilliseconds ?? 0;
    if (da <= 0 || db <= 0) return true;
    final longest = da > db ? da : db;
    return (da - db).abs() * 50 <= longest;
  }

  /// "4K", "1080p", …; null for a file without a video stream.
  static String? resolutionLabel(Fragment$fragmentMediaFiles file) {
    final stream = _videoStream(file);
    if (stream == null || stream.height <= 0) return null;
    // By width as well: a 2.39:1 film in a 3840-wide frame is 1606 high.
    if (stream.width >= 3800 || stream.height >= 2000) return '4K';
    if (stream.width >= 2500 || stream.height >= 1400) return '1440p';
    if (stream.width >= 1900 || stream.height >= 1000) return '1080p';
    if (stream.width >= 1200 || stream.height >= 700) return '720p';
    return '${stream.height}p';
  }

  static const _codecNames = {
    'hevc': 'HEVC',
    'h265': 'HEVC',
    'h264': 'H.264',
    'avc': 'H.264',
    'av1': 'AV1',
    'vp9': 'VP9',
    'mpeg2video': 'MPEG-2',
    'mpeg4': 'MPEG-4',
    'vc1': 'VC-1',
  };

  /// Container from the path's extension, uppercased ("MKV").
  static String? formatOf(Fragment$fragmentMediaFiles file) {
    final name = file.path.split('/').last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0 || dot == name.length - 1) return null;
    return name.substring(dot + 1).toUpperCase();
  }

  static String _size(double bytes) {
    const units = ['B', 'kB', 'MB', 'GB', 'TB'];
    var value = bytes;
    var unit = 0;
    while (value >= 1000 && unit < units.length - 1) {
      value /= 1000;
      unit++;
    }
    return '${value.toStringAsFixed(unit == 0 || value >= 10 ? 0 : 1)} ${units[unit]}';
  }

  static String _duration(int ms) {
    final minutes = (ms / 60000).round();
    return minutes >= 60
        ? '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}'
        : '$minutes min';
  }

  /// One label per file, in [files] order: "4K · HEVC · 58 GB". Whatever is
  /// the same for all of them and tells nothing apart is still shown (it is
  /// what the user is choosing between); what *does* differ and is not in the
  /// base label yet — the running time of another cut, the container — is
  /// added only when needed, and files that still read the same get numbered.
  static List<String> labelsFor(List<Fragment$fragmentMediaFiles> files) {
    String base(Fragment$fragmentMediaFiles f) {
      final codec = videoCodecOf(f);
      return [
        ?resolutionLabel(f),
        if (codec != null) _codecNames[codec] ?? codec.toUpperCase(),
        if (f.size > 0) _size(f.size),
      ].join(' · ');
    }

    var labels = [for (final f in files) base(f)];
    final differentCuts = files.any((a) => files.any((b) => !sameTimeline(a, b)));
    if (differentCuts) {
      labels = [
        for (var i = 0; i < files.length; i++)
          (files[i].durationInMilliseconds ?? 0) > 0
              ? '${labels[i]} · ${_duration(files[i].durationInMilliseconds!)}'
              : labels[i],
      ];
    }
    if (labels.toSet().length < labels.length) {
      labels = [
        for (var i = 0; i < files.length; i++)
          [labels[i], ?formatOf(files[i])].where((p) => p.isNotEmpty).join(' · '),
      ];
    }
    final seen = <String, int>{};
    return [
      for (final label in labels)
        labels.where((l) => l == label).length > 1
            ? '$label (${seen[label] = (seen[label] ?? 0) + 1})'
            : label,
    ];
  }
}
