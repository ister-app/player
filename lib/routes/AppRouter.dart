import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/routes/ServerChildDeepLinkGuard.dart';

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
    CustomRoute(path: '/player', page: MusicPlayerRoute.page, opaque: false, barrierColor: Colors.transparent, duration: Duration.zero, reverseDuration: Duration.zero),
    // Party-mode remote control: the same full-screen overlay presentation as
    // the music player, so it sits above nested server routes and mini player.
    CustomRoute(path: '/remote/:serverName/:playQueueId', page: RemoteControlRoute.page, opaque: false, barrierColor: Colors.transparent, duration: Duration.zero, reverseDuration: Duration.zero),
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
          AutoRoute(path: 'books/:bookId', page: BookRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'books/:bookId/read/:mediaFileId', page: ReaderRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'podcasts/:podcastId', page: PodcastRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'persons/:personId', page: PersonRoute.page, guards: [_deepLinkGuard]),
        ]
    ),
  ];
}
