import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/graphql/serverActivitySubscription.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/ServerActivityBody.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/ResilientSubscription.dart';

/// Live server-activity dashboard: what the server is working on right now
/// (with subject and sub-step), queued work per kind, running transcodes,
/// nodes and recent failures. Seeded from serverActivitySnapshot, then kept
/// current by merging serverActivity events (NODE_ACTIVITY replaces that
/// node's entry, TRANSCODE_ACTIVITY replaces that node's transcode passes,
/// QUEUE_STATS replaces the whole list, FAILURE is prepended). A 30s ticker
/// keeps the elapsed/relative times moving between events.
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

  Widget _skeleton(BuildContext context, AppLocalizations loc) {
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Widget sectionLabel(String title) => Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 4.0),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: mutedColor),
          ),
        );
    Widget card(int count, IconData icon) => Card(
          child: Column(
            children: [
              for (int i = 0; i < count; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(icon, size: 20, color: mutedColor),
                  title: Text(BoneMock.name),
                  subtitle: Text(BoneMock.words(2)),
                ),
              ],
            ],
          ),
        );
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          sectionLabel(loc.busyNow),
          card(2, Icons.troubleshoot),
          sectionLabel(loc.queuedWork),
          card(3, Icons.list_alt),
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
      body = _skeleton(context, loc);
    } else {
      body = ServerActivityBody(
        nodes: _nodes.values.toList(),
        queueStats: _queueStats,
        failures: _failures,
        transcodes: [
          for (final passes in _transcodesByNode.values) ...passes,
        ],
        liveFeedBroken: _liveFeedBroken,
        now: DateTime.now().toUtc(),
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
