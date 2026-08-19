import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/main.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/routes/AppRouter.gr.dart';

/// Boots a router the way `Main` does and returns the resulting root stack.
Future<List<String>> _bootStack(
  AppRouter router, {
  required List<RouteMatch> segments,
}) async {
  final config = router.config(
    deepLinkBuilder: (link) => bootDeepLink(link, 'my-server'),
  );
  final delegate = config.routerDelegate as AutoRouterDelegate;
  await delegate.setInitialRoutePath(UrlState.fromSegments(segments));
  return router.stack.map((page) => page.routeData.name).toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a plain launch opens the last server as the only root route', () async {
    final router = AppRouter();
    final stack = await _bootStack(router, segments: const []);

    // Nothing below the server's shell, so back at its root finds nothing to
    // pop: the delegate reports the back button as unhandled and the platform
    // leaves the app, rather than revealing the server list underneath.
    expect(stack, [ServerHomeRoute.name]);
    expect(router.canPop(), isFalse);
  });

  test('the path form of that link would bury the server list underneath',
      () async {
    // Why bootDeepLink hands over a route instead of '/server/<name>': a path
    // deep link prefix-matches '/' as well. Pin it so a well-meant switch back
    // to DeepLink.path is caught here.
    final router = AppRouter();
    final matches =
        router.matcher.match('/server/my-server', includePrefixMatches: true);

    expect(matches?.map((m) => m.name), [HomeRoute.name, ServerHomeRoute.name]);
  });

  test('a real deep link keeps its own stack', () async {
    final router = AppRouter();
    final segments = router.matcher.match(
      '/server/my-server/movies/movie-1',
      includePrefixMatches: true,
    )!;
    final stack = await _bootStack(router, segments: segments);

    expect(stack.last, ServerHomeRoute.name);
    expect(
      router.stack.last.routeData.pendingChildren.map((c) => c.name),
      contains(MovieRoute.name),
    );
  });
}
