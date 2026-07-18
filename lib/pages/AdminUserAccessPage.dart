import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/adminLibraries.graphql.dart';
import 'package:player/graphql/adminUsers.graphql.dart';
import 'package:player/graphql/setUserLibraryAccess.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';

/// Admin-only: which restricted libraries one user may see. Visible-to-all libraries are shown
/// locked on: everyone sees those; restrict the library first (AdminLibrariesPage) to manage
/// per-user access.
@RoutePage()
class AdminUserAccessPage extends StatefulWidget {
  final String serverName;
  final String userId;
  final String userName;

  const AdminUserAccessPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('userId') required this.userId,
    required this.userName,
  });

  @override
  State<AdminUserAccessPage> createState() => _AdminUserAccessPageState();
}

class _AdminUserAccessPageState extends State<AdminUserAccessPage> {
  /// Optimistic switch positions; the query result is the fallback.
  final Map<String, bool> _pending = {};

  Future<void> _setAccess(
      BuildContext context, String libraryId, bool granted) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final client = ClientManager.getClientForUrl(widget.serverName).value;

    setState(() => _pending[libraryId] = granted);
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetUserLibraryAccess,
      variables: Variables$Mutation$setUserLibraryAccess(
        userId: widget.userId,
        libraryId: libraryId,
        granted: granted,
      ).toJson(),
    ));
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      if (mounted) {
        setState(() => _pending.remove(libraryId));
        messenger.showSnackBar(SnackBar(content: Text(loc.changeNotSaved)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final client = ClientManager.getClientForUrl(widget.serverName);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: GraphQLProvider(
        client: client,
        child: Query(
          options: QueryOptions(
            document: documentNodeQueryadminLibraries,
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: (QueryResult librariesResult,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            return Query(
              options: QueryOptions(
                document: documentNodeQueryadminUsers,
                fetchPolicy: FetchPolicy.cacheAndNetwork,
              ),
              builder: (QueryResult usersResult,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                final exception =
                    librariesResult.exception ?? usersResult.exception;
                if (exception != null) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(exception.toString()),
                  ));
                }
                if (librariesResult.data == null || usersResult.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final libraries = Query$adminLibraries
                        .fromJson(librariesResult.data!)
                        .libraries ??
                    [];
                final user = Query$adminUsers
                    .fromJson(usersResult.data!)
                    .users
                    .where((candidate) => candidate.id == widget.userId)
                    .firstOrNull;
                final granted = user == null
                    ? <String>{}
                    : user.grantedLibraries
                        .map((library) => library.id)
                        .toSet();

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      child: Column(
                        children: [
                          for (int i = 0; i < libraries.length; i++) ...[
                            if (i > 0) const Divider(height: 1, indent: 56),
                            SwitchListTile(
                              secondary:
                                  const Icon(Icons.video_library_outlined),
                              title: Text(libraries[i].name),
                              subtitle: libraries[i].visibleToAll
                                  ? Text(loc.visibleToEveryone)
                                  : null,
                              value: libraries[i].visibleToAll ||
                                  (_pending[libraries[i].id] ??
                                      granted.contains(libraries[i].id)),
                              onChanged: libraries[i].visibleToAll
                                  ? null
                                  : (value) => _setAccess(
                                      context, libraries[i].id, value),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
