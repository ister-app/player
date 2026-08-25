import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';

import '../components/AdminGate.dart';
import '../components/SaveLogTile.dart';
import '../components/SettingsSection.dart';
import '../utils/AppVersion.dart';
import '../l10n/app_localizations.dart';

/// The settings hub, grouped by scope: what follows you across devices, what
/// only holds here, who else may see or steer your playback, the server, and
/// the app itself.
///
/// The admin entries live in the server section behind an [AdminGate], which
/// collapses to nothing — they are passed as the section's `trailing` so that
/// hiding them leaves no stray divider, while the section header stays put for
/// the always-visible status entry.
@RoutePage()
class ServerSettingsPage extends StatelessWidget {
  final String serverName;

  const ServerSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingsSection(
            key: const ValueKey('settings-section-playback'),
            title: loc.settingsSectionPlayback,
            children: [
              ListTile(
                key: const ValueKey('settings-tile-language'),
                leading: const Icon(Icons.language),
                title: Text(loc.languageSettings),
                subtitle: Text(loc.languageSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerSettingsLanguageRoute()),
              ),
              if (!kIsWeb)
                ListTile(
                  key: const ValueKey('settings-tile-playback'),
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(loc.playbackSettings),
                  subtitle: Text(loc.playbackSettingsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AutoRouter.of(context)
                          .push(ServerSettingsPlaybackRoute()),
                ),
            ],
          ),
          // Every entry here is device-local and absent on web, so the header
          // has to go with them.
          if (!kIsWeb)
            SettingsSection(
              key: const ValueKey('settings-section-this-device'),
              title: loc.settingsSectionThisDevice,
              children: [
                ListTile(
                  key: const ValueKey('settings-tile-downloads'),
                  leading: const Icon(Icons.download_for_offline_outlined),
                  title: Text(loc.downloads),
                  subtitle: Text(loc.downloadsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AutoRouter.of(context).push(ServerDownloadsRoute()),
                ),
                ListTile(
                  key: const ValueKey('settings-tile-sleep-timer'),
                  leading: const Icon(Icons.bedtime_outlined),
                  title: Text(loc.sleepTimer),
                  subtitle: Text(loc.sleepTimerDeviceOnly),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AutoRouter.of(context)
                          .push(const SleepTimerSettingsRoute()),
                ),
              ],
            ),
          SettingsSection(
            key: const ValueKey('settings-section-sharing'),
            title: loc.settingsSectionSharing,
            children: [
              ListTile(
                key: const ValueKey('settings-tile-sharing'),
                leading: const Icon(Icons.shield_outlined),
                title: Text(loc.sharingSettings),
                subtitle: Text(loc.sharingSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerSettingsSharingRoute()),
              ),
              ListTile(
                key: const ValueKey('settings-tile-devices'),
                leading: const Icon(Icons.devices),
                title: Text(loc.devicesTitle),
                subtitle: Text(loc.devicesSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerSettingsDevicesRoute()),
              ),
              ListTile(
                key: const ValueKey('settings-tile-now-playing'),
                leading: const Icon(Icons.speaker_group_outlined),
                title: Text(loc.nowPlaying),
                subtitle: Text(loc.nowPlayingSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerNowPlayingRoute()),
              ),
            ],
          ),
          SettingsSection(
            key: const ValueKey('settings-section-server'),
            title: loc.settingsSectionServer,
            trailing: AdminGate(
              serverName: serverName,
              child: Column(
                children: [
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    key: const ValueKey('settings-tile-users'),
                    leading: const Icon(Icons.manage_accounts_outlined),
                    title: Text(loc.usersAndAccess),
                    subtitle: Text(loc.usersAndAccessSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => AutoRouter.of(context).push(AdminUsersRoute()),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    key: const ValueKey('settings-tile-libraries'),
                    leading: const Icon(Icons.visibility_outlined),
                    title: Text(loc.libraryVisibility),
                    subtitle: Text(loc.libraryVisibilitySubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        AutoRouter.of(context).push(AdminLibrariesRoute()),
                  ),
                ],
              ),
            ),
            children: [
              ListTile(
                key: const ValueKey('settings-tile-server'),
                leading: const Icon(Icons.dns),
                title: Text(loc.serverStatusAndMaintenance),
                subtitle: Text(loc.serverSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerSettingsClusterRoute()),
              ),
            ],
          ),
          SettingsSection(
            key: const ValueKey('settings-section-app'),
            title: loc.settingsSectionApp,
            children: [
              if (!kIsWeb) const SaveLogTile(),
              ListTile(
                key: const ValueKey('settings-tile-about'),
                leading: const Icon(Icons.info_outline),
                title: Text(loc.aboutAttributions),
                subtitle: Text(loc.aboutAttributionsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    AutoRouter.of(context).push(ServerSettingsAboutRoute()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: FutureBuilder<String>(
              future: appVersionString(),
              builder: (context, snapshot) {
                final version = snapshot.data;
                if (version == null) {
                  return const SizedBox.shrink();
                }
                return Text(
                  loc.appVersion(version),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).disabledColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
