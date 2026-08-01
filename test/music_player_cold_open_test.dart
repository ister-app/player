import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Minimal router: the REAL MusicPlayerPage at /player, with stubs in place of
/// the pages its cold-open guard can redirect to.
class _TestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('RootRoute',
              builder: (data) => const Scaffold(body: Text('root'))),
        ),
        AutoRoute(path: '/player', page: MusicPlayerRoute.page),
        AutoRoute(
          path: '/home',
          page: PageInfo(HomeRoute.name,
              builder: (data) => const Scaffold(body: Text('server list'))),
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
  TestWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final handler = MediaPlayerHandler.instance;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    ClientManager.instance.lastClientUsed = null;
    handler.mediaLoading.value = false;
    handler.musicPlayerOpen.value = false;
  });

  tearDown(() {
    handler.mediaLoading.value = false;
    handler.musicPlayerOpen.value = false;
  });

  testWidgets('cold /player URL with nothing playing redirects away',
      (tester) async {
    final router = _TestRouter();
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    router.push(const MusicPlayerRoute());
    await tester.pumpAndSettle();

    expect(find.text('server list'), findsOneWidget);
    expect(find.byType(PlayerView), findsNothing);
  });

  testWidgets(
      'player pushed while a fresh track is loading stays open '
      '(no jump to the start screen)', (tester) async {
    final router = _TestRouter();
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    // startPlayQueueFor… flips mediaLoading before bumping
    // openMusicPlayerRequest; mediaItem/queue are still empty at that point.
    handler.mediaLoading.value = true;
    router.push(const MusicPlayerRoute());
    // Fixed pumps rather than pumpAndSettle: the loading skeleton's shimmer
    // animates forever. 600ms covers the route transition and slide-up.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(PlayerView, skipOffstage: false), findsOneWidget);
    expect(find.text('server list'), findsNothing);
    expect(handler.musicPlayerOpen.value, isTrue);
  });
}
