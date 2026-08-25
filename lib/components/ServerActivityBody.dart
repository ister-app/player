import 'package:flutter/material.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ServerActivityPresentation.dart';
import 'LiveFeedBanner.dart';

/// The rendered content of the server settings screen. Stateless and fed plain
/// fragment lists (plus an injectable [now]) so widget tests can drive it
/// without a GraphQL client; ServerSettingsClusterPage owns the
/// subscription/merge state and rebuilds this on every update and on a
/// periodic ticker.
///
/// [header] (the server card) and [footer] (the management actions) are
/// injected by the page, and [nodeInfo] adds the url/version the activity feed
/// doesn't carry, so the nodes section tells the whole story in one place.
class ServerActivityBody extends StatelessWidget {
  final List<Fragment$fragmentServerActivityEvent> nodes;
  final List<Fragment$fragmentQueueStat> queueStats;
  final List<Fragment$fragmentEventFailure> failures;
  final List<Fragment$fragmentTranscodePass> transcodes;
  final bool liveFeedBroken;
  final DateTime now;
  final String? intro;
  final Widget? header;
  final Widget? footer;
  final Map<String, Query$getServerInfoQuery$getServerInfo$nodes> nodeInfo;

  const ServerActivityBody({
    super.key,
    required this.nodes,
    required this.queueStats,
    required this.failures,
    required this.transcodes,
    required this.liveFeedBroken,
    required this.now,
    this.intro,
    this.header,
    this.footer,
    this.nodeInfo = const {},
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final busyTiles = _busyTiles(context, loc);
    final totalQueued =
        queueStats.fold<int>(0, (sum, stat) => sum + stat.depth);
    final idle = busyTiles.isEmpty && totalQueued == 0;

    final nodeNames = _sortedNodeNames();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (liveFeedBroken) const LiveFeedBanner(),
        if (intro != null) SettingsIntro(intro!),
        if (header != null) header!,
        if (idle)
          _idleHero(context, loc)
        else ...[
          if (busyTiles.isNotEmpty) ...[
            SettingsSectionLabel(loc.busyNow),
            _sectionCard(busyTiles),
          ],
          SettingsSectionLabel(loc.queuedWork),
          _queueSection(context, loc),
        ],
        if (nodeNames.isNotEmpty) ...[
          SettingsSectionLabel(loc.nodes),
          _sectionCard([
            for (final name in nodeNames) _nodeTile(context, loc, name),
          ]),
        ],
        SettingsSectionLabel(loc.recentFailures),
        if (failures.isEmpty)
          Card(
            child: ListTile(
              title: Text(
                loc.noRecentFailures,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          _sectionCard([
            for (final failure in failures)
              _FailureTile(failure: failure, now: now)
          ]),
        if (footer != null) footer!,
      ],
    );
  }

  List<Fragment$fragmentServerActivityEvent> _sortedNodes() =>
      nodes.toList()..sort((a, b) => a.nodeName.compareTo(b.nodeName));

  Fragment$fragmentServerActivityEvent? _nodeEventFor(String name) {
    for (final node in nodes) {
      if (node.nodeName == name) return node;
    }
    return null;
  }

  /// Every node either source knows about: the activity feed only reports a
  /// node once it emits an event, while getServerInfo lists them all.
  List<String> _sortedNodeNames() => <String>{
        for (final node in nodes) node.nodeName,
        ...nodeInfo.keys,
      }.toList()
        ..sort();

  bool get _multiNode => nodes.length > 1;

  // ===== Busy now =====

  List<Widget> _busyTiles(BuildContext context, AppLocalizations loc) {
    final tiles = <Widget>[];
    for (final node in _sortedNodes()) {
      for (final item in node.processing ??
          const <Fragment$fragmentServerActivityEvent$processing>[]) {
        tiles.add(_processingTile(context, loc, node.nodeName, item));
      }
    }
    for (final pass in transcodes) {
      tiles.add(_transcodeTile(context, loc, pass));
    }
    return tiles;
  }

  Widget _processingTile(BuildContext context, AppLocalizations loc,
      String nodeName, Fragment$fragmentServerActivityEvent$processing item) {
    final kind = ServerActivityPresentation.kindFor(item.queue);
    final title = item.subject ?? ServerActivityPresentation.labelFor(loc, kind);
    final stepLabel = ServerActivityPresentation.stepLabel(loc, item.step);
    final subtitleParts = <String>[
      if (item.subject != null || stepLabel != null)
        stepLabel ?? ServerActivityPresentation.labelFor(loc, kind)
      else
        item.queue,
      if (_multiNode) nodeName,
    ];
    final startedAt = ServerActivityPresentation.parseInstant(item.startedAt);
    return ListTile(
      leading: Icon(ServerActivityPresentation.iconFor(kind),
          size: 20, color: Theme.of(context).colorScheme.primary),
      title: Text(title,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitleParts.join(' · '),
          style: Theme.of(context).textTheme.bodySmall),
      trailing: startedAt == null
          ? null
          : _chip(context,
              ServerActivityPresentation.formatElapsed(startedAt, now)),
    );
  }

  Widget _transcodeTile(BuildContext context, AppLocalizations loc,
      Fragment$fragmentTranscodePass pass) {
    final startedAt = ServerActivityPresentation.parseInstant(pass.startedAt);
    final subtitleParts = <String>[
      '${loc.transcodesTag} · ${ServerActivityPresentation.qualityLabel(pass.quality)}',
      if (pass.background) loc.backgroundTag,
      if (_multiNode) pass.nodeName,
    ];
    return ListTile(
      leading: Icon(
          ServerActivityPresentation.iconFor(ActivityKind.transcode),
          size: 20,
          color: Theme.of(context).colorScheme.primary),
      title: Text(pass.title ?? loc.activityKindTranscode,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitleParts.join(' · '),
          style: Theme.of(context).textTheme.bodySmall),
      trailing: startedAt == null
          ? null
          : _chip(context,
              ServerActivityPresentation.formatElapsed(startedAt, now)),
    );
  }

  // ===== Queued work =====

  Widget _queueSection(BuildContext context, AppLocalizations loc) {
    final depthsByKind = <ActivityKind, int>{};
    for (final stat in queueStats) {
      if (stat.depth == 0) continue;
      final kind = ServerActivityPresentation.kindFor(stat.queue);
      depthsByKind[kind] = (depthsByKind[kind] ?? 0) + stat.depth;
    }
    final tiles = <Widget>[
      if (depthsByKind.isEmpty)
        ListTile(
          leading: Icon(Icons.check_circle_outline,
              size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          title: Text(loc.allQueuesEmpty,
              style: Theme.of(context).textTheme.bodyMedium),
        )
      else
        for (final entry in (depthsByKind.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))))
          ListTile(
            leading: Icon(ServerActivityPresentation.iconFor(entry.key),
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text(
                ServerActivityPresentation.queuedLabelFor(
                    loc, entry.key, entry.value),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
      if (queueStats.isNotEmpty)
        ExpansionTile(
          shape: const Border(),
          title: Text(loc.queueDetails,
              style: Theme.of(context).textTheme.bodySmall),
          children: [
            for (final stat in queueStats) _rawQueueTile(context, loc, stat),
          ],
        ),
    ];
    return _sectionCard(tiles);
  }

  Widget _rawQueueTile(BuildContext context, AppLocalizations loc,
      Fragment$fragmentQueueStat stat) {
    final busy = stat.depth > 0;
    return ListTile(
      dense: true,
      title: Text(stat.queue, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(loc.consumers(stat.consumers),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: Text(
        loc.queueDepth(stat.depth),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: busy ? Theme.of(context).colorScheme.primary : null,
            ),
      ),
    );
  }

  // ===== Nodes =====

  Widget _nodeTile(BuildContext context, AppLocalizations loc, String name) {
    final node = _nodeEventFor(name);
    final info = nodeInfo[name];
    final timestamp = node == null
        ? null
        : ServerActivityPresentation.parseInstant(node.timestamp);
    final stale = timestamp != null &&
        ServerActivityPresentation.isStale(timestamp, now);
    final hasInFlight = (node?.processing ?? const []).isNotEmpty;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final staleColor = stale && hasInFlight
        ? Theme.of(context).colorScheme.error
        : mutedColor;
    final smallStyle = Theme.of(context).textTheme.bodySmall;

    // The address line comes from getServerInfo, the last-seen line from the
    // activity feed; a node can have either, both or neither.
    final subtitleLines = <Widget>[
      if (info != null)
        Text(
          'v${info.version} · ${info.url}',
          style: smallStyle?.copyWith(color: mutedColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      if (stale)
        Text(
          loc.lastSeenAgo(
              ServerActivityPresentation.formatRelative(loc, timestamp, now)),
          style: smallStyle?.copyWith(color: staleColor),
        ),
    ];

    return ListTile(
      leading: Icon(stale ? Icons.cloud_off : Icons.storage,
          size: 20, color: stale ? staleColor : mutedColor),
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: stale ? mutedColor : null,
            ),
      ),
      subtitle: subtitleLines.isEmpty
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: subtitleLines,
            ),
      trailing: node == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _chip(context, loc.processedCount(node.processedCount ?? 0)),
                const SizedBox(width: 4),
                _chip(context, loc.failedCount(node.failedCount ?? 0)),
              ],
            ),
    );
  }

  // ===== Shared bits =====

  Widget _idleHero(BuildContext context, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            Icon(Icons.bedtime_outlined,
                size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(loc.serverIdle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              loc.serverIdleSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _sectionCard(List<Widget> tiles) {
    return Card(
      child: Column(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 56),
            tiles[i],
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Chip(
      label: Text(label, style: Theme.of(context).textTheme.bodySmall),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Failure row with a relative timestamp; the error message is clamped to two
/// lines and expands on tap (stack traces can be long).
class _FailureTile extends StatefulWidget {
  final Fragment$fragmentEventFailure failure;
  final DateTime now;

  const _FailureTile({required this.failure, required this.now});

  @override
  State<_FailureTile> createState() => _FailureTileState();
}

class _FailureTileState extends State<_FailureTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final failure = widget.failure;
    final errorColor = Theme.of(context).colorScheme.error;
    final kind = ServerActivityPresentation.kindFor(failure.queue);
    final occurredAt = ServerActivityPresentation.parseInstant(failure.occurredAt);
    final when = occurredAt == null
        ? failure.occurredAt
        : ServerActivityPresentation.formatRelative(loc, occurredAt, widget.now);

    return ListTile(
      leading: Icon(Icons.error_outline, size: 20, color: errorColor),
      title: Text(
        ServerActivityPresentation.labelFor(loc, kind),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        [
          if (failure.errorMessage != null) failure.errorMessage!,
          '${failure.nodeName} · $when',
        ].join('\n'),
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: _expanded ? null : 3,
        overflow: _expanded ? null : TextOverflow.ellipsis,
      ),
      onTap: () => setState(() => _expanded = !_expanded),
    );
  }
}
