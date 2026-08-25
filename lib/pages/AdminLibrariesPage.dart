import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/adminLibraries.graphql.dart';
import 'package:player/graphql/setLibraryVisibleToAll.graphql.dart';

import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';

/// Admin-only: per library whether every user may see it. Access for individual users to a
/// restricted library is granted on the user's page (AdminUserAccessPage).
@RoutePage()
class AdminLibrariesPage extends StatefulWidget {
  final String serverName;

  const AdminLibrariesPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<AdminLibrariesPage> createState() => _AdminLibrariesPageState();
}

class _AdminLibrariesPageState extends State<AdminLibrariesPage> {
  /// Optimistic switch positions; the query result is the fallback.
  final Map<String, bool> _pending = {};

  Future<void> _setVisibleToAll(
      BuildContext context, String libraryId, bool visibleToAll) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final client = ClientManager.getClientForUrl(widget.serverName).value;

    setState(() => _pending[libraryId] = visibleToAll);
    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetLibraryVisibleToAll,
      variables: Variables$Mutation$setLibraryVisibleToAll(
        libraryId: libraryId,
        visibleToAll: visibleToAll,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.libraryVisibility),
      ),
      body: GraphQLProvider(
        client: ClientManager.getClientForUrl(widget.serverName),
        child: Query(
          options: QueryOptions(
            document: documentNodeQueryadminLibraries,
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return SettingsErrorState(
                message: loc.couldNotLoad,
                detailsLabel: loc.errorDetails,
                details: result.exception.toString(),
              );
            }
            if (result.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final libraries =
                Query$adminLibraries.fromJson(result.data!).libraries ?? [];
            if (libraries.isEmpty) {
              return SettingsEmptyState(
                icon: Icons.video_library_outlined,
                title: loc.noLibrariesYet,
                message: loc.adminRoleNote,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SettingsIntro(loc.adminRoleNote),
                SettingsCard(children: [
                      for (int i = 0; i < libraries.length; i++)
                        SwitchListTile(
                          secondary: const Icon(Icons.video_library_outlined),
                          title: Text(libraries[i].name),
                          subtitle: Text(
                            (_pending[libraries[i].id] ??
                                    libraries[i].visibleToAll)
                                ? loc.visibleToEveryone
                                : loc.restrictedLibrarySubtitle,
                          ),
                          value: _pending[libraries[i].id] ??
                              libraries[i].visibleToAll,
                          onChanged: (value) => _setVisibleToAll(
                              context, libraries[i].id, value),
                        ),
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}
