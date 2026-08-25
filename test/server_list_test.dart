import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/ServerList.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Minimal router: the server list at '/', and a stub in place of the real
/// server home page so goToServerRoute has somewhere to navigate to.
class _TestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('ServerListRoute',
              builder: (data) => const Scaffold(body: ServerList())),
        ),
        AutoRoute(
          path: '/server/:serverName',
          page: PageInfo(ServerHomeRoute.name,
              builder: (data) => const Placeholder()),
        ),
      ];
}

Widget _app(_TestRouter router) => MaterialApp.router(
      routerConfig: router.config(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    WellKnownService.resetForTest();
    ClientManager.instance.lastClientUsed = null;
    ServerListState.debugIsWeb = true;
  });

  tearDown(() {
    ServerListState.debugIsWeb = false;
    ClientManager.instance.lastClientUsed = null;
  });

  testWidgets(
      'web build does not auto-add its hosting origin when it serves no well-known',
      (tester) async {
    ServerListState.debugWebHost = () => 'static.example.app';
    final mock = MockClient((request) async => http.Response('not found', 404));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(find.byType(Card), findsNothing);
    expect(find.byType(Placeholder), findsNothing);
    expect(await SharedPreferencesAsync().getStringList('servers'), isNull);
    // The empty overview is the welcome screen with its own add button.
    expect(find.text('Welcome to Ister'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Add a server'), findsOneWidget);
  });

  testWidgets('web build auto-adds its hosting origin when well-known resolves',
      (tester) async {
    ServerListState.debugWebHost = () => 'served.example.app';
    final mock = MockClient((request) async {
      expect(request.url.path, '/.well-known/ister');
      return http.Response(
          'My Server\nhttps://oidc.example.app\nhttps://served.example.app/api',
          200);
    });

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(await SharedPreferencesAsync().getStringList('servers'),
        ['served.example.app']);
    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('a reachable server shows name, address and a connected chip',
      (tester) async {
    ServerListState.debugIsWeb = false;
    await SharedPreferencesAsync().setStringList('servers', ['media.example.com']);
    final mock = MockClient((request) async => http.Response(
        'My Server\nhttps://oidc.example.com\nhttps://media.example.com/api',
        200));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(find.text('My Server'), findsOneWidget);
    expect(find.text('https://media.example.com/api'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
  });

  testWidgets('an unreachable server is marked but still opens',
      (tester) async {
    ServerListState.debugIsWeb = false;
    await SharedPreferencesAsync().setStringList('servers', ['down.example.com']);
    final mock = MockClient((request) async => throw Exception('refused'));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();
      expect(find.text('Unreachable'), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(find.byType(Placeholder), findsOneWidget);
    expect(ClientManager.instance.lastClientUsed, 'down.example.com');
  });

  testWidgets(
      'a server we reached before but that is down now is not "connected"',
      (tester) async {
    ServerListState.debugIsWeb = false;
    final prefs = SharedPreferencesAsync();
    await prefs.setStringList('servers', ['cached.example.com']);
    // What an earlier successful visit left behind.
    await prefs.setString('wellknown_cached.example.com_name', 'My Server');
    await prefs.setString(
        'wellknown_cached.example.com_oidcUrl', 'https://oidc.example.com');
    await prefs.setString('wellknown_cached.example.com_serverUrl',
        'https://cached.example.com/api');
    final mock = MockClient((request) async => throw Exception('refused'));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(find.text('Connected'), findsNothing);
    expect(find.text('Unreachable'), findsOneWidget);
    // The remembered name still labels the card; only the status is honest.
    expect(find.text('My Server'), findsOneWidget);
    expect(find.text('https://cached.example.com/api'), findsOneWidget);
  });

  testWidgets('removing a server asks for confirmation first', (tester) async {
    ServerListState.debugIsWeb = false;
    await SharedPreferencesAsync().setStringList('servers', ['media.example.com']);
    final mock = MockClient((request) async => http.Response(
        'My Server\nhttps://oidc.example.com\nhttps://media.example.com/api',
        200));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(_TestRouter()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove My Server?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await SharedPreferencesAsync().getStringList('servers'),
          ['media.example.com']);
      expect(find.text('My Server'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(await SharedPreferencesAsync().getStringList('servers'), isEmpty);
    expect(find.text('Welcome to Ister'), findsOneWidget);
  });
}
