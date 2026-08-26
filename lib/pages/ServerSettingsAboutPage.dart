import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:player/graphql/attributions.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/AppVersion.dart';
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

  /// The kind of catalogue a provider is, so the rows read as a list of
  /// sources rather than four identical link tiles.
  static IconData _sourceIcon(Enum$MetadataSource source) {
    switch (source) {
      case Enum$MetadataSource.TMDB:
        return Icons.movie_outlined;
      case Enum$MetadataSource.MUSICBRAINZ:
      case Enum$MetadataSource.COVER_ART_ARCHIVE:
        return Icons.album_outlined;
      case Enum$MetadataSource.OPEN_LIBRARY:
        return Icons.menu_book_outlined;
      case Enum$MetadataSource.WIKIPEDIA:
      case Enum$MetadataSource.WIKIDATA:
      case Enum$MetadataSource.WIKIMEDIA_COMMONS:
        return Icons.article_outlined;
      case Enum$MetadataSource.PODCAST_FEED:
        return Icons.podcasts_outlined;
      case Enum$MetadataSource.LOCAL_FILE:
      case Enum$MetadataSource.$unknown:
        return Icons.public;
    }
  }

  /// `https://www.themoviedb.org/` → `themoviedb.org`: the bare domain is
  /// what identifies the provider; the scheme and a `www.` are noise in a
  /// subtitle that also has to carry a notice and a license.
  static String _displayUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return url;
    final host = uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host;
    final path = uri.path == '/' ? '' : uri.path;
    return '$host$path';
  }

  /// One provider row: the domain as the subtitle, with the notice and
  /// license the provider mandates underneath in a quieter style.
  Widget _attributionTile(
    BuildContext context,
    AppLocalizations loc,
    Query$attributionsQuery$attributions attribution,
  ) {
    final theme = Theme.of(context);
    final fine = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final url = attribution.url;
    return ListTile(
      leading: Icon(_sourceIcon(attribution.source)),
      title: Text(attribution.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (url != null) Text(_displayUrl(url)),
          if (attribution.notice != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(attribution.notice!, style: fine),
            ),
          if (attribution.license != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                loc.attributionLicense(attribution.license!),
                style: fine,
              ),
            ),
        ],
      ),
      trailing: url == null ? null : const Icon(Icons.open_in_new),
      onTap: url == null
          ? null
          : () =>
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.aboutAttributions)),
      body: Query(
        options: QueryOptions(document: documentNodeQueryattributionsQuery),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
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
                        : loc.attributionsIntro,
                  ),
                ),
                // One card, one row per provider — a card each turned four
                // sources into four floating boxes with no shared alignment.
                // Bones for the rows that are on their way: without them the
                // skeleton boned only the static content and reserved nothing
                // for the list, so the project section was shoved down on load.
                if (loading)
                  SettingsSection(
                    title: loc.aboutSectionSources,
                    children: [
                      for (var i = 0; i < _skeletonAttributionCount; i++)
                        ListTile(
                          leading: const Icon(Icons.public),
                          title: Text(BoneMock.name),
                          subtitle: Text(BoneMock.words(3)),
                        ),
                    ],
                  )
                else if (attributions.isNotEmpty)
                  SettingsSection(
                    title: loc.aboutSectionSources,
                    children: [
                      for (final attribution in attributions)
                        _attributionTile(context, loc, attribution),
                    ],
                  ),
                Skeleton.keep(
                  child: SettingsSectionLabel(loc.aboutSectionProject),
                ),
                Skeleton.keep(
                  child: SettingsCard(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: Text(loc.projectWebsite),
                        subtitle: Text(_websiteUrl.host),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => launchUrl(
                          _websiteUrl,
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: Text(loc.projectSourceCode),
                        subtitle: Text('${_sourceUrl.host}${_sourceUrl.path}'),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => launchUrl(
                          _sourceUrl,
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(loc.openSourceLicenses),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLicenses(context),
                      ),
                      // The settings entry promises the app version lives
                      // here, and the license page is the only other place
                      // that shows it.
                      FutureBuilder<String>(
                        future: appVersionString(),
                        builder: (context, snapshot) {
                          final version = snapshot.data;
                          if (version == null) return const SizedBox.shrink();
                          return ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(loc.appVersion(version)),
                          );
                        },
                      ),
                    ],
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
