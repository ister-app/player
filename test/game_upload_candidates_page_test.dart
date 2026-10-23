import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/upload/GameUploadTarget.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/GameUploadCandidatesPage.dart';
import 'package:player/utils/upload/GameFoundProbe.dart';
import 'package:player/utils/upload/UploadModels.dart';
import 'package:player/utils/upload/games/GameLibraryIndex.dart';
import 'package:player/utils/upload/games/GameUploadCandidate.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const platforms = [
  GamePlatformOption(platform: Enum$GamePlatform.SNES, folder: 'snes', entryExtensions: ['sfc']),
  GamePlatformOption(platform: Enum$GamePlatform.PS3, folder: 'ps3', entryExtensions: []),
];

final directory = UploadDirectory(
  id: 'g1', name: 'games', libraryId: 'lg', libraryName: 'Games', libraryType: 'GAME', storageKind: 'LOCAL',
  path: '/media/games', nodeName: 'n', nodeUrl: 'http://n', freeBytes: null, writable: true,
);

GameUploadCandidate rom(String title, {String? year}) => GameUploadCandidate(
      platform: Enum$GamePlatform.SNES,
      platformFolder: 'snes',
      title: title,
      year: year,
      kind: GameCandidateKind.romFile,
      sourcePath: '/roms/snes/$title.sfc',
      files: [(relativePath: '$title.sfc', absolutePath: '/roms/snes/$title.sfc', size: 1024)],
    );

const souls = GameUploadCandidate(
  platform: Enum$GamePlatform.PS3,
  platformFolder: 'ps3',
  title: "Demon's Souls",
  year: '2009',
  kind: GameCandidateKind.tree,
  sourcePath: '/dumps/Demons Souls (2009)',
  titleId: 'BLUS30443',
);

void main() {
  setUp(() => SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty());

  GameUploadSelection? result;

  /// Opens the page from a host screen so that popping with a selection
  /// lands in [result].
  Future<void> pump(WidgetTester tester, List<GameUploadCandidate> candidates) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    result = null;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            key: const ValueKey('open'),
            onPressed: () async {
              result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GameUploadCandidatesPage(
                  serverName: 'http://srv',
                  directory: directory,
                  platforms: platforms,
                  scan: (_) async => candidates,
                  indexLoader: (_) async => GameLibraryIndex({
                    GameLibraryIndex.key(Enum$GamePlatform.SNES, 'Chrono Trigger'): const FoundGame(
                        id: 'g', title: 'Chrono Trigger', platform: Enum$GamePlatform.SNES, form: Enum$GameForm.ROM, savePathSource: 'NONE'),
                  }),
                ),
              ));
            },
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.byKey(const ValueKey('open')));
    await tester.pumpAndSettle();
  }

  testWidgets('groups by platform, unticks what the library has, and returns the ticked games', (tester) async {
    final chrono = rom('Chrono Trigger', year: '1995');
    final mario = rom('Super Mario World');
    await pump(tester, [chrono, mario, souls]);

    expect(find.text('SNES (2)'), findsOneWidget);
    expect(find.text('PlayStation 3 (1)'), findsOneWidget);
    expect(find.text('Already in the library'), findsOneWidget);
    expect(find.text('No year'), findsOneWidget, reason: 'Mario has none');
    expect(find.textContaining('BLUS30443'), findsOneWidget);
    expect(find.textContaining('size known when listed'), findsOneWidget);
    expect(tester.widget<CheckboxListTile>(find.byKey(ValueKey('game-candidate-${chrono.id}'))).value, isFalse);
    expect(tester.widget<CheckboxListTile>(find.byKey(ValueKey('game-candidate-${mario.id}'))).value, isTrue);
    expect(find.text('Upload 2 games · 1.0 kB+'), findsOneWidget, reason: 'one size unknown');

    // Edit Mario's title and year.
    await tester.tap(find.byKey(ValueKey('game-candidate-edit-${mario.id}')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('upload-game-year')), '1990');
    await tester.pumpAndSettle();
    expect(find.text('Uploads as snes/Super Mario World (1990)/'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('upload-game-edit-save')));
    await tester.pumpAndSettle();
    expect(find.text('Super Mario World (1990)'), findsOneWidget);

    // "Select none" for the SNES group, then the upload button carries only Souls.
    // "Select all" ticks Chrono too; a second tap unticks the whole group.
    await tester.tap(find.byKey(const ValueKey('game-candidates-all-SNES')));
    await tester.pumpAndSettle();
    expect(find.text('Upload 3 games · 2.0 kB+'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('game-candidates-all-SNES')));
    await tester.pumpAndSettle();
    expect(find.text('Upload 1 game'), findsOneWidget, reason: 'only Souls, whose size is unknown');
    await tester.tap(find.byKey(ValueKey('game-candidate-${mario.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Upload 2 games · 1.0 kB+'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('game-candidates-upload')));
    await tester.pumpAndSettle();
    expect(result!.candidates.map((c) => c.rootName), ['Super Mario World (1990)', "Demon's Souls (2009)"]);
  });

  testWidgets('nothing found says where it looked', (tester) async {
    await pump(tester, const []);
    // Which message depends on whether this machine has a ~/Games; both point at the settings.
    expect(find.textContaining('Game settings'), findsOneWidget);
    expect(find.byKey(const ValueKey('game-candidates-upload')), findsNothing);
  });
}
