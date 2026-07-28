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
}
