import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';

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
  subtitles,
  searchIndex,
  other,
}

/// One step of work on the activity screen: a processing item or a transcode
/// pass, reduced to what the tile shows.
class ActivityEntry {
  final String nodeName;
  final ActivityKind kind;

  /// What is being worked on (file name, episode code); null when the server
  /// reported no subject — the tile then shows the kind label instead.
  final String? subject;

  /// The sub-step or, for transcodes, the quality; null when unknown.
  final String? detail;
  final DateTime? startedAt;
  final bool background;

  /// The AMQP queue the work came from; null for transcode passes.
  final String? queue;

  const ActivityEntry({
    required this.nodeName,
    required this.kind,
    required this.subject,
    required this.detail,
    required this.startedAt,
    this.background = false,
    this.queue,
  });
}

/// Every step that belongs to one thing (a show, a movie, an album, a
/// library sweep), so the screen can show "Seinfeld" once with the files and
/// steps under it instead of a flat list of look-alike rows.
class ActivityGroup {
  final String key;

  /// Server token for the kind of thing ("show", "movie", ...); null for the
  /// fallback group of work that reported no context.
  final String? contextType;
  final String title;
  final Set<String> directories;
  final Set<String> libraries;
  final List<ActivityEntry> entries;

  /// True for the catch-all group of one kind of work whose items reported no
  /// context at all; its title is the kind label, so rows show the raw queue
  /// rather than repeating it.
  final bool isKindFallback;

  const ActivityGroup({
    required this.key,
    required this.contextType,
    required this.title,
    required this.directories,
    required this.libraries,
    required this.entries,
    this.isKindFallback = false,
  });

  DateTime? get startedAt {
    DateTime? earliest;
    for (final entry in entries) {
      final at = entry.startedAt;
      if (at != null && (earliest == null || at.isBefore(earliest))) {
        earliest = at;
      }
    }
    return earliest;
  }
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
    'MetadataBackfillRequested': ActivityKind.analyzeLibrary,
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
    'SubtitleExtractRequested': ActivityKind.subtitles,
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
      case ActivityKind.subtitles:
        return Icons.subtitles_outlined;
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
      case ActivityKind.subtitles:
        return loc.activityKindSubtitles;
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
      case ActivityKind.subtitles:
        return loc.activityQueuedSubtitles(depth);
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
      case 'upload':
        return loc.activityStepUpload;
      default:
        return null;
    }
  }

  /// Icon for the thing a group is about; unknown tokens (a newer server) get
  /// a neutral icon.
  static IconData contextIcon(String? contextType) {
    switch (contextType) {
      case 'show':
        return Icons.tv_outlined;
      case 'movie':
        return Icons.movie_outlined;
      case 'album':
        return Icons.album_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'podcast':
        return Icons.podcasts;
      case 'person':
        return Icons.person_outline;
      case 'library':
        return Icons.folder_outlined;
      default:
        return Icons.work_outline;
    }
  }

  /// Bundles in-flight work and transcode passes by the thing they belong to.
  /// The key is the server's contextType + contextId; work without a context
  /// falls back to its context title, and work with neither is collected per
  /// kind ("Refreshing metadata"). Groups come oldest-first, entries too, so
  /// the row that has been running longest stays at the top.
  static List<ActivityGroup> groupActivity(
    AppLocalizations loc,
    Iterable<Fragment$fragmentServerActivityEvent> nodes,
    Iterable<Fragment$fragmentTranscodePass> transcodes,
  ) {
    final groups = <String, _GroupBuilder>{};

    _GroupBuilder builderFor({
      required String? contextType,
      required String? contextId,
      required String? context,
      required ActivityKind kind,
    }) {
      final String key;
      final String title;
      var fallback = false;
      if (contextType != null && contextId != null) {
        key = '$contextType:$contextId';
        title = context ?? contextType;
      } else if (context != null) {
        key = 'context:$context';
        title = context;
      } else {
        key = 'kind:${kind.name}';
        title = labelFor(loc, kind);
        fallback = true;
      }
      return groups.putIfAbsent(
          key,
          () => _GroupBuilder(
              key: key,
              contextType:
                  contextType != null && contextId != null ? contextType : null,
              title: title,
              isKindFallback: fallback));
    }

    for (final node in nodes) {
      for (final item in node.processing ??
          const <Fragment$fragmentServerActivityEvent$processing>[]) {
        final kind = kindFor(item.queue);
        final builder = builderFor(
          contextType: item.contextType,
          contextId: item.contextId,
          context: item.context,
          kind: kind,
        );
        if (item.directory != null) builder.directories.add(item.directory!);
        if (item.$library != null) builder.libraries.add(item.$library!);
        builder.entries.add(ActivityEntry(
          nodeName: node.nodeName,
          kind: kind,
          subject: item.subject,
          detail: stepLabel(loc, item.step),
          startedAt: parseInstant(item.startedAt),
          queue: item.queue,
        ));
      }
    }
    for (final pass in transcodes) {
      final builder = builderFor(
        contextType: pass.contextType,
        contextId: pass.contextId,
        context: pass.context,
        kind: ActivityKind.transcode,
      );
      builder.entries.add(ActivityEntry(
        nodeName: pass.nodeName,
        kind: ActivityKind.transcode,
        subject: pass.title,
        detail: '${loc.transcodesTag} · ${qualityLabel(pass.quality)}',
        startedAt: parseInstant(pass.startedAt),
        background: pass.background,
      ));
    }

    final result = groups.values.map((b) => b.build()).toList();
    int byStart(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    }
    for (final group in result) {
      group.entries.sort((a, b) => byStart(a.startedAt, b.startedAt));
    }
    result.sort((a, b) {
      final order = byStart(a.startedAt, b.startedAt);
      return order != 0 ? order : a.title.compareTo(b.title);
    });
    return result;
  }

  /// "1.2 TB" / "512 GB" / "3.4 MB" — decimal units, the way disk vendors and
  /// `df -H` count.
  static String formatBytes(double bytes) {
    const units = ['B', 'kB', 'MB', 'GB', 'TB', 'PB'];
    var value = bytes < 0 ? 0.0 : bytes;
    var unit = 0;
    while (value >= 1000 && unit < units.length - 1) {
      value /= 1000;
      unit++;
    }
    final text = unit == 0
        ? value.toStringAsFixed(0)
        : value >= 100
            ? value.toStringAsFixed(0)
            : value.toStringAsFixed(1);
    return '$text ${units[unit]}';
  }

  /// Coarse uptime: "3d 4h", "5h 12m", "42m".
  static String formatUptime(DateTime since, DateTime now) {
    var elapsed = now.difference(since);
    if (elapsed.isNegative) elapsed = Duration.zero;
    if (elapsed.inDays >= 1) {
      return '${elapsed.inDays}d ${elapsed.inHours % 24}h';
    }
    if (elapsed.inHours >= 1) {
      return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m';
    }
    return '${elapsed.inMinutes}m';
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

class _GroupBuilder {
  final String key;
  final String? contextType;
  final String title;
  final bool isKindFallback;
  final Set<String> directories = {};
  final Set<String> libraries = {};
  final List<ActivityEntry> entries = [];

  _GroupBuilder({
    required this.key,
    required this.contextType,
    required this.title,
    required this.isKindFallback,
  });

  ActivityGroup build() => ActivityGroup(
        key: key,
        contextType: contextType,
        title: title,
        directories: directories,
        libraries: libraries,
        entries: entries,
        isKindFallback: isKindFallback,
      );
}
