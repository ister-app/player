import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/upload/GameUploadNaming.dart';

/// The two fields a game folder is composed from — `Title (year)` — with
/// the year optional and checked, and a line saying where the game lands.
class GameTitleYearFields extends StatelessWidget {
  const GameTitleYearFields({
    super.key,
    required this.title,
    required this.year,
    required this.onChanged,
    this.platformFolder,
    this.autofocus = false,
  });

  final TextEditingController title;
  final TextEditingController year;
  final VoidCallback onChanged;

  /// When given, the preview line reads `Uploads as <platformFolder>/<folder>/`.
  final String? platformFolder;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final yearOk = GameUploadNaming.isValidYear(year.text);
    final folder = GameUploadNaming.compose(title.text, year.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                key: const ValueKey('upload-game-title'),
                controller: title,
                autofocus: autofocus,
                decoration: InputDecoration(labelText: loc.uploadGameTitle),
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                key: const ValueKey('upload-game-year'),
                controller: year,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: loc.uploadGameYear,
                  errorText: yearOk ? null : loc.uploadGameYearInvalid,
                ),
                onChanged: (_) => onChanged(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          folder.isEmpty ? loc.uploadGameTitleRequired : loc.uploadGameFolderPreview(platformFolder ?? '?', folder),
          key: const ValueKey('upload-game-folder-preview'),
          style: theme.textTheme.bodySmall?.copyWith(color: folder.isEmpty ? theme.colorScheme.error : null),
        ),
      ],
    );
  }
}

/// A dialog around [GameTitleYearFields]; returns the edited pair or null.
Future<({String title, String? year})?> showGameTitleYearDialog(BuildContext context,
    {required String title, required String? year, required String platformFolder}) {
  final loc = AppLocalizations.of(context)!;
  final titleController = TextEditingController(text: title);
  final yearController = TextEditingController(text: year ?? '');
  return showDialog<({String title, String? year})>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final valid = titleController.text.trim().isNotEmpty && GameUploadNaming.isValidYear(yearController.text);
        return AlertDialog(
          title: Text(loc.uploadGamesEditTitle),
          content: SizedBox(
            width: 480,
            child: GameTitleYearFields(
              title: titleController,
              year: yearController,
              platformFolder: platformFolder,
              autofocus: true,
              onChanged: () => setState(() {}),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(loc.cancel)),
            FilledButton(
              key: const ValueKey('upload-game-edit-save'),
              onPressed: valid
                  ? () {
                      final y = yearController.text.trim();
                      Navigator.of(context).pop((title: titleController.text.trim(), year: y.isEmpty ? null : y));
                    }
                  : null,
              child: Text(loc.uploadGamesSave),
            ),
          ],
        );
      },
    ),
  );
}
