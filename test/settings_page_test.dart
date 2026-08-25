import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/SettingsSection.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ServerSettingsPage.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _server = 'test-server';

/// The page only needs the `me` query, for [AdminGate].
MockClient _fakeGraphQL({required bool isAdmin}) => MockClient((request) async {
  final body = json.decode(request.body) as Map<String, dynamic>;
  final query = body['query'] as String? ?? '';
  final payload = query.contains('me {')
      ? {
          'data': {
            '__typename': 'Query',
            'me': {
              '__typename': 'Me',
              'id': 'user-1',
              'name': 'Gerben',
              'email': 'gerben@example.org',
              'isAdmin': isAdmin,
            },
          },
        }
      : {
          'data': {'__typename': 'Query'},
        };
  return http.Response(
    json.encode(payload),
    200,
    headers: {'content-type': 'application/json'},
  );
});

Widget _app(Widget home) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [Locale('en')],
  home: home,
);

/// The sections and tiles in the order they are laid out, top to bottom. Keyed
/// rather than matched on text: this machine runs nl and CI runs en.
List<String> _keysInOrder(WidgetTester tester) {
  const wanted = {
    'settings-section-playback',
    'settings-tile-language',
    'settings-tile-playback',
    'settings-section-this-device',
    'settings-tile-downloads',
    'settings-tile-sleep-timer',
    'settings-section-sharing',
    'settings-tile-sharing',
    'settings-tile-devices',
    'settings-tile-now-playing',
    'settings-section-server',
    'settings-tile-server',
    'settings-tile-users',
    'settings-tile-libraries',
    'settings-section-app',
    'settings-tile-about',
  };
  final found = <(double, String)>[];
  for (final element in tester.allElements) {
    final key = element.widget.key;
    if (key is! ValueKey<String> || !wanted.contains(key.value)) continue;
    final box = element.renderObject;
    if (box is! RenderBox || !box.attached) continue;
    found.add((box.localToGlobal(Offset.zero).dy, key.value));
  }
  found.sort((a, b) => a.$1.compareTo(b.$1));
  return found.map((e) => e.$2).toList();
}

void main() {
  /// Tall enough that the whole list is laid out at once — the order assertions
  /// read the on-screen positions.
  Future<void> pumpPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(const ServerSettingsPage(serverName: _server)),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.clients.clear();
    PermissionsService().invalidate(_server);
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  void useClient(http.Client client) {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
      link: HttpLink('https://api.example/graphql', httpClient: client),
      cache: GraphQLCache(),
    );
  }

  testWidgets('groups the entries by scope, in order', (tester) async {
    useClient(_fakeGraphQL(isAdmin: true));
    await pumpPage(tester);

    expect(_keysInOrder(tester), [
      'settings-section-playback',
      'settings-tile-language',
      'settings-tile-playback',
      'settings-section-this-device',
      'settings-tile-downloads',
      'settings-tile-sleep-timer',
      'settings-section-sharing',
      'settings-tile-sharing',
      'settings-tile-devices',
      'settings-tile-now-playing',
      'settings-section-server',
      'settings-tile-server',
      'settings-tile-users',
      'settings-tile-libraries',
      'settings-section-app',
      'settings-tile-about',
    ]);
  });

  testWidgets('every entry carries a subtitle', (tester) async {
    useClient(_fakeGraphQL(isAdmin: true));
    await pumpPage(tester);

    final tiles = tester.widgetList<ListTile>(find.byType(ListTile));
    expect(tiles, isNotEmpty);
    for (final tile in tiles) {
      expect(
        tile.subtitle,
        isNotNull,
        reason: 'tile ${tile.key} has no subtitle',
      );
    }
  });

  testWidgets('hides the admin entries but keeps the server section', (
    tester,
  ) async {
    useClient(_fakeGraphQL(isAdmin: false));
    await pumpPage(tester);

    expect(find.byKey(const ValueKey('settings-tile-users')), findsNothing);
    expect(find.byKey(const ValueKey('settings-tile-libraries')), findsNothing);
    expect(
      find.byKey(const ValueKey('settings-section-server')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('settings-tile-server')), findsOneWidget);
  });

  testWidgets('the gated admin block leaves no trailing divider behind', (
    tester,
  ) async {
    useClient(_fakeGraphQL(isAdmin: false));
    await pumpPage(tester);

    // The server section holds one visible tile, so it must hold no divider.
    final section = find.byKey(const ValueKey('settings-section-server'));
    expect(
      find.descendant(of: section, matching: find.byType(Divider)),
      findsNothing,
    );
  });

  testWidgets('SettingsSection divides its children but not its trailing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: SettingsSection(
            title: 'Section',
            trailing: const SizedBox.shrink(),
            children: const [
              ListTile(title: Text('one')),
              ListTile(title: Text('two')),
              ListTile(title: Text('three')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Divider), findsNWidgets(2));
  });
}
