import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/upload/UploadProgressView.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/upload/UploadModels.dart';
import 'package:player/utils/upload/UploadRunner.dart';

void main() {
  UploadItem item() => UploadItem(
      UploadFileState(
          fileId: 'fa',
          relativePath: 'Season 09/s09e01.mkv',
          size: 100,
          chunkSize: 10,
          receivedBytes: 0,
          status: 'PENDING',
          completedParts: const []),
      null);

  Future<void> pumpTile(WidgetTester tester, UploadItem item) => tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
          builder: (context) => Scaffold(
              body: UploadProgressView.itemTile(AppLocalizations.of(context)!, Theme.of(context), item)))));

  testWidgets('a file that is being retried shows why', (tester) async {
    final retried = item()
      ..phase = UploadItemPhase.uploading
      ..retrying = 'Cannot stage s09e01.mkv';
    await pumpTile(tester, retried);

    expect(find.byKey(const ValueKey('upload-item-retrying')), findsOneWidget);
    expect(find.textContaining('Cannot stage s09e01.mkv'), findsOneWidget);
  });

  testWidgets('a file going through normally shows no retry line', (tester) async {
    await pumpTile(tester, item()..phase = UploadItemPhase.uploading);

    expect(find.byKey(const ValueKey('upload-item-retrying')), findsNothing);
  });
}
