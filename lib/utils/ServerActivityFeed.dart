import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/graphql/serverActivitySubscription.graphql.dart';

import 'LoggerService.dart';
import 'ResilientSubscription.dart';

/// The live activity state of one server, shared by the server status page and
/// the node detail page: seeded from serverActivitySnapshot and then kept
/// current by merging serverActivity events (NODE_ACTIVITY replaces that
/// node's entry, TRANSCODE_ACTIVITY replaces that node's transcode passes,
/// QUEUE_STATS replaces the whole list, FAILURE is prepended). A 30s ticker
/// notifies listeners so elapsed/relative times keep moving between events.
class ServerActivityFeed extends ChangeNotifier {
  static const int _maxFailures = 100;

  final GraphQLClient client;

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
  bool _disposed = false;

  ServerActivityFeed(this.client);

  bool get loaded => _loaded;
  String? get error => _error;
  bool get liveFeedBroken => _liveFeedBroken;
  Map<String, Fragment$fragmentServerActivityEvent> get nodes => _nodes;
  List<Fragment$fragmentQueueStat> get queueStats => _queueStats;
  List<Fragment$fragmentEventFailure> get failures => _failures;
  List<Fragment$fragmentTranscodePass> get transcodes => [
        for (final passes in _transcodesByNode.values) ...passes,
      ];

  List<Fragment$fragmentTranscodePass> transcodesFor(String nodeName) =>
      _transcodesByNode[nodeName] ?? const [];

  /// Opens the subscription and fetches the snapshot. Safe to call once.
  void start() {
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_loaded) _notify();
    });

    _subscription = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionserverActivity,
      onData: (result) {
        _loaded = true;
        _error = null;
        _liveFeedBroken = false;
        _applyEvent(
            Subscription$serverActivity.fromJson(result.data!).serverActivity);
        _notify();
      },
      onFailure: (_) {
        _liveFeedBroken = true;
        _notify();
      },
    );

    client
        .query(QueryOptions(
            document: documentNodeQueryserverActivitySnapshot,
            fetchPolicy: FetchPolicy.networkOnly))
        .then((result) {
      if (_disposed) return;
      if (result.hasException) {
        LoggerService().logger.e(result.exception);
        _error ??= result.exception.toString();
        _notify();
        return;
      }
      final data = result.data;
      if (data == null) return;
      final snapshot =
          Query$serverActivitySnapshot.fromJson(data).serverActivitySnapshot;
      _loaded = true;
      // Events that already arrived via the subscription are fresher than
      // the snapshot — only fill in what is still missing.
      for (final node in snapshot.nodes) {
        _nodes.putIfAbsent(node.nodeName, () => node);
      }
      final snapshotTranscodes = <String, List<Fragment$fragmentTranscodePass>>{};
      for (final pass in snapshot.transcodes) {
        snapshotTranscodes.putIfAbsent(pass.nodeName, () => []).add(pass);
      }
      for (final entry in snapshotTranscodes.entries) {
        _transcodesByNode.putIfAbsent(entry.key, () => entry.value);
      }
      if (_queueStats.isEmpty) _queueStats = snapshot.queueStats;
      if (_failures.isEmpty) _failures = snapshot.recentFailures;
      _notify();
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

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _subscription?.dispose();
    super.dispose();
  }
}
