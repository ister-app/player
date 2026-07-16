import 'package:flutter/material.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/epub/EpubPackage.dart';

/// The table of contents as an end drawer; the entry whose chapter is on
/// screen is highlighted.
class ReaderTocDrawer extends StatelessWidget {
  const ReaderTocDrawer({
    super.key,
    required this.package,
    required this.currentSpineIndex,
    required this.onEntryTap,
  });

  final EpubPackage package;
  final int currentSpineIndex;
  final void Function(EpubTocEntry entry) onEntryTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Books without any TOC still get chapter navigation: one entry per
    // linear spine item.
    final entries = package.toc.isNotEmpty
        ? package.toc
        : [
            for (final (index, item) in package.spine.indexed)
              if (item.linear)
                EpubTocEntry(
                    label: '${loc.chapter} ${index + 1}', href: item.href),
          ];
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                loc.tableOfContents,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final selected =
                      package.spineIndexForHref(entry.href) == currentSpineIndex;
                  return TvFocusable(
                    onTap: () => onEntryTap(entry),
                    child: ListTile(
                      dense: true,
                      selected: selected,
                      contentPadding: EdgeInsets.only(
                          left: 16.0 + entry.depth * 16.0, right: 16),
                      title: Text(
                        entry.label.isNotEmpty
                            ? entry.label
                            : '${loc.chapter} ${index + 1}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => onEntryTap(entry),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
