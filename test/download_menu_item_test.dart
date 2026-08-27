import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/download/DownloadMenuItem.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadService.dart';

/// `MenuItemButton._handleSelect` closes the menu *before* it calls
/// `onPressed`, which deactivates the item's element. A download action that
/// reads `AppLocalizations.of(context)` from the callback therefore blows up
/// with "Looking up a deactivated widget's ancestor is unsafe" and nothing is
/// ever queued — see [DownloadActionScope].
void main() {
  Widget wrap(Widget child) => GraphQLProvider(
        client: ValueNotifier(GraphQLClient(
          link: HttpLink('https://api.example/graphql'),
          cache: GraphQLCache(),
        )),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(body: child),
        ),
      );

  testWidgets('picking the item runs the action after the menu has closed',
      (tester) async {
    var loaded = false;
    final action = DownloadAction(
      serverName: 'test-server',
      kind: DownloadKind.track,
      mediaId: 'track-1',
      // Returning nothing keeps the store out of it: the action reports
      // "nothing to download" through the messenger and stops there.
      load: (_) async {
        loaded = true;
        return const <DownloadRequest>[];
      },
    );

    await tester.pumpWidget(wrap(
      MenuAnchor(
        menuChildren: [DownloadMenuItem(action: action)],
        builder: (context, controller, _) => TextButton(
          onPressed: controller.open,
          child: const Text('menu'),
        ),
      ),
    ));

    await tester.tap(find.text('menu'));
    await tester.pump();

    expect(find.byType(DownloadMenuItem), findsOneWidget,
        reason: 'the menu should be open');

    await tester.tap(find.byType(DownloadMenuItem));
    await tester.pump();

    // The failure this guards against surfaces as an uncaught exception from
    // the callback, not as a wrong result.
    expect(tester.takeException(), isNull);
    expect(loaded, isTrue,
        reason: 'the action never ran, so the context lookup threw');
  });

  testWidgets('the scope survives its originating element being unmounted',
      (tester) async {
    late DownloadActionScope scope;
    var show = true;
    late StateSetter setOuter;

    await tester.pumpWidget(wrap(StatefulBuilder(
      builder: (context, setState) {
        setOuter = setState;
        return show
            ? Builder(builder: (inner) {
                scope = DownloadActionScope.of(inner);
                return const Text('here');
              })
            : const Text('gone');
      },
    )));

    setOuter(() => show = false);
    await tester.pump();
    expect(find.text('gone'), findsOneWidget);

    // Nothing below reaches back into the dead element.
    expect(scope.loc.download, isNotEmpty);
    expect(() => scope.messenger.hideCurrentSnackBar(), returnsNormally);
    expect(scope.client.value, isA<GraphQLClient>());
  });
}
