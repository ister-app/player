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

            if (result.data == null || result.isLoading) {
              final mutedColor =
                  Theme.of(context).colorScheme.onSurfaceVariant;
              return Skeletonizer(
                enabled: true,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.dns, size: 32),
                        title: Text(BoneMock.name),
                        subtitle: Text(BoneMock.words(3)),
                      ),
                    ),
                    _sectionLabel(context, loc.nodes),
                    Card(
                      child: Column(
                        children: List.generate(
                          2,
                          (i) => Column(
                            children: [
                              if (i > 0) const Divider(height: 1, indent: 56),
                              ListTile(
                                leading: Icon(Icons.storage,
                                    size: 20, color: mutedColor),
                                title: Text(BoneMock.name),
                                subtitle: Text(BoneMock.words(3)),
                                trailing: const Chip(label: Text('1.0.0')),
                              ),
                            ],
                          ),
                        ),
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
              padding: const EdgeInsets.all(16.0),
              children: [
                if (info != null) ...[
                  Card(
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
                  ),
                ],
                if (nodes.isNotEmpty) ...[
                  _sectionLabel(context, loc.nodes),
                  Card(
                    child: Column(
                      children: [
                        for (int i = 0; i < nodes.length; i++) ...[
                          if (i > 0) const Divider(height: 1, indent: 56),
                          ListTile(
                            leading: Icon(Icons.storage,
                                size: 20, color: mutedColor),
                            title: Text(
                              nodes[i].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              nodes[i].url,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Chip(
                              label: Text(
                                nodes[i].version,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
