import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/rebuildSearchIndex.graphql.dart';
import 'package:player/graphql/refreshMetadata.graphql.dart';
import 'package:player/graphql/scanLibraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/graphql/serverActivitySubscription.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/ConfirmDialog.dart';
import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';
import '../components/AdminGate.dart';
import '../components/ServerActivityBody.dart';
import '../utils/ClientManager.dart';
import '../utils/LibraryIcons.dart';
import '../utils/LoggerService.dart';
import '../utils/ResilientSubscription.dart';
import '../utils/ServerTaskRunner.dart';

/// Everything about the server in one screen: which server this is and the
/// nodes it runs on (name, url, version from getServerInfo), what those nodes
/// are doing right now, the queued work, recent failures, and — for admins —
/// the maintenance actions.
///
/// The live half is seeded from serverActivitySnapshot and then kept current by
/// merging serverActivity events (NODE_ACTIVITY replaces that node's entry,
/// TRANSCODE_ACTIVITY replaces that node's transcode passes, QUEUE_STATS
/// replaces the whole list, FAILURE is prepended). A 30s ticker keeps the
/// elapsed/relative times moving between events.
@RoutePage()
class ServerSettingsClusterPage extends StatefulWidget {
  final String serverName;

  const ServerSettingsClusterPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ServerSettingsClusterPage> createState() =>
      _ServerSettingsClusterPageState();
}

class _ServerSettingsClusterPageState extends State<ServerSettingsClusterPage> {
  static const int _maxFailures = 100;

