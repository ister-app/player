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
    // Reset so a value left over from a previously open server's home page
    // doesn't select the wrong tab here. Post-frame: the shell above listens
    // via ValueListenableBuilder, and notifying it while this page mounts
    // mid-build throws "markNeedsBuild called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabNavigationNotifier.value = 0;
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
            if (mounted && tabNavigationNotifier.value != tabIndex) {
              tabNavigationNotifier.value = tabIndex;
            }
          });
        }

        return child;
      },
    );
  }
}
