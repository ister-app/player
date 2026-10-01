import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/NoAccessView.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoginManager.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A signed-in user the server will not serve must see a no-access screen
/// (missing `user` role), and a session the server rejects outright must be
/// signed out — neither may sit on the "connecting" spinner forever, which
/// is what the endless stream-token retry used to produce.
const _server = 'plain.example';

/// Answers `createStreamToken` with [denial]; every other operation gets an
/// empty, valid result.
MockClient _graphQL(String denial) => MockClient((request) async {
      final body = json.decode(request.body) as Map<String, dynamic>;
      final query = body['query'] as String? ?? '';
      if (query.contains('createStreamToken')) {
        return http.Response(
          json.encode({
            'errors': [
              {
                'message': denial,
                'extensions': {'classification': denial.toUpperCase()}
              }
            ],
            'data': null,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response(
        json.encode({
          'data': {'__typename': 'Query'}
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

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

Future<void> _openServer(WidgetTester tester, AppRouter router) async {
  await tester.pumpWidget(_wrapRouter(router));
  await _pump(tester);
  // replace() resolves when the pushed route pops again — never await it.
  unawaited(router.replace(ServerHomeRoute(serverName: _server)));
  await _pump(tester);
  await _pump(tester);
}

void main() {
  final loggedOut = <String>[];

  setUp(() async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    SharedPreferences.setMockInitialValues({});
    ClientManager.clients.clear();
    StreamTokenService.resetForTest();
    loggedOut.clear();
    LoginManager.loggedInOverride = true;
    LoginManager.logoutHook = loggedOut.add;
    final prefs = SharedPreferencesAsync();
    await prefs.setStringList('servers', [_server]);
    await prefs.setString('wellknown_${_server}_name', 'Plain Server');
    await prefs.setString(
        'wellknown_${_server}_oidcUrl', 'https://oidc.example/realm');
    await prefs.setString('wellknown_${_server}_serverUrl', 'https://$_server');
  });

  tearDown(() {
    LoginManager.loggedInOverride = null;
    LoginManager.logoutHook = null;
    ClientManager.testClientBuilder = null;
    ClientManager.clients.clear();
    StreamTokenService.resetForTest();
  });

  testWidgets('a user without the role sees the no-access screen and can '
      'switch server', (tester) async {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _graphQL('Forbidden')),
          cache: GraphQLCache(),
        );
    final router = AppRouter();
    await _openServer(tester, router);

    expect(find.byKey(NoAccessView.viewKey), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(loggedOut, isEmpty, reason: 'forbidden keeps the session');

    await tester.tap(find.byKey(NoAccessView.switchServerKey));
    // Let the server-overview route animate in and the old one out.
    await _pump(tester);
    await _pump(tester);
    await _pump(tester);
    expect(router.current.name, HomeRoute.name);
    expect(find.byKey(NoAccessView.viewKey), findsNothing);
    // The slow "forbidden" retry timer outlives the page; cancel it before
    // the binding checks for pending timers.
    StreamTokenService.resetForTest();
  });

  testWidgets('the sign-out button on the no-access screen forgets the session',
      (tester) async {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _graphQL('Forbidden')),
          cache: GraphQLCache(),
        );
    await _openServer(tester, AppRouter());
    await tester.tap(find.byKey(NoAccessView.logoutKey));
    await _pump(tester);
    expect(loggedOut, [_server]);
  });

  testWidgets('a rejected session is signed out instead of spinning',
      (tester) async {
    ClientManager.testClientBuilder = (_) => GraphQLClient(
          link: HttpLink('https://api.example/graphql',
              httpClient: _graphQL('Unauthorized')),
          cache: GraphQLCache(),
        );
    await _openServer(tester, AppRouter());

    expect(loggedOut, [_server], reason: 'signed out exactly once');
    expect(find.byKey(NoAccessView.viewKey), findsNothing);
  });
}
