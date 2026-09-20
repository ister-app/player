import 'package:player/graphql/fragmentEpisode.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

/// Episodes that share one media file (s04e06-e07.mkv): each episode is a
/// slice of the file, in absolute file time — the same timeline as the
/// player position and the server's progress.
class EpisodeParts {
  EpisodeParts._();

  /// The slice of [ep] within a multi-episode media file. Null for a normal
  /// single-episode file, and while the server has not computed the slice
  /// boundaries yet (duration 0) — playback then falls back to whole-file
  /// behavior.
  ///
  /// The server sends one part per media file of the episode. [mediaFileId]
  /// names the file that plays (another version of the episode can be sliced
  /// differently, or not be a multi-episode file at all); without it — lists,
  /// tiles, anything that is not the player — the first part.
  static ({int startMs, int endMs})? bounds(Fragment$fragmentEpisode? ep,
      {String? mediaFileId}) {
    final parts = ep?.mediaFileParts;
    final part = mediaFileId == null
        ? parts?.firstOrNull
        : parts?.where((p) => p.mediaFile.id == mediaFileId).firstOrNull;
    if (part == null) return null;
    if ((part.mediaFile.episodes?.length ?? 0) < 2) return null;
    final durationMs = part.durationInMilliseconds.toInt();
    if (durationMs <= 0) return null;
    final startMs = part.startInMilliseconds.toInt();
    return (startMs: startMs, endMs: startMs + durationMs);
  }

  /// Sorted episode numbers of a file shared by two or more episodes; null
  /// when the file holds a single episode.
  static List<int>? sharedNumbers(Iterable<int>? fileEpisodeNumbers) {
    if (fileEpisodeNumbers == null) return null;
    final numbers = fileEpisodeNumbers.toList()..sort();
    return numbers.length < 2 ? null : numbers;
  }

  /// "⧉ E6+E7"
  static String label(AppLocalizations loc, List<int> numbers) =>
      '⧉ ${numbers.map(loc.episodePrefix).join('+')}';
}
