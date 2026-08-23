import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/download/DownloadService.dart';

/// "Open downloads" on the server-unreachable screens — only when this
/// device actually holds something playable for the server.
class OfflineDownloadsButton extends StatelessWidget {
  const OfflineDownloadsButton({super.key, required this.serverName});

  final String serverName;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    final service = DownloadService.instance;
    return FutureBuilder<void>(
      future: service.ensureStarted().then((_) => service.store.load(serverName)),
      builder: (context, _) => ValueListenableBuilder<int>(
        valueListenable: service.revision,
        builder: (context, __, ___) {
          final any = service.entriesFor(serverName).any((e) => e.isComplete);
          if (!any) return const SizedBox.shrink();
          return OutlinedButton.icon(
            onPressed: () => context.router.root
                .push(DownloadsRoute(serverName: serverName)),
            icon: const Icon(Icons.download_done),
            label: Text(loc.openDownloads),
          );
        },
      ),
    );
  }
}
