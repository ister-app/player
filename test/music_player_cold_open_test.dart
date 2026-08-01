import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/graphql/fragmentPlayQueue.graphql.dart';
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
          // A real nested router so navigate(ServerHomeRoute(children: [...]))
          // can materialise the artist/album stubs below.
          page: PageInfo(ServerHomeRoute.name,
              builder: (data) => const AutoRouter()),
          children: [
            AutoRoute(
              path: '',
              initial: true,
              page: PageInfo('StubServerHome',
                  builder: (data) => const Scaffold(body: Text('server home'))),
            ),
            AutoRoute(
              path: 'persons/:personId',
              page: PageInfo(PersonRoute.name,
                  builder: (data) => const Scaffold(body: Text('artist page'))),
            ),
            AutoRoute(
              path: 'albums/:albumId',
              page: PageInfo(AlbumRoute.name,
                  builder: (data) => const Scaffold(body: Text('album page'))),
            ),
          ],
        ),
      ];
}

/// A playing track on `test-server`, enough for PlayerView's metadata lines
/// and their navigation targets.
void _installPlayingTrack(MediaPlayerHandler handler) {
  handler.serverName = 'test-server';
  handler.currentPlayQueueItem = Fragment$fragmentPlayQueue$playQueueItems(
    id: 'pq-item-1',
    position: 0,
    track: Fragment$fragmentPlayQueue$playQueueItems$track(
      id: 'track-1',
      number: 1,
      discNumber: 1,
      artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist(
          id: 'artist-1', name: 'The Artist'),
      album: Fragment$fragmentPlayQueue$playQueueItems$track$album(
          id: 'album-1', name: 'The Album'),
    ),
  );
  handler.mediaItem.add(const MediaItem(
    id: 'test-server;track;pq-item-1',
    title: 'The Song',
    artist: 'The Artist',
    album: 'The Album',
  ));
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
    handler.serverName = null;
    handler.currentPlayQueueItem = null;
    handler.mediaItem.add(null);
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

  testWidgets('tapping the artist line opens the artist page', (tester) async {
    _installPlayingTrack(handler);
    final router = _TestRouter();
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    // Mirror the real topology: the player overlay sits on top of the server
    // shell, so navigate() updates the shell's children *below* the overlay.
    await router.replaceAll([ServerHomeRoute(serverName: 'test-server')]);
    await tester.pumpAndSettle();
    router.push(const MusicPlayerRoute());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('The Artist').first);
    await tester.pumpAndSettle();

    expect(find.text('artist page'), findsOneWidget);
    expect(find.byType(PlayerView, skipOffstage: false), findsNothing);
  });

  testWidgets('tapping the album line opens the album page', (tester) async {
    _installPlayingTrack(handler);
    final router = _TestRouter();
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    await router.replaceAll([ServerHomeRoute(serverName: 'test-server')]);
    await tester.pumpAndSettle();
    router.push(const MusicPlayerRoute());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('The Album').first);
    await tester.pumpAndSettle();

    expect(find.text('album page'), findsOneWidget);
    expect(find.byType(PlayerView, skipOffstage: false), findsNothing);
  });
}
