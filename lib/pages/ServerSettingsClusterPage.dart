import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';

@RoutePage()
class ServerSettingsClusterPage extends StatelessWidget {
  final String serverName;

  const ServerSettingsClusterPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
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
        client: ClientManager.getClientForUrl(serverName),
        child: Query(
          options: QueryOptions(
              document: documentNodeQuerygetServerInfoQuery),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Center(child: Text(result.exception.toString()));
            }

            if (result.data == null && result.isLoading) {
              final mutedColor =
                  Theme.of(context).colorScheme.onSurfaceVariant;
              return Skeletonizer(
                enabled: true,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dns, size: 32),
                      title: Text(BoneMock.name),
                      subtitle: Text(BoneMock.words(3)),
                    ),
                    const Divider(),
                    _sectionHeader(context, loc.nodes),
                    ...List.generate(
                      2,
                      (_) => ListTile(
                        dense: true,
                        leading: Icon(Icons.storage, size: 20, color: mutedColor),
                        title: Text(BoneMock.name),
                        subtitle: Text(BoneMock.words(3)),
                        trailing: const Chip(label: Text('1.0.0')),
                      ),
                    ),
                  ],
                ),
              );
            }

            final info =
                Query$getServerInfoQuery.fromJson(result.data!).getServerInfo;
            final nodes = info?.nodes ?? [];
            final mutedColor =
                Theme.of(context).colorScheme.onSurfaceVariant;

            return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: [
                if (info != null) ...[
                  ListTile(
                    leading: const Icon(Icons.dns, size: 32),
                    title: Text(
                      info.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      info.url,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Divider(),
                ],
                _sectionHeader(context, loc.nodes),
                ...nodes.map((node) => ListTile(
                      dense: true,
                      leading:
                          Icon(Icons.storage, size: 20, color: mutedColor),
                      title: Text(
                        node.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        node.url,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Chip(
                        label: Text(
                          node.version,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
