import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.languageSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => AutoRouter.of(context)
                .push(ServerSettingsLanguageRoute()),
          ),
          ListTile(
            leading: const Icon(Icons.dns),
            title: Text(loc.server),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => AutoRouter.of(context)
                .push(ServerSettingsClusterRoute()),
          ),
        ],
      ),
    );
  }
}
