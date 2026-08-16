import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// What broad kind of work a queue/event represents, so the activity screen can
/// show a human label and icon instead of raw AMQP queue names.
enum ActivityKind {
  analyzeFile,
  scan,
  analyzeLibrary,
  metadata,
  importFiles,
  artwork,
  transcode,
  podcast,
  continueWatching,
  segments,
  searchIndex,
  other,
}

/// Pure presentation helpers for the server-activity screen. Kept free of
/// widgets/state so they are trivially unit-testable.
class ServerActivityPresentation {
  ServerActivityPresentation._();

  /// A node whose snapshot timestamp is older than this is considered stale
  /// (the server heartbeats unchanged snapshots every 60s).
  static const staleAfter = Duration(minutes: 3);

  static const _queuePrefix = 'app.ister.server.';

  // Queue base name (MessageQueue constants server-side) -> kind. Per-directory
  // queues get a suffix (app.ister.server.MediaFileFound.disk1), stripped in
  // [kindFor]. Unknown names map to [ActivityKind.other] so new server queues
  // never break older players.
  static const Map<String, ActivityKind> _kinds = {
    'MediaFileFound': ActivityKind.analyzeFile,
    'FileScanRequested': ActivityKind.scan,
    'NewDirectoriesScanRequested': ActivityKind.scan,
    'AnalyzeLibraryRequested': ActivityKind.analyzeLibrary,
    'AnalyzeData': ActivityKind.analyzeLibrary,
    'ShowFound': ActivityKind.metadata,
    'MovieFound': ActivityKind.metadata,
    'EpisodeFound': ActivityKind.metadata,
    'PersonFound': ActivityKind.metadata,
    'AlbumFound': ActivityKind.metadata,
    'TrackFound': ActivityKind.metadata,
    'BookFound': ActivityKind.metadata,
    'ChapterFound': ActivityKind.metadata,
    'ComicSeriesFound': ActivityKind.metadata,
    'NfoFileFound': ActivityKind.metadata,
    'AudioFileFound': ActivityKind.importFiles,
    'EpubFileFound': ActivityKind.importFiles,
    'ComicFileFound': ActivityKind.importFiles,
    'SubtitleFileFound': ActivityKind.importFiles,
    'ImageFound': ActivityKind.artwork,
    'UpdateImagesRequested': ActivityKind.artwork,
    'TranscodeRequested': ActivityKind.transcode,
    'TranscodePassRequested': ActivityKind.transcode,
    'PreTranscodeRecentlyWatched': ActivityKind.transcode,
    'PodcastFound': ActivityKind.podcast,
    'PodcastEpisodeFound': ActivityKind.podcast,
    'PodcastRefreshRequested': ActivityKind.podcast,
    'PodcastEpisodeDownloadRequested': ActivityKind.podcast,
    'ContinueWatchingRebuildRequested': ActivityKind.continueWatching,
    'DetectSegments': ActivityKind.segments,
    'SearchIndexRequested': ActivityKind.searchIndex,
    'SearchReindexRequested': ActivityKind.searchIndex,
  };

  static ActivityKind kindFor(String queue) {
    var name = queue;
    if (name.startsWith(_queuePrefix)) {
      name = name.substring(_queuePrefix.length);
    }
    final dot = name.indexOf('.');
    if (dot > 0) name = name.substring(0, dot);
    return _kinds[name] ?? ActivityKind.other;
  }

  static IconData iconFor(ActivityKind kind) {
    switch (kind) {
      case ActivityKind.analyzeFile:
        return Icons.troubleshoot;
      case ActivityKind.scan:
        return Icons.folder_open;
      case ActivityKind.analyzeLibrary:
        return Icons.video_library_outlined;
      case ActivityKind.metadata:
        return Icons.description_outlined;
      case ActivityKind.importFiles:
        return Icons.note_add_outlined;
      case ActivityKind.artwork:
        return Icons.image_outlined;
      case ActivityKind.transcode:
        return Icons.speed;
      case ActivityKind.podcast:
        return Icons.podcasts;
      case ActivityKind.continueWatching:
        return Icons.play_circle_outline;
      case ActivityKind.segments:
        return Icons.skip_next_outlined;
      case ActivityKind.searchIndex:
        return Icons.search;
      case ActivityKind.other:
        return Icons.settings_outlined;
    }
  }

