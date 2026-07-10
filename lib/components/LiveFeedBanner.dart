import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Shown when a live subscription dropped and is being retried, so a stale
/// page never masquerades as a live one.
class LiveFeedBanner extends StatelessWidget {
  const LiveFeedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: scheme.errorContainer,
        child: ListTile(
          dense: true,
          leading: Icon(Icons.cloud_off, size: 20, color: scheme.onErrorContainer),
          title: Text(
            loc.liveUpdatesUnavailable,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: scheme.onErrorContainer),
          ),
        ),
      ),
    );
  }
}
