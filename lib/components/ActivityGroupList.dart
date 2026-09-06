import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/ServerActivityPresentation.dart';

/// The "working on now" cards: one card per [ActivityGroup] — a heading naming
/// the show / movie / album / library the work belongs to, with its disk and
/// library as chips, and one row per step under it (file, step, node, elapsed).
class ActivityGroupList extends StatelessWidget {
  final List<ActivityGroup> groups;
  final DateTime now;

  /// Whether more than one node is in play; then every row names its node.
  final bool showNode;

  const ActivityGroupList({
    super.key,
    required this.groups,
    required this.now,
    required this.showNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups)
          ActivityGroupCard(group: group, now: now, showNode: showNode),
      ],
    );
  }
}

class ActivityGroupCard extends StatelessWidget {
  final ActivityGroup group;
  final DateTime now;
  final bool showNode;

  const ActivityGroupCard({
    super.key,
    required this.group,
    required this.now,
    required this.showNode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final tags = <String>[...group.libraries, ...group.directories];

    return Card(
      key: ValueKey('activity-group-${group.key}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(
                ServerActivityPresentation.contextIcon(group.contextType),
                color: theme.colorScheme.primary),
            title: Text(group.title,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            subtitle: tags.isEmpty
                ? null
                : Text(tags.join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          for (final entry in group.entries) _entryTile(context, loc, entry),
        ],
      ),
    );
  }

  Widget _entryTile(
      BuildContext context, AppLocalizations loc, ActivityEntry entry) {
    final theme = Theme.of(context);
    final kindLabel = ServerActivityPresentation.labelFor(loc, entry.kind);
    // Subject on the title line when the server named one; otherwise the kind
    // of work — or, in the per-kind catch-all group whose heading already says
    // that, the raw queue. The detail line carries the step, or (outside the
    // catch-all group) the kind, so a named subject still says what is
    // happening to it.
    final title = entry.subject ??
        (group.isKindFallback ? entry.queue ?? kindLabel : kindLabel);
    final detailParts = <String>[
      if (entry.detail != null)
        entry.detail!
      else if (entry.subject != null && !group.isKindFallback)
        kindLabel,
      if (entry.background) loc.backgroundTag,
      if (showNode) loc.activityOnNode(entry.nodeName),
    ];
    final startedAt = entry.startedAt;
    return ListTile(
      dense: true,
      leading: Icon(ServerActivityPresentation.iconFor(entry.kind),
          size: 20, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title,
          style: theme.textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: detailParts.isEmpty
          ? null
          : Text(detailParts.join(' · '), style: theme.textTheme.bodySmall),
      trailing: startedAt == null
          ? null
          : Chip(
              label: Text(
                  ServerActivityPresentation.formatElapsed(startedAt, now),
                  style: theme.textTheme.bodySmall),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
    );
  }
}