  /// Human label for a kind ("Analyzing media file").
  static String labelFor(AppLocalizations loc, ActivityKind kind) {
    switch (kind) {
      case ActivityKind.analyzeFile:
        return loc.activityKindAnalyzeFile;
      case ActivityKind.scan:
        return loc.activityKindScan;
      case ActivityKind.analyzeLibrary:
        return loc.activityKindAnalyzeLibrary;
      case ActivityKind.metadata:
        return loc.activityKindMetadata;
      case ActivityKind.importFiles:
        return loc.activityKindImportFiles;
      case ActivityKind.artwork:
        return loc.activityKindArtwork;
      case ActivityKind.transcode:
        return loc.activityKindTranscode;
      case ActivityKind.podcast:
        return loc.activityKindPodcast;
      case ActivityKind.continueWatching:
        return loc.activityKindContinueWatching;
      case ActivityKind.segments:
        return loc.activityKindSegments;
      case ActivityKind.searchIndex:
        return loc.activityKindSearchIndex;
      case ActivityKind.other:
        return loc.activityKindOther;
    }
  }

  /// A queued-work sentence for a kind ("812 files to analyze").
  static String queuedLabelFor(AppLocalizations loc, ActivityKind kind, int depth) {
    switch (kind) {
      case ActivityKind.analyzeFile:
        return loc.activityQueuedAnalyzeFile(depth);
      case ActivityKind.scan:
        return loc.activityQueuedScan(depth);
      case ActivityKind.metadata:
        return loc.activityQueuedMetadata(depth);
      case ActivityKind.artwork:
        return loc.activityQueuedArtwork(depth);
      case ActivityKind.transcode:
        return loc.activityQueuedTranscode(depth);
      case ActivityKind.segments:
        return loc.activityQueuedSegments(depth);
      default:
        return loc.activityQueuedGeneric(depth, labelFor(loc, kind));
    }
  }

  /// Label for a server-reported sub-step token; null for unknown tokens (the
  /// server may add steps this player doesn't know yet).
  static String? stepLabel(AppLocalizations loc, String? step) {
    switch (step) {
      case 'probe':
        return loc.activityStepProbe;
      case 'crop':
        return loc.activityStepCrop;
      case 'subtitles':
        return loc.activityStepSubtitles;
      case 'boundaries':
        return loc.activityStepBoundaries;
      case 'still':
        return loc.activityStepStill;
      case 'fingerprint':
        return loc.activityStepFingerprint;
      case 'match':
        return loc.activityStepMatch;
      case 'transcode':
        return loc.activityStepTranscode;
      default:
        return null;
    }
  }

  /// "video 720p" from the server's quality token "video_720p"/"audio_0_128k".
  static String qualityLabel(String quality) => quality.replaceAll('_', ' ');

  /// Relative time like "12s ago" / "5 min ago" / "3 hrs ago".
  static String formatRelative(AppLocalizations loc, DateTime at, DateTime now) {
    final elapsed = now.difference(at);
    if (elapsed.inSeconds < 60) return loc.relativeSecondsAgo(elapsed.inSeconds < 0 ? 0 : elapsed.inSeconds);
    if (elapsed.inMinutes < 60) return loc.relativeMinutesAgo(elapsed.inMinutes);
    if (elapsed.inHours < 24) return loc.relativeHoursAgo(elapsed.inHours);
    return loc.relativeDaysAgo(elapsed.inDays);
  }

  /// Compact elapsed-time chip text: "42s", "3m", "1u02" style is avoided —
  /// "3m 12s" / "1h 03m" for readability.
  static String formatElapsed(DateTime since, DateTime now) {
    var elapsed = now.difference(since);
    if (elapsed.isNegative) elapsed = Duration.zero;
    if (elapsed.inHours >= 1) {
      final minutes = elapsed.inMinutes % 60;
      return '${elapsed.inHours}h ${minutes.toString().padLeft(2, '0')}m';
    }
    if (elapsed.inMinutes >= 1) {
      final seconds = elapsed.inSeconds % 60;
      return '${elapsed.inMinutes}m ${seconds.toString().padLeft(2, '0')}s';
    }
    return '${elapsed.inSeconds}s';
  }

  static bool isStale(DateTime timestamp, DateTime now) =>
      now.difference(timestamp) > staleAfter;

  /// Parses the server's `String.valueOf(Instant)` timestamps; null on garbage.
  static DateTime? parseInstant(String? value) =>
      value == null ? null : DateTime.tryParse(value);
}
