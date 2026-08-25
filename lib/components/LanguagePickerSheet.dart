import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguageData.dart';
import '../utils/LanguageService.dart';
import 'AppModalSheet.dart';

/// Opens the language picker and resolves to the chosen language, or null when
/// the sheet is dismissed.
///
/// [exclude] holds the ISO 639-3 ids already on the list the caller is adding
/// to; they are left out entirely, which is what keeps the preference lists
/// duplicate-free without a filtering pass afterwards.
Future<LanguageData?> showLanguagePicker(
  BuildContext context, {
  Set<String> exclude = const <String>{},
}) {
  return showAppSheet<LanguageData>(
    context,
    builder: (_) => LanguagePickerSheet(exclude: exclude),
  );
}

/// A searchable language list.
///
/// The ISO 639-3 table holds 7924 entries, but only the ~420 with an ISO 639-1
/// or 639-2 code can appear as a track language in a media container — the rest
/// is noise you would scroll past. Those are shown by default; a toggle lifts
/// the filter for the rare file that carries something else.
class LanguagePickerSheet extends StatefulWidget {
  const LanguagePickerSheet({super.key, this.exclude = const <String>{}});

  final Set<String> exclude;

  @override
  State<LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

/// Languages offered at the top when the user has not typed anything, after the
/// device's own locales. Roughly the audio tracks a library actually carries.
const List<String> _commonLanguageCodes = ['en', 'nl', 'de', 'fr', 'es', 'ja'];

class _LanguagePickerSheetState extends State<LanguagePickerSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  late final Future<List<LanguageData>> _languagesFuture;

  /// A private copy of the table, sorted by display name; every keystroke only
  /// filters this list.
  List<LanguageData> _sorted = const [];

  /// Language id to its name in the UI language, resolved once per locale so
  /// the sort comparator and the search do not re-derive it per comparison.
  final Map<String, String> _names = {};
  String _namesLocale = '';

  String _query = '';
  bool _showAll = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _languagesFuture = _load();
  }

  Future<List<LanguageData>> _load() async {
    // A copy: _resolveNames sorts it, and the service's cache is shared.
    _sorted = List<LanguageData>.from(await LanguageService().getAllLanguages());
    return _sorted;
  }

  /// Resolves and sorts by the names of [localeName]. Memoised, so this only
  /// does work on the first build and if the UI language changes under it.
  void _resolveNames(String localeName) {
    if (_namesLocale == localeName) return;
    _namesLocale = localeName;
    final service = LanguageService();
    _names
      ..clear()
      ..addEntries(_sorted
          .map((l) => MapEntry(l.id, service.displayName(l.id, localeName))));
    // "Duits" belongs under the D in Dutch, not where "German" would sit.
    _sorted.sort((a, b) =>
        _names[a.id]!.toLowerCase().compareTo(_names[b.id]!.toLowerCase()));
  }

  String _nameOf(LanguageData lang) => _names[lang.id] ?? lang.refName;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Filtering 7924 entries per keystroke is cheap, rebuilding the list around
    // it is not — wait for a pause in typing.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _query = value.trim().toLowerCase());
    });
  }

  /// Whether a media container could ever name this language: only languages
  /// with an ISO 639-1 or 639-2 code can.
  static bool _isTrackLanguage(LanguageData lang) =>
      lang.part1.isNotEmpty || lang.part2b.isNotEmpty;

  bool _matches(LanguageData lang) {
    if (_query.isEmpty) return true;
    // Both names, so "Duits", "German" and "de" all find German whichever
    // language the UI is in.
    if (_nameOf(lang).toLowerCase().contains(_query)) return true;
    if (lang.refName.toLowerCase().contains(_query)) return true;
    // Codes are matched whole, so "nl" finds Dutch instead of every language
    // whose name happens to contain those letters.
    return lang
        .toCodeList()
        .any((code) => code.isNotEmpty && code.toLowerCase() == _query);
  }

  List<LanguageData> _suggestions() {
    final codes = <String>[
      for (final locale in WidgetsBinding.instance.platformDispatcher.locales)
        locale.languageCode,
      ..._commonLanguageCodes,
    ];
    final seen = <String>{};
    final out = <LanguageData>[];
    final service = LanguageService();
    for (final code in codes) {
      final lang = service.lookup(code);
      if (lang == null) continue;
      if (widget.exclude.contains(lang.id)) continue;
      if (!seen.add(lang.id)) continue;
      out.add(lang);
    }
    return out;
  }

  /// The rows to render: [String] entries are section headings, [LanguageData]
  /// entries are selectable languages.
  List<Object> _rows(AppLocalizations loc) {
    _resolveNames(loc.localeName);
    final filtered = _sorted
        .where((lang) => !widget.exclude.contains(lang.id))
        .where((lang) => _showAll || _isTrackLanguage(lang))
        .where(_matches)
        .toList();

    if (_query.isNotEmpty) return filtered;

    final suggestions = _suggestions();
    return [
      if (suggestions.isNotEmpty) ...[loc.suggestedLanguages, ...suggestions],
      loc.allLanguages,
      ...filtered,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(loc.selectLanguage, style: theme.textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // The clear button tracks the field directly: the query itself is
            // debounced, and waiting 150 ms for the icon to appear reads as lag.
            child: ListenableBuilder(
              listenable: _searchCtrl,
              builder: (context, _) => TextField(
                key: const ValueKey('language-picker-search'),
                controller: _searchCtrl,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: loc.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: loc.close,
                          onPressed: () {
                            _searchCtrl.clear();
                            _debounce?.cancel();
                            setState(() => _query = '');
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LanguageData>>(
              future: _languagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(loc.error(snapshot.error!)));
                }
                final rows = _rows(loc);
                if (rows.whereType<LanguageData>().isEmpty) {
                  return Center(child: Text(loc.noLanguageFound));
                }
                return ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    if (row is String) return _heading(context, row);
                    return _languageTile(context, row as LanguageData);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            key: const ValueKey('language-picker-show-all'),
            dense: true,
            title: Text(loc.showAllLanguages, style: theme.textTheme.bodyMedium),
            value: _showAll,
            onChanged: (value) => setState(() => _showAll = value),
          ),
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.labelMedium
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _languageTile(BuildContext context, LanguageData lang) {
    final code = lang.part1.isNotEmpty ? lang.part1 : lang.id;
    return ListTile(
      key: ValueKey('language-option-${lang.id}'),
      title: Text(_nameOf(lang)),
      trailing: Chip(
        label: Text(code),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onTap: () => Navigator.of(context).pop(lang),
    );
  }
}
