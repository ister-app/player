import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/DownloadStore.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/GameInstallStore.dart';
import 'package:player/utils/games/GameLibraryService.dart';
import 'package:player/utils/games/launch/GameProcessRunner.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';
import 'package:player/utils/upload/games/Rpcs3Locator.dart';
import 'package:player/utils/games/launch/EmulatorRegistry.dart';
import 'package:player/utils/games/LocalGameCopy.dart';
import 'package:player/utils/activity/ActivityPresenceService.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'support/game_fixture.dart';
import '../support/sfo_builder.dart';
import '../support/recording_presence.dart';

/// Pretends to run the game: returns at once with exit code 0.
class FakeRunner extends GameProcessRunner {
  FakeRunner() : super(isFlatpak: () => false);
  int runs = 0;

  /// Commands [canRun] answers yes to (an emulator the test pretends is installed).
  final Set<String> runnable = {};
  List<String>? lastArguments;

  @override
  Future<bool> canRun(String command) async => runnable.contains(command);

  @override
  Future<GameProcessResult> run(String command, List<String> arguments,
      {String? workingDirectory, Map<String, String>? environment, Duration? timeout}) async {
    runs++;
    lastArguments = arguments;
    return const GameProcessResult(exitCode: 0, duration: Duration(minutes: 3), stderrTail: '');
  }
}

const server = 'https://srv.example';
final slug = DownloadStore.slug(server);

