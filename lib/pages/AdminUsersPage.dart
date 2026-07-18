import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/adminUsers.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';

/// Admin-only: every user known to the server, entry point for per-user library access.
@RoutePage()
class AdminUsersPage extends StatelessWidget {
  final String serverName;

  const AdminUsersPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.usersAndAccess),
      ),
      body: GraphQLProvider(
        client: ClientManager.getClientForUrl(serverName),
        child: Query(
          options: QueryOptions(
            document: documentNodeQueryadminUsers,
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(result.exception.toString()),
              ));
            }
            if (result.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final users = Query$adminUsers.fromJson(result.data!).users;
            if (users.isEmpty) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(loc.noUsersYet),
              ));
            }
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Column(
                    children: [
                      for (int i = 0; i < users.length; i++) ...[
                        if (i > 0) const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(users[i].name ?? users[i].id),
                          subtitle: users[i].email == null
                              ? null
                              : Text(users[i].email!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (users[i].isAdmin)
                                Chip(
                                  label: Text(loc.adminLabel),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () => AutoRouter.of(context).push(
                            AdminUserAccessRoute(
                              userId: users[i].id,
                              userName: users[i].name ?? users[i].id,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 4.0),
                  child: Text(
                    loc.adminRoleNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
