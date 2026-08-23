import 'package:flutter/material.dart';
import 'package:oidc/oidc.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AddServerPage.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// The sign-in screen for one server: who you are signing in to, what will
/// happen, one button — and on Android TV the device-code QR and code while
/// [deviceAuthResponse] is pending.
class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.info,
    required this.onLogin,
    required this.onSwitchServer,
    this.deviceAuthResponse,
  });

  final WellKnownInfo info;
  final VoidCallback onLogin;
  final VoidCallback onSwitchServer;
  final OidcDeviceAuthorizationResponse? deviceAuthResponse;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final pending = deviceAuthResponse != null;
    return Center(
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
              Text(info.name,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(info.serverUrl,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Text(loc.loginExplanation, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                autofocus: true,
                onPressed: pending ? null : onLogin,
                icon: const Icon(Icons.login),
                label: Text(pending
                    ? loc.waitingForLogin
                    : loc.loginButton(info.name)),
              ),
              if (pending) ...[
                const SizedBox(height: 24),
                _DeviceFlowCard(response: deviceAuthResponse!),
              ],
              const SizedBox(height: 12),
              TextButton(
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

class _DeviceFlowCard extends StatelessWidget {
  const _DeviceFlowCard({required this.response});

  final OidcDeviceAuthorizationResponse response;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(loc.deviceFlowInstructions, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            QrImageView(
              data: (response.verificationUriComplete ??
                      response.verificationUri)
                  .toString(),
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            SelectableText(
              response.verificationUri.toString(),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              response.userCode,
              style: theme.textTheme.displaySmall?.copyWith(
                letterSpacing: 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