void main() {
  late Directory tmp;
  late FakeGameServer fake;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('ister-game-install-');
    fake = FakeGameServer();
  });

  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  late FakeRunner runner;
  final recorded = <(String, Duration)>[];
  var recordFails = false;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    runner = FakeRunner();
    recorded.clear();
    recordFails = false;
  });

  Map<String, String> env() => {'HOME': tmp.path, 'XDG_CONFIG_HOME': '${tmp.path}/.config'};

  GameLibraryService service({GameInstallStore? store, ActivityPresenceService? presence}) =>
      GameLibraryService.forTest(
        runner: runner,
        presence: presence,
        registry: EmulatorRegistry(runner: runner, environment: env()),
        steam: SteamLibraryLocator(environment: env()),
        localCopies: LocalGameCopyFinder(steam: SteamLibraryLocator(environment: env()), rpcs3: Rpcs3Locator(environment: env())),
        recordPlayed: (server, id, duration) async {
          if (recordFails) throw Exception('offline');
          recorded.add((id, duration));
        },
        store: store ?? GameInstallStore(tmp),
        http: DownloadHttp(
          httpClient: fake.client,
          tokenProvider: (_) async => 'tok',
          onAuthFailure: (_) {},
          backoff: (_) => Duration.zero,
          maxAttempts: 2,
        ),
        apiFactory: (name) => GameApi(name, httpClient: fake.client, bearer: (_) async => 'bearer'),
        servers: () async => [server],
        deviceName: 'test-box',
      );

  Future<void> until(bool Function() condition, {Duration timeout = const Duration(seconds: 10)}) async {
    final end = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(end)) fail('condition not met in time');
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  test('installs every file, reports bytes inside a file, keeps the manifest', () async {
    fake.games['g1'] = [FakeGameFile('rom.cue', 10, entry: true, chunk: 10), FakeGameFile('rom.bin', 3000, chunk: 500)];
    fake.versions['g1'] = 'v1';
    final s = service();
    final seen = <int>[];
    s.progressOf('g1').addListener(() {
      final p = s.progressOf('g1').value;
      if (p != null && p.status == GameInstallStatus.downloading) seen.add(p.doneBytes);
    });

    final install = await s.installAndWait(server, gameFixture());

    expect(install.status, GameInstallStatus.installed);
    expect(install.installedVersion, 'v1');
    expect(install.title, 'Test Game');
    expect(File('${install.filesDir.path}/rom.bin').lengthSync(), 3000);
    expect(File('${install.filesDir.path}/rom.cue').lengthSync(), 10);
    expect((await s.store.readManifest(install))!.version, 'v1');
    // Progress moved in steps smaller than a whole file.
    expect(seen.where((b) => b > 0 && b < 3000), isNotEmpty);
    expect(s.runningCount.value, 0);
    expect(s.revision.value, greaterThan(0));
  });

  test('pause keeps the part file, resume continues with a Range request', () async {
    final big = FakeGameFile('rom.bin', 3000, chunk: 500)..gate = Completer<void>();
    fake.games['g1'] = [big];
    final s = service();
    await s.install(server, gameFixture());
    // The first chunk landed; the stream now waits on the gate.
    await until(() => (s.progressOf('g1').value?.doneBytes ?? 0) >= 500);

    await s.pause(server, 'g1');
    big.gate!.complete();
    await until(() => s.runningCount.value == 0);

    final paused = (await s.store.get(server, 'g1'))!;
    expect(paused.status, GameInstallStatus.paused);
    expect(paused.isResumable, isTrue);
    final part = File('${paused.filesDir.path}/rom.bin.part');
    expect(part.existsSync(), isTrue);
    final kept = part.lengthSync();
    expect(kept, greaterThan(0));
    expect(kept, lessThan(3000));

    big.gate = null;
    fake.requests.clear();
    await s.resume(server, 'g1');
    final done = await s.installAndWait(server, gameFixture());
    expect(done.status, GameInstallStatus.installed);
    expect(File('${done.filesDir.path}/rom.bin').lengthSync(), 3000);
    final ranged = fake.requests.where((r) => r.headers['Range'] != null).toList();
    expect(ranged, isNotEmpty, reason: 'the second attempt continued the part file');
    expect(ranged.first.headers['Range'], 'bytes=$kept-');
    // The restored bytes are the original ones, not a re-download from zero.
    expect(File('${done.filesDir.path}/rom.bin').readAsBytesSync(), big.bytes);
  });

  test('cancel stops with the files kept; installing again resumes', () async {
    final big = FakeGameFile('rom.bin', 3000, chunk: 500)..gate = Completer<void>();
    fake.games['g1'] = [big];
    final s = service();
    await s.install(server, gameFixture());
    await until(() => (s.progressOf('g1').value?.doneBytes ?? 0) >= 500);
    await s.cancel(server, 'g1');
    big.gate!.complete();
    await until(() => s.runningCount.value == 0);
    final cancelled = (await s.store.get(server, 'g1'))!;
    expect(cancelled.status, GameInstallStatus.cancelled);
    expect(cancelled.error, isNull);
    expect(File('${cancelled.filesDir.path}/rom.bin.part').existsSync(), isTrue);

    big.gate = null;
    final done = await s.installAndWait(server, gameFixture());
    expect(done.status, GameInstallStatus.installed);
  });

  test('one game installs at a time; the next waits in the queue with its position', () async {
    final first = FakeGameFile('a.bin', 1000, chunk: 500)..gate = Completer<void>();
    fake.games['g1'] = [first];
    fake.games['g2'] = [FakeGameFile('b.bin', 100, chunk: 100)];
    final s = service();
    await s.install(server, gameFixture(id: 'g1'));
    await s.install(server, gameFixture(id: 'g2', title: 'Second'));
    await until(() => s.progressOf('g1').value?.status == GameInstallStatus.downloading);

    expect(s.progressOf('g2').value?.status, GameInstallStatus.queued);
    expect(s.progressOf('g2').value?.queuePosition, 1);
    expect(s.runningCount.value, 1);
    expect(fake.requests.where((r) => r.url.path.contains('/game/g2/')), isEmpty);

    first.gate!.complete();
    await s.installAndWait(server, gameFixture(id: 'g2'));
    expect((await s.store.get(server, 'g1'))!.status, GameInstallStatus.installed);
    expect((await s.store.get(server, 'g2'))!.status, GameInstallStatus.installed);
  });

  test('a game that is gone from the server fails with a persisted, translatable error', () async {
    fake.games['g1'] = [FakeGameFile('a.bin', 10)];
    fake.manifestStatus['g1'] = 404;
    final s = service();
    final failed = await s.installAndWait(server, gameFixture());
    expect(failed.status, GameInstallStatus.failed);
    expect(failed.error, 'gone');
    // Persisted: a fresh store reads the same.
    expect((await GameInstallStore(tmp).get(server, 'g1'))!.error, 'gone');

    fake.manifestStatus.remove('g1');
    await s.retry(server, 'g1');
    expect((await s.installAndWait(server, gameFixture())).status, GameInstallStatus.installed);
  });

  test('an install left downloading by an earlier run continues on start', () async {
    fake.games['g1'] = [FakeGameFile('a.bin', 1500, chunk: 500)];
    // What the previous run left behind: the record plus half a part file.
    final dir = Directory('${tmp.path}/$slug/g1/files')..createSync(recursive: true);
    File('${dir.path}/a.bin.part').writeAsBytesSync(FakeGameFile('a.bin', 1500).bytes.sublist(0, 700));
    final earlier = GameInstallStore(tmp);
    await earlier.put(
        server,
        GameInstall(
            gameId: 'g1',
            form: 'ROM',
            platform: 'PSX',
            dir: '${tmp.path}/$slug/g1',
            status: GameInstallStatus.downloading,
            title: 'Left behind',
            totalBytes: 1500,
            filesTotal: 1));
    await earlier.put(
        server,
        GameInstall(
            gameId: 'g2', form: 'ROM', platform: 'PSX', dir: '${tmp.path}/$slug/g2', status: GameInstallStatus.paused));

    final s = service();
    await s.ensureStarted();
    await until(() => s.progressOf('g1').value?.status == GameInstallStatus.installed);
    expect(File('${dir.path}/a.bin').lengthSync(), 1500);
    expect(fake.requests.where((r) => r.headers['Range'] == 'bytes=700-'), isNotEmpty);
    // The paused one waits for the user.
    expect((await s.store.get(server, 'g2'))!.status, GameInstallStatus.paused);
    expect(s.progressOf('g2').value?.status, GameInstallStatus.paused);
  });

  test('a newer server version marks the install and the update fetches only what changed', () async {
    final a = FakeGameFile('a.bin', 100, chunk: 100, lastModified: 't1');
    final b = FakeGameFile('b.bin', 200, chunk: 200, lastModified: 't1');
    fake.games['g1'] = [a, b];
    fake.versions['g1'] = 'v1';
    final s = service();
    await s.installAndWait(server, gameFixture(version: 'v1'));

    await s.checkForUpdate(server, 'g1', version: 'v1', sizeBytes: 300);
    expect((await s.store.get(server, 'g1'))!.status, GameInstallStatus.installed);

    // b changed on the server (same size, new modification time), c is new, a is gone.
    final b2 = FakeGameFile('b.bin', 200, chunk: 200, lastModified: 't2');
    final c = FakeGameFile('c.bin', 50, chunk: 50, lastModified: 't2');
    fake.games['g1'] = [b2, c];
    fake.versions['g1'] = 'v2';
    await s.checkForUpdate(server, 'g1', version: 'v2', sizeBytes: 250);
    final flagged = (await s.store.get(server, 'g1'))!;
    expect(flagged.status, GameInstallStatus.updateAvailable);
    expect(flagged.availableVersion, 'v2');
    expect(flagged.isInstalled, isTrue, reason: 'still playable while an update waits');

    fake.requests.clear();
    await s.update(server, 'g1');
    final updated = await s.installAndWait(server, gameFixture());
    expect(updated.status, GameInstallStatus.installed);
    expect(updated.installedVersion, 'v2');
    expect(updated.availableVersion, isNull);
    final fetched = fake.requests.where((r) => r.url.path.contains('/file/')).map((r) => r.url.pathSegments.last).toList();
    expect(fetched, containsAll(['b.bin', 'c.bin']));
    expect(fetched, isNot(contains('a.bin')));
    expect(File('${updated.filesDir.path}/a.bin').existsSync(), isFalse);
    expect(File('${updated.filesDir.path}/c.bin').lengthSync(), 50);
  });

  test('uninstall removes the files in any state but not during a session', () async {
    fake.games['g1'] = [FakeGameFile('a.bin', 10)];
    final s = service();
    final install = await s.installAndWait(server, gameFixture());
    expect(Directory(install.dir).existsSync(), isTrue);
    await s.uninstall(server, 'g1');
    expect(Directory(install.dir).existsSync(), isFalse);
    expect(await s.store.get(server, 'g1'), isNull);
    expect(s.progressOf('g1').value, isNull);

    // A half install can go too.
    final big = FakeGameFile('a.bin', 3000, chunk: 500)..gate = Completer<void>();
    fake.games['g1'] = [big];
    await s.install(server, gameFixture());
    await until(() => (s.progressOf('g1').value?.doneBytes ?? 0) >= 500);
    await s.pause(server, 'g1');
    big.gate!.complete();
    await until(() => s.runningCount.value == 0);
    await s.uninstall(server, 'g1');
    expect(await s.store.get(server, 'g1'), isNull);
  });

  test('the install record is JSON a reader of the old format still understands', () async {
    fake.games['g1'] = [FakeGameFile('a.bin', 10)];
    final s = service();
    await s.installAndWait(server, gameFixture());
    final json = jsonDecode(File('${tmp.path}/$slug/installs.json').readAsStringSync()) as Map;
    final record = (json['installs'] as List).single as Map;
    expect(record['status'], 'installed');
    expect(record['gameId'], 'g1');
  });

  group('play loop', () {
    Future<GameInstall> installedNative(GameLibraryService s) async {
      final dir = '${tmp.path}/$slug/g1';
      File('$dir/files/game.sh').createSync(recursive: true);
      final install = GameInstall(
          gameId: 'g1',
          form: 'PC_LINUX_PORTABLE',
          platform: 'LINUX',
          dir: dir,
          status: GameInstallStatus.installed,
          entryPath: 'game.sh',
          totalBytes: 1,
          filesTotal: 1);
      await s.store.put(server, install);
      return install;
    }

    test('launch walks the phases, records the play time and closes the session', () async {
      final s = service();
      await installedNative(s);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');
      final phases = <GamePlayPhase>[];
      s.phaseOf('g1').addListener(() => phases.add(s.phaseOf('g1').value));

      final prepared = await s.prepare(server, game);
      expect(prepared.conflict, isNull);
      final result = (await s.launch(server, game, prepared.plan))!;

      expect(runner.runs, 1);
      expect(result.duration, const Duration(minutes: 3));
      expect(result.hasErrors, isFalse);
      expect(recorded, [('g1', const Duration(minutes: 3))]);
      expect(phases, containsAllInOrder([
        GamePlayPhase.preparingSaves,
        GamePlayPhase.launching,
        GamePlayPhase.running,
        GamePlayPhase.recording,
        GamePlayPhase.idle,
      ]));
      expect(s.sessionOf('g1').value, isNull);
      expect((await s.store.get(server, 'g1'))!.hasOpenSession, isFalse);
      expect(s.lastResultOf('g1').value, same(result));
    });

    test('a session whose server steps failed stays open until retry sync succeeds', () async {
      final s = service();
      await installedNative(s);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');
      recordFails = true;
      final prepared = await s.prepare(server, game);
      final result = (await s.launch(server, game, prepared.plan))!;
      expect(result.hasErrors, isTrue);
      expect(s.sessionOf('g1').value, isNotNull, reason: 'kept for a retry');
      expect((await s.store.get(server, 'g1'))!.hasOpenSession, isTrue);

      recordFails = false;
      final retried = await s.retrySync(server, game);
      expect(retried.hasErrors, isFalse);
      expect(recorded.length, 1);
      expect(s.sessionOf('g1').value, isNull);
    });

    test('a session left open by an earlier run is restored and can be finished or discarded', () async {
      final s = service();
      final install = await installedNative(s);
      install
        ..sessionStartedAt = DateTime(2026, 1, 1, 12)
        ..sessionDetached = true;
      await s.store.put(server, install);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');

      final session = (await s.restoreSession(server, game))!;
      expect(session.restored, isTrue);
      expect(session.startedAt, DateTime(2026, 1, 1, 12));
      expect(s.phaseOf('g1').value, GamePlayPhase.running);

      await s.discardSession(server, 'g1');
      expect(s.sessionOf('g1').value, isNull);
      expect(s.phaseOf('g1').value, GamePlayPhase.idle);
      expect((await s.store.get(server, 'g1'))!.hasOpenSession, isFalse);
      expect(recorded, isEmpty);

      // Restored again and finished: the play time is recorded.
      install.sessionStartedAt = DateTime.now().subtract(const Duration(minutes: 10));
      await s.store.put(server, install);
      await s.restoreSession(server, game);
      final result = await s.finishDetached(server, game);
      expect(result.hasErrors, isFalse);
      expect(recorded.single.$2.inMinutes, greaterThanOrEqualTo(9));
      expect((await s.store.get(server, 'g1'))!.hasOpenSession, isFalse);
    });

    test('a running game is reported as a now-playing session and ended with the session', () async {
      final presence = RecordingPresence();
      final s = service(presence: presence.service);
      await installedNative(s);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');

      final prepared = await s.prepare(server, game);
      await s.launch(server, game, prepared.plan);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(presence.reports, hasLength(1));
      expect(presence.reports.single.variables['mediaType'], 'GAME');
      expect(presence.reports.single.variables['mediaId'], 'g1');
      expect(presence.reports.single.variables['progressFraction'], isNull);
      expect(presence.ends, hasLength(1), reason: 'the session closed with the process');
      expect(presence.ends.single.variables['sessionId'],
          presence.reports.single.variables['sessionId']);
    });

    test('a session restored after a restart is reported again until it is discarded', () async {
      final presence = RecordingPresence();
      final s = service(presence: presence.service);
      final install = await installedNative(s);
      install.sessionStartedAt = DateTime.utc(2026, 10, 24, 11);
      await s.store.put(server, install);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');

      expect(await s.restoreSession(server, game), isNotNull);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(presence.reports, hasLength(1));
      expect(presence.ends, isEmpty);

      await s.discardSession(server, 'g1');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(presence.ends, hasLength(1));
    });

    test('uninstall is refused while a session is open', () async {
      final s = service();
      await installedNative(s);
      final game = gameFixture(form: 'PC_LINUX_PORTABLE', platform: 'LINUX');
      recordFails = true;
      final prepared = await s.prepare(server, game);
      await s.launch(server, game, prepared.plan);
      expect(() => s.uninstall(server, 'g1'), throwsStateError);
    });
  });

  group('adopting a copy that is already on this computer', () {
    void write(String path, String text) => File('${tmp.path}/$path')
      ..createSync(recursive: true)
      ..writeAsStringSync(text);

    test('an RPCS3 HDD game: installed without a download, launches from its own folder, forgotten without deleting it',
        () async {
      write('.config/rpcs3/dev_hdd0/game/NPEA00111/PARAM.SFO', '');
      write('.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN', '');
      write('.config/rpcs3/dev_flash/vsh/x', '');
      runner.runnable.add('rpcs3');
      fake.games['g1'] = [];
      final s = service();
      final game = gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'NPEA00111', version: 'v1');

      final copy = await s.findLocalCopy(server, game);
      expect(copy!.kind, LocalGameCopyKind.rpcs3Hdd);
      final install = await s.adopt(server, game, copy);
      expect(install.status, GameInstallStatus.installed);
      expect(install.isAdopted, isTrue);
      expect(install.installedVersion, 'v1');
      expect(install.bytesOnDisk, 0, reason: 'not Ister\'s bytes');
      expect((await s.installOf(server, 'g1'))!.adoptedFrom, '${tmp.path}/.config/rpcs3/dev_hdd0/game/NPEA00111');
      expect(await s.findLocalCopy(server, game), isNull, reason: 'already installed');
      expect(Directory(install.dir).existsSync(), isTrue, reason: "Ister's own folder for tmp/outbox");

      // Same version on the server: nothing to update; a newer one: offered.
      await s.checkForUpdate(server, 'g1', version: 'v1');
      expect((await s.installOf(server, 'g1'))!.status, GameInstallStatus.installed);
      await s.checkForUpdate(server, 'g1', version: 'v2', sizeBytes: 5);
      expect((await s.installOf(server, 'g1'))!.status, GameInstallStatus.updateAvailable);

      final prepared = await s.prepare(server, game);
      expect(prepared.plan.command, 'rpcs3');
      expect(prepared.plan.arguments.last, '${tmp.path}/.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN');

      await s.uninstall(server, 'g1');
      expect(await s.installOf(server, 'g1'), isNull);
      expect(File('${tmp.path}/.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN').existsSync(), isTrue);
      expect(Directory(install.dir).existsSync(), isFalse);
    });

    test('an RPCS3 game that saves under another folder name: the folder is found by its SFO title and uploaded', () async {
      write('.config/rpcs3/dev_hdd0/game/NPEA00363/PARAM.SFO', '');
      write('.config/rpcs3/dev_hdd0/game/NPEA00363/USRDIR/EBOOT.BIN', '');
      write('.config/rpcs3/dev_flash/vsh/x', '');
      const savedata = '.config/rpcs3/dev_hdd0/home/00000001/savedata';
      File('${tmp.path}/$savedata/BCES00065_NDI_UNCHARTED_DF_0/PARAM.SFO')
        ..createSync(recursive: true)
        ..writeAsBytesSync(buildSfo({'TITLE': "Uncharted: Drake's Fortune™", 'SAVEDATA_DIRECTORY': 'BCES00065_NDI_UNCHARTED_DF_0'}));
      write('$savedata/BCES00065_NDI_UNCHARTED_DF_0/SAVE.DAT', 'the fortress');
      File('${tmp.path}/$savedata/NPEA00111-AUTO-SCORES/PARAM.SFO')
        ..createSync(recursive: true)
        ..writeAsBytesSync(buildSfo({'TITLE': 'PixelJunk™ Monsters'}));
      write('$savedata/NPEA00111-AUTO-SCORES/SCORES.DAT', 'not ours');
      runner.runnable.add('rpcs3');
      fake.games['g1'] = [];
      final s = service();
      // The server's title still carries the patch version an older scanner kept.
      final game = gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'NPEA00363', title: "Uncharted: Drake's Fortune™ 1.02", version: 'v1');
      final copy = await s.findLocalCopy(server, game);
      await s.adopt(server, game, copy!);

      final prepared = await s.prepare(server, game);
      expect(prepared.plan.saveSlots.map((slot) => slot.template), ['rpcs3:NPEA00363', 'rpcs3:BCES00065_NDI_UNCHARTED_DF_0']);
      final result = await s.launch(server, game, prepared.plan);
      expect(result!.errors, isEmpty);
      expect(result.noSaveFound, isFalse);
      expect(result.uploadedSave?.version, 1);
      expect(fake.uploadedSaves['g1'], hasLength(1));
      final names = ZipDecoder().decodeBytes(fake.uploadedSaves['g1']!.single).map((f) => f.name).toList();
      expect(names, contains('1/SAVE.DAT'));
      expect(names, isNot(contains(contains('SCORES.DAT'))));
      expect((await s.installOf(server, 'g1'))!.lastSaveVersion, 1);

      // Nothing changed: the next session uploads nothing and says so.
      final again = await s.launch(server, game, (await s.prepare(server, game)).plan);
      expect(again!.saveUnchanged, isTrue, reason: 'errors=${again.errors} uploaded=${again.uploadedSave?.version} noSave=${again.noSaveFound} sha=${(await s.installOf(server, 'g1'))!.lastSaveSha}');
      expect(fake.uploadedSaves['g1'], hasLength(1));
    });

    test('an RPCS3 game that never saved reports that no save was found', () async {
      write('.config/rpcs3/dev_hdd0/game/NPEA00111/PARAM.SFO', '');
      write('.config/rpcs3/dev_hdd0/game/NPEA00111/USRDIR/EBOOT.BIN', '');
      write('.config/rpcs3/dev_flash/vsh/x', '');
      runner.runnable.add('rpcs3');
      fake.games['g1'] = [];
      final s = service();
      final game = gameFixture(form: 'PS3_FOLDER', platform: 'PS3', titleId: 'NPEA00111', version: 'v1');
      await s.adopt(server, game, (await s.findLocalCopy(server, game))!);
      final result = await s.launch(server, game, (await s.prepare(server, game)).plan);
      expect(result!.noSaveFound, isTrue);
      expect(result.saveUnchanged, isFalse);
      expect(fake.uploadedSaves['g1'], isNull);
    });

    test('a Steam game in a library: launches through Steam, no manifest is written', () async {
      write('.local/share/Steam/steamapps/appmanifest_620.acf',
          '"AppState" { "appid" "620" "name" "Portal 2" "StateFlags" "4" "installdir" "Portal 2" }');
      write('.local/share/Steam/steamapps/common/Portal 2/portal2.sh', '');
      runner.runnable.add('steam');
      fake.games['g1'] = [];
      final s = service();
      final game = gameFixture(form: 'STEAM', platform: 'STEAM', steamAppId: '620', version: 'v1');
      final copy = await s.findLocalCopy(server, game);
      final install = await s.adopt(server, game, copy!);
      expect(install.steamAppId, 620);
      expect(install.steamLibrary, '${tmp.path}/.local/share/Steam');
      expect(install.steamInstallDir, 'Portal 2');
      final before = File('${tmp.path}/.local/share/Steam/steamapps/appmanifest_620.acf').readAsStringSync();
      final prepared = await s.prepare(server, game);
      expect(prepared.plan.detached, isTrue);
      expect(prepared.plan.arguments, contains('steam://rungameid/620'));
      expect(File('${tmp.path}/.local/share/Steam/steamapps/appmanifest_620.acf').readAsStringSync(), before,
          reason: 'Steam owns the acf');
    });
  });
}
