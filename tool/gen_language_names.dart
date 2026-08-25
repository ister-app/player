// Regenerates `assets/language-names.json`, the language display names shown in
// the picker, the preference lists and the player's track menu.
//
// The ISO 639-3 table the app already ships (`assets/iso-639-3.tab`) only holds
// English reference names, so it cannot label a Dutch UI. CLDR has the names in
// every locale; this pulls the two the app is translated into.
//
// Run it by hand — the output is committed, so builds stay offline:
//
//   dart run tool/gen_language_names.dart
//
// Keys are BCP-47 language subtags: mostly ISO 639-1 (`nl`, `de`), three-letter
// for languages without one (`fil`, `haw`, `nds`). Region and script variants
// (`nl-BE`, `zh-Hans-alt-long`, `ar-001`) are dropped — the app matches on a
// bare language code.
import 'dart:convert';
import 'dart:io';

/// The locales `lib/l10n` is translated into.
const _locales = ['en', 'nl'];

const _base = 'https://raw.githubusercontent.com/unicode-org/cldr-json/main'
    '/cldr-json/cldr-localenames-full/main';

Future<void> main() async {
  final client = HttpClient();
  final out = <String, Map<String, String>>{};
  String? cldrVersion;

  Future<Map<String, dynamic>> getJson(Uri uri) async {
    stdout.writeln('Fetching $uri');
    final response = await (await client.getUrl(uri)).close();
    if (response.statusCode != 200) {
      stderr.writeln('  ${response.statusCode} for $uri');
      exit(1);
    }
    return json.decode(await response.transform(utf8.decoder).join())
        as Map<String, dynamic>;
  }

  try {
    // The per-locale files carry no version; the package manifest does.
    cldrVersion = (await getJson(Uri.parse(
        'https://raw.githubusercontent.com/unicode-org/cldr-json/main'
        '/cldr-json/cldr-localenames-full/package.json')))['version'] as String?;

    for (final locale in _locales) {
      final body = await getJson(Uri.parse('$_base/$locale/languages.json'));

      final languages = (((body['main'] as Map<String, dynamic>)[locale]
              as Map<String, dynamic>)['localeDisplayNames']
          as Map<String, dynamic>)['languages'] as Map<String, dynamic>;

      final names = <String, String>{};
      for (final entry in languages.entries) {
        if (entry.key.contains('-')) continue; // region/script/alt variant
        names[entry.key] = entry.value as String;
      }
      final sorted = Map.fromEntries(
          names.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      out[locale] = sorted;
      stdout.writeln('  ${sorted.length} names');
    }
  } finally {
    client.close();
  }

  final file = File('assets/language-names.json');
  await file.writeAsString('${const JsonEncoder.withIndent('  ').convert({
        '_source': 'Unicode CLDR ${cldrVersion ?? "unknown"} — '
            'unicode-org/cldr-json, cldr-localenames-full. '
            'Regenerate with tool/gen_language_names.dart',
        ...out,
      })}\n');
  stdout.writeln('Wrote ${file.path} (CLDR ${cldrVersion ?? "unknown"})');
}
