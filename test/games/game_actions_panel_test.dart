import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/games/GameActionsPanel.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLibraryService.dart';

import 'support/game_fixture.dart';

const server = 'https://srv.example';

void main() {
  late Directory tmp;
  late FakeGameServer fake;
  late GameLibraryService service;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-game-panel-');
    fake = FakeGameServer();
    service = GameLibraryService.forTest(
      store: GameInstallStore(tmp, true),
      http: DownloadHttp(
          httpClient: fake.client, tokenProvider: (_) async => 't', onAuthFailure: (_) {}, backoff: (_) => Duration.zero),
      apiFactory: (name) => GameApi(name, httpClient: fake.client, bearer: (_) async => 'b'),
      servers: () async => [server],
      deviceName: 'box',
    );
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  Widget panel() => MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: SingleChildScrollView(
            child: GameActionsPanel(serverName: server, game: gameFixture(), service: service),
          ),
        ),
      );

  Future<void> seed(GameInstallStatus status, {String? error, int done = 400, int total = 1000}) => service.store.put(
      server,
      GameInstall(
        gameId: 'g1',
        form: 'ROM',
        platform: 'PSX',
        dir: '${tmp.path}/${DownloadStore.slug(server)}/g1',
        status: status,
        title: 'Test Game',
        totalBytes: total,
        doneBytes: done,
        filesTotal: 2,
        filesDone: 1,
        error: error,
      ));

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('not installed: an install button with the size', (tester) async {
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-install')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-play')), findsNothing);
    expect(find.byKey(const ValueKey('game-uninstall')), findsNothing);
  });

  testWidgets('paused: resume and remove, with the kept bytes', (tester) async {
    await seed(GameInstallStatus.paused);
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-resume-install')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-uninstall')), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('failed after a restart: the persisted error, retry and remove', (tester) async {
    await seed(GameInstallStatus.failed, error: 'no-space');
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-retry-install')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-uninstall')), findsOneWidget);
    final error = tester.widget<Text>(find.byKey(const ValueKey('game-install-error')));
    expect(error.data, isNot(contains('no-space')), reason: 'the key is translated, not shown raw');
    expect(error.data, isNotEmpty);
  });

  testWidgets('cancelled: install again (resumes) and remove, no error text', (tester) async {
    await seed(GameInstallStatus.cancelled);
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-install')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-uninstall')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-install-error')), findsNothing);
  });

  testWidgets('installed: play and remove', (tester) async {
    await seed(GameInstallStatus.installed, done: 1000);
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-play')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-uninstall')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-update')), findsNothing);
  });

  testWidgets('update available: play stays, update is offered', (tester) async {
    await seed(GameInstallStatus.updateAvailable, done: 1000);
    await tester.pumpWidget(panel());
    await settle(tester);
    expect(find.byKey(const ValueKey('game-play')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-update')), findsOneWidget);
  });

  testWidgets('downloading: pause and cancel with a live progress line; pausing flips the buttons', (tester) async {
    // The install engine itself is covered by the service tests. Here the
    // install is started for real but stalls on its first file write (no
    // real I/O completes under the widget test's fake clock), and the
    // progress the engine would publish is fed in directly.
    fake.games['g1'] = [FakeGameFile('rom.bin', 3000)];
    await tester.pumpWidget(panel());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('game-install')));
    await settle(tester);
    expect((await service.store.get(server, 'g1'))!.status, GameInstallStatus.downloading);
    service.progressOf('g1').value = const GameInstallProgress(
      status: GameInstallStatus.downloading,
      doneBytes: 500,
      totalBytes: 3000,
      filesDone: 0,
      filesTotal: 1,
      bytesPerSecond: 1000,
      remaining: Duration(seconds: 3),
    );
    await settle(tester);
    expect(find.byKey(const ValueKey('game-pause-install')), findsOneWidget);
    expect(find.byKey(const ValueKey('game-cancel-install')), findsOneWidget);
    final line = tester.widget<Text>(find.byKey(const ValueKey('game-install-progress'))).data!;
    expect(line, contains('500 B'));
    expect(line, contains('3.0 kB'));
    expect(line, contains('1.0 kB/s'));

    await tester.tap(find.byKey(const ValueKey('game-pause-install')));
    await settle(tester);
    expect(find.byKey(const ValueKey('game-resume-install')), findsOneWidget);
    expect((await service.store.get(server, 'g1'))!.status, GameInstallStatus.paused);
    service.stopActivity();
  });
}
