import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguageService.dart';
import 'LanguagePickerSheet.dart';
import 'TvFocusable.dart';

/// An ordered list of preferred languages, most preferred first.
///
/// The order *is* the setting — `MediaPlayerHandler._selectPreferredTrack` walks
/// it and takes the first language with a matching track — so every row shows
/// its rank, and reordering is reachable by drag, by keyboard and by D-pad.
///
/// Values are ISO 639-3 ids, the same strings [LanguagePreferences] stores.
class LanguagePreferenceList extends StatefulWidget {
  const LanguagePreferenceList({
    super.key,
    required this.values,
    required this.onChanged,
    required this.emptyHint,
    required this.keyPrefix,
  });

  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  /// Shown instead of the rows when nothing is selected, explaining what the
  /// player does without a preference.
  final String emptyHint;

  /// Distinguishes the widget keys of the spoken and subtitle lists on the same
  /// page (`spoken` / `subtitle`).
  final String keyPrefix;

  @override
  State<LanguagePreferenceList> createState() => _LanguagePreferenceListState();
}

class _LanguagePreferenceListState extends State<LanguagePreferenceList> {
  /// The language's name in the UI language. Both language tables are loaded
  /// before the first frame (`main.dart`), so this needs no future — an id
  /// nothing knows comes back as itself.
  String _nameOf(String id, AppLocalizations loc) =>
      LanguageService().displayName(id, loc.localeName);

  void _emit(List<String> next) => widget.onChanged(List<String>.unmodifiable(next));

  Future<void> _add() async {
    final picked = await showLanguagePicker(
      context,
      exclude: widget.values.toSet(),
    );
    if (picked == null) return;
    _emit([...widget.values, picked.id]);
  }

  void _move(int from, int to) {
    if (to < 0 || to >= widget.values.length) return;
    final next = List<String>.from(widget.values);
    next.insert(to, next.removeAt(from));
    _emit(next);
  }

  /// [ReorderableListView.onReorderItem] already accounts for the row being
  /// lifted out of the list, so [newIndex] is the final position.
  void _reorder(int oldIndex, int newIndex) => _move(oldIndex, newIndex);

  void _remove(int index) {
    final loc = AppLocalizations.of(context)!;
    final id = widget.values[index];
    final label = _nameOf(id, loc);
    final previous = List<String>.from(widget.values);

    _emit(List<String>.from(widget.values)..removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(loc.languageRemoved(label)),
        action: SnackBarAction(label: loc.undo, onPressed: () => _emit(previous)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.values.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.emptyHint,
                key: ValueKey('${widget.keyPrefix}-empty'),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: _reorder,
            proxyDecorator: (child, index, animation) =>
                Material(color: Colors.transparent, child: child),
            itemCount: widget.values.length,
            itemBuilder: (context, index) => _row(context, index),
          ),
        const Divider(height: 1, indent: 56),
        TvFocusable(
          onTap: _add,
          child: ListTile(
            key: ValueKey('${widget.keyPrefix}-add'),
            leading: const Icon(Icons.add),
            title: Text(loc.addLanguage),
            onTap: _add,
          ),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, int index) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final id = widget.values[index];
    final data = LanguageService().lookup(id);
    final isFirst = index == 0;
    final isLast = index == widget.values.length - 1;

    // Keyed on the language id, not the row index: an index key makes Flutter
    // carry dismiss state over to whatever moved into that slot.
    return Dismissible(
      key: ValueKey('${widget.keyPrefix}-row-$id'),
      background: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => _remove(index),
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Text(
            '${index + 1}',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.onSecondaryContainer),
          ),
        ),
        title: Text(_nameOf(id, loc)),
        subtitle: Text(data == null || data.part1.isEmpty ? id : '${data.part1} · $id'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dragging is the nice way to reorder, but it is unreachable with a
            // remote or a keyboard — hence the same moves in a menu.
            PopupMenuButton<String>(
              key: ValueKey('${widget.keyPrefix}-menu-$id'),
              onSelected: (value) {
                switch (value) {
                  case 'up':
                    _move(index, index - 1);
                  case 'down':
                    _move(index, index + 1);
                  case 'remove':
                    _remove(index);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'up',
                  enabled: !isFirst,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.arrow_upward),
                    title: Text(loc.moveUp),
                  ),
                ),
                PopupMenuItem(
                  value: 'down',
                  enabled: !isLast,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.arrow_downward),
                    title: Text(loc.moveDown),
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.delete_outline),
                    title: Text(loc.removeLanguage),
                  ),
                ),
              ],
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.only(left: 4, right: 8),
                child: Icon(Icons.drag_handle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
