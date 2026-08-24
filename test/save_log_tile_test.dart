import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:player/components/SaveLogTile.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/AppLogStore.dart';

void main() {
  late Directory root;
  late AppLogStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('savelog');
    store = AppLogStore(rootOverride: root);
  });

  tearDown(() async {
    SaveLogTile.savePickerOverride = null;
    await root.delete(recursive: true);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: SaveLogTile(store: store)),
    ));
  }

  void seedLog() {
    Logger(
      filter: ProductionFilter(),
      printer: SimplePrinter(colors: false),
      output: store.output,
    ).i('something went wrong');
  }

  testWidgets('saves the exported log and confirms', (tester) async {
    seedLog();
    String? pickedName;
    Uint8List? pickedBytes;
    SaveLogTile.savePickerOverride = (fileName, bytes) async {
      pickedName = fileName;
      pickedBytes = bytes;
      return Uri.file('/somewhere/$fileName');
    };

    await pump(tester);
    await tester.tap(find.byType(SaveLogTile));
    await tester.pumpAndSettle();

    expect(pickedName, startsWith('ister-log-'));
    expect(String.fromCharCodes(pickedBytes!),
        contains('something went wrong'));
    expect(find.text('Log saved'), findsOneWidget);
  });

  testWidgets('cancelling shows no snackbar', (tester) async {
    seedLog();
    SaveLogTile.savePickerOverride = (fileName, bytes) async => null;

    await pump(tester);
    await tester.tap(find.byType(SaveLogTile));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a failing save reports the error', (tester) async {
    seedLog();
    SaveLogTile.savePickerOverride =
        (fileName, bytes) async => throw Exception('disk full');

    await pump(tester);
    await tester.tap(find.byType(SaveLogTile));
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not save the log'), findsOneWidget);
  });

  testWidgets('an empty log reports there is nothing to save', (tester) async {
    await pump(tester);
    await tester.tap(find.byType(SaveLogTile));
    await tester.pumpAndSettle();

    expect(find.text('There is no log to save yet'), findsOneWidget);
  });
}