  bool _loaded = false;
  String? _error;
  bool _liveFeedBroken = false;
  final Map<String, Fragment$fragmentServerActivityEvent> _nodes = {};
  final Map<String, List<Fragment$fragmentTranscodePass>> _transcodesByNode =
      {};
  List<Fragment$fragmentQueueStat> _queueStats = [];
  List<Fragment$fragmentEventFailure> _failures = [];
  ResilientSubscription? _subscription;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    final client = ClientManager.getClientForUrl(widget.serverName).value;

    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && _loaded) setState(() {});
    });

    _subscription = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionserverActivity,
      onData: (result) {
        if (!mounted) return;
        setState(() {
          _loaded = true;
          _error = null;
          _liveFeedBroken = false;
          _applyEvent(
              Subscription$serverActivity.fromJson(result.data!).serverActivity);
        });
      },
      onFailure: (_) {
        if (!mounted) return;
        setState(() => _liveFeedBroken = true);
      },
    );

    client
        .query(QueryOptions(
            document: documentNodeQueryserverActivitySnapshot,
            fetchPolicy: FetchPolicy.networkOnly))
        .then((result) {
      if (!mounted) return;
      if (result.hasException) {
        LoggerService().logger.e(result.exception);
        setState(() => _error ??= result.exception.toString());
        return;
      }
      final data = result.data;
      if (data == null) return;
      final snapshot =
          Query$serverActivitySnapshot.fromJson(data).serverActivitySnapshot;
      setState(() {
        _loaded = true;
        // Events that already arrived via the subscription are fresher than
        // the snapshot — only fill in what is still missing.
        for (final node in snapshot.nodes) {
          _nodes.putIfAbsent(node.nodeName, () => node);
        }
        final snapshotTranscodes =
            <String, List<Fragment$fragmentTranscodePass>>{};
        for (final pass in snapshot.transcodes) {
          snapshotTranscodes.putIfAbsent(pass.nodeName, () => []).add(pass);
        }
        for (final entry in snapshotTranscodes.entries) {
          _transcodesByNode.putIfAbsent(entry.key, () => entry.value);
        }
        if (_queueStats.isEmpty) _queueStats = snapshot.queueStats;
        if (_failures.isEmpty) _failures = snapshot.recentFailures;
      });
    });
  }

  void _applyEvent(Fragment$fragmentServerActivityEvent event) {
    switch (event.type) {
      case Enum$ServerActivityEventType.NODE_ACTIVITY:
        _nodes[event.nodeName] = event;
        break;
      case Enum$ServerActivityEventType.TRANSCODE_ACTIVITY:
        _transcodesByNode[event.nodeName] = event.transcodes ?? [];
        break;
      case Enum$ServerActivityEventType.QUEUE_STATS:
        _queueStats = event.queueStats ?? _queueStats;
        break;
      case Enum$ServerActivityEventType.FAILURE:
        final failure = event.failure;
        if (failure != null) {
          _failures = [failure, ..._failures.take(_maxFailures - 1)];
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _subscription?.dispose();
    super.dispose();
  }


  /// Picks the library to rebuild, then confirms — the FORCE refresh deletes
  /// that library's stored metadata and artwork before re-fetching everything.
  Future<void> _showRebuildOptions(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(QueryOptions(
      document: documentNodeQuerylibraries,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));

    if (!context.mounted) return;
    final libraries = result.data == null
        ? <Query$libraries$libraries>[]
        : (Query$libraries.fromJson(result.data!).libraries ??
            <Query$libraries$libraries>[]);

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final mutedColor = Theme.of(sheetContext).colorScheme.onSurfaceVariant;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final library in libraries)
                  ListTile(
                    leading:
                        Icon(libraryTypeIcon(library.type), color: mutedColor),
                    title: Text(library.name),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _confirmAndRebuild(context, library);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmAndRebuild(
      BuildContext context, Query$libraries$libraries library) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: loc.rebuildLibraryConfirmTitle,
      body: loc.rebuildLibraryConfirmBody(library.name),
      confirmLabel: loc.rebuildLibraryMetadata,
    );
    if (!confirmed || !context.mounted) return;
    await runServerTask(
      context,
      documentNodeMutationrefreshMetadata,
      library.name,
      variables: {
        'mode': Enum$MetadataRefreshMode.FORCE.name,
        'libraryId': library.id,
      },
    );
  }

  /// The management actions are admin-only; on an older server without permissions
  /// (status unknown) they stay visible, matching what that server enforces.
  Widget _gatedManagementSection(BuildContext context) {
    return AdminGate(
      serverName: widget.serverName,
      showWhenUnknown: true,
      child: _managementSection(context),
    );
  }

  Widget _managementSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return SettingsSection(
      title: loc.management,
      hint: loc.managementHint,
      children: [
        ListTile(
          leading: Icon(Icons.loop, color: mutedColor),
          title: Text(loc.scanLibraries),
          subtitle: Text(loc.scanLibrariesSubtitle),
          onTap: () => runServerTask(
            context,
            documentNodeMutationscanLibraries,
            loc.scanLibraries,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cloud_download_outlined, color: mutedColor),
          title: Text(loc.fetchMissingMetadata),
          subtitle: Text(loc.fetchMissingMetadataSubtitle),
          onTap: () => runServerTask(
            context,
            documentNodeMutationrefreshMetadata,
            loc.fetchMissingMetadata,
            variables: {'mode': Enum$MetadataRefreshMode.MISSING.name},
          ),
        ),
        ListTile(
          leading: Icon(Icons.build_circle_outlined, color: mutedColor),
          title: Text(loc.rebuildLibraryMetadata),
          subtitle: Text(loc.rebuildLibraryMetadataSubtitle),
          trailing: Icon(Icons.chevron_right, color: mutedColor),
          onTap: () => _showRebuildOptions(context),
        ),
        ListTile(
          leading: Icon(Icons.manage_search, color: mutedColor),
          title: Text(loc.rebuildSearchIndex),
          subtitle: Text(loc.rebuildSearchIndexSubtitle),
          onTap: () => runServerTask(
            context,
            documentNodeMutationrebuildSearchIndex,
            loc.rebuildSearchIndex,
          ),
        ),
      ],
    );
  }

  Widget _serverCard(
      BuildContext context, Query$getServerInfoQuery$getServerInfo info) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.dns, size: 32),
        title: Text(
          info.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          info.url,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  /// Shown until the activity snapshot lands; the management section below it
  /// is real from the first frame, as it needs no server data.
  Widget _skeleton(BuildContext context, AppLocalizations loc) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Widget card(int count, IconData icon, {Widget? trailing}) => Card(
          child: Column(
            children: [
              for (int i = 0; i < count; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(icon, size: 20, color: mutedColor),
                  title: Text(BoneMock.name),
                  subtitle: Text(BoneMock.words(2)),
                  trailing: trailing,
                ),
              ],
            ],
          ),
        );
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SettingsIntro(loc.serverStatusIntro),
        Skeletonizer(
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.dns, size: 32),
                  title: Text(BoneMock.name),
                  subtitle: Text(BoneMock.words(3)),
                ),
              ),
              SettingsSectionLabel(loc.busyNow),
              card(2, Icons.troubleshoot),
              SettingsSectionLabel(loc.queuedWork),
              card(3, Icons.list_alt),
              SettingsSectionLabel(loc.nodes),
              card(2, Icons.storage, trailing: const Chip(label: Text('1.0.0'))),
            ],
          ),
        ),
        _gatedManagementSection(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.server),
      ),
      body: GraphQLProvider(
        client: ClientManager.getClientForUrl(widget.serverName),
        child: Query(
          options:
              QueryOptions(document: documentNodeQuerygetServerInfoQuery),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            // getServerInfo only adorns the page (server card, node url and
            // version); while it loads or fails, the live sections carry on.
            final info = result.data == null || result.hasException
                ? null
                : Query$getServerInfoQuery.fromJson(result.data!).getServerInfo;

            if (!_loaded) {
              if (_error == null) return _skeleton(context, loc);
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  SettingsIntro(loc.serverStatusIntro),
                  if (info != null) _serverCard(context, info),
                  SettingsErrorState(
                    message: loc.couldNotLoad,
                    detailsLabel: loc.errorDetails,
                    details: _error,
                  ),
                  _gatedManagementSection(context),
                ],
              );
            }

            return ServerActivityBody(
              intro: loc.serverStatusIntro,
              header: info == null ? null : _serverCard(context, info),
              nodeInfo: {
                for (final node in info?.nodes ??
                    const <Query$getServerInfoQuery$getServerInfo$nodes>[])
                  node.name: node,
              },
              nodes: _nodes.values.toList(),
              queueStats: _queueStats,
              failures: _failures,
              transcodes: [
                for (final passes in _transcodesByNode.values) ...passes,
              ],
              liveFeedBroken: _liveFeedBroken,
              now: DateTime.now().toUtc(),
              footer: _gatedManagementSection(context),
            );
          },
        ),
      ),
    );
  }
}
