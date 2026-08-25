import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerSettingsLanguagePage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/UserSettingsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Pins the language settings page: the ordered preference lists, the picker
/// that replaced the 7924-entry dropdown, and the revert-on-rejected-save.
///
/// Everything is found by [ValueKey], never by label: this machine runs `nl`
/// and CI runs `en`.
const _server = 'test-server';

Map<String, dynamic> _settings({
  List<String> audio = const [],
  List<String> subtitle = const [],
  bool hideSubtitlesMatchingAudio = false,
}) =>
    {
      '__typename': 'UserSettings',
      'preferredAudioLanguages': audio,
      'preferredSubtitleLanguages': subtitle,
      'directPlay': true,
      'transcode': true,
      'maxVideoHeight': null,
      'autoSkipIntro': false,
      'hideSubtitlesMatchingAudio': hideSubtitlesMatchingAudio,
    };

/// Serves `userSettings` and echoes `updateUserSettings` back as stored,
/// recording every mutation input. With [rejectMutations] the mutation fails,
/// which is what the page's revert path is for.
MockClient _fakeGraphQL(
  Map<String, dynamic> stored, {
  List<Map<String, dynamic>>? mutations,
  bool rejectMutations = false,
}) =>
    MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      final variables = body['variables'] as Map<String, dynamic>? ?? const {};

      if (query.contains('updateUserSettings')) {
        final input = variables['input'] as Map<String, dynamic>;
        mutations?.add(input);
        if (rejectMutations) {
          return http.Response(
              json.encode({
                'errors': [
                  {'message': 'nope'}
                ]
              }),
              200,
              headers: {'content-type': 'application/json'});
        }
        stored['preferredAudioLanguages'] = input['preferredAudioLanguages'];
        stored['preferredSubtitleLanguages'] =
            input['preferredSubtitleLanguages'];
        stored['hideSubtitlesMatchingAudio'] =
            input['hideSubtitlesMatchingAudio'];
        return http.Response(
            json.encode({
              'data': {'__typename': 'Mutation', 'updateUserSettings': stored}
            }),
            200,
            headers: {'content-type': 'application/json'});
      }

      return http.Response(
          json.encode({
            'data': {'__typename': 'Query', 'userSettings': stored}
          }),
          200,
          headers: {'content-type': 'application/json'});
    });

