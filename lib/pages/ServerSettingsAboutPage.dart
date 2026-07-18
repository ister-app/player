import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:player/graphql/attributions.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../l10n/app_localizations.dart';

/// Credits the external metadata/artwork providers the server reports via the
/// attributions query (with any provider-mandated notice, e.g. TMDB's), and
/// links to the bundled open-source licenses.
@RoutePage()
class ServerSettingsAboutPage extends StatelessWidget {
  final String serverName;

  const ServerSettingsAboutPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  Future<void> _showLicenses(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    showLicensePage(
      context: context,
      applicationName: info.appName,
      applicationVersion: '${info.version}+${info.buildNumber}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.aboutAttributions)),
      body: Query(
        options: QueryOptions(document: documentNodeQueryattributionsQuery),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          // An older server without the attributions query just shows the
          // fallback line instead of an error page.
          final attributions = result.hasException || result.data == null
              ? const <Query$attributionsQuery$attributions>[]
              : Query$attributionsQuery.fromJson(result.data!).attributions;
          final loading = result.isLoading && result.data == null;

          return Skeletonizer(
            enabled: loading,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    result.hasException && attributions.isEmpty
                        ? loc.attributionsUnavailable
                        : loc.attributionsIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                for (final attribution in attributions)
                  Card(
                    child: ListTile(
                      title: Text(attribution.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (attribution.url != null) Text(attribution.url!),
                          if (attribution.notice != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(attribution.notice!),
                            ),
                          if (attribution.license != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(loc
                                  .attributionLicense(attribution.license!)),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(loc.openSourceLicenses),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showLicenses(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
