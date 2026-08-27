import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';

/// What a page offers to download: one item (tracked by [kind]/[mediaId] for
/// its status) whose request(s) are loaded lazily — most pages only hold a
/// summary of the item and fetch the full snapshot when asked.
class DownloadAction {
  const DownloadAction({
    required this.serverName,
    required this.kind,
    required this.mediaId,
    required this.load,
  });

  final String serverName;
  final DownloadKind kind;
  final String mediaId;
  final Future<List<DownloadRequest>> Function(GraphQLClient client) load;

  String get key => DownloadEntry.keyFor(kind, mediaId);
}

/// The context-dependent things a download action needs, resolved up front.
///
/// Every download entry point is a `MenuItemButton`, and `_handleSelect`
/// closes the menu *before* it calls `onPressed`. That deactivates the menu
/// item's element, so a `BuildContext` captured in the callback is already
/// dead by the time the action reads it: `AppLocalizations.of` then throws
/// "Looking up a deactivated widget's ancestor is unsafe" and the download
/// never starts. Build one of these while the widget is still mounted and
/// hand it to the action instead — the resolved objects outlive the element.
class DownloadActionScope {
  const DownloadActionScope({
    required this.loc,
    required this.messenger,
    required this.client,
  });

  /// Call from `build`, never from inside the callback.
  factory DownloadActionScope.of(BuildContext context) => DownloadActionScope(
        loc: AppLocalizations.of(context)!,
        messenger: ScaffoldMessenger.of(context),
        client: GraphQLProvider.of(context),
      );

  final AppLocalizations loc;
  final ScaffoldMessengerState messenger;

  /// The notifier, not its value: the client may still be swapped between
  /// building the menu and picking an item.
  final ValueNotifier<GraphQLClient> client;
}

/// Runs [action]: enqueues when nothing is on disk (or the last attempt
/// failed), removes/cancels otherwise. Reports through a snackbar.
Future<void> runDownloadAction(
    DownloadActionScope scope, DownloadAction action) async {
  final loc = scope.loc;
  final messenger = scope.messenger;
  final service = DownloadService.instance;
  final existing = service.entryFor(action.serverName, action.key);
  if (existing != null && existing.status != DownloadStatus.failed) {
    await service.remove(action.serverName, action.key);
    return;
  }
  if (existing != null) {
    await service.retry(action.serverName, action.key);
    return;
  }
  final client = scope.client.value;
  final List<DownloadRequest> requests;
  try {
    requests = await action.load(client);
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(loc.downloadFailedLocal(e.toString()))));
    return;
  }
  if (requests.isEmpty) {
    messenger.showSnackBar(SnackBar(content: Text(loc.downloadNothingToDownload)));
    return;
  }
  await service.enqueueAll(action.serverName, requests);
  messenger.showSnackBar(
      SnackBar(content: Text(loc.downloadQueued(requests.length))));
}

/// Enqueues a whole group (album, audiobook, "next N episodes") — never
/// toggles, existing entries just become pinned.
Future<void> enqueueDownloads(DownloadActionScope scope, String serverName,
    Future<List<DownloadRequest>> Function(GraphQLClient client) load) async {
  final loc = scope.loc;
  final messenger = scope.messenger;
  final client = scope.client.value;
  final List<DownloadRequest> requests;
  try {
    requests = await load(client);
  } catch (e) {
    messenger.showSnackBar(
        SnackBar(content: Text(loc.downloadFailedLocal(e.toString()))));
    return;
  }
  if (requests.isEmpty) {
    messenger.showSnackBar(SnackBar(content: Text(loc.downloadNothingToDownload)));
    return;
  }
  await DownloadService.instance.enqueueAll(serverName, requests);
  messenger.showSnackBar(
      SnackBar(content: Text(loc.downloadQueued(requests.length))));
}

/// The label/icon for an item's current download state.
(IconData, String) downloadActionPresentation(
    AppLocalizations loc, DownloadEntry? entry) {
  if (entry == null) return (Icons.download_outlined, loc.download);
  switch (entry.status) {
    case DownloadStatus.queued:
    case DownloadStatus.downloading:
    case DownloadStatus.paused:
      return (Icons.close, loc.cancelDownload);
    case DownloadStatus.complete:
      return (Icons.delete_outline, loc.removeDownload);
    case DownloadStatus.failed:
      return (Icons.refresh, loc.retryDownload);
  }
}

/// A `MenuItemButton` for the overflow menus of the detail pages; hidden on
/// web, where nothing can be stored.
class DownloadMenuItem extends StatelessWidget {
  const DownloadMenuItem(
      {super.key, required this.action, this.enabled = true, this.label});

  final DownloadAction action;
  final bool enabled;

  /// Replaces the generic "Download" label while nothing is on disk.
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    // Resolved here, while this element is still mounted: by the time
    // onPressed runs the menu has closed and taken this context with it.
    final scope = DownloadActionScope.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: DownloadService.instance.revision,
      builder: (context, _, __) {
        final entry =
            DownloadService.instance.entryFor(action.serverName, action.key);
        final (icon, text) = downloadActionPresentation(loc, entry);
        return MenuItemButton(
          onPressed: enabled ? () => runDownloadAction(scope, action) : null,
          child: ListTile(
              leading: Icon(icon),
              title: Text(entry == null ? (label ?? text) : text)),
        );
      },
    );
  }
}

/// Small status marker next to a row: a progress ring while downloading, a
/// pin once complete, a warning when failed; nothing otherwise.
class DownloadStatusIcon extends StatelessWidget {
  const DownloadStatusIcon({
    super.key,
    required this.serverName,
    required this.kind,
    required this.mediaId,
    this.size = 18,
  });

  final String serverName;
  final DownloadKind kind;
  final String mediaId;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    final service = DownloadService.instance;
    final key = DownloadEntry.keyFor(kind, mediaId);
    return ValueListenableBuilder<int>(
      valueListenable: service.revision,
      builder: (context, _, __) {
        final entry = service.entryFor(serverName, key);
        if (entry == null) return const SizedBox.shrink();
        final color = Theme.of(context).colorScheme.primary;
        switch (entry.status) {
          case DownloadStatus.complete:
            return Icon(Icons.offline_pin, size: size, color: color);
          case DownloadStatus.failed:
            return Icon(Icons.error_outline,
                size: size, color: Theme.of(context).colorScheme.error);
          case DownloadStatus.queued:
          case DownloadStatus.paused:
            return Icon(Icons.schedule, size: size, color: color);
          case DownloadStatus.downloading:
            return ValueListenableBuilder<DownloadProgress?>(
              valueListenable: service.progressOf(serverName, key),
              builder: (context, p, __) => SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                    strokeWidth: 2, value: p?.fraction ?? entry.progress),
              ),
            );
        }
      },
    );
  }
}

/// Asks how many of the next episodes to download; null when dismissed.
Future<int?> showDownloadNextDialog(BuildContext context,
    {required int defaultCount}) {
  final loc = AppLocalizations.of(context)!;
  final controller = TextEditingController(text: '$defaultCount');
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.downloadNextDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: loc.downloadNextDialogHint),
            onSubmitted: (v) => Navigator.of(context).pop(int.tryParse(v)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final n in const [3, 5, 10])
                TvFocusable(
                  onTap: () => Navigator.of(context).pop(n),
                  child: ChoiceChip(
                    label: Text('$n'),
                    selected: false,
                    onSelected: (_) => Navigator.of(context).pop(n),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(int.tryParse(controller.text)),
          child: Text(loc.download),
        ),
      ],
    ),
  );
}
