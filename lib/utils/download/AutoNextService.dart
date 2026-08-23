import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/seasonById.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/download/AutoNextPreferences.dart';
import 'package:player/utils/download/DownloadLoaders.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/NextUnwatched.dart';

/// What one run did, for the UI's feedback.
class AutoNextRunResult {
  const AutoNextRunResult({
    this.following = true,
    this.queued = 0,
    this.removed = 0,
    this.skipped = false,
    this.failed = false,
  });

  /// The show is not followed (any more); nothing was touched.
  final bool following;

  /// Episodes newly queued for download.
  final int queued;

  /// Watched episodes whose download was dropped again.
  final int removed;

  /// Another run for this show was in progress; this one was merged into it.
  final bool skipped;

  /// The server could not be reached; the follow stays and is retried later.
  final bool failed;
}

/// Keeps a followed show's next unwatched episodes on the device: whenever an
/// episode is watched its download is dropped and the next unwatched one is
/// fetched, so the user always has N episodes ahead.
///
/// The follows themselves live in [AutoNextPreferences] (device-local, per
/// server); the downloads it enqueues carry [DownloadEntry.autoNext] so a run
/// only ever removes what it added itself — a manually downloaded episode is
/// never deleted by this.
class AutoNextService {
  AutoNextService({DownloadService? downloads}) : _downloads = downloads;

  static AutoNextService instance = AutoNextService();

  final DownloadService? _downloads;
  DownloadService get downloads => _downloads ?? DownloadService.instance;

  /// Test seam: the client a run queries the show with.
  @visibleForTesting
  GraphQLClient Function(String serverName)? clientBuilder;

  final Map<String, Timer> _debounce = {};
  final Set<String> _running = {};
  final Set<String> _rerun = {};

  static String _key(String server, String showId) => '$server|$showId';

  /// Starts following [showId]: keeps [count] unwatched episodes downloaded.
  /// Runs right away so the first episodes start downloading.
  Future<AutoNextRunResult> follow(String server, String showId,
      {required String title, required int count}) async {
    await AutoNextPreferences.set(server,
        AutoNextFollow(showId: showId, title: title, count: count));
    return run(server, showId);
  }

  /// Stops following [showId]. Files already on the device stay — they were
  /// downloaded to be watched; only the automatic top-up ends.
  Future<void> unfollow(String server, String showId) =>
      AutoNextPreferences.remove(server, showId);

  Future<AutoNextFollow?> followFor(String server, String showId) =>
      AutoNextPreferences.get(server, showId);

  /// Schedules a run shortly, coalescing bursts. The default delay leaves the
  /// server time to record the watch status of the episode that just ended —
  /// the progress update is still in flight when playback advances.
  void schedule(String server, String showId,
      {Duration delay = const Duration(seconds: 20)}) {
    if (kIsWeb) return;
    final key = _key(server, showId);
    _debounce[key]?.cancel();
    _debounce[key] = Timer(delay, () => unawaited(run(server, showId)));
  }

  /// Runs every follow of [server] (app start, server connect, downloads page).
  Future<void> runAll(String server) async {
    if (kIsWeb) return;
    for (final showId in (await AutoNextPreferences.all(server)).keys) {
      await run(server, showId);
    }
  }

  /// Brings [showId]'s downloads in line with its follow now. Serialized per
  /// show; a call during a run queues one more run.
  Future<AutoNextRunResult> run(String server, String showId) async {
    if (kIsWeb) return const AutoNextRunResult(following: false);
    final key = _key(server, showId);
    if (_running.contains(key)) {
      _rerun.add(key);
      return const AutoNextRunResult(skipped: true);
    }
    _running.add(key);
    try {
      final follow = await AutoNextPreferences.get(server, showId);
      if (follow == null) return const AutoNextRunResult(following: false);
      final GraphQLClient client;
      try {
        client = clientBuilder?.call(server) ??
            ClientManager.getClientForUrl(server).value;
      } catch (e) {
        LoggerService().logger.w('auto-next has no client for $server: $e');
        return const AutoNextRunResult(failed: true);
      }
      final ShowEpisodes show;
      try {
        // Fresh watch status: a cached one is exactly the state this run is
        // supposed to react to a change in.
        show = await DownloadLoaders.showEpisodes(client, showId,
            fetchPolicy: FetchPolicy.networkOnly);
      } catch (e) {
        LoggerService().logger.w('auto-next could not load $showId: $e');
        return const AutoNextRunResult(failed: true);
      }
      await downloads.ensureStarted();
      await downloads.store.load(server);

      final picked = NextUnwatched.select(show.episodes, follow.count);
      final pickedIds = {for (final e in picked) e.id};
      // The snapshot a download stores is the full episode fragment, which
      // the season query does not carry (no season/cast/rating) — so the
      // picked episodes are fetched the same way the show page fetches them.
      final requests = <DownloadRequest>[];
      var queued = 0;
      for (final e in picked) {
        if (downloads.entryFor(
                server, DownloadEntry.keyFor(DownloadKind.episode, e.id)) ==
            null) {
          queued++;
        }
        requests.addAll(await DownloadLoaders.episode(client, e.id,
            groupTitle: show.title,
            seasonNumber: show.seasonNumbers[e.id],
            autoNext: true));
      }
      if (requests.isNotEmpty) await downloads.enqueueAll(server, requests);

      // Watched episodes this feature downloaded have served their purpose.
      final watched = {
        for (final e in show.episodes)
          if (_watched(e)) e.id
      };
      var removed = 0;
      for (final entry in downloads.entriesFor(server)) {
        if (entry.kind != DownloadKind.episode ||
            !entry.autoNext ||
            entry.groupId != showId) {
          continue;
        }
        if (pickedIds.contains(entry.mediaId)) continue;
        if (!watched.contains(entry.mediaId)) continue;
        await downloads.remove(server, entry.key);
        removed++;
      }
      return AutoNextRunResult(queued: queued, removed: removed);
    } catch (e) {
      LoggerService().logger.w('auto-next run failed for $showId: $e');
      return const AutoNextRunResult(failed: true);
    } finally {
      _running.remove(key);
      if (_rerun.remove(key)) unawaited(run(server, showId));
    }
  }

  static bool _watched(Query$seasonById$seasonById$episodes e) =>
      e.watchStatus?.any((w) => w.watched) ?? false;

  @visibleForTesting
  void resetForTest() {
    for (final t in _debounce.values) {
      t.cancel();
    }
    _debounce.clear();
    _running.clear();
    _rerun.clear();
  }
}
