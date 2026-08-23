import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AddServerPage.dart';
import 'package:player/utils/ServerStore.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key, this.hasServers});

  /// Set to whether the list is non-empty whenever it is known, so the
  /// owning page can show or hide its add-server FAB.
  final ValueNotifier<bool>? hasServers;

  @override
  State<ServerList> createState() => ServerListState();
}

class ServerListState extends State<ServerList> {
  /// The web build auto-adds its hosting origin; widget tests compile with
  /// kIsWeb=false, so they override these to exercise that path.
  @visibleForTesting
  static bool debugIsWeb = kIsWeb;
  @visibleForTesting
  static String Function() debugWebHost = () => Uri.base.host;

  final SharedPreferencesAsync _sharedPreferencesAsync =
      SharedPreferencesAsync();
  late Future<List<String>> _servers;

  /// Per-server probe generation: bumping one re-runs only that card's
  /// well-known fetch (the card's FutureBuilder is keyed on it).
  final Map<String, int> _refreshTokens = {};
  int _refreshAll = 0;

  void refresh() => setState(() {
        _refreshAll++;
      });

  Future<void> refreshAsync() async {
    refresh();
    // The cards fetch on their own; give the skeletons a beat so the
    // pull-to-refresh indicator doesn't snap away instantly.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  void _report(bool hasServers) {
    final notifier = widget.hasServers;
    if (notifier == null || notifier.value == hasServers) return;
    // Mid-build: defer the notification so the listener rebuilds cleanly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) notifier.value = hasServers;
    });
  }

  void _retry(String server) => setState(() {
        _refreshTokens[server] = (_refreshTokens[server] ?? 0) + 1;
      });

  Future<void> _confirmDelete(String server, String displayName) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.removeServerTitle(displayName)),
        content: Text(loc.removeServerBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.removeServer),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _servers = ServerStore.remove(server);
    });
  }

  void _openAddServer({bool firstRun = false}) {
    AutoRouter.of(context).push(AddServerRoute(firstRun: firstRun));
  }

  @override
  void initState() {
    super.initState();
    if (ClientManager.instance.lastClientUsed != null) {
      goToServerRoute(ClientManager.instance.lastClientUsed!);
    }

    _servers = ServerStore.list().then(
      (servers) async {
        if (debugIsWeb && servers.isEmpty && ClientManager.instance.lastClientUsed == null) {
          final host = debugWebHost();
          // Only auto-add the hosting origin when it actually serves an Ister
          // well-known; a plain static host (e.g. player.ister.app) should
          // leave the list empty.
          if (await WellKnownService.fetch(host) != null) {
            servers.add(host);
            await _sharedPreferencesAsync.setStringList(ServerStore.key, servers);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) goToServerRoute(host);
            });
          }
        }
        return servers;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return FutureBuilder<List<String>>(
      future: _servers,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(loc.error(snapshot.error!)));
            }
            final servers = snapshot.data ?? const [];
            _report(servers.isNotEmpty);
            if (servers.isEmpty) return _welcome(context);
            return RefreshIndicator(
              onRefresh: refreshAsync,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          for (final server in servers)
                            _ServerCard(
                              key: ValueKey(
                                  '$server-$_refreshAll-${_refreshTokens[server] ?? 0}'),
                              server: server,
                              onOpen: () => goToServerRoute(server),
                              onRetry: () => _retry(server),
                              onRemove: (name) => _confirmDelete(server, name),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  /// First run: no servers yet. The whole screen is the invitation.
  Widget _welcome(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_outline,
                  size: 96, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(loc.welcomeTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(loc.welcomeBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 32),
              FilledButton.icon(
                autofocus: true,
                onPressed: () => _openAddServer(firstRun: true),
                icon: const Icon(Icons.add),
                label: Text(loc.addServerTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goToServerRoute(String serverName) async {
    if (!mounted) return;
    // Route through the setter so the in-memory value stays in sync too.
    ClientManager.instance.lastClientUsed = serverName;
    AutoRouter.of(context).replace(ServerHomeRoute(serverName: serverName));
  }
}

enum _ServerAction { open, retry, downloads, remove }

/// One server on the overview: probes its well-known on build (skeleton
/// while pending) and shows name, address and a status chip. Unreachable
/// servers stay tappable — the server page offers the offline downloads.
class _ServerCard extends StatelessWidget {
  const _ServerCard({
    super.key,
    required this.server,
    required this.onOpen,
    required this.onRetry,
    required this.onRemove,
  });

  final String server;
  final VoidCallback onOpen;
  final VoidCallback onRetry;
  final void Function(String displayName) onRemove;

  bool _hasDownloads() {
    if (kIsWeb) return false;
    return DownloadService.instance
        .entriesFor(server)
        .any((e) => e.isComplete);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return FutureBuilder<WellKnownInfo?>(
      future: WellKnownService.fetch(server),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Text('·')),
                title: Text(BoneMock.name),
                subtitle: Text(BoneMock.words(3)),
              ),
            ),
          );
        }

        final info = snapshot.data;
        final reachable = info != null;
        final name = info?.name ?? server;
        final colors = Theme.of(context).colorScheme;
        final muted = TextStyle(color: Theme.of(context).disabledColor);
        final offline = !reachable && _hasDownloads();

        return TvFocusable(
          onTap: onOpen,
          onLongPress: () => onRemove(name),
          child: Card(
            child: ListTile(
              leading: ServerAvatar(name: name, muted: !reachable),
              title: Text(name, style: reachable ? null : muted),
              // Without well-known info the title already is the address.
              subtitle: info == null ? null : Text(info.serverUrl),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusChip(
                    label: reachable
                        ? loc.statusConnected
                        : offline
                            ? loc.statusOfflineAvailable
                            : loc.statusUnreachable,
                    icon: reachable
                        ? Icons.check_circle
                        : offline
                            ? Icons.download_done
                            : Icons.cloud_off,
                    color: reachable
                        ? colors.primary
                        : offline
                            ? colors.tertiary
                            : colors.outline,
                  ),
                  PopupMenuButton<_ServerAction>(
                    tooltip: MaterialLocalizations.of(context).showMenuTooltip,
                    onSelected: (action) {
                      switch (action) {
                        case _ServerAction.open:
                          onOpen();
                        case _ServerAction.retry:
                          onRetry();
                        case _ServerAction.downloads:
                          context.router.root
                              .push(DownloadsRoute(serverName: server));
                        case _ServerAction.remove:
                          onRemove(name);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _ServerAction.open,
                        child: ListTile(
                          leading: const Icon(Icons.arrow_forward),
                          title: Text(loc.open),
                        ),
                      ),
                      PopupMenuItem(
                        value: _ServerAction.retry,
                        child: ListTile(
                          leading: const Icon(Icons.refresh),
                          title: Text(loc.retry),
                        ),
                      ),
                      if (!kIsWeb)
                        PopupMenuItem(
                          value: _ServerAction.downloads,
                          child: ListTile(
                            leading: const Icon(Icons.download),
                            title: Text(loc.downloads),
                          ),
                        ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: _ServerAction.remove,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline,
                              color: colors.error),
                          title: Text(loc.removeServer,
                              style: TextStyle(color: colors.error)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: onOpen,
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(
      {required this.label, required this.icon, required this.color});

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color)),
        ],
      ),
    );
  }
}
