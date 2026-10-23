import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/games/GameLabels.dart';
import '../../utils/upload/GameFoundProbe.dart';

/// After a game upload: the game as the library lists it, with a button to
/// its page and — for PC and Steam games — whether its saves will sync.
class GameFoundTile extends StatelessWidget {
  const GameFoundTile({super.key, required this.found, required this.onOpen, this.dense = false});

  final FoundGame found;
  final VoidCallback onOpen;
  final bool dense;

  /// The Ludusavi verdict line, null for games whose saves stay in the emulator.
  static String? savesLine(AppLocalizations loc, FoundGame found) {
    if (!found.usesSavePaths) return null;
    return switch (found.savePathSource) {
      'MANIFEST' => loc.uploadGameSavesKnown,
      'ADMIN' => loc.uploadGameSavesAdmin,
      _ => loc.uploadGameSavesUnknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final saves = savesLine(loc, found);
    return ListTile(
      key: const ValueKey('upload-game-found'),
      dense: dense,
      leading: Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
      title: Text(loc.uploadGameFound(found.title, GameLabels.platform(found.platform))),
      subtitle: saves == null ? null : Text(saves),
      trailing: TextButton(
        key: const ValueKey('upload-game-open'),
        onPressed: onOpen,
        child: Text(loc.gameOpenPage),
      ),
    );
  }
}
