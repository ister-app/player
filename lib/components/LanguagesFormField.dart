import 'package:flutter/material.dart';
import '../components/LanguageDataWidget.dart';

/// A form field that lets the user pick an arbitrary number of languages.
///
/// The field stores a **list of language IDs** (`List<String>`).
/// A trailing empty slot is always kept so the user can add a new language
/// without pressing an extra button.
class LanguageFormField extends FormField<List<String>> {
  /// Called whenever the list of selected languages changes.
  final ValueChanged<List<String>>? onChanged;

  LanguageFormField({
    super.key,
    this.onChanged,
    List<String>? initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.validator,
  }) : super(
    initialValue: initialValue ?? const [],
    builder: (_) => const SizedBox.shrink(),
  );

  @override
  FormFieldState<List<String>> createState() => _LanguageFormFieldState();
}

class _LanguageFormFieldState extends FormFieldState<List<String>> {
  /// The actual list of language IDs (no nulls).
  /// A separate flag tells us whether we need to show the placeholder row.
  List<String> _languages = [];
  bool _hasPlaceholder = true; // always true unless the list is empty.

  @override
  LanguageFormField get widget => super.widget as LanguageFormField;

  @override
  void initState() {
    super.initState();
    // Seed with the initial value, then ensure a placeholder exists.
    _languages = List<String>.from(widget.initialValue ?? []);
    _ensurePlaceholder();
  }

  /// Builds the clean list (without placeholder) and notifies the form
  /// and the optional external callback.
  void _notifyChange() {
    final clean = List<String>.unmodifiable(_languages);
    didChange(clean);
    widget.onChanged?.call(clean);
  }

  /// Guarantees that a trailing empty slot is present.
  void _ensurePlaceholder() {
    _hasPlaceholder = true;
  }

  /// Adds a new empty slot if the current last entry already contains a value.
  void _addPlaceholderIfNeeded() {
    if (!_hasPlaceholder) {
      _hasPlaceholder = true;
    }
  }

  /// Handles a language change at [index].
  void _onLanguageChanged(String value, int index) {
    setState(() {
      // Replace the placeholder with the new value.
      if (_hasPlaceholder && index == _languages.length) {
        _languages.add(value);
      } else {
        _languages[index] = value;
      }

      // Remove duplicates while preserving the first occurrence.
      final seen = <String>{};
      _languages = _languages.where((lang) {
        if (seen.contains(lang)) return false;
        seen.add(lang);
        return true;
      }).toList();

      // Always keep a trailing placeholder.
      _addPlaceholderIfNeeded();
      _notifyChange();
    });
  }

  /// Removes the language at [index].
  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
      // If the list becomes empty we still want a placeholder row.
      if (_languages.isEmpty) _hasPlaceholder = true;
      _notifyChange();
    });
  }

  /// Reorders the internal list.
  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final moved = _languages.removeAt(oldIndex);
      _languages.insert(newIndex, moved);
      _notifyChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the visual rows: real languages + optional placeholder.
    final itemCount = _languages.length + (_hasPlaceholder ? 1 : 0);
    return ReorderableListView.builder(
      itemCount: itemCount,
      onReorder: _reorder,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final isPlaceholder = index == _languages.length && _hasPlaceholder;
        final languageId = isPlaceholder ? null : _languages[index];

        return Dismissible(
          key: ValueKey('language-$index-${languageId ?? "placeholder"}'),
          confirmDismiss: (_) async => !isPlaceholder,
          onDismissed: (_) => _removeLanguage(index),
          child: ListTile(
            title: LanguageDataWidget(
              // `initialLanguage` expects a nullable Language object; we pass the ID.
              initialLanguage: languageId,
              onChanged: (value) => value != null
                  ? _onLanguageChanged(value.id, index)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
