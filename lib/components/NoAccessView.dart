import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AddServerPage.dart';
import 'package:player/utils/WellKnownService.dart';

/// Shown when the user is signed in but the server refuses to serve them:
/// the account lacks the `user` role. A sibling of [LoginView] with the same
/// layout, so the two states read as one flow.
class NoAccessView extends StatelessWidget {
  const NoAccessView({
    super.key,
    required this.info,
    required this.onLogout,
    required this.onSwitchServer,
  });

  static const Key viewKey = ValueKey('no-access-view');
  static const Key logoutKey = ValueKey('no-access-logout');
  static const Key switchServerKey = ValueKey('no-access-switch-server');

  final WellKnownInfo info;
  final VoidCallback onLogout;
  final VoidCallback onSwitchServer;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      key: viewKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: FittedBox(child: ServerAvatar(name: info.name)),
              ),
              const SizedBox(height: 16),
              Icon(Icons.lock_outline,
                  size: 40, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(loc.noAccessTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(info.serverUrl,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Text(loc.noAccessDescription(info.name),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: logoutKey,
                autofocus: true,
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: Text(loc.loginAgain),
              ),
              const SizedBox(height: 12),
              TextButton(
                key: switchServerKey,
                onPressed: onSwitchServer,
                child: Text(loc.chooseAnotherServer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
