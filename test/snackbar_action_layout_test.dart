import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/l10n/app_localizations_nl.dart';
import 'package:player/main.dart';

/// Pins [appSnackBarTheme]: without it a snackbar carrying the Dutch "Ongedaan
/// maken" action balloons from one line to a 110px block on every phone width.
///
/// Material drops the action onto its own row once its label is wider than a
/// quarter of the bar, and then *still* reserves 40% of the width beside the
/// text — so the text wraps as well. English "Undo" never trips it, which is
/// why this only ever showed up in Dutch.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Widths are the whole point here, and the default test font makes every
    // glyph the same box — measure with the font the app actually ships.
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/roboto/Roboto-Bold.ttf'));
    await loader.load();
  });

  /// Height of a snackbar showing [message] with the Dutch undo action.
  Future<double> heightOf(
    WidgetTester tester, {
    required double width,
    required String message,
    required bool withTheme,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final messenger = GlobalKey<ScaffoldMessengerState>();
    await tester.pumpWidget(MaterialApp(
      scaffoldMessengerKey: messenger,
      theme: ThemeData(
        fontFamily: 'Roboto',
        snackBarTheme: withTheme ? appSnackBarTheme : const SnackBarThemeData(),
      ),
      home: const Scaffold(body: SizedBox()),
    ));

    messenger.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: AppLocalizationsNl().undo, onPressed: () {}),
    ));
    await tester.pumpAndSettle();
    return tester.getSize(find.byType(SnackBar)).height;
  }

  // A narrow phone, a common one, and a wide one.
  for (final width in [320.0, 360.0, 412.0]) {
    testWidgets('a Dutch undo action stays inline at ${width.toInt()}px',
        (tester) async {
      final message = AppLocalizationsNl().languageRemoved('Nederlands');
      expect(
        await heightOf(tester,
            width: width, message: message, withTheme: true),
        lessThanOrEqualTo(70.0),
        reason: 'at most two text lines; the action never gets its own row '
            '(48px on a 360px phone, 68px on a cramped 320px one)',
      );
    });
  }

  testWidgets('without the theme it is the tall block this guards against',
      (tester) async {
    final message = AppLocalizationsNl().languageRemoved('Nederlands');
    expect(
      await heightOf(tester, width: 360, message: message, withTheme: false),
      greaterThan(100.0),
    );
  });

  testWidgets('a long name still wraps rather than overflowing',
      (tester) async {
    final height = await heightOf(tester,
        width: 320,
        message: AppLocalizationsNl()
            .languageRemoved('Portugees (Brazilië) en omstreken'),
        withTheme: true);
    expect(height, greaterThan(48.0));
    expect(tester.takeException(), isNull);
  });
}
