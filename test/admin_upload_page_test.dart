import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/AdminUploadPage.dart';
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
  late int chunkBytes;

  Future<http.Response> server(http.Request request) async {
    final path = request.url.path;
    calls.add('${request.method} $path');
    String json(Object body) => jsonEncode(body);
    if (path == '/library-upload/directories') {
      return http.Response(
          json([
            {
              'id': 'd1', 'name': 'disk-a', 'libraryId': 'l1', 'libraryName': 'Shows', 'libraryType': 'SHOW',
              'storageKind': 'LOCAL', 'path': '/media/shows', 'nodeName': 'node-a', 'nodeUrl': 'http://node-a',
              'freeBytes': 5000000000, 'writable': true
            },
            {
              'id': 'd2', 'name': 'disk-ro', 'libraryId': 'l1', 'libraryName': 'Shows', 'libraryType': 'SHOW',
              'storageKind': 'LOCAL', 'path': '/media/ro', 'nodeName': 'node-a', 'nodeUrl': 'http://node-a',
              'freeBytes': 1, 'writable': false
            },
          ]),
          200);
    }
    if (path == '/library-upload/preview') {
      lastPlan = (jsonDecode(request.body) as Map).cast<String, dynamic>();
      final rootName = lastPlan['rootName'] as String?;
      final recognised = rootName != null && rootName.contains('(');
      return http.Response(
          json({
            'directoryId': 'd1',
            'libraryType': 'SHOW',
            'roots': [
              {'name': rootName ?? '', 'level': recognised ? 'SHOW' : 'NONE', 'existing': false}
            ],
            'entries': [
              {
                'relativePath': 'Season 01/e01.mkv', 'targetPath': '/media/shows/$rootName/Season 01/e01.mkv',
                'size': 20, 'status': recognised ? 'RECOGNISED' : 'IGNORED',
                if (!recognised) 'ignoreReason': 'FOLDER_NOT_SCANNED',
                if (!recognised) 'detail': rootName,
                if (recognised)
                  'recognition': {'kind': 'MEDIA', 'title': 'The Show', 'year': 2019, 'season': 1, 'episodes': [1]}
              },
              {'relativePath': 'notes.txt', 'size': 3, 'status': 'IGNORED', 'ignoreReason': 'UNSUPPORTED_FILE'},
            ],
            'uploadBytes': recognised ? 20 : 0,
            'uploadFiles': recognised ? 1 : 0,
          }),
          200);
    }
    if (path == '/library-upload/sessions') {
      return http.Response(
          json({
            'sessionId': 's1', 'status': 'ACTIVE', 'directoryId': 'd1', 'overwrite': false,
            'files': [
              {
                'fileId': 'f1', 'relativePath': 'Season 01/e01.mkv', 'targetPath': 'x', 'size': 20, 'chunkSize': 16,
                'receivedBytes': 0, 'status': 'PENDING'
              }
            ],
            'skipped': []
          }),
          200);
    }
    if (path.endsWith('/chunk')) {
      chunkBytes += request.bodyBytes.length;
      return http.Response(json({'fileId': 'f1', 'receivedBytes': chunkBytes, 'status': 'UPLOADING'}), 200);
    }
    if (path.endsWith('/complete')) {
      return http.Response(json({'fileId': 'f1', 'receivedBytes': 20, 'status': 'COMPLETED'}), 200);
    }
    return http.Response('nope', 404);
  }

  setUp(() {
    calls = [];
    lastPlan = {};
    chunkBytes = 0;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AdminUploadPage(
        serverName: 'http://srv',
        api: UploadApi('http://srv', httpClient: MockClient(server), bearer: (_) async => 'Bearer t'),
        pickFolder: () async => UploadSourceFolder(
            name: 'The Show', files: [_File('Season 01/e01.mkv', 20), _File('notes.txt', 3)]),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('pick → preview warns → rename root → upload', (tester) async {
    await pumpPage(tester);

    // one library → selected; one WRITABLE directory → selected, the read-only one is shown but disabled
    expect(find.text('disk-a'), findsOneWidget);
    expect(find.text('Not writable for the server'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // "The Show" has no year: the scanner would not descend into it, and the page says so
    expect(find.text('The Show — not recognised as a library folder'), findsOneWidget);
    expect(find.text('None of these files would be picked up by the library'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const ValueKey('upload-start'))).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('upload-root-name')), 'The Show (2019)');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(lastPlan['rootName'], 'The Show (2019)');
    expect(find.text('The Show (2019) — seen as SHOW'), findsOneWidget);
    expect(find.textContaining('S01E01'), findsOneWidget);
    expect(find.textContaining('Not a file this library uses'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('upload-start')));
    // the transfer runs on its own futures; pump until the page reports the end of it
    final finished = find.text('Upload finished. The files are being added to the library.');
    for (var i = 0; i < 100 && finished.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(chunkBytes, 20);
    expect(calls.where((c) => c.endsWith('/chunk')).length, 2, reason: '20 bytes in chunks of 16');
    expect(calls.last, endsWith('/complete'));
    expect(find.text('Upload finished. The files are being added to the library.'), findsOneWidget);
    // everything after the directory listing went to the directory's node
    expect(calls.first, 'GET /library-upload/directories');
  });

  testWidgets('"upload as one folder" off sends no root name', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.byKey(const ValueKey('upload-pick-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.byKey(const ValueKey('upload-keep-folder')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(lastPlan.containsKey('rootName'), isTrue);
    expect(lastPlan['rootName'], isNull);
  });
}
