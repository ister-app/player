import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/artwork/ArtworkNavigation.dart';
import 'package:player/utils/artwork/ArtworkTarget.dart';

/// `MenuItemButton._handleSelect` closes the menu and only then, a frame
/// later, calls `onPressed`; the item's element is gone by then, so an
/// `AutoRouter.of(context)` from the callback threw "Null check operator used
/// on a null value" and the picker never opened. The router has to be
/// resolved in `build`.
class _NavRouter extends RootStackRouter {
  ArtworkPickerRouteArgs? pushedArgs;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          initial: true,
          page: PageInfo('HostRoute',
              builder: (data) => Scaffold(
                    body: MenuAnchor(
                      menuChildren: const [
                        ChangeArtworkMenuItem(
                          target:
                              ArtworkTarget(ArtworkTargetKind.movie, 'movie-1'),
                          title: 'A movie',
                        ),
                      ],
                      builder: (context, controller, _) => TextButton(
                        onPressed: controller.open,
                        child: const Text('menu'),
                      ),
                    ),
                  )),
        ),
        AutoRoute(
          path: '/artwork',
          page: PageInfo(ArtworkPickerRoute.name, builder: (data) {
            pushedArgs = data.argsAs<ArtworkPickerRouteArgs>();
            return const Scaffold(body: Text('picker-stub'));
          }),
        ),
      ];
}

void main() {
  testWidgets('picking the item opens the picker after the menu has closed',
      (tester) async {
    final router = _NavRouter();
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router.config(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en')],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('menu'));
    await tester.pump();
    expect(find.byKey(ChangeArtworkMenuItem.itemKey), findsOneWidget);

    await tester.tap(find.byKey(ChangeArtworkMenuItem.itemKey));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('picker-stub'), findsOneWidget);
    expect(router.pushedArgs?.kind, 'movie');
    expect(router.pushedArgs?.id, 'movie-1');
    expect(router.pushedArgs?.title, 'A movie');
  });
}
