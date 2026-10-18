import 'package:material_ui/material_ui.dart';
import 'package:player/utils/games/GameLabels.dart';
import 'package:player/utils/games/GameLibraryService.dart';

import '../../l10n/app_localizations.dart';

/// Both sides of a save conflict — the newer snapshot on the server and the
/// changed saves on this computer — as a choice; `Continue` returns the
/// picked [SaveConflictChoice], backing out returns `cancel`.
class SaveConflictDialog extends StatefulWidget {
  const SaveConflictDialog({super.key, required this.conflict});

  final SaveConflict conflict;

  static Future<SaveConflictChoice> show(BuildContext context, SaveConflict conflict) async =>
      await showDialog<SaveConflictChoice>(
        context: context,
        builder: (context) => SaveConflictDialog(conflict: conflict),
      ) ??
      SaveConflictChoice.cancel;

  @override
  State<SaveConflictDialog> createState() => _SaveConflictDialogState();
}

class _SaveConflictDialogState extends State<SaveConflictDialog> {
  SaveConflictChoice _choice = SaveConflictChoice.useServer;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final head = widget.conflict.serverHead;
    final local = widget.conflict.localModified;
    final lastSynced = widget.conflict.install.lastSaveVersion;
    return AlertDialog(
      title: Text(loc.gameSaveConflictTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioGroup<SaveConflictChoice>(
            groupValue: _choice,
            onChanged: (value) => setState(() => _choice = value ?? _choice),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<SaveConflictChoice>(
                  key: const ValueKey('game-conflict-server'),
                  value: SaveConflictChoice.useServer,
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.gameSaveConflictServer),
                  subtitle: Text(loc.gameSaveConflictServerLine(
                      head.version, head.deviceName ?? '—', GameLabels.dateTime(head.createdAt))),
                ),
                RadioListTile<SaveConflictChoice>(
                  key: const ValueKey('game-conflict-local'),
                  value: SaveConflictChoice.keepLocal,
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.gameSaveConflictLocal),
                  subtitle: Text(local == null
                      ? loc.gameSaveConflictLocalLineUnknown(lastSynced)
                      : loc.gameSaveConflictLocalLine(lastSynced, GameLabels.dateTime(local))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(loc.gameSaveConflictHistoryNote, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(SaveConflictChoice.cancel),
          child: Text(loc.cancel),
        ),
        FilledButton(
          key: const ValueKey('game-conflict-continue'),
          onPressed: () => Navigator.of(context).pop(_choice),
          child: Text(loc.gameContinue),
        ),
      ],
    );
  }
}
