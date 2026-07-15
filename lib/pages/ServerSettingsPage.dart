import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:player/routes/AppRouter.gr.dart';

import '../l10n/app_localizations.dart';

@RoutePage()
class ServerSettingsPage extends StatelessWidget {
  const ServerSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required String serverName,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.languageSettings),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => AutoRouter.of(context)
                      .push(ServerSettingsLanguageRoute()),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.dns),
                  title: Text(loc.server),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => AutoRouter.of(context)
                      .push(ServerSettingsClusterRoute()),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.speaker_group_outlined),
                  title: Text(loc.nowPlaying),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AutoRouter.of(context).push(ServerNowPlayingRoute()),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.monitor_heart_outlined),
                  title: Text(loc.serverActivity),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AutoRouter.of(context).push(ServerActivityRoute()),
                ),
                if (!kIsWeb) ...[
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: Text(loc.playbackSettings),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => AutoRouter.of(context)
                        .push(ServerSettingsPlaybackRoute()),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final info = snapshot.data;
                if (info == null) {
                  return const SizedBox.shrink();
                }
                const commit =
                    String.fromEnvironment('GIT_COMMIT', defaultValue: '');
                var version = '${info.version}+${info.buildNumber}';
                if (commit.isNotEmpty) {
                  version = '$version ($commit)';
                }
                return Text(
                  loc.appVersion(version),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
