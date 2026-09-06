import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';

import '../components/ServerNodeBody.dart';
import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ServerActivityFeed.dart';

/// One node of the server: disks with free space, host details, uptime and
/// the work running on it. Reached from the node list on the server status
/// page; the live data comes from its own [ServerActivityFeed], so a deep
/// link works without the status page having been opened first.
@RoutePage()
class ServerNodePage extends StatefulWidget {
  final String serverName;
  final String nodeName;

  const ServerNodePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('nodeName') required this.nodeName,
  });

  @override
  State<ServerNodePage> createState() => _ServerNodePageState();
}

class _ServerNodePageState extends State<ServerNodePage> {
  late final ServerActivityFeed _feed;

  @override
  void initState() {
    super.initState();
    _feed = ServerActivityFeed(
        ClientManager.getClientForUrl(widget.serverName).value)
      ..addListener(_onFeed)
      ..start();
  }

  void _onFeed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _feed.removeListener(_onFeed);
    _feed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.nodeName)),
      body: GraphQLProvider(
        client: ClientManager.getClientForUrl(widget.serverName),
        child: Query(
          options: QueryOptions(document: documentNodeQuerygetServerInfoQuery),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            final info = result.data == null || result.hasException
                ? null
                : Query$getServerInfoQuery.fromJson(result.data!).getServerInfo;
            Query$getServerInfoQuery$getServerInfo$nodes? nodeInfo;
            for (final node in info?.nodes ??
                const <Query$getServerInfoQuery$getServerInfo$nodes>[]) {
              if (node.name == widget.nodeName) nodeInfo = node;
            }

            if (!_feed.loaded) {
              if (_feed.error == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  SettingsErrorState(
                    message: loc.couldNotLoad,
                    detailsLabel: loc.errorDetails,
                    details: _feed.error,
                  ),
                ],
              );
            }

            return ServerNodeBody(
              nodeName: widget.nodeName,
              event: _feed.nodes[widget.nodeName],
              info: nodeInfo,
              transcodes: _feed.transcodesFor(widget.nodeName),
              liveFeedBroken: _feed.liveFeedBroken,
              now: DateTime.now().toUtc(),
            );
          },
        ),
      ),
    );
  }
}
