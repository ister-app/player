import 'package:auto_route/auto_route.dart';
import 'package:player/routes/AppRouter.gr.dart';

class ServerChildDeepLinkGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final hasOverview = router.stack.any(
      (r) => r.name == ServerHomeOverviewRoute.name,
    );
    if (!hasOverview) {
      router.push(ServerHomeOverviewRoute());
    }
    resolver.next(true);
  }
}
