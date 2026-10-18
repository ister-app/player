import 'package:material_ui/material_ui.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';

import '../../l10n/app_localizations.dart';

/// Which Steam library folder a game is restored into, when there are
/// several. Returns null when dismissed.
class SteamLibraryPicker extends StatefulWidget {
  const SteamLibraryPicker({super.key, required this.libraries});

  final List<SteamLibrary> libraries;

  static Future<SteamLibrary?> show(BuildContext context, List<SteamLibrary> libraries) => showDialog<SteamLibrary>(
        context: context,
        builder: (context) => SteamLibraryPicker(libraries: libraries),
      );

  @override
  State<SteamLibraryPicker> createState() => _SteamLibraryPickerState();
}

class _SteamLibraryPickerState extends State<SteamLibraryPicker> {
  late SteamLibrary _choice = widget.libraries.first;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(loc.gamePickSteamLibrary),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioGroup<SteamLibrary>(
            groupValue: _choice,
            onChanged: (value) => setState(() => _choice = value ?? _choice),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final library in widget.libraries)
                  RadioListTile<SteamLibrary>(
                    key: ValueKey('steam-library-${library.path}'),
                    value: library,
                    contentPadding: EdgeInsets.zero,
                    title: Text(library.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(library.path, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(loc.gameSteamLibraryPickerHint, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(loc.cancel)),
        FilledButton(onPressed: () => Navigator.of(context).pop(_choice), child: Text(loc.gameContinue)),
      ],
    );
  }
}
