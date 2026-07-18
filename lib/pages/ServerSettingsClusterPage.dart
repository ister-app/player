import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForLibrary.graphql.dart';
import 'package:player/graphql/analyzeLibrary.graphql.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/reindexSearch.graphql.dart';
import 'package:player/graphql/scanLibrary.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../components/AdminGate.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';

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

  Future<void> _runManagementTask(
    BuildContext context,
    DocumentNode document,
    String label, {
    Map<String, dynamic>? variables,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final client = GraphQLProvider.of(context).value;

    final result = await client.mutate(MutationOptions(
      document: document,
      variables: variables ?? const {},
    ));

    if (!context.mounted) return;
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      messenger.showSnackBar(
        SnackBar(content: Text(loc.taskFailed(label))),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(content: Text(loc.taskStarted(label))),
    );
  }

  IconData _libraryIcon(Enum$LibraryType type) {
    switch (type) {
      case Enum$LibraryType.SHOW:
        return Icons.tv;
      case Enum$LibraryType.MUSIC:
        return Icons.library_music;
      default:
        return Icons.movie;
    }
  }

  Future<void> _showAnalyzeOptions(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(QueryOptions(
      document: documentNodeQuerylibraries,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));

    if (!context.mounted) return;
    final libraries = result.data == null
        ? <Query$libraries$libraries>[]
        : (Query$libraries.fromJson(result.data!).libraries ??
            <Query$libraries$libraries>[]);

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final mutedColor = Theme.of(sheetContext).colorScheme.onSurfaceVariant;
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.analytics_outlined, color: mutedColor),
                  title: Text(loc.analyzeAllLibraries),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _runManagementTask(
                      context,
                      documentNodeMutationanalyzeLibrary,
                      loc.analyzeAllLibraries,
                    );
                  },
                ),
                if (libraries.isNotEmpty) const Divider(height: 1),
                for (final library in libraries)
                  ListTile(
                    leading: Icon(_libraryIcon(library.type), color: mutedColor),
                    title: Text(library.name),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _runManagementTask(
                        context,
                        documentNodeMutationanalyzeDataForLibraryMutation,
                        library.name,
                        variables: {'libraryId': library.id},
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// The management actions are admin-only; on an older server without permissions
  /// (status unknown) they stay visible, matching what that server enforces.
  Widget _gatedManagementSection(BuildContext context) {
    return AdminGate(
      serverName: serverName,
      showWhenUnknown: true,
      child: _managementSection(context),
    );
  }

  Widget _managementSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel(context, loc.management),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.loop, color: mutedColor),
                title: Text(loc.scanLibrary),
                onTap: () => _runManagementTask(
                  context,
                  documentNodeMutationscanLibrary,
                  loc.scanLibrary,
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.analytics_outlined, color: mutedColor),
                title: Text(loc.analyzeLibrary),
                trailing: Icon(Icons.chevron_right, color: mutedColor),
                onTap: () => _showAnalyzeOptions(context),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.manage_search, color: mutedColor),
                title: Text(loc.reindexSearch),
                onTap: () => _runManagementTask(
                  context,
                  documentNodeMutationreindexSearch,
                  loc.reindexSearch,
                ),
              ),
            ],
          ),
        ),
      ],
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
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(child: Text(result.exception.toString())),
                  _gatedManagementSection(context),
                ],
              );
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
                    _gatedManagementSection(context),
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
                _gatedManagementSection(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
