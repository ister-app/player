import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'TvFocusable.dart';

/// The label above a carousel row ("Continue watching:", a library name, ...).
///
/// With [onTap] set the header becomes the row's "show all" affordance: it
/// gains a chevron and opens the row's full vertical list. Without [onTap] it
/// renders exactly like the plain header it replaces.
class RowHeader extends StatelessWidget {
  const RowHeader({
    super.key,
    required this.label,
    this.onTap,
    this.style,
    this.padding = const EdgeInsets.all(5),
    this.trailingColon = true,
  });

  final String label;
  final VoidCallback? onTap;

  /// Overrides the default bold bodyMedium (the cast header uses titleMedium).
  final TextStyle? style;
  final EdgeInsetsGeometry padding;

  /// The carousel headers end in a colon; the cast header does not.
  final bool trailingColon;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold);
    final text = trailingColon ? '$label:' : label;
    if (onTap == null) {
      return Container(
        padding: padding,
        child: Text(text, style: textStyle),
      );
    }
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Tooltip(
        message: AppLocalizations.of(context)!.showAll,
        child: TvFocusable(
          onTap: onTap,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Padding(
                padding: padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text, style: textStyle),
                    Icon(Icons.chevron_right,
                        size: (textStyle.fontSize ?? 14) + 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
