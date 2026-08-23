import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/components/download/DownloadMenuItem.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/EpisodeParts.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/LocalPlayQueue.dart';
import 'package:player/utils/download/OfflineProgressStore.dart';
import 'package:player/utils/download/OfflineSyncService.dart';

String formatBytes(int bytes) {
  const units = ['B', 'kB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1000 && unit < units.length - 1) {
    value /= 1000;
    unit++;
  }
  final digits = unit == 0 ? 0 : (value < 10 ? 1 : 0);
  return '${value.toStringAsFixed(digits)} ${units[unit]}';
}

/// Everything downloaded for one server, grouped the way it was browsed
/// (album, show, podcast, audiobook, movie), playable without the server.
/// Lives on the root router so it renders when the server shell cannot.
@RoutePage()
class DownloadsPage extends StatefulWidget {
  const DownloadsPage({
    super.key,
    @PathParam('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _Group {
  _Group(this.kind, this.id, this.title);
  final DownloadKind kind;
  final String id;
  final String title;
  final List<DownloadEntry> entries = [];

  int get bytes => sumUniqueBytes(entries);
  bool get playable => entries.any((e) => e.isComplete && !e.isReading);
  DateTime get newest => entries
      .map((e) => e.createdAt)
      .reduce((a, b) => a.isAfter(b) ? a : b);
}

class _DownloadsPageState extends State<DownloadsPage> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = DownloadService.instance;
    await service.ensureStarted();
    await service.store.load(widget.serverName);
    await OfflineProgressStore.instance.load(widget.serverName);
    if (mounted) setState(() => _ready = true);
  }

  List<_Group> _groups(List<DownloadEntry> entries) {
    final map = <String, _Group>{};
    for (final e in entries) {
      // A book's chapters and its epub/comic files form one group.
      final key = e.kind == DownloadKind.chapter || e.kind == DownloadKind.book
          ? 'book:${e.groupId}'
          : '${e.kind.name}:${e.groupId}';
      map.putIfAbsent(key, () => _Group(e.kind, e.groupId, e.groupTitle))
          .entries
          .add(e);
    }
    final groups = map.values.toList()
      ..sort((a, b) => b.newest.compareTo(a.newest));
    for (final g in groups) {
      g.entries.sort((a, b) => a.sortKey.compareTo(b.sortKey));
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final service = DownloadService.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.downloads),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: service.paused,
            builder: (context, paused, _) => IconButton(
              icon: Icon(paused ? Icons.play_arrow : Icons.pause),
              tooltip: paused ? loc.resumeAllDownloads : loc.pauseAllDownloads,
              onPressed: () =>
                  paused ? service.resumeAll() : service.pauseAll(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: loc.syncOfflineProgress,
            onPressed: () => _sync(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: loc.downloadSettings,
            onPressed: () => AutoRouter.of(context)
                .push(DownloadSettingsRoute(serverName: widget.serverName)),
          ),
        ],
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<int>(
              valueListenable: service.revision,
              builder: (context, _, __) {
                final entries = service.entriesFor(widget.serverName);
                if (entries.isEmpty) return _empty(context);
                final groups = _groups(entries);
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _summary(context, entries),
                    const SizedBox(height: 8),
                    for (final g in groups) _groupTile(context, g),
                  ],
                );
              },
            ),
    );
  }

  Widget _empty(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_for_offline_outlined,
                size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text(loc.noDownloadsYet,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(loc.noDownloadsHint, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _summary(BuildContext context, List<DownloadEntry> entries) {
    final loc = AppLocalizations.of(context)!;
    final total = sumUniqueBytes(entries);
    final active = entries.where((e) => e.isActive).length;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.storage_outlined),
        title: Text(loc.storageUsed(formatBytes(total))),
        subtitle: Text([
          loc.downloadItemsCount(entries.length),
          if (active > 0) '${loc.downloadStatusDownloading}: $active',
        ].join(' · ')),
      ),
    );
  }

  Widget _groupTile(BuildContext context, _Group g) {
    final loc = AppLocalizations.of(context)!;
    final service = DownloadService.instance;
    final first = g.entries.firstWhere((e) => e.artworkFile != null,
        orElse: () => g.entries.first);
    final art = service.localArtworkFor(widget.serverName, first.mediaFileId);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: SizedBox(
          width: 48,
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: art != null && File(art).existsSync()
                ? Image.file(File(art), fit: BoxFit.cover)
                : ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(_kindIcon(g.kind)),
                  ),
          ),
        ),
        title: Text(g.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
            '${loc.downloadItemsCount(g.entries.length)} · ${formatBytes(g.bytes)}'),
        trailing: g.playable
            ? TvFocusable(
                onTap: () => _play(context, g, g.entries.firstWhere((e) => e.isComplete)),
                child: IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  tooltip: loc.playOffline,
                  onPressed: () => _play(
                      context, g, g.entries.firstWhere((e) => e.isComplete)),
                ),
              )
            : null,
        children: [for (final e in g.entries) _entryTile(context, g, e)],
      ),
    );
  }

  Widget _entryTile(BuildContext context, _Group g, DownloadEntry e) {
    final loc = AppLocalizations.of(context)!;
    final service = DownloadService.instance;
    final status = switch (e.status) {
      DownloadStatus.queued => loc.downloadStatusQueued,
      DownloadStatus.paused => loc.downloadStatusQueued,
      DownloadStatus.downloading => loc.downloadStatusDownloading,
      DownloadStatus.complete => null,
      DownloadStatus.failed => e.error == 'no-space'
          ? loc.downloadNoSpace
          : loc.downloadFailedLocal(e.error ?? ''),
    };
    final progress = OfflineProgressStore.instance.get(widget.serverName, e.key);
    if (e.isReading) return _readingTile(context, e);
    final shared = e.kind == DownloadKind.episode
        ? EpisodeParts.sharedNumbers(e.queueItem.episode?.mediaFile?.firstOrNull
            ?.episodes
            ?.map((x) => x.number))
        : null;
    final parts = [
      if (e.subtitle != null && e.subtitle!.isNotEmpty) e.subtitle!,
      if (shared != null) EpisodeParts.label(loc, shared),
      if (e.durationMs > 0) DurationUtil.format(Duration(milliseconds: e.durationMs)),
      if (e.bytes > 0) formatBytes(e.bytes),
      if (status != null) status,
    ];
    return TvFocusable(
      onTap: e.isComplete
          ? () => _play(context, g, e)
          : e.status == DownloadStatus.failed
              ? () => service.retry(widget.serverName, e.key)
              : null,
      child: ListTile(
        dense: true,
        leading: SizedBox(
          width: 24,
          child: Center(
            child: e.isComplete && progress != null && !progress.finished
                ? Icon(Icons.play_circle_outline,
                    size: 20, color: Theme.of(context).colorScheme.primary)
                : DownloadStatusIcon(
                    serverName: widget.serverName,
                    kind: e.kind,
                    mediaId: e.mediaId,
                    size: 20),
          ),
        ),
        title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(parts.join(' · '),
            maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: MenuAnchor(
          menuChildren: [
            if (e.status == DownloadStatus.failed)
              MenuItemButton(
                onPressed: () => service.retry(widget.serverName, e.key),
                child: ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(loc.retryDownload)),
              ),
            MenuItemButton(
              onPressed: () => service.remove(widget.serverName, e.key),
              child: ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(e.isActive ? loc.cancelDownload : loc.removeDownload)),
            ),
          ],
          builder: (context, controller, _) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
        onTap: e.isComplete
            ? () => _play(context, g, e)
            : e.status == DownloadStatus.failed
                ? () => service.retry(widget.serverName, e.key)
                : null,
      ),
    );
  }

  Widget _readingTile(BuildContext context, DownloadEntry e) {
    final loc = AppLocalizations.of(context)!;
    final service = DownloadService.instance;
    final status = switch (e.status) {
      DownloadStatus.queued || DownloadStatus.paused => loc.downloadStatusQueued,
      DownloadStatus.downloading => loc.downloadStatusDownloading,
      DownloadStatus.complete => null,
      DownloadStatus.failed => e.error == 'no-space'
          ? loc.downloadNoSpace
          : loc.downloadFailedLocal(e.error ?? ''),
    };
    final parts = [
      e.format?.name.toUpperCase() ?? '',
      if (e.mediaOverlays) loc.readAloudEdition,
      if (e.pageCount != null && e.format != BookFormat.epub) '${e.pageCount} p.',
      if (e.bytes > 0) formatBytes(e.bytes),
      if (status != null) status,
    ];
    return TvFocusable(
      onTap: e.isComplete ? () => _read(context, e) : null,
      child: ListTile(
        dense: true,
        leading: SizedBox(
          width: 24,
          child: Center(
            child: DownloadStatusIcon(
                serverName: widget.serverName,
                kind: e.kind,
                mediaId: e.mediaId,
                size: 20),
          ),
        ),
        title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(parts.where((p) => p.isNotEmpty).join(' · '),
            maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: MenuAnchor(
          menuChildren: [
            if (e.status == DownloadStatus.failed)
              MenuItemButton(
                onPressed: () => service.retry(widget.serverName, e.key),
                child: ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(loc.retryDownload)),
              ),
            MenuItemButton(
              onPressed: () => service.remove(widget.serverName, e.key),
              child: ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(e.isActive ? loc.cancelDownload : loc.removeDownload)),
            ),
          ],
          builder: (context, controller, _) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
        onTap: e.isComplete ? () => _read(context, e) : null,
      ),
    );
  }

  void _read(BuildContext context, DownloadEntry e) {
    final PageRouteInfo route = e.format == BookFormat.epub
        ? OfflineReaderRoute(
            serverName: widget.serverName,
            bookId: e.groupId,
            mediaFileId: e.mediaFileId,
            nodeUrl: e.nodeUrl,
            title: e.title)
        : OfflineComicReaderRoute(
            serverName: widget.serverName,
            bookId: e.groupId,
            mediaFileId: e.mediaFileId,
            nodeUrl: e.nodeUrl,
            title: e.title);
    context.router.root.push(route);
  }

  static IconData _kindIcon(DownloadKind kind) => switch (kind) {
        DownloadKind.track => Icons.album_outlined,
        DownloadKind.chapter => Icons.menu_book_outlined,
        DownloadKind.podcastEpisode => Icons.podcasts,
        DownloadKind.movie => Icons.movie_outlined,
        DownloadKind.episode => Icons.tv_outlined,
        DownloadKind.book => Icons.auto_stories_outlined,
      };

  Future<void> _play(BuildContext context, _Group g, DownloadEntry start) async {
    final server = widget.serverName;
    final pq = LocalPlayQueue.build(server, g.entries,
        startKey: start.key, progress: OfflineProgressStore.instance);
    if (pq.playQueueItems?.isEmpty ?? true) return;
    final isVideo =
        start.kind == DownloadKind.movie || start.kind == DownloadKind.episode;
    int? startMs;
    final local = OfflineProgressStore.instance.get(server, start.key);
    if (isVideo) {
      final item = start.queueItem;
      // An episode inside a multi-episode file lives in [startMs, endMs) of
      // the file; positions outside its slice belong to a sibling.
      final part = EpisodeParts.bounds(item.episode);
      bool inSlice(int ms) =>
          part == null || (ms >= part.startMs && ms < part.endMs);
      if (local != null && !local.finished && inSlice(local.positionMs)) {
        startMs = local.positionMs;
      } else {
        final movieWs = item.movie?.watchStatus?.firstOrNull;
        final episodeWs = item.episode?.watchStatus?.firstOrNull;
        if (movieWs != null && !movieWs.watched) {
          startMs = movieWs.progressInMilliseconds;
        } else if (episodeWs != null &&
            !episodeWs.watched &&
            inSlice(episodeWs.progressInMilliseconds)) {
          startMs = episodeWs.progressInMilliseconds;
        } else {
          startMs = part?.startMs;
        }
      }
    }
    if (isVideo) {
      await AutoRouter.of(context).push(LocalVideoRoute(serverName: server));
    }
    await MediaPlayerHandler.instance.startLocalPlayQueue(server, pq,
        startItemId: pq.currentItemId, startTimeMs: startMs, openPlayer: !isVideo);
  }

  Future<void> _sync(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final n = await OfflineSyncService.trySync(widget.serverName, force: true);
    messenger.showSnackBar(SnackBar(content: Text(loc.offlineProgressSynced(n))));
  }
}
