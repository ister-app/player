import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/AppLogStore.dart';
import '../utils/LoggerService.dart';

/// Settings action that saves the rolling app log ([AppLogStore]) to a
/// user-chosen location through the system save dialog (SAF on Android, the
/// XDG portal on Linux — flatpak-safe).
class SaveLogTile extends StatelessWidget {
  const SaveLogTile({super.key, this.store});

  /// Test seam; defaults to [AppLogStore.instance].
  final AppLogStore? store;

  /// Test seam replacing the file_picker save dialog. Returns the saved
  /// location, or null when the user cancelled.
  @visibleForTesting
  static Future<Uri?> Function(String fileName, Uint8List bytes)?
      savePickerOverride;

  Future<void> _save(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await (store ?? AppLogStore.instance).exportBytes();
      if (bytes == null) {
        messenger.showSnackBar(SnackBar(content: Text(loc.errorLogEmpty)));
        return;
      }
      final date = DateTime.now().toIso8601String().split('T').first;
      final fileName = 'ister-log-$date.txt';
      final saved = savePickerOverride != null
          ? await savePickerOverride!(fileName, bytes)
          : await FilePicker.saveFile(
              fileName: fileName,
              bytes: bytes,
              mimeType: 'text/plain',
            );
      if (saved == null) return; // Cancelled — nothing to report.
      messenger.showSnackBar(SnackBar(content: Text(loc.errorLogSaved)));
    } catch (e) {
      LoggerService().logger.w('saving the error log failed: $e');
      messenger
          .showSnackBar(SnackBar(content: Text(loc.errorLogSaveFailed('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.save_alt),
      title: Text(loc.saveErrorLog),
      subtitle: Text(loc.saveErrorLogSubtitle),
      onTap: () => _save(context),
    );
  }
}
