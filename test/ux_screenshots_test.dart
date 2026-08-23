// Renders the first-run / server screens to PNG files for a visual check.
// Only runs when UX_SCREENSHOT_DIR is set (it is a tool, not an assertion):
//   UX_SCREENSHOT_DIR=/tmp/shots flutter test test/ux_screenshots_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/LoginView.dart';
import 'package:player/components/ServerList.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AddServerPage.dart';
import 'package:player/pages/HomePage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

final _dir = Platform.environment['UX_SCREENSHOT_DIR'];
final _key = GlobalKey();

class _Router extends RootStackRouter {
  _Router(this.home);
  final Widget home;
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            path: '/',
            initial: true,
            page: PageInfo('Home', builder: (_) => home)),
        AutoRoute(
            path: '/add-server',
            page: PageInfo(AddServerRoute.name,
                builder: (_) => const AddServerPage())),
        AutoRoute(
            path: '/server/:serverName',
            page: PageInfo(ServerHomeRoute.name,
                builder: (_) => const Placeholder())),
        AutoRoute(
            path: '/downloads/:serverName',
            page: PageInfo(DownloadsRoute.name,
                builder: (_) => const Placeholder())),
      ];
}

Widget _app(Widget home, {Locale locale = const Locale('nl')}) =>
    RepaintBoundary(
      key: _key,
      child: MaterialApp.router(
        routerConfig: _Router(home).config(),
        locale: locale,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xFF4D7C0F)),
          fontFamily: 'Roboto',
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('nl')],
      ),
    );

Future<void> _shot(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    final boundary =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('$_dir/$name.png').writeAsBytes(bytes!.buffer.asUint8List());
  });
}

const _wk =
    'Thuisserver\nhttps://oidc.example.com\nhttps://media.example.com/api';

void main() {
  if (_dir == null) {
    test('skipped: UX_SCREENSHOT_DIR not set', () {});
    return;
  }

  setUpAll(() async {
    Directory(_dir!).createSync(recursive: true);
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/roboto/Roboto-Bold.ttf'));
    await loader.load();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.instance.lastClientUsed = null;
    ServerListState.debugIsWeb = false;
  });

  Future<void> size(WidgetTester tester,
      {double w = 900, double h = 640}) async {
    tester.view.physicalSize = Size(w, h);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('welcome (first run)', (tester) async {
    await size(tester);
    final mock = MockClient((_) async => http.Response('', 404));
    await http.runWithClient(() async {
      await tester.pumpWidget(_app(const HomePage()));
      await tester.pumpAndSettle();
      await _shot(tester, '01-welcome');
    }, () => mock);
  });

  testWidgets('add server: empty, found, not-ister, unreachable, duplicate',
      (tester) async {
    await size(tester);
    await SharedPreferencesAsync()
        .setStringList('servers', ['media.example.com']);
    final mock = MockClient((request) async {
      if (request.url.host == 'media.example.com') {
        return http.Response(_wk, 200);
      }
      if (request.url.host == 'www.example.com') {
        return http.Response('<html>', 200);
      }
      if (request.url.host == 'nieuw.example.com') {
        return http.Response(_wk, 200);
      }
      throw const SocketException('refused');
    });
    await http.runWithClient(() async {
      await tester.pumpWidget(_app(const AddServerPage(firstRun: true)));
      await tester.pumpAndSettle();
      await _shot(tester, '02-add-server-empty');

      await tester.enterText(
          find.byType(TextField), 'https://nieuw.example.com/');
      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      await _shot(tester, '03-add-server-found');
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'www.example.com');
      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      await _shot(tester, '04-add-server-not-ister');

      await tester.enterText(find.byType(TextField), 'nergens.example.com');
      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      await _shot(tester, '05-add-server-unreachable');

      await tester.enterText(find.byType(TextField), 'media.example.com');
      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      await _shot(tester, '06-add-server-duplicate');
    }, () => mock);
  });

  testWidgets('server overview with cards, menu and remove dialog',
      (tester) async {
    await size(tester);
    await SharedPreferencesAsync()
        .setStringList('servers', ['media.example.com', 'oud.example.com']);
    final mock = MockClient((request) async {
      if (request.url.host == 'media.example.com') {
        return http.Response(_wk, 200);
      }
      throw const SocketException('refused');
    });
    await http.runWithClient(() async {
      await tester.pumpWidget(_app(const HomePage()));
      await tester.pumpAndSettle();
      await _shot(tester, '07-overview');

      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      await _shot(tester, '08-overview-menu');
      await tester.tap(find.text('Verwijderen'));
      await tester.pumpAndSettle();
      await _shot(tester, '09-overview-remove-dialog');
    }, () => mock);
  });

  testWidgets('login view', (tester) async {
    await size(tester);
    await tester.pumpWidget(_app(Scaffold(
      appBar: AppBar(
          leading: const BackButton(), title: const Text('Thuisserver')),
      body: LoginView(
        info: const WellKnownInfo(
            name: 'Thuisserver',
            oidcUrl: 'https://oidc.example.com',
            serverUrl: 'https://media.example.com/api'),
        onLogin: () {},
        onSwitchServer: () {},
      ),
    )));
    await tester.pumpAndSettle();
    await _shot(tester, '10-login');
  });
}
