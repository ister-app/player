import 'package:flutter/material.dart';

/// The one section-header style shared by every settings screen.
///
/// Lifted out of ServerSettingsLanguagePage, which grew it first; the settings
/// hub, playback, downloads and sleep-timer pages all render it now so the
/// headers line up wherever you land.
class SettingsSectionLabel extends StatelessWidget {
  final String title;

  const SettingsSectionLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

/// A labelled section holding [children] in a single card, with hairline
/// dividers between them — the settings-hub shape.
///
/// [trailing] is appended verbatim, without an auto-divider: it is meant for
/// permission-gated rows that collapse to nothing (see [AdminGate]) and
/// therefore have to carry their own leading divider, or leave no stray one
/// behind when they are hidden.
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (final child in children) {
      if (rows.isNotEmpty) {
        rows.add(const Divider(height: 1, indent: 56));
      }
      rows.add(child);
    }
    if (trailing != null) rows.add(trailing!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionLabel(title),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: rows),
        ),
      ],
    );
  }
}
