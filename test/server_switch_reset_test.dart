import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Switching servers with the home-title switcher replaces ServerHomeRoute
/// with itself under a different serverName. The page key is the route name,
/// so the Navigator reuses the existing ServerHomePage State — every
/// per-server future latch (`_wellKnownFuture`, `_initFuture`, ...) must be
/// reset in didUpdateWidget or the new server shows the old server's name and
/// never initializes its login manager (a login page whose button does
/// nothing).
const _serverA = 'plain.example';
const _serverB = 'localhost:8080/api';

MockClient _fakeGraphQL() => MockClient((request) async => http.Response(
      json.encode({
        'data': {'__typename': 'Query'}
      }),
      200,
      headers: {'content-type': 'application/json'},
    ));

Future<void> _seedWellKnown(String id, String name) async {
  final prefs = SharedPreferencesAsync();
  await prefs.setString('wellknown_${id}_name', name);
  await prefs.setString(
      'wellknown_${id}_oidcUrl', 'https://oidc.example/realm');
  await prefs.setString('wellknown_${id}_serverUrl', 'https://$id');
}

Widget _wrapRouter(AppRouter router) => MaterialApp.router(
      routerConfig: router.config(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );

Future<void> _pump(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    SharedPreferences.setMockInitialValues({});
    ClientManager.clients.clear();
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _fakeGraphQL()),
          cache: GraphQLCache(),
        );
    await SharedPreferencesAsync().setStringList('servers', [_serverA, _serverB]);
    // Well-known comes from the prefs fallback: network is unreachable in
    // widget tests, so fetch() lands on these entries.
    await _seedWellKnown(_serverA, 'Plain Server');
    await _seedWellKnown(_serverB, 'Sub Server');
  });

  tearDown(() {
    ClientManager.testClientBuilder = null;
  });

  testWidgets('switching servers re-resolves the new server instead of '
      'keeping the old state', (tester) async {
    final router = AppRouter();
    await tester.pumpWidget(_wrapRouter(router));
    await _pump(tester);

    // replace() resolves when the pushed route pops again — never await it.
    unawaited(router.replace(ServerHomeRoute(serverName: _serverA)));
    // Extra pumps: the server-overview route must finish animating out, or its
    // server cards still count towards the text expectations below.
    await _pump(tester);
    await _pump(tester);

    // Not logged in: the login page for A, titled with A's friendly name
    // (app bar + login heading).
    expect(find.text('Plain Server'), findsNWidgets(2));
    expect(find.text('https://$_serverA'), findsOneWidget);

    unawaited(router.replace(ServerHomeRoute(serverName: _serverB)));
    await _pump(tester);

    // The reused State must now be about B everywhere: B's friendly name in
    // the app bar (a fresh well-known lookup) and B in the login prompt.
    // Before the didUpdateWidget reset this kept showing 'Plain Server'.
    expect(find.text('Sub Server'), findsNWidgets(2));
    expect(find.text('Plain Server'), findsNothing);
    expect(find.text('https://$_serverB'), findsOneWidget);
  });
}
