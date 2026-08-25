import 'package:flutter/material.dart';

/// The building blocks every settings screen is made of.
///
/// Before these existed each page invented its own: three section-label styles
/// (two of them the muted `labelMedium` this one replaced), three styles of
/// explanatory prose, and cards that were flush on one page and inset by the
/// Material default margin on the next. A page assembled from [SettingsIntro],
/// [SettingsSection]/[SettingsCard], [SettingsEmptyState] and
/// [SettingsErrorState] lines up with every other one.

/// The one section-header style shared by every settings screen.
///
/// Deliberately louder than the rows it heads: accented, bold and a size up.
/// The muted label style it started as read as just another line of helper
/// text on pages that carry tile subtitles or hints under every row.
class SettingsSectionLabel extends StatelessWidget {
  final String title;

  const SettingsSectionLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// The paragraph at the top of a settings page: what this screen is for and,
/// where it matters, whether the setting travels with the account or stays on
/// this device. Always the first child of the page's list.
class SettingsIntro extends StatelessWidget {
  final String text;

  const SettingsIntro(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 12.0),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

/// A line of explanation under a [SettingsSectionLabel] — smaller than
/// [SettingsIntro], because it qualifies one section rather than the page.
class SettingsHint extends StatelessWidget {
  final String text;

  const SettingsHint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

/// A settings card: flush with the page padding (the Material default margin
/// would inset it by 4 and misalign it against the section labels) and with a
/// hairline between its rows.
///
/// [trailing] is appended verbatim, without an auto-divider: it is meant for
/// permission-gated rows that collapse to nothing (see AdminGate) and
/// therefore have to carry their own leading divider, or leave no stray one
/// behind when they are hidden.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final Widget? trailing;
  final Clip? clipBehavior;

  const SettingsCard({
    super.key,
    required this.children,
    this.trailing,
    this.clipBehavior,
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
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: clipBehavior,
      child: Column(children: rows),
    );
  }
}

/// A labelled section: header, optional [hint], then the rows in one card.
class SettingsSection extends StatelessWidget {
  final String title;
  final String? hint;
  final List<Widget> children;
  final Widget? trailing;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.hint,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionLabel(title),
        if (hint != null) SettingsHint(hint!),
        SettingsCard(trailing: trailing, children: children),
      ],
    );
  }
}

/// The "there is nothing here yet" hero, shared so that an empty device list
/// looks like an empty download list.
class SettingsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;

  const SettingsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.disabledColor),
            const SizedBox(height: 16),
            Text(title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message!, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

/// The failure hero. [details] is the raw exception: kept reachable for a bug
/// report, but never the headline — several of these pages used to render
/// `exception.toString()` as their entire body.
class SettingsErrorState extends StatelessWidget {
  final String message;
  final String? details;
  final String detailsLabel;

  const SettingsErrorState({
    super.key,
    required this.message,
    required this.detailsLabel,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        // Without a bound the disclosure row runs the full page width while
        // the headline above it stays centred.
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.disabledColor),
              const SizedBox(height: 16),
              Text(message,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center),
              if (details != null) ...[
                const SizedBox(height: 8),
                ExpansionTile(
                  key: const ValueKey('settings-error-details'),
                  title: Text(detailsLabel, style: theme.textTheme.bodySmall),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  children: [
                    SelectableText(
                      details!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
