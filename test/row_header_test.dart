import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/RowHeader.dart';
import 'package:player/components/TvFocusable.dart';
import 'package:player/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: RowHeaderHost(child: child)),
    );

class RowHeaderHost extends StatelessWidget {
  const RowHeaderHost({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => child;
}

void main() {
  testWidgets('tappable header fires onTap and shows the chevron affordance',
      (tester) async {
    var taps = 0;
    await tester
        .pumpWidget(_wrap(RowHeader(label: 'Movies', onTap: () => taps++)));

    expect(find.text('Movies:'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    // Reachable by D-pad on Android TV.
    expect(find.byType(TvFocusable), findsOneWidget);

    await tester.tap(find.text('Movies:'));
    expect(taps, 1);
  });

  testWidgets('plain header renders without chevron or tap handling',
      (tester) async {
    await tester.pumpWidget(_wrap(const RowHeader(label: 'Movies')));

    expect(find.text('Movies:'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(TvFocusable), findsNothing);
  });

  testWidgets('cast variant drops the colon', (tester) async {
    await tester.pumpWidget(_wrap(
        RowHeader(label: 'Cast', trailingColon: false, onTap: () {})));

    expect(find.text('Cast'), findsOneWidget);
    expect(find.text('Cast:'), findsNothing);
  });
}
