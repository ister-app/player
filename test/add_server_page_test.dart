import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AddServerPage.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class _TestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('AddServerRoute',
              builder: (data) => const AddServerPage()),
        ),
        AutoRoute(
          path: '/server/:serverName',
          page: PageInfo(ServerHomeRoute.name,
              builder: (data) => const Placeholder()),
        ),
      ];
}

Widget _app() => MaterialApp.router(
      routerConfig: _TestRouter().config(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );

Future<void> _connect(WidgetTester tester, String address) async {
  await tester.enterText(find.byType(TextField), address);
  await tester.tap(find.text('Connect'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.instance.lastClientUsed = null;
  });

  tearDown(() => ClientManager.instance.lastClientUsed = null);

  testWidgets('a found server is shown by name and added on confirm',
      (tester) async {
    final mock = MockClient((request) async {
      expect(request.url.toString(),
          'https://media.example.com/.well-known/ister');
      return http.Response(
          'My Server\nhttps://oidc.example.com\nhttps://media.example.com/api',
          200);
    });

    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      // The scheme and trailing slash are stripped before probing.
      await _connect(tester, 'https://media.example.com/');

      expect(find.text('Server found'), findsOneWidget);
      expect(find.text('My Server'), findsOneWidget);
      expect(find.text('https://media.example.com/api'), findsOneWidget);
      expect(await SharedPreferencesAsync().getStringList('servers'), isNull);

      await tester.tap(find.text('Add and sign in'));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(await SharedPreferencesAsync().getStringList('servers'),
        ['media.example.com']);
    expect(ClientManager.instance.lastClientUsed, 'media.example.com');
    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('an address that answers without a well-known is explained',
      (tester) async {
    final mock = MockClient((request) async => http.Response('nope', 404));
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _connect(tester, 'www.example.com');
    }, () => mock);

    expect(find.textContaining('No Ister server was found'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(await SharedPreferencesAsync().getStringList('servers'), isNull);
  });

  testWidgets('an address that does not answer is reported as unreachable',
      (tester) async {
    final mock = MockClient((request) async => throw Exception('refused'));
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _connect(tester, 'nowhere.example.com');
    }, () => mock);

    expect(find.textContaining('could not be reached'), findsOneWidget);
  });

  testWidgets('an empty address never probes', (tester) async {
    var calls = 0;
    final mock = MockClient((request) async {
      calls++;
      return http.Response('', 200);
    });
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _connect(tester, '   ');
    }, () => mock);

    expect(calls, 0);
    expect(find.text('Enter a server address without spaces'), findsOneWidget);
  });

  testWidgets('an already configured server offers to open it',
      (tester) async {
    await SharedPreferencesAsync().setStringList('servers', ['media.example.com']);
    var calls = 0;
    final mock = MockClient((request) async {
      calls++;
      return http.Response('', 200);
    });
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await _connect(tester, 'media.example.com');

      expect(calls, 0);
      expect(find.text('This server is already in your list.'), findsOneWidget);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }, () => mock);

    expect(find.byType(Placeholder), findsOneWidget);
    expect(await SharedPreferencesAsync().getStringList('servers'),
        ['media.example.com']);
  });
}
