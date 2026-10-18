import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/games/SaveConflictDialog.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLibraryService.dart';

void main() {
  final conflict = SaveConflict(
    serverHead: GameSaveInfo(
        version: 7, sizeBytes: 100, sha256: 'x', deviceName: 'laptop', note: null, createdAt: DateTime(2026, 3, 4, 10, 30)),
    install: GameInstall(gameId: 'g', form: 'ROM', platform: 'NES', dir: 'd', status: GameInstallStatus.installed, lastSaveVersion: 5),
    slots: const [],
    localModified: DateTime(2026, 3, 5, 9, 0),
  );

  Future<SaveConflictChoice?> open(WidgetTester tester) async {
    SaveConflictChoice? result;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
      supportedLocales: const [Locale('en')],
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await SaveConflictDialog.show(context, conflict),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('shows both sides and defaults to the server', (tester) async {
    await open(tester);
    expect(find.byKey(const ValueKey('game-conflict-server')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-conflict-local')), findsOneWidget);
    expect(find.textContaining('laptop'), findsOneWidget);
    expect(find.textContaining('2026-03-04 10:30'), findsOneWidget);
    expect(find.textContaining('2026-03-05 09:00'), findsOneWidget);
  });

  testWidgets('continue returns the picked side, cancel returns cancel', (tester) async {
    SaveConflictChoice? result;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
      supportedLocales: const [Locale('en')],
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await SaveConflictDialog.show(context, conflict),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('game-conflict-local')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-conflict-continue')));
    await tester.pumpAndSettle();
    expect(result, SaveConflictChoice.keepLocal);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('game-conflict-continue')));
    await tester.pumpAndSettle();
    expect(result, SaveConflictChoice.useServer);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5)); // barrier
    await tester.pumpAndSettle();
    expect(result, SaveConflictChoice.cancel);
  });
}
