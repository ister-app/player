import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/upload/GameUploadTarget.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AdminUploadPage.dart';
import 'package:player/utils/upload/GameFoundProbe.dart';
import 'package:player/utils/upload/UploadApi.dart';
import 'package:player/utils/upload/UploadSource.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

class _File implements UploadSourceFile {
  _File(this.relativePath, this.size);
  @override
  final String relativePath;
  @override
  final int size;
  @override
  Stream<List<int>> openRead(int start, int end) => Stream.value(List.filled(end - start, 1));
}

void main() {
  late List<String> calls;
  late Map<String, dynamic> lastPlan;
  late int lookups;
  late bool withMarker;

  Future<http.Response> server(http.Request request) async {
    final path = request.url.path;
    calls.add('${request.method} $path');
    String json(Object body) => jsonEncode(body);
    if (path == '/library-upload/directories') {
      return http.Response(
          json([
            {
              'id': 'g1', 'name': 'games-disk', 'libraryId': 'lg', 'libraryName': 'Games', 'libraryType': 'GAME',
              'storageKind': 'LOCAL', 'path': '/media/games', 'nodeName': 'node-a', 'nodeUrl': 'http://node-a',
              'freeBytes': 5000000000, 'writable': true
            },
          ]),
          200);
    }
    if (path == '/library-upload/preview') {
      lastPlan = (jsonDecode(request.body) as Map).cast<String, dynamic>();
      final rootName = lastPlan['rootName'] as String? ?? '';
      final parent = lastPlan['targetParent'] as String? ?? '';
      final placed = parent.isNotEmpty && rootName.contains('(');
      final base = '/media/games/$parent/$rootName';
      final entries = <Map<String, Object?>>[];
      if (withMarker) {
        entries.add({
          'relativePath': 'PS3_GAME/PARAM.SFO', 'targetPath': '$base/PS3_GAME/PARAM.SFO', 'size': 5,
          'status': placed ? 'RECOGNISED' : 'IGNORED',
          if (!placed) 'ignoreReason': 'FOLDER_NOT_SCANNED',
          if (placed)
            'recognition': {'kind': 'GAME_MARKER', 'title': "Demon's Souls", 'year': 2009, 'platform': 'PS3', 'form': 'PS3_FOLDER'}
        });
      }
      entries.add({
        'relativePath': 'PS3_GAME/USRDIR/EBOOT.BIN', 'targetPath': '$base/PS3_GAME/USRDIR/EBOOT.BIN', 'size': 15,
        'status': placed && withMarker ? 'RECOGNISED' : 'IGNORED',
        if (!(placed && withMarker)) 'ignoreReason': withMarker ? 'FOLDER_NOT_SCANNED' : 'GAME_INCOMPLETE',
        if (!withMarker) 'detail': 'missing PS3_GAME/PARAM.SFO in $parent/$rootName',
        if (placed && withMarker)
          'recognition': {'kind': 'GAME_TREE_FILE', 'title': "Demon's Souls", 'year': 2009, 'platform': 'PS3', 'form': 'PS3_FOLDER'}
      });
      final files = placed && withMarker ? 2 : 0;
      return http.Response(
          json({
            'directoryId': 'g1',
            'libraryType': 'GAME',
            'roots': [
              {'name': rootName, 'level': placed ? 'GAME' : 'NONE', 'existing': false}
            ],
            'entries': entries,
            'uploadBytes': files == 0 ? 0 : 20,
            'uploadFiles': files,
          }),
          200);
    }
    if (path == '/library-upload/sessions') {
      return http.Response(
          json({
            'sessionId': 's1', 'status': 'ACTIVE', 'directoryId': 'g1', 'overwrite': false,
            'files': [
              {'fileId': 'f1', 'relativePath': 'PS3_GAME/PARAM.SFO', 'targetPath': 'x', 'size': 5, 'chunkSize': 16, 'receivedBytes': 0, 'status': 'PENDING'},
              {'fileId': 'f2', 'relativePath': 'PS3_GAME/USRDIR/EBOOT.BIN', 'targetPath': 'y', 'size': 15, 'chunkSize': 16, 'receivedBytes': 0, 'status': 'PENDING'},
            ],
            'skipped': []
          }),
          200);
    }
    if (path.endsWith('/chunk')) {
      final id = path.split('/')[path.split('/').indexOf('files') + 1];
      return http.Response(json({'fileId': id, 'receivedBytes': request.bodyBytes.length, 'status': 'UPLOADING'}), 200);
    }
    if (path.endsWith('/complete')) {
      final id = path.split('/')[path.split('/').indexOf('files') + 1];
      return http.Response(json({'fileId': id, 'receivedBytes': id == 'f1' ? 5 : 15, 'status': 'COMPLETED'}), 200);
    }
    return http.Response('nope', 404);
  }

  setUp(() {
    calls = [];
    lastPlan = {};
    lookups = 0;
    withMarker = true;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  Future<void> pumpPage(WidgetTester tester, {String folderName = "Demon's Souls (2009)"}) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AdminUploadPage(
        serverName: 'http://srv',
        api: UploadApi('http://srv', httpClient: MockClient(server), bearer: (_) async => 'Bearer t'),
        pickFolder: () async => UploadSourceFolder(name: folderName, files: [
          if (withMarker) _File('PS3_GAME/PARAM.SFO', 5),
          _File('PS3_GAME/USRDIR/EBOOT.BIN', 15),
        ]),
        loadPlatforms: () async => const [
          GamePlatformOption(platform: Enum$GamePlatform.PSX, folder: 'psx', entryExtensions: ['cue', 'chd']),
          GamePlatformOption(platform: Enum$GamePlatform.PS3, folder: 'ps3', entryExtensions: []),
          GamePlatformOption(platform: Enum$GamePlatform.STEAM, folder: 'steam', entryExtensions: []),
        ],
        findGame: (libraryId, title) async {
          lookups++;
          if (libraryId != 'lg' || lookups < 2) return null;
          return FoundGame(
              id: 'game-1', title: title, platform: Enum$GamePlatform.PS3, form: Enum$GameForm.PS3_FOLDER, savePathSource: 'NONE');
        },
        gameProbeInterval: const Duration(milliseconds: 100),
        gameProbePatience: const Duration(seconds: 5),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> pickPs3(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('upload-game-platform')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('upload-game-platform-PS3')).last);
    await tester.pumpAndSettle();
  }

  testWidgets('a game library gets a platform picker, Title (year) fields and the composed folder', (tester) async {
    await pumpPage(tester);
    expect(find.byKey(const ValueKey('upload-game-platform')), findsOneWidget);
    expect(find.byKey(const ValueKey('upload-target-parent')), findsNothing, reason: 'no free text field for games');

    await pickPs3(tester);
    expect(tester.widget<Text>(find.byKey(const ValueKey('upload-game-platform-hint'))).data, contains('PARAM.SFO'));

    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    // The picked folder name is split into title and year.
    expect(tester.widget<TextField>(find.byKey(const ValueKey('upload-game-title'))).controller!.text, "Demon's Souls");
    expect(tester.widget<TextField>(find.byKey(const ValueKey('upload-game-year'))).controller!.text, '2009');
    expect(find.byKey(const ValueKey('upload-keep-folder')), findsNothing, reason: 'a game is always one folder');
    expect(lastPlan['targetParent'], 'ps3');
    expect(lastPlan['rootName'], "Demon's Souls (2009)");
    expect(tester.widget<Text>(find.byKey(const ValueKey('upload-game-folder-preview'))).data,
        "Uploads as ps3/Demon's Souls (2009)/");
    expect(find.text("Demon's Souls (2009) — seen as a game"), findsOneWidget);
    expect(find.textContaining('PlayStation 3 · PS3 game'), findsWidgets);

    // Editing the title re-composes the folder and re-runs the preview.
    await tester.enterText(find.byKey(const ValueKey('upload-game-title')), "Demon's Souls Remastered");
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(lastPlan['rootName'], "Demon's Souls Remastered (2009)");

    await tester.enterText(find.byKey(const ValueKey('upload-game-year')), '20x');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Four digits, 1950–2100'), findsOneWidget);
  });

  testWidgets('a game tree without its marker file is explained', (tester) async {
    withMarker = false;
    await pumpPage(tester, folderName: "Demon's Souls (2009)");
    await pickPs3(tester);
    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.textContaining('Not uploaded: missing PS3_GAME/PARAM.SFO'), findsOneWidget);
    expect(find.textContaining('must be uploaded in one go'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const ValueKey('upload-start'))).onPressed, isNull);
  });

  testWidgets('a folder without a year in a game library is called out', (tester) async {
    await pumpPage(tester, folderName: 'Some Game');
    await pickPs3(tester);
    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(lastPlan['rootName'], 'Some Game');
    expect(find.textContaining('is not a game folder'), findsOneWidget);
  });

  testWidgets('after the upload the game is looked up in the library', (tester) async {
    await pumpPage(tester);
    await pickPs3(tester);
    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('upload-start')));
    final found = find.byKey(const ValueKey('upload-game-found'));
    var sawProbing = false;
    for (var i = 0; i < 100 && found.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byKey(const ValueKey('upload-game-probing')).evaluate().isNotEmpty) sawProbing = true;
    }
    expect(sawProbing, isTrue, reason: 'the page says it is waiting for the scan');
    expect(found, findsOneWidget);
    expect(lookups, 2);
    expect(find.textContaining("Found in the library: Demon's Souls (PlayStation 3)"), findsOneWidget);
    expect(find.byKey(const ValueKey('upload-game-open')), findsOneWidget);
    // A PS3 game keeps its saves in the emulator: no Ludusavi verdict.
    expect(find.textContaining('save locations', skipOffstage: false), findsNothing);
  });
}
