import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/games/GameInstallsSection.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLibraryService.dart';

import 'support/game_fixture.dart';

const server = 'https://srv.example';

void main() {
  late Directory tmp;
  late GameLibraryService service;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-game-section-');
    final fake = FakeGameServer();
    service = GameLibraryService.forTest(
      store: GameInstallStore(tmp, true),
      http: DownloadHttp(
          httpClient: fake.client, tokenProvider: (_) async => 't', onAuthFailure: (_) {}, backoff: (_) => Duration.zero),
      apiFactory: (name) => GameApi(name, httpClient: fake.client, bearer: (_) async => 'b'),
      servers: () async => [server],
    );
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  GameInstall install(String id, GameInstallStatus status, {int done = 0, int total = 1000, String? error}) => GameInstall(
        gameId: id,
        form: 'ROM',
        platform: 'SNES',
        dir: '${tmp.path}/$id',
        status: status,
        title: 'Game $id',
        totalBytes: total,
        doneBytes: done,
        error: error,
      );

  Widget section(List<GameInstall> installs, {bool inShell = false}) => MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: SingleChildScrollView(
            child: GameInstallsSection(serverName: server, installs: installs, inShell: inShell, service: service),
          ),
        ),
      );

  testWidgets('lists installs with active ones first and the storage total', (tester) async {
    await tester.pumpWidget(section([
      install('b', GameInstallStatus.installed, done: 1000),
      install('a', GameInstallStatus.paused, done: 400),
      install('c', GameInstallStatus.failed, done: 10, error: 'gone'),
    ]));
    await tester.pump();
    expect(find.byKey(const ValueKey('game-installs-section')), findsOneWidget);
    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles.map((t) => (t.key as ValueKey).value), [
      'game-install-a',
      'game-install-b',
      'game-install-c',
    ], reason: 'alphabetical: nothing is active, paused is not');
    expect(GameInstallsSection.bytesOf([
      install('b', GameInstallStatus.installed, done: 1000),
      install('a', GameInstallStatus.paused, done: 400),
    ]), 1400);
    expect(find.byType(LinearProgressIndicator), findsOneWidget, reason: 'only the paused one shows a bar');
  });

  testWidgets('the menu offers what the state allows', (tester) async {
    await tester.pumpWidget(section([install('p', GameInstallStatus.paused, done: 400)], inShell: true));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-install-menu-p')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('game-install-resume-p')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-install-remove-p')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-install-open-p')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-install-pause-p')), findsNothing);
    expect(find.byKey(const ValueKey('game-install-cancel-p')), findsNothing);
  });

  testWidgets('outside the shell there is no way to the game page', (tester) async {
    await tester.pumpWidget(section([install('i', GameInstallStatus.installed, done: 1000)]));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-install-menu-i')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('game-install-open-i')), findsNothing);
    expect(find.byKey(const ValueKey('game-install-remove-i')), findsOneWidget);
  });

  testWidgets('resume from the menu re-queues the install', (tester) async {
    final paused = install('p', GameInstallStatus.paused, done: 400);
    await service.store.put(server, paused);
    await tester.pumpWidget(section([paused]));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('game-install-menu-p')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('game-install-resume-p')));
    await tester.pump();
    expect((await service.store.get(server, 'p'))!.status, isNot(GameInstallStatus.paused));
  });
}
