import 'package:auto_route/auto_route.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/routes/ServerChildDeepLinkGuard.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final _deepLinkGuard = ServerChildDeepLinkGuard();

  @override
  List<AutoRoute> get routes => [
    // RedirectRoute(path: "/", redirectTo: "/home"),
    AutoRoute(path: "/", page: HomeRoute.page), // page with all logged in servers and button to login in new server
    AutoRoute(path: "/server/:serverName", page: ServerHomeRoute.page,
        children: [
          AutoRoute(path: '', page: ServerHomeOverviewRoute.page, initial: true,
              children: [
                RedirectRoute(path: '', redirectTo: 'home'),
                AutoRoute(path: 'home', page: ServerHomeContentRoute.page),
                AutoRoute(path: 'library', page: ShowHomeRoute.page),
                AutoRoute(path: 'settings', page: ServerSettingsRoute.page),
                ]
          ), // Overview with newly added items and resume watching view
          AutoRoute(path: 'settings/languages', page: ServerSettingsLanguageRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/cluster', page: ServerSettingsClusterRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'settings/playback', page: ServerSettingsPlaybackRoute.page, guards: [_deepLinkGuard]),
          AutoRoute(path: 'shows/:showId', page: ShowOverviewRoute.page,
            guards: [_deepLinkGuard],
            children: [
              AutoRoute(path: 'overview', page: ShowOverviewContentRoute.page, initial: true),
              AutoRoute(path: 'episodes/:episodeId', page: ShowEpisodeRoute.page),
            ]
          ),
          AutoRoute(path: 'movies/:movieId', page: MovieRoute.page, guards: [_deepLinkGuard]),
        ]
    ),
  ];
}