Widget _app({Locale locale = const Locale('en')}) => MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('nl')],
      home: const ServerSettingsLanguagePage(serverName: _server),
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Reading the language assets is real I/O, which never completes under a
    // widget test's fake clock. Warm the singleton's caches here, outside the
    // test body, so the lookups inside it resolve on a microtask.
    await LanguageService().ensureLoaded();
  });

  setUp(() {
    // The picker's search field autofocuses, and a blinking cursor is an
    // animation that never settles — pumpAndSettle would time out on it.
    EditableText.debugDeterministicCursor = true;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    // The service caches settings per server in memory for the process.
    UserSettingsService().invalidate(_server);
  });

  tearDown(() {
    EditableText.debugDeterministicCursor = false;
    ClientManager.testClientBuilder = null;
  });

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql', httpClient: client),
          cache: GraphQLCache(),
        );
  }

  /// Opens the picker from the "add language" row of [prefix]'s list.
  Future<void> openPicker(WidgetTester tester, String prefix) async {
    await tester.tap(find.byKey(ValueKey('$prefix-add')));
    await tester.pumpAndSettle();
  }

  testWidgets('shows saved languages in order, most preferred first',
      (tester) async {
    useClient(_fakeGraphQL(_settings(audio: ['nld', 'eng'])));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('spoken-row-nld')), findsOneWidget);
    expect(find.byKey(const ValueKey('spoken-row-eng')), findsOneWidget);
    // Rank badges make the priority visible.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    // The empty hint belongs to the still-empty subtitle list only.
    expect(find.byKey(const ValueKey('spoken-empty')), findsNothing);
    expect(find.byKey(const ValueKey('subtitle-empty')), findsOneWidget);
  });

  testWidgets('adding a language from the picker appends it and saves',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(_fakeGraphQL(_settings(audio: ['nld']), mutations: mutations));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await openPicker(tester, 'spoken');
    await tester.tap(find.byKey(const ValueKey('language-option-eng')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('spoken-row-eng')), findsOneWidget);
    expect(mutations.last['preferredAudioLanguages'], ['nld', 'eng']);
  });

  testWidgets('a language already on the list is not offered again',
      (tester) async {
    useClient(_fakeGraphQL(_settings(audio: ['nld'])));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await openPicker(tester, 'spoken');
    expect(find.byKey(const ValueKey('language-option-nld')), findsNothing);
    expect(find.byKey(const ValueKey('language-option-eng')), findsOneWidget);
  });

  testWidgets('rows and picker name languages in the UI language',
      (tester) async {
    useClient(_fakeGraphQL(_settings(audio: ['deu'])));
    await tester.pumpWidget(_app(locale: const Locale('nl')));
    await tester.pumpAndSettle();

    expect(find.text('Duits'), findsOneWidget);
    expect(find.text('German'), findsNothing);

    // Searching matches the Dutch name, the English one, and the code.
    for (final term in ['Duits', 'German', 'de']) {
      await openPicker(tester, 'subtitle');
      await tester.enterText(
          find.byKey(const ValueKey('language-picker-search')), term);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('language-option-deu')), findsOneWidget,
          reason: term);
      Navigator.of(tester.element(find.byType(ListView).first)).pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('searching by ISO code finds the language', (tester) async {
    useClient(_fakeGraphQL(_settings()));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await openPicker(tester, 'spoken');
    await tester.enterText(
        find.byKey(const ValueKey('language-picker-search')), 'nl');
    // The query is debounced by 150 ms.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('language-option-nld')), findsOneWidget);
    // A whole-code match must not drag in every name containing "nl".
    expect(find.byKey(const ValueKey('language-option-eng')), findsNothing);
  });

  testWidgets('languages without an ISO 639-1/2 code appear only when "show all" is on',
      (tester) async {
    useClient(_fakeGraphQL(_settings()));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await openPicker(tester, 'spoken');
    // "aaa" (Ghotuo) is one of the ~7500 entries no media file can name.
    await tester.enterText(
        find.byKey(const ValueKey('language-picker-search')), 'aaa');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-option-aaa')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('language-picker-show-all')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('language-option-aaa')), findsOneWidget);
  });

  testWidgets('move up reorders the saved list', (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(
        _fakeGraphQL(_settings(audio: ['nld', 'eng']), mutations: mutations));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('spoken-menu-eng')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pumpAndSettle();

    expect(mutations.last['preferredAudioLanguages'], ['eng', 'nld']);
  });

  testWidgets('removing shows an undo that restores the original order',
      (tester) async {
    final mutations = <Map<String, dynamic>>[];
    useClient(
        _fakeGraphQL(_settings(audio: ['nld', 'eng']), mutations: mutations));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('spoken-menu-nld')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('spoken-row-nld')), findsNothing);
    expect(mutations.last['preferredAudioLanguages'], ['eng']);

    await tester.tap(find.byType(SnackBarAction));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('spoken-row-nld')), findsOneWidget);
    expect(mutations.last['preferredAudioLanguages'], ['nld', 'eng']);
  });

  group('no-subtitles-in-the-spoken-language toggle', () {
    const key = ValueKey('hide-subtitles-matching-audio');

    testWidgets('is off unless the server says otherwise', (tester) async {
      useClient(_fakeGraphQL(_settings()));
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(tester.widget<SwitchListTile>(find.byKey(key)).value, isFalse);
    });

    testWidgets('reflects a server that has it on', (tester) async {
      useClient(_fakeGraphQL(_settings(hideSubtitlesMatchingAudio: true)));
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(tester.widget<SwitchListTile>(find.byKey(key)).value, isTrue);
    });

    testWidgets('turning it on sends it in the mutation', (tester) async {
      final mutations = <Map<String, dynamic>>[];
      useClient(_fakeGraphQL(_settings(), mutations: mutations));
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // The switch is the last thing on the page, below the fold on the
      // default 800x600 test surface.
      await tester.ensureVisible(find.byKey(key));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();

      expect(mutations.last['hideSubtitlesMatchingAudio'], isTrue);
      expect(tester.widget<SwitchListTile>(find.byKey(key)).value, isTrue);
    });

    testWidgets('a rejected save flips it back', (tester) async {
      useClient(_fakeGraphQL(_settings(), rejectMutations: true));
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(key));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();

      expect(tester.widget<SwitchListTile>(find.byKey(key)).value, isFalse);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  testWidgets('a rejected save puts the previous list back', (tester) async {
    useClient(_fakeGraphQL(_settings(audio: ['nld']), rejectMutations: true));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await openPicker(tester, 'spoken');
    await tester.tap(find.byKey(const ValueKey('language-option-eng')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('spoken-row-eng')), findsNothing);
    expect(find.byKey(const ValueKey('spoken-row-nld')), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
