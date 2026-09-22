import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/TabNavigationNotifier.dart';

@RoutePage()
class ServerHomeOverviewPage extends StatefulWidget {
  const ServerHomeOverviewPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerHomeOverviewPage> createState() => _ServerHomeOverviewPageState();
}

class _ServerHomeOverviewPageState extends State<ServerHomeOverviewPage> {
  TabsRouter? _tabsRouter;

  @override
  void initState() {
    super.initState();
    // Reconcile the shell's bar with the tabs. ServerHomePage already reset the
    // notifier to home for this server, so a different value here is a tab the
    // user picked before the tabs had mounted — the bar is up a frame earlier —
    // and it wins, unless the URL itself chose a tab (a deep link to /library).
    // Post-frame: the shell above listens via ValueListenableBuilder, and
    // notifying it while this page mounts mid-build throws "markNeedsBuild
    // called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = _tabsRouter;
      if (!mounted || router == null) return;
      final picked = tabNavigationNotifier.value;
      if (router.activeIndex == ServerTab.home && picked != ServerTab.home) {
        router.setActiveIndex(picked);
      } else {
        tabNavigationNotifier.value = router.activeIndex;
      }
    });
    tabNavigationNotifier.addListener(_onExternalTabChange);
  }

  @override
  void dispose() {
    tabNavigationNotifier.removeListener(_onExternalTabChange);
    super.dispose();
  }

  void _onExternalTabChange() {
    _tabsRouter?.setActiveIndex(tabNavigationNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        ServerHomeContentRoute(),
        SearchRoute(),
        ShowHomeRoute(),
        ServerSettingsRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        _tabsRouter = AutoTabsRouter.of(context);
        final tabIndex = _tabsRouter!.activeIndex;

        // Mirror the real active tab back into the notifier so the nav rail/bar
        // (built one level up in ServerHomePage) highlights the right entry when
        // the tab changes by means other than a tap. Only schedule the deferred
        // write when there's an actual mismatch to avoid per-build churn and a
        // notifier feedback loop.
        if (tabNavigationNotifier.value != tabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Compare against the router's index now, not the one this build
            // saw: the mount reconciliation above may have moved it meanwhile.
            final active = _tabsRouter?.activeIndex;
            if (mounted && active != null && tabNavigationNotifier.value != active) {
              tabNavigationNotifier.value = active;
            }
          });
        }

        return child;
      },
    );
  }
}
