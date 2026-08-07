import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/TvDirectionalFocusPolicy.dart';

/// The show page nests a router: the cast row lives in the nested route (its
/// own navigator FocusScope) while the season list lives in the parent route,
/// both inside the same outer scrollable. Directional candidates limited to
/// the nearest scope can never see the season list from the cast row — this
/// reproduces that structure.
void main() {
  Widget buildNestedPage() {
    return MaterialApp(
      builder: (context, child) => FocusTraversalGroup(
        policy: TvDirectionalFocusPolicy(),
        child: child ?? const SizedBox.shrink(),
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Nested navigator: the content route with its own scope,
                    // like AutoRouter() inside ShowOverviewPage.
                    SizedBox(
                      height: 500,
                      child: Navigator(
                        onGenerateRoute: (_) => MaterialPageRoute(
                          builder: (_) => SingleChildScrollView(
                            child: Column(children: [
                              const SizedBox(height: 350),
                              SizedBox(
                                height: 100,
                                child: TextButton(
                                  key: const Key('cast'),
                                  onPressed: () {},
                                  child: const Text('cast'),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    // Season list in the parent route, below the fold.
                    const SizedBox(height: 500),
                    ListTile(
                      key: const Key('season'),
                      title: const Text('season'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: TextButton(
                key: const Key('bar'),
                onPressed: () {},
                child: const Text('bar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets(
      'DOWN crosses the nested-route scope into the parent-route season list',
      (tester) async {
    await tester.pumpWidget(buildNestedPage());
    await tester.pumpAndSettle();

    Focus.of(tester.element(find.text('cast'))).requestFocus();
    await tester.pump();
    expect(Focus.of(tester.element(find.text('cast'))).hasPrimaryFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();

    expect(
        Focus.of(tester.element(find.text('season'))).hasPrimaryFocus, isTrue,
        reason: 'the season list in the parent route must be reachable from '
            'the cast row in the nested route');
  });
}
