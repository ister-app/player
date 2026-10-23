import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../pages/DownloadsPage.dart' show formatBytes;
import '../../utils/upload/games/GameUploadCandidate.dart';

/// One game the scanner found: a checkbox, the folder it becomes, where it
/// came from, and the badges that tell the admin whether to tick it.
class GameCandidateTile extends StatelessWidget {
  const GameCandidateTile({
    super.key,
    required this.candidate,
    required this.selected,
    required this.inLibrary,
    required this.onSelected,
    required this.onEdit,
  });

  final GameUploadCandidate candidate;
  final bool selected;
  final bool inLibrary;
  final ValueChanged<bool> onSelected;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = candidate.sizeBytes;
    final details = <String>[
      candidate.sourcePath,
      if (candidate.steamAppId != null) loc.uploadGamesSteamApp(candidate.steamAppId!),
      if (candidate.titleId != null) candidate.titleId!,
      if (candidate.treePrefix != null) loc.uploadGamesFromRpcs3,
      size == null ? loc.uploadGamesSizeUnknown : formatBytes(size),
    ];
    final badges = <Widget>[
      if (inLibrary) _badge(theme, loc.uploadGamesInLibrary, theme.colorScheme.secondaryContainer, theme.colorScheme.onSecondaryContainer),
      if (candidate.conflictWith != null)
        _badge(theme, loc.uploadGamesConflict(candidate.conflictWith!), theme.colorScheme.errorContainer, theme.colorScheme.onErrorContainer),
      if (candidate.year == null)
        _badge(theme, loc.uploadGamesNoYear, theme.colorScheme.surfaceContainerHighest, theme.colorScheme.onSurfaceVariant),
    ];
    return CheckboxListTile(
      key: ValueKey('game-candidate-${candidate.id}'),
      value: selected,
      onChanged: (value) => onSelected(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(children: [
        Expanded(child: Text(candidate.rootName, maxLines: 1, overflow: TextOverflow.ellipsis)),
        IconButton(
          key: ValueKey('game-candidate-edit-${candidate.id}'),
          tooltip: loc.uploadGamesEditTitle,
          icon: const Icon(Icons.edit_outlined, size: 18),
          visualDensity: VisualDensity.compact,
          onPressed: onEdit,
        ),
      ]),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(details.join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
        if (badges.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Wrap(spacing: 6, runSpacing: 4, children: badges)),
      ]),
      isThreeLine: badges.isNotEmpty,
    );
  }

  static Widget _badge(ThemeData theme, String text, Color background, Color foreground) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: theme.textTheme.labelSmall?.copyWith(color: foreground)),
      );
}
