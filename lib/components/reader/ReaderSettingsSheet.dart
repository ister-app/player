import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/epub/ReaderPreferences.dart';

/// Bottom sheet with the reading settings: font size, line spacing, margins,
/// font and theme. Changes are applied (and persisted) immediately through
/// the callbacks.
class ReaderSettingsSheet extends StatefulWidget {
  const ReaderSettingsSheet({
    super.key,
    required this.fontScale,
    required this.lineHeight,
    required this.margin,
    required this.fontFamily,
    required this.theme,
    required this.onFontScaleChanged,
    required this.onLineHeightChanged,
    required this.onMarginChanged,
    required this.onFontFamilyChanged,
    required this.onThemeChanged,
  });

  final double fontScale;
  final double lineHeight;
  final double margin;
  final ReaderFontFamily fontFamily;
  final ReaderTheme theme;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<double> onMarginChanged;
  final ValueChanged<ReaderFontFamily> onFontFamilyChanged;
  final ValueChanged<ReaderTheme> onThemeChanged;

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  late double _fontScale = widget.fontScale;
  late double _lineHeight = widget.lineHeight;
  late double _margin = widget.margin;
  late ReaderFontFamily _fontFamily = widget.fontFamily;
  late ReaderTheme _theme = widget.theme;

  static const double _step = 0.1;
  static const double _marginStep = 8;

  String _themeLabel(AppLocalizations loc, ReaderTheme theme) =>
      switch (theme) {
        ReaderTheme.light => loc.readerThemeLight,
        ReaderTheme.sepia => loc.readerThemeSepia,
        ReaderTheme.dark => loc.readerThemeDark,
      };

  String _fontLabel(AppLocalizations loc, ReaderFontFamily family) =>
      switch (family) {
        ReaderFontFamily.standard => loc.readerFontStandard,
        ReaderFontFamily.serif => loc.readerFontSerif,
        ReaderFontFamily.sans => loc.readerFontSans,
      };

  void _setFontScale(double value) {
    final clamped = value.clamp(
        ReaderPreferences.minFontScale, ReaderPreferences.maxFontScale);
    setState(() => _fontScale = clamped);
    widget.onFontScaleChanged(clamped);
  }

  void _setLineHeight(double value) {
    final clamped = value.clamp(
        ReaderPreferences.minLineHeight, ReaderPreferences.maxLineHeight);
    setState(() => _lineHeight = clamped);
    widget.onLineHeightChanged(clamped);
  }

  void _setMargin(double value) {
    final clamped =
        value.clamp(ReaderPreferences.minMargin, ReaderPreferences.maxMargin);
    setState(() => _margin = clamped);
    widget.onMarginChanged(clamped);
  }

  /// A slider row with `TvFocusable` stepper buttons on either side, the
  /// layout every numeric setting in this sheet shares.
  Widget _stepperSlider({
    required double value,
    required double min,
    required double max,
    required double step,
    required String label,
    required IconData decreaseIcon,
    required IconData increaseIcon,
    required ValueChanged<double> onChanged,
  }) =>
      Row(
        children: [
          TvFocusable(
            onTap: () => onChanged(value - step),
            child: IconButton(
              onPressed: () => onChanged(value - step),
              icon: Icon(decreaseIcon),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / step).round(),
              label: label,
              onChanged: onChanged,
            ),
          ),
          TvFocusable(
            onTap: () => onChanged(value + step),
            child: IconButton(
              onPressed: () => onChanged(value + step),
              icon: Icon(increaseIcon),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      // Scrollable: with every typography setting the sheet outgrows a small
      // landscape screen.
      child: SingleChildScrollView(
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
              _stepperSlider(
                value: _fontScale,
                min: ReaderPreferences.minFontScale,
                max: ReaderPreferences.maxFontScale,
                step: _step,
                label: '${(_fontScale * 100).round()}%',
                decreaseIcon: Icons.text_decrease,
                increaseIcon: Icons.text_increase,
                onChanged: _setFontScale,
              ),
              Text(loc.lineHeight,
                  style: Theme.of(context).textTheme.labelLarge),
              _stepperSlider(
                value: _lineHeight,
                min: ReaderPreferences.minLineHeight,
                max: ReaderPreferences.maxLineHeight,
                step: _step,
                label: _lineHeight.toStringAsFixed(1),
                decreaseIcon: Icons.density_small,
                increaseIcon: Icons.density_large,
                onChanged: _setLineHeight,
              ),
              Text(loc.pageMargins,
                  style: Theme.of(context).textTheme.labelLarge),
              _stepperSlider(
                value: _margin,
                min: ReaderPreferences.minMargin,
                max: ReaderPreferences.maxMargin,
                step: _marginStep,
                label: _margin.round().toString(),
                decreaseIcon: Icons.format_indent_decrease,
                increaseIcon: Icons.format_indent_increase,
                onChanged: _setMargin,
              ),
              Text(loc.readerFont,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<ReaderFontFamily>(
                segments: [
                  for (final family in ReaderFontFamily.values)
                    ButtonSegment(
                      value: family,
                      label: Text(
                        _fontLabel(loc, family),
                        style: TextStyle(fontFamily: family.fontFamily),
                      ),
                    ),
                ],
                selected: {_fontFamily},
                onSelectionChanged: (selection) {
                  setState(() => _fontFamily = selection.first);
                  widget.onFontFamilyChanged(selection.first);
                },
              ),
              const SizedBox(height: 16),
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
      ),
    );
  }
}
