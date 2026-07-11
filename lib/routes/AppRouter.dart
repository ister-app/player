import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/routes/ServerChildDeepLinkGuard.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

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
    final hasMusicPlayer = controller.stack.any((p) => p.routeData.name == MusicPlayerRoute.name);
    final dismiss = MediaPlayerHandler.instance.dismissMusicPlayer;
    // Only intercept back when we actually have a dismiss handler to run;
    // otherwise fall through so the back button isn't silently swallowed.
    if (hasMusicPlayer && dismiss != null) {
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
    CustomRoute(path: '/player', page: MusicPlayerRoute.page, opaque: false, barrierColor: Colors.transparent, duration: Duration.zero, reverseDuration: Duration.zero),
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
          AutoRoute(path: 'settings/nowplaying', page: ServerNowPlayingRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/nowplaying/:playQueueId', page: RemoteControlRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/activity', page: ServerActivityRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'shows/:showId', page: ShowOverviewRoute.page,
            guards: [_deepLinkGuard],
            children: [
              AutoRoute(path: 'overview', page: ShowOverviewContentRoute.page, initial: true),
              AutoRoute(path: 'episodes/:episodeId', page: ShowEpisodeRoute.page),
            ]
          ),
          AutoRoute(path: 'search', page: SearchRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'movies/:movieId', page: MovieRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'albums/:albumId', page: AlbumRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'persons/:personId', page: PersonRoute.page, guards: [_deepLinkGuard]),
        ]
    ),
  ];
}
