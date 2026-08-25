import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/routes/ServerChildDeepLinkGuard.dart';
import 'package:player/utils/ClientManager.dart';

/// Closes a full-screen overlay route (`/player`, `/remote/…`): pops it, or
/// lands on the server shell when it is the only route left.
///
/// Android can dispose the activity while the audio foreground service keeps
/// the process alive; on return the router rebuilds the root stack from the
/// current URL, and for an overlay route that leaves a stack of exactly one.
/// Popping that empties the navigator, which renders blank with no way out —
/// the user has to kill the app. [ServerChildDeepLinkGuard] does the same job
/// for the server's child routes.
void popOverlayRoute(BuildContext context, {String? serverName}) {
  final router = context.router;
  if (router.stack.length > 1) {
    router.pop();
    return;
  }
  final server = serverName ?? ClientManager.instance.lastClientUsed;
  router.replaceAll([
    if (server != null) ServerHomeRoute(serverName: server) else HomeRoute(),
  ]);
}

class _MusicPlayerAwareDelegate extends AutoRouterDelegate {
  _MusicPlayerAwareDelegate(
    super.controller, {
    super.navRestorationScopeId,
    super.placeholder,
    super.navigatorObservers,
    super.deepLinkBuilder,
    super.rebuildStackOnDeepLink,
    super.reevaluateListenable,
    super.clipBehavior,
  });

  @override
  Future<bool> popRoute() async {
    // A player overlay (music player or party-mode remote) is dismissed with
    // its slide-down animation instead of an instant pop; only intercept back
    // when one is actually open so the button isn't silently swallowed.
    final dismiss = PlayerView.activeBackHandler;
    if (dismiss != null) {
      dismiss();
      return true;
    }
    return super.popRoute();
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final _deepLinkGuard = ServerChildDeepLinkGuard();
  AutoRouterDelegate? _lazyDelegate;

  @override
  AutoRouterDelegate delegate({
    String? navRestorationScopeId,
    WidgetBuilder? placeholder,
    NavigatorObserversBuilder navigatorObservers =
        AutoRouterDelegate.defaultNavigatorObserversBuilder,
    DeepLinkBuilder? deepLinkBuilder,
    bool rebuildStackOnDeepLink = false,
    Listenable? reevaluateListenable,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return _lazyDelegate ??= _MusicPlayerAwareDelegate(
      this,
      navRestorationScopeId: navRestorationScopeId,
      placeholder: placeholder,
      navigatorObservers: navigatorObservers,
      deepLinkBuilder: deepLinkBuilder,
      rebuildStackOnDeepLink: rebuildStackOnDeepLink,
      reevaluateListenable: reevaluateListenable,
      clipBehavior: clipBehavior,
    );
  }

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: "/", page: HomeRoute.page),
    AutoRoute(path: "/add-server", page: AddServerRoute.page),
    CustomRoute(path: '/player', page: MusicPlayerRoute.page, opaque: false, barrierColor: Colors.transparent, duration: Duration.zero, reverseDuration: Duration.zero),
    // Party-mode remote control: the same full-screen overlay presentation as
    // the music player, so it sits above nested server routes and mini player.
    CustomRoute(path: '/remote/:serverName/:playQueueId', page: RemoteControlRoute.page, opaque: false, barrierColor: Colors.transparent, duration: Duration.zero, reverseDuration: Duration.zero),
    // Downloads live outside the server shell: they must render (and play)
    // when the server is unreachable, so nothing here runs a GraphQL query.
    AutoRoute(path: '/downloads/:serverName', page: DownloadsRoute.page),
    AutoRoute(path: '/downloads/:serverName/settings', page: DownloadSettingsRoute.page),
    AutoRoute(path: '/downloads/:serverName/play', page: LocalVideoRoute.page),
    AutoRoute(path: '/downloads/:serverName/read/:bookId/:mediaFileId', page: OfflineReaderRoute.page),
    AutoRoute(path: '/downloads/:serverName/comic/:bookId/:mediaFileId', page: OfflineComicReaderRoute.page),
    AutoRoute(path: "/server/:serverName", page: ServerHomeRoute.page,
        children: [
          AutoRoute(path: '', page: ServerHomeOverviewRoute.page, initial: true,
              children: [
                RedirectRoute(path: '', redirectTo: 'home'),
                AutoRoute(path: 'home', page: ServerHomeContentRoute.page),
                AutoRoute(path: 'library', page: ShowHomeRoute.page),
                AutoRoute(path: 'settings', page: ServerSettingsRoute.page),
              ]
          ),
          AutoRoute(path: 'settings/languages', page: ServerSettingsLanguageRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/cluster', page: ServerSettingsClusterRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/playback', page: ServerSettingsPlaybackRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/sleep-timer', page: SleepTimerSettingsRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/sharing', page: ServerSettingsSharingRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/devices', page: ServerSettingsDevicesRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/nowplaying', page: ServerNowPlayingRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/about', page: ServerSettingsAboutRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/downloads', page: ServerDownloadsRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/downloads/settings', page: ServerDownloadSettingsRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/downloads/play', page: ServerLocalVideoRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/users', page: AdminUsersRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/users/:userId', page: AdminUserAccessRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/libraries', page: AdminLibrariesRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'shows/:showId', page: ShowOverviewRoute.page,
            guards: [_deepLinkGuard],
            children: [
              AutoRoute(path: 'overview', page: ShowOverviewContentRoute.page, initial: true),
              AutoRoute(path: 'episodes/:episodeId', page: ShowEpisodeRoute.page),
            ]
          ),
          AutoRoute(path: 'search', page: SearchRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'list', page: MediaListRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'playlists', page: PlaylistListRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'playlists/:playlistId', page: PlaylistRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'cast', page: CastListRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'movies/:movieId', page: MovieRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'albums/:albumId', page: AlbumRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'books/:bookId', page: BookRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'books/:bookId/read/:mediaFileId', page: ReaderRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'books/:bookId/comic/:mediaFileId', page: ComicReaderRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'series/:seriesId', page: SeriesRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'podcasts/:podcastId', page: PodcastRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'persons/:personId', page: PersonRoute.page, guards: [_deepLinkGuard]),
        ]
    ),
  ];
}
