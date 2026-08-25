import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'LanguageData.dart';

/// Credits the two bundled language data sets on the licence page the About
/// screen opens (`ServerSettingsAboutPage`). Neither ships with the Flutter
/// package licences, so they have to be registered by hand.
void registerLanguageDataLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['ISO 639-3 code tables'],
      'The ISO 639-3 language code tables (assets/iso-639-3.tab) are '
      'published by SIL International, the ISO 639-3 registration authority, '
      'and are used here under their terms of use.\n\n'
      'https://iso639-3.sil.org/code_tables/download_tables',
    );
    yield const LicenseEntryWithLineBreaks(
      ['Unicode CLDR'],
      'The language display names (assets/language-names.json) are derived '
      'from the Unicode Common Locale Data Repository, distributed under the '
      'Unicode License.\n\n'
      'https://www.unicode.org/license.txt',
    );
  });
}

/// The ISO 639-3 table plus the CLDR display names shown for a language code.
///
/// The ISO table (`assets/iso-639-3.tab`) is the identity of a language — every
/// code it can be known by — but its `refName` is English only, so it cannot
/// label a Dutch UI. `assets/language-names.json` carries the CLDR names for
/// the locales the app is translated into; see `tool/gen_language_names.dart`.
class LanguageService {
  // Private constructor
  LanguageService._privateConstructor();

  // Singleton instance
  static final LanguageService _instance =
      LanguageService._privateConstructor();

  // Factory constructor to return the single instance
  factory LanguageService() {
    return _instance;
  }

  List<LanguageData>? _cache;

  /// Every code a language can be named by (`id`, 639-2 b/t, 639-1) mapped to
  /// it, so a lookup is a hash hit instead of a scan over 7924 rows.
  final Map<String, LanguageData> _byCode = {};

  /// `locale -> language subtag -> display name`, straight from CLDR.
  Map<String, Map<String, String>> _displayNames = const {};

  Future<void>? _loading;

  Future<List<LanguageData>> loadLanguageData() async {
    if (_cache == null) {
      final String response =
          await rootBundle.loadString('assets/iso-639-3.tab');
      final List<String> lines = response.split('\n');
      final parsed = <LanguageData>[];

      // Skip the first line
      for (var i = 1; i < lines.length; i++) {
        var line = lines[i];
        if (line.trim().isNotEmpty) {
          List<String> fields = line.split('\t');
          parsed.add(LanguageData.fromCsv(fields));
        }
      }
      for (final language in parsed) {
        for (final code in language.toCodeList()) {
          if (code.isNotEmpty) _byCode.putIfAbsent(code, () => language);
        }
      }
      _cache = parsed;
    }
    return _cache!;
  }

  /// Loads both tables once. Call this during boot: [displayName] is
  /// synchronous, so it can only answer from what is already in memory.
  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    await loadLanguageData();
    final raw = json.decode(
        await rootBundle.loadString('assets/language-names.json')) as Map<String, dynamic>;
    _displayNames = {
      for (final entry in raw.entries)
        if (entry.value is Map<String, dynamic>)
          entry.key: {
            for (final name in (entry.value as Map<String, dynamic>).entries)
              name.key: name.value as String,
          },
    };
  }

  // The getLanguageData method with a nullable return type
  Future<LanguageData?> getLanguageData(String query) async {
    // Ensure data is loaded
    await loadLanguageData();
    return lookup(query);
  }

  /// Synchronous code lookup. Returns null until [loadLanguageData] has run.
  LanguageData? lookup(String code) => _byCode[_normalize(code)];

  Future<List<LanguageData>> getAllLanguages() async {
    // Ensure data is loaded
    await loadLanguageData();
    return _cache!; // Return all cached languages
  }

  /// The name of [code] in [localeName], e.g. `('nld', 'nl') -> 'Nederlands'`.
  ///
  /// Synchronous on purpose: the player's track menu labels tracks from a
  /// static, synchronous function. Falls back to the English reference name and
  /// finally to the code itself, so it is safe to call before [ensureLoaded]
  /// resolves — the label is then merely untranslated, never missing.
  String displayName(String code, String localeName) {
    final normalized = _normalize(code);
    if (normalized.isEmpty) return code;

    // Only the language part of the UI locale matters: 'nl_NL' and 'nl' share
    // one name table.
    final names = _displayNames[_normalize(localeName)];
    final language = _byCode[normalized];
    if (names != null) {
      // Ordered by how CLDR keys languages: the 639-1 code where there is one,
      // otherwise the three-letter subtag.
      for (final candidate in [
        language?.part1,
        language?.id,
        language?.part2t,
        language?.part2b,
        normalized,
      ]) {
        if (candidate == null || candidate.isEmpty) continue;
        final name = names[candidate];
        if (name != null) return name;
      }
    }
    return language?.refName ?? code;
  }

  /// Lowercases and drops any region/script suffix: `en-US`, `nl_NL` -> `en`, `nl`.
  static String _normalize(String code) {
    final cut = code.replaceAll('_', '-').split('-').first.trim().toLowerCase();
    return cut;
  }
}
