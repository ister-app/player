import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/graphql/serverActivitySubscription.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/LiveFeedBanner.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/ResilientSubscription.dart';

/// Live server-activity dashboard: per-node processing, queue depths and
/// recent failures. Seeded from serverActivitySnapshot, then kept current by
/// merging serverActivity events (NODE_ACTIVITY replaces that node's entry,
/// QUEUE_STATS replaces the whole list, FAILURE is prepended).
@RoutePage()
class ServerActivityPage extends StatefulWidget {
  final String serverName;

  const ServerActivityPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ServerActivityPage> createState() => _ServerActivityPageState();
}

class _ServerActivityPageState extends State<ServerActivityPage> {
  static const int _maxFailures = 100;

  bool _loaded = false;
  String? _error;
  bool _liveFeedBroken = false;
  final Map<String, Fragment$fragmentServerActivityEvent> _nodes = {};
  List<Fragment$fragmentQueueStat> _queueStats = [];
  List<Fragment$fragmentEventFailure> _failures = [];
  ResilientSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    final client = ClientManager.getClientForUrl(widget.serverName).value;

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
    _subscription?.dispose();
    super.dispose();
  }

  Widget _sectionLabel(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Chip _countChip(BuildContext context, String label) {
    return Chip(
      label: Text(label, style: Theme.of(context).textTheme.bodySmall),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _nodeTile(
      BuildContext context, Fragment$fragmentServerActivityEvent node) {
    final loc = AppLocalizations.of(context)!;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final processing = node.processing ?? const [];

    return ListTile(
      leading: Icon(Icons.storage, size: 20, color: mutedColor),
      title: Text(
        node.nodeName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        processing.isEmpty
            ? loc.idle
            : processing.map((p) => '${p.queue} · ${p.eventType}').join('\n'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _countChip(context, loc.processedCount(node.processedCount ?? 0)),
          const SizedBox(width: 4),
          _countChip(context, loc.failedCount(node.failedCount ?? 0)),
        ],
      ),
    );
  }

  Widget _queueTile(BuildContext context, Fragment$fragmentQueueStat stat) {
    final loc = AppLocalizations.of(context)!;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final busy = stat.depth > 0;

    return ListTile(
      leading: Icon(Icons.list_alt, size: 20, color: mutedColor),
      title: Text(
        stat.queue,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        loc.consumers(stat.consumers),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Chip(
        label: Text(
          loc.queueDepth(stat.depth),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: busy ? Theme.of(context).colorScheme.primary : null,
              ),
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _failureTile(
      BuildContext context, Fragment$fragmentEventFailure failure) {
    final errorColor = Theme.of(context).colorScheme.error;

    return ListTile(
      leading: Icon(Icons.error_outline, size: 20, color: errorColor),
      title: Text(
        [failure.queue, if (failure.eventType != null) failure.eventType!]
            .join(' · '),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        [
          if (failure.errorMessage != null) failure.errorMessage!,
          '${failure.nodeName} · ${failure.occurredAt}',
        ].join('\n'),
        style: Theme.of(context).textTheme.bodySmall,
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    Widget body;
    if (_error != null && !_loaded) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!),
        ),
      );
    } else if (!_loaded) {
      final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
      body = Skeletonizer(
        enabled: true,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _sectionLabel(context, loc.nodes),
            _sectionCard(List.generate(
              2,
              (i) => ListTile(
                leading: Icon(Icons.storage, size: 20, color: mutedColor),
                title: Text(BoneMock.name),
                subtitle: Text(BoneMock.words(2)),
              ),
            )),
            _sectionLabel(context, loc.queues),
            _sectionCard(List.generate(
              3,
              (i) => ListTile(
                leading: Icon(Icons.list_alt, size: 20, color: mutedColor),
                title: Text(BoneMock.name),
                subtitle: Text(BoneMock.words(2)),
              ),
            )),
          ],
        ),
      );
    } else {
      final nodes = _nodes.values.toList()
        ..sort((a, b) => a.nodeName.compareTo(b.nodeName));
      body = ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_liveFeedBroken) const LiveFeedBanner(),
          if (nodes.isNotEmpty) ...[
            _sectionLabel(context, loc.nodes),
            _sectionCard([for (final node in nodes) _nodeTile(context, node)]),
          ],
          if (_queueStats.isNotEmpty) ...[
            _sectionLabel(context, loc.queues),
            _sectionCard(
                [for (final stat in _queueStats) _queueTile(context, stat)]),
          ],
          _sectionLabel(context, loc.recentFailures),
          if (_failures.isEmpty)
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
              for (final failure in _failures) _failureTile(context, failure)
            ]),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.serverActivity),
      ),
      body: body,
    );
  }
}
