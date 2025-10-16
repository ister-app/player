import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';

@RoutePage()
class ServerHomeOverviewPage extends StatelessWidget {
  final String serverName;

  const ServerHomeOverviewPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

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
        final tabsRouter = AutoTabsRouter.of(context);
        final screenWidth = MediaQuery.of(context).size.width;
        final isWideScreen = screenWidth >= 1280;

        return Scaffold(
          body: Row(
            children: [
              // Use NavigationRail for wide screens
              if (isWideScreen)
                NavigationRail(
                  minWidth: 100,
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: (index) {
                    tabsRouter.setActiveIndex(index);
                  },
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(Icons.home),
                      label: Text(AppLocalizations.of(context)!.home),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.book),
                      label: Text(AppLocalizations.of(context)!.library),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text(AppLocalizations.of(context)!.settings),
                    ),
                  ],
                ),
              if (isWideScreen) const VerticalDivider(thickness: 1, width: 5),
              Expanded(
                child: child,
              ),
            ],
          ),
          // BottomNavigationBar for narrow screens
          bottomNavigationBar: !isWideScreen
              ? NavigationBar(
                  selectedIndex: tabsRouter.activeIndex,
                  onDestinationSelected: (index) {
                    tabsRouter.setActiveIndex(index);
                  },
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.home),
                      label: AppLocalizations.of(context)!.home,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.book),
                      label: AppLocalizations.of(context)!.library,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.settings),
                      label: AppLocalizations.of(context)!.settings,
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
