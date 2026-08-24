import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/AppModalSheet.dart';

/// The server shell in miniature: a nested navigator filling the content area
/// with the mini player below it. A sheet opened from a page inside that
/// navigator must still slide up from the bottom of the *window*.
Widget _shell({required void Function(BuildContext) onPage}) => MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Navigator(
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (context) {
                    onPage(context);
                    return const Text('page');
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const SizedBox(height: 72, child: Text('mini')),
      ),
    );

void main() {
  testWidgets('a sheet from a nested navigator ends at the window bottom',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late BuildContext pageContext;
    await tester.pumpWidget(_shell(onPage: (c) => pageContext = c));
    await tester.pumpAndSettle();

    showAppSheet<void>(
      pageContext,
      builder: (_) => const SizedBox(
        key: ValueKey('sheet'),
        height: 300,
        width: double.infinity,
      ),
    );
    await tester.pumpAndSettle();

    // Without the root navigator this stopped at 728: the bottom of the
    // content area, above the mini player.
    expect(tester.getRect(find.byKey(const ValueKey('sheet'))).bottom, 800);
  });
}
