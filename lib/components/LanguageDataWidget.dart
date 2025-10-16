import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/LanguageData.dart';
import '../utils/LanguageService.dart';

class LanguageDataWidget extends StatefulWidget {
  /// Called when the selected language changes.
  final ValueChanged<LanguageData?>? onChanged;

  /// ISO‑code (or any identifier) of the language that should be selected
  /// when the widget first builds.
  final String? initialLanguage;

  const LanguageDataWidget({
    super.key,
    this.onChanged,
    this.initialLanguage,
  });

  @override
  State<LanguageDataWidget> createState() => _LanguageDataWidgetState();
}

class _LanguageDataWidgetState extends State<LanguageDataWidget> {
  final LanguageService _languageService = LanguageService();

  /// Holds the currently selected language.  It is also used by
  /// `DropdownButton2` via `valueListenable`.
  final ValueNotifier<LanguageData?> _selected = ValueNotifier(null);

  final TextEditingController _searchCtrl = TextEditingController();

  /// Cached list of languages – loaded once in `initState`.
  late final Future<List<LanguageData>> _languagesFuture;

  @override
  void initState() {
    super.initState();

    // Load languages once and, if an initial value is supplied,
    // resolve it to a `LanguageData` instance.
    _languagesFuture = _loadLanguages();
  }

  Future<List<LanguageData>> _loadLanguages() async {
    final languages = await _languageService.getAllLanguages();

    if (widget.initialLanguage != null) {
      final initial =
          await _languageService.getLanguageData(widget.initialLanguage!);
      _selected.value = initial;
    }

    return languages;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LanguageData>>(
      future: _languagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.error(snapshot.error!),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noLanguagesFound),
          );
        }

        final languages = snapshot.data!;

        return DropdownButton2<LanguageData>(
          isExpanded: true,
          hint: Text(AppLocalizations.of(context)!.selectLanguage),
          items: languages
              .map(
                (lang) => DropdownItem<LanguageData>(
                  value: lang,
                  child: Text(lang.refName),
                ),
              )
              .toList(),
          valueListenable: _selected,
          onChanged: (lang) {
            _selected.value = lang;
            widget.onChanged?.call(lang);
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            width: double.infinity,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: _searchCtrl,
            searchBarWidgetHeight: 50,
            searchBarWidget: Container(
              height: 50,
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            noResultsWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(AppLocalizations.of(context)!.noLanguageFound),
            ),
            // Case‑insensitive match on the language name.
            searchMatchFn: (item, searchValue) =>
                item.value?.refName
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()) ??
                false,
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) _searchCtrl.clear();
          },
        );
      },
    );
  }
}
