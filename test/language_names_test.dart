import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/LanguageService.dart';

/// Pins the code-to-name lookup the picker, the preference lists and the
/// player's track menu all go through.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('before the tables are loaded', () {
    test('a code comes back as itself instead of throwing', () {
      // Deliberately the first test in the file: the service is a singleton, so
      // once anything awaits ensureLoaded the tables stay loaded for the run.
      expect(LanguageService().displayName('nld', 'nl'), 'nld');
    });
  });

  group('displayName', () {
    setUpAll(() => LanguageService().ensureLoaded());

    test('names a language in the UI language', () {
      expect(LanguageService().displayName('nld', 'nl'), 'Nederlands');
      expect(LanguageService().displayName('nld', 'en'), 'Dutch');
      expect(LanguageService().displayName('deu', 'nl'), 'Duits');
      expect(LanguageService().displayName('jpn', 'nl'), 'Japans');
    });

    test('takes any of the codes a language is known by', () {
      // ISO 639-1, 639-2/T, 639-2/B and 639-3 all name Dutch.
      for (final code in ['nl', 'nld', 'dut']) {
        expect(LanguageService().displayName(code, 'nl'), 'Nederlands',
            reason: code);
      }
    });

    test('ignores region and script suffixes on both arguments', () {
      expect(LanguageService().displayName('nl-BE', 'nl_NL'), 'Nederlands');
      expect(LanguageService().displayName('EN-US', 'en'), 'English');
    });

    test('falls back to the English reference name when CLDR has no entry', () {
      // Montenegrin is one of only two of the 421 track-capable languages CLDR
      // does not name.
      expect(LanguageService().displayName('cnr', 'nl'), 'Montenegrin');
    });

    test('falls back to the code itself for a language nothing knows', () {
      expect(LanguageService().displayName('zzz', 'nl'), 'zzz');
      expect(LanguageService().displayName('', 'nl'), '');
    });

    test('names the "undetermined" code mpv puts on unlabelled tracks', () {
      // Better than the bare "und" the track menu used to show.
      expect(LanguageService().displayName('und', 'en'), 'Unknown language');
      // CLDR keeps the Dutch phrase lowercase; it is a description, not a name.
      expect(LanguageService().displayName('und', 'nl'), 'onbekende taal');
    });

    test('an unsupported UI language still yields the English name', () {
      expect(LanguageService().displayName('nld', 'fr'), 'Dutch');
    });

    test('lookup resolves a language from any of its codes', () {
      expect(LanguageService().lookup('dut')?.id, 'nld');
      expect(LanguageService().lookup('nl')?.refName, 'Dutch');
      expect(LanguageService().lookup('zzz'), isNull);
    });
  });
}
