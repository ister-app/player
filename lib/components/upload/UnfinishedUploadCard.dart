import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../routes/AppRouter.gr.dart';
import '../../utils/upload/UploadApi.dart';
import '../../utils/upload/UploadResumeStore.dart';
import '../../utils/upload/UploadSource.dart';

/// A reminder on the server's home that an upload from an earlier run of the
/// app is still open — closing the app mid-upload only pauses it, but the
/// page that continues it sits three levels down in the settings, and nothing
/// used to point there. One tap takes the user to it and continues.
///
/// Renders nothing while the store is read and when there is nothing to
/// resume, so the home never shifts for a server without an upload.
class UnfinishedUploadCard extends StatefulWidget {
  const UnfinishedUploadCard({super.key, required this.serverName, this.store, this.api, this.onResume});

  final String serverName;
  final UploadResumeStore? store;
  final UploadApi? api;

  /// Test seam; the default opens the upload page with `resume`.
  final VoidCallback? onResume;

  @override
  State<UnfinishedUploadCard> createState() => _UnfinishedUploadCardState();
}

class _UnfinishedUploadCardState extends State<UnfinishedUploadCard> {
  late final Future<StoredUpload?> _unfinished = uploadSourceSupported || widget.store != null
      ? (widget.store ?? UploadResumeStore(widget.serverName)).loadUnfinished(widget.api ?? UploadApi(widget.serverName))
      : Future.value(null);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoredUpload?>(
      future: _unfinished,
      builder: (context, snapshot) {
        final unfinished = snapshot.data;
        if (unfinished == null) return const SizedBox.shrink();
        final loc = AppLocalizations.of(context)!;
        final scheme = Theme.of(context).colorScheme;
        final title = unfinished.displayTitle;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Card(
            key: const ValueKey('home-unfinished-upload'),
            color: scheme.tertiaryContainer,
            child: ListTile(
              leading: Icon(Icons.upload_outlined, color: scheme.onTertiaryContainer),
              title: Text(loc.uploadUnfinishedTitle, style: TextStyle(color: scheme.onTertiaryContainer)),
              subtitle: Text(
                title == null ? loc.uploadUnfinishedHomeBodyUnnamed : loc.uploadUnfinishedHomeBody(title),
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
              trailing: FilledButton.tonal(
                key: const ValueKey('home-unfinished-upload-resume'),
                onPressed: widget.onResume ?? () => AutoRouter.of(context).push(AdminUploadRoute(resume: true)),
                child: Text(loc.uploadResumeNow),
              ),
            ),
          ),
        );
      },
    );
  }
}
