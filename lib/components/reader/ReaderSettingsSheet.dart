import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/epub/ReaderPreferences.dart';

/// Bottom sheet with the reading settings: font size and theme. Changes are
/// applied (and persisted) immediately through the callbacks.
class ReaderSettingsSheet extends StatefulWidget {
  const ReaderSettingsSheet({
    super.key,
    required this.fontScale,
    required this.theme,
    required this.onFontScaleChanged,
    required this.onThemeChanged,
  });

  final double fontScale;
  final ReaderTheme theme;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<ReaderTheme> onThemeChanged;

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  late double _fontScale = widget.fontScale;
  late ReaderTheme _theme = widget.theme;

  static const double _step = 0.1;

  String _themeLabel(AppLocalizations loc, ReaderTheme theme) =>
      switch (theme) {
        ReaderTheme.light => loc.readerThemeLight,
        ReaderTheme.sepia => loc.readerThemeSepia,
        ReaderTheme.dark => loc.readerThemeDark,
      };

  void _setFontScale(double value) {
    final clamped = value.clamp(
        ReaderPreferences.minFontScale, ReaderPreferences.maxFontScale);
    setState(() => _fontScale = clamped);
    widget.onFontScaleChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.readerSettings,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(loc.fontSize, style: Theme.of(context).textTheme.labelLarge),
            Row(
              children: [
                TvFocusable(
                  onTap: () => _setFontScale(_fontScale - _step),
                  child: IconButton(
                    onPressed: () => _setFontScale(_fontScale - _step),
                    icon: const Icon(Icons.text_decrease),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _fontScale,
                    min: ReaderPreferences.minFontScale,
                    max: ReaderPreferences.maxFontScale,
                    divisions: ((ReaderPreferences.maxFontScale -
                                ReaderPreferences.minFontScale) /
                            _step)
                        .round(),
                    label: '${(_fontScale * 100).round()}%',
                    onChanged: _setFontScale,
                  ),
                ),
                TvFocusable(
                  onTap: () => _setFontScale(_fontScale + _step),
                  child: IconButton(
                    onPressed: () => _setFontScale(_fontScale + _step),
                    icon: const Icon(Icons.text_increase),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(loc.readerTheme,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ReaderTheme>(
              segments: [
                for (final theme in ReaderTheme.values)
                  ButtonSegment(
                    value: theme,
                    label: Text(_themeLabel(loc, theme)),
                    icon: CircleAvatar(
                      radius: 8,
                      backgroundColor: theme.background,
                    ),
                  ),
              ],
              selected: {_theme},
              onSelectionChanged: (selection) {
                setState(() => _theme = selection.first);
                widget.onThemeChanged(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
