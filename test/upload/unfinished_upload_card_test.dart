import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/upload/UnfinishedUploadCard.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/upload/UploadApi.dart';
import 'package:player/utils/upload/UploadResumeStore.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  UploadApi api({bool sessionActive = true}) => UploadApi('srv',
      bearer: (_) async => 'Bearer t',
      httpClient: MockClient((request) async {
        if (!sessionActive) return http.Response('{"detail":"gone"}', 404);
        return http.Response(
            jsonEncode({
              'sessionId': 's1',
              'status': 'ACTIVE',
              'files': [
                {
                  'fileId': 'f1',
                  'relativePath': 'a.mkv',
                  'size': 100,
                  'chunkSize': 16,
                  'status': 'UPLOADING',
                  'receivedBytes': 16,
                  'completedParts': <int>[],
                }
              ],
            }),
            200);
      }));

  Future<void> pump(WidgetTester tester, UploadApi api, {VoidCallback? onResume}) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
          body: UnfinishedUploadCard(serverName: 'srv', store: UploadResumeStore('srv'), api: api, onResume: onResume)),
    ));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('names the interrupted upload and continues on tap', (tester) async {
    await UploadResumeStore('srv')
        .save(const StoredUpload(sessionId: 's1', nodeUrl: 'http://node', s3: false, sourcePath: '/x', title: 'Seinfeld (1989)'));
    var resumed = 0;
    await pump(tester, api(), onResume: () => resumed++);
    expect(find.byKey(const ValueKey('home-unfinished-upload')), findsOneWidget);
    expect(find.textContaining('Seinfeld (1989) stopped before it was done'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home-unfinished-upload-resume')));
    expect(resumed, 1);
  });

  testWidgets('a session the server no longer has is forgotten and shows nothing', (tester) async {
    await UploadResumeStore('srv').save(const StoredUpload(sessionId: 's1', nodeUrl: 'http://node', s3: false, sourcePath: '/x'));
    await pump(tester, api(sessionActive: false));
    expect(find.byKey(const ValueKey('home-unfinished-upload')), findsNothing);
    expect(await UploadResumeStore('srv').load(), isNull);
  });

  testWidgets('nothing remembered, nothing shown', (tester) async {
    await pump(tester, api());
    expect(find.byKey(const ValueKey('home-unfinished-upload')), findsNothing);
  });
}
