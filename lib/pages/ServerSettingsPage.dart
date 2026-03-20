import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/LanguagesFormField.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LanguagePreferences.dart';

@RoutePage()
class ServerSettingsPage extends StatefulWidget {
  final String serverName;

  const ServerSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  final List<String> _spokenLanguages = [];
  final List<String> _subtitleLanguages = [];
  late Future<void> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final spoken = await LanguagePreferences.getSpokenLanguages();
    final subtitle = await LanguagePreferences.getSubtitleLanguages();

    _spokenLanguages
      ..clear()
      ..addAll(spoken);
    _subtitleLanguages
      ..clear()
      ..addAll(subtitle);
  }

  void _handleSpokenChanged(List<String> newList) {
    LanguagePreferences.setSpokenLanguages(newList);
    setState(() => _spokenLanguages
      ..clear()
      ..addAll(newList));
  }

  void _handleSubtitleChanged(List<String> newList) {
    LanguagePreferences.setSubtitleLanguages(newList);
    setState(() => _subtitleLanguages
      ..clear()
      ..addAll(newList));
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: GraphQLProvider(
        client: ClientManager.getClientForUrl(widget.serverName),
        child: FutureBuilder<void>(
          future: _preferencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  loc.loadError(snapshot.error!),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: [
                _sectionHeader(context, loc.preferredSpoken),
                LanguageFormField(
                  initialValue: _spokenLanguages,
                  onChanged: _handleSpokenChanged,
                ),
                const SizedBox(height: 8),
                const Divider(),
                _sectionHeader(context, loc.preferredSubtitle),
                LanguageFormField(
                  initialValue: _subtitleLanguages,
                  onChanged: _handleSubtitleChanged,
                ),
                const SizedBox(height: 8),
                const Divider(),
                Query(
                  options: QueryOptions(
                      document: documentNodeQuerygetServerInfoQuery),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.data == null && result.isLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeader(context, loc.server),
                            ListTile(
                              leading: const Icon(Icons.dns),
                              title: Text(BoneMock.name),
                              subtitle: Text(BoneMock.words(3)),
                            ),
                            const Divider(),
                            _sectionHeader(context, loc.nodes),
                            ...List.generate(
                              2,
                              (_) => ListTile(
                                leading: const Icon(Icons.storage),
                                title: Text(BoneMock.name),
                                subtitle: Text(BoneMock.words(3)),
                                trailing: const Chip(label: Text('1.0.0')),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final info = Query$getServerInfoQuery
                        .fromJson(result.data!)
                        .getServerInfo;
                    final nodes = info?.nodes ?? [];

                    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                          child: Text(
                            loc.nodes,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: mutedColor),
                          ),
                        ),
                        ...nodes.map((node) => ListTile(
                              dense: true,
                              leading: Icon(Icons.storage, size: 20, color: mutedColor),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
