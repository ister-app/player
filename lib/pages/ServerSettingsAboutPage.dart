import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:player/graphql/attributions.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/SettingsSection.dart';
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

  static final Uri _websiteUrl = Uri.parse('https://ister.app');
  static final Uri _sourceUrl = Uri.parse('https://github.com/ister-app');

  /// How many attribution cards the skeleton reserves. Servers list a handful
  /// of metadata sources, so this is deliberately a small, fixed number.
  static const int _skeletonAttributionCount = 3;

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
                // The attributions are the only thing that loads here. The
                // intro and the project links keep their colour *and* their
                // taps: Skeletonizer makes its whole subtree unhittable, which
                // left three working links grey and dead during the query.
                Skeleton.keep(
                  child: SettingsIntro(
                      result.hasException && attributions.isEmpty
                          ? loc.attributionsUnavailable
                          : loc.attributionsIntro),
                ),
                if (loading || attributions.isNotEmpty)
                  SettingsSectionLabel(loc.aboutSectionSources),
                // Bones for the cards that are on their way. Without them the
                // skeleton boned only the static content and reserved nothing
                // for the list, so the project section was shoved down on load.
                if (loading)
                  for (var i = 0; i < _skeletonAttributionCount; i++)
                    SettingsCard(children: [
                      ListTile(
                        title: Text(BoneMock.name),
                        subtitle: Text(BoneMock.words(3)),
                      ),
                    ]),
                for (final attribution in attributions)
                  SettingsCard(children: [
                    ListTile(
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
                  ]),
                Skeleton.keep(
                    child: SettingsSectionLabel(loc.aboutSectionProject)),
                Skeleton.keep(
                    child: SettingsCard(children: [
                      ListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: Text(loc.projectWebsite),
                        subtitle: Text(_websiteUrl.host),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => launchUrl(_websiteUrl,
                            mode: LaunchMode.externalApplication),
                      ),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: Text(loc.projectSourceCode),
                        subtitle:
                            Text('${_sourceUrl.host}${_sourceUrl.path}'),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => launchUrl(_sourceUrl,
                            mode: LaunchMode.externalApplication),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(loc.openSourceLicenses),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLicenses(context),
                      ),
                ])),
              ],
            ),
          );
        },
      ),
    );
  }
}
