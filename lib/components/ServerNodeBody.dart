import 'package:flutter/material.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ServerActivityPresentation.dart';
import 'ActivityGroupList.dart';
import 'LiveFeedBanner.dart';

/// Everything about one node: whether it is alive, what it runs on, its disks
/// with their free space, its helper set-up and what it is doing right now.
/// Stateless and fed the node's last activity event plus its getServerInfo
/// row (either may be missing), with an injectable [now] for widget tests.
class ServerNodeBody extends StatelessWidget {
  final String nodeName;
  final Fragment$fragmentServerActivityEvent? event;
  final Query$getServerInfoQuery$getServerInfo$nodes? info;
  final List<Fragment$fragmentTranscodePass> transcodes;
  final bool liveFeedBroken;
  final DateTime now;

  const ServerNodeBody({
    super.key,
    required this.nodeName,
    required this.event,
    required this.info,
    required this.transcodes,
    required this.liveFeedBroken,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final facts = event?.nodeInfo;
    final groups = ServerActivityPresentation.groupActivity(
        loc, [if (event != null) event!], transcodes);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (liveFeedBroken) const LiveFeedBanner(),
        _headerCard(context, loc, facts),
        SettingsSectionLabel(loc.nodeStatus),
        _statusCard(context, loc, facts),
        SettingsSectionLabel(loc.nodeDisks),
        _disksCard(context, loc, facts),
        if (facts != null &&
            (facts.helperDisks.isNotEmpty || facts.offloadJobs.isNotEmpty))
          _helperCard(context, loc, facts),
        SettingsSectionLabel(loc.busyNow),
        if (groups.isEmpty)
          _noteCard(context, loc.nodeIdle)
        else
          ActivityGroupList(groups: groups, now: now, showNode: false),
      ],
    );
  }

  Widget _headerCard(BuildContext context, AppLocalizations loc,
      Fragment$fragmentNodeInfo? facts) {
    final theme = Theme.of(context);
    final subtitleParts = <String>[
      if (facts?.hostname != null) facts!.hostname!,
      if (info != null) info!.url,
    ];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.storage, size: 32),
        title: Text(nodeName, style: theme.textTheme.titleMedium),
        subtitle: subtitleParts.isEmpty
            ? null
            : Text(subtitleParts.join(' · '),
                style: theme.textTheme.bodySmall),
      ),
    );
  }

  Widget _statusCard(BuildContext context, AppLocalizations loc,
      Fragment$fragmentNodeInfo? facts) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final node = event;
    final timestamp = node == null
        ? null
        : ServerActivityPresentation.parseInstant(node.timestamp);
    final stale = timestamp != null &&
        ServerActivityPresentation.isStale(timestamp, now);
    final startedAt = facts == null
        ? null
        : ServerActivityPresentation.parseInstant(facts.startedAt);

    Widget row(IconData icon, String title, {String? value, Color? color}) =>
        ListTile(
          dense: true,
          leading: Icon(icon, size: 20, color: color ?? muted),
          title: Text(title, style: theme.textTheme.bodyMedium),
          trailing: value == null
              ? null
              : Text(value,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted)),
        );

    final tiles = <Widget>[
      if (node == null)
        row(Icons.hourglass_empty, loc.nodeNoActivityYet)
      else if (stale)
        row(
          Icons.cloud_off,
          loc.nodeOffline,
          value: loc.lastSeenAgo(
              ServerActivityPresentation.formatRelative(loc, timestamp, now)),
          color: theme.colorScheme.error,
        )
      else
        row(Icons.check_circle_outline, loc.nodeOnline,
            value: timestamp == null
                ? null
                : ServerActivityPresentation.formatRelative(
                    loc, timestamp, now),
            color: theme.colorScheme.primary),
      if (startedAt != null)
        row(Icons.timer_outlined,
            loc.nodeUpFor(
                ServerActivityPresentation.formatUptime(startedAt, now))),
      if (node != null)
        ListTile(
          dense: true,
          leading: Icon(Icons.functions, size: 20, color: muted),
          title: Wrap(
            spacing: 4,
            children: [
              _chip(context, loc.processedCount(node.processedCount ?? 0)),
              _chip(context, loc.failedCount(node.failedCount ?? 0)),
            ],
          ),
        ),
      if (info != null) ...[
        row(Icons.new_releases_outlined, loc.nodeVersion, value: info!.version),
        row(Icons.link, loc.nodeAddress, value: info!.url),
      ],
      if (facts != null) ...[
        if (facts.hostname != null)
          row(Icons.dns_outlined, loc.nodeHost, value: facts.hostname),
        if (facts.javaVersion != null)
          row(Icons.coffee_outlined, loc.nodeJava, value: facts.javaVersion),
        if (facts.availableProcessors != null)
          row(Icons.memory, loc.nodeCpus(facts.availableProcessors!)),
        if (facts.maxMemoryBytes != null)
          row(Icons.sd_storage_outlined, loc.nodeHeapLimit,
              value: ServerActivityPresentation.formatBytes(
                  facts.maxMemoryBytes!)),
      ] else if (node != null)
        ListTile(
          dense: true,
          leading: Icon(Icons.info_outline, size: 20, color: muted),
          title: Text(loc.nodeInfoUnavailable,
              style: theme.textTheme.bodySmall?.copyWith(color: muted)),
        ),
    ];
    return _sectionCard(tiles);
  }

  Widget _disksCard(BuildContext context, AppLocalizations loc,
      Fragment$fragmentNodeInfo? facts) {
    final directories = facts?.directories ?? const [];
    if (directories.isEmpty) return _noteCard(context, loc.nodeNoDisks);
    return _sectionCard([
      for (final directory in directories) _diskTile(context, loc, directory),
    ]);
  }

  Widget _diskTile(BuildContext context, AppLocalizations loc,
      Fragment$fragmentNodeInfo$directories directory) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final isCache = directory.type == 'CACHE';
    final total = directory.totalBytes;
    final free = directory.freeBytes;
    final mounted = total != null && free != null && total > 0;
    final usedFraction = mounted ? ((total - free) / total).clamp(0.0, 1.0) : 0.0;
    final tight = usedFraction >= 0.9;

    return ListTile(
      key: ValueKey('node-disk-${directory.name}'),
      isThreeLine: true,
      leading: Icon(isCache ? Icons.cached : Icons.folder_outlined,
          size: 20, color: muted),
      title: Text(directory.name, style: theme.textTheme.bodyMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            [
              if (isCache) loc.nodeCacheDisk else if (directory.$library != null) directory.$library!,
              directory.path,
            ].join(' · '),
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          if (mounted) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: usedFraction,
                minHeight: 6,
                color: tight ? theme.colorScheme.error : theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              loc.nodeFreeOf(ServerActivityPresentation.formatBytes(free),
                  ServerActivityPresentation.formatBytes(total)),
              style: theme.textTheme.bodySmall?.copyWith(
                  color: tight ? theme.colorScheme.error : muted),
            ),
          ] else
            Text(loc.nodeNotMounted,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
        ],
      ),
    );
  }

  Widget _helperCard(BuildContext context, AppLocalizations loc,
      Fragment$fragmentNodeInfo facts) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _sectionCard([
        if (facts.helperDisks.isNotEmpty)
          ListTile(
            dense: true,
            leading: Icon(Icons.handshake_outlined, size: 20, color: muted),
            title: Text(loc.nodeHelperDisks, style: theme.textTheme.bodyMedium),
            subtitle: Text(
              [
                for (final disk in facts.helperDisks)
                  '${disk.name}: ${disk.jobs.map(_jobLabel).join(', ')}',
              ].join('\n'),
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
          ),
        if (facts.offloadJobs.isNotEmpty)
          ListTile(
            dense: true,
            leading: Icon(Icons.outbound_outlined, size: 20, color: muted),
            title: Text(loc.nodeOffloadJobs, style: theme.textTheme.bodyMedium),
            subtitle: Text(facts.offloadJobs.map(_jobLabel).join(', '),
                style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          ),
      ]),
    );
  }

  /// "SUBTITLE_EXTRACT" -> "subtitle extract"; the job families are server
  /// tokens the player does not translate.
  static String _jobLabel(String job) => job.toLowerCase().replaceAll('_', ' ');

  Widget _noteCard(BuildContext context, String text) => Card(
        child: ListTile(
          title: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      );

  Widget _sectionCard(List<Widget> tiles) => Card(
        child: Column(
          children: [
            for (int i = 0; i < tiles.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 56),
              tiles[i],
            ],
          ],
        ),
      );

  Widget _chip(BuildContext context, String label) => Chip(
        label: Text(label, style: Theme.of(context).textTheme.bodySmall),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      );
}
