import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/components/VideoVersionPicker.dart';
import 'package:player/graphql/fragmentMediafiles.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

Fragment$fragmentMediaFiles _file(String id, int width, int height) =>
    Fragment$fragmentMediaFiles(
      id: id,
      path: '/movies/The Movie (2020)/$id.mkv',
      size: 8e9,
      durationInMilliseconds: 5400000,
      directory: Fragment$fragmentMediaFiles$directory(
        servingNode: Fragment$fragmentMediaFiles$directory$servingNode(
            url: 'http://node.example'),
      ),
      mediaFileStreams: [
        Fragment$fragmentMediaFiles$mediaFileStreams(
            id: 'v-$id',
            codecName: 'h264',
            codecType: 'VIDEO',
            width: width,
            height: height,
            path: '',
            streamIndex: 0),
      ],
    );

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('com.alexmercerind/media_kit_video'),
          (call) async => null);
  MediaKit.ensureInitialized();
  // Outside a test zone: the singleton's watchdog timer would otherwise count
  // as a pending timer of whichever test touches it first.
  MediaPlayerHandler.instance;

  final hd = _file('mf-hd', 1920, 1080);
  final uhd = _file('mf-uhd', 3840, 2160);

  testWidgets('an item with one file shows no version chip', (tester) async {
    await tester.pumpWidget(_app(VideoVersionRow(
        files: [hd], playing: false, pickedId: null, onPicked: (_) {})));
    expect(find.byKey(VideoVersionChip.chipKey), findsNothing);
  });

  testWidgets('picking a version before playback reports its id, and '
      '"automatic" reports null', (tester) async {
    final picks = <String?>[];
    String? picked;
    await tester.pumpWidget(_app(StatefulBuilder(
      builder: (context, setState) => VideoVersionRow(
        files: [hd, uhd],
        playing: false,
        pickedId: picked,
        onPicked: (id) => setState(() {
          picked = id;
          picks.add(id);
        }),
      ),
    )));
    expect(find.byKey(VideoVersionChip.chipKey), findsOneWidget);

    await tester.tap(find.byKey(VideoVersionChip.chipKey));
    await tester.pumpAndSettle();
    expect(find.byKey(VideoVersionChip.automaticKey), findsOneWidget);
    await tester.tap(find.byKey(VideoVersionChip.optionKey('mf-hd')));
    await tester.pumpAndSettle();
    expect(picks, ['mf-hd']);

    await tester.tap(find.byKey(VideoVersionChip.chipKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(VideoVersionChip.automaticKey));
    await tester.pumpAndSettle();
    expect(picks, ['mf-hd', null]);
  });

  testWidgets('while the item plays there is no "automatic": a stream is '
      'always some version', (tester) async {
    await tester.pumpWidget(_app(VideoVersionRow(
        files: [hd, uhd], playing: true, pickedId: null, onPicked: (_) {})));
    await tester.tap(find.byKey(VideoVersionChip.chipKey));
    await tester.pumpAndSettle();
    expect(find.byKey(VideoVersionChip.automaticKey), findsNothing);
    expect(find.byKey(VideoVersionChip.optionKey('mf-uhd')), findsOneWidget);
  });

  testWidgets('dismissing the sheet changes nothing', (tester) async {
    var calls = 0;
    await tester.pumpWidget(_app(VideoVersionRow(
        files: [hd, uhd],
        playing: false,
        pickedId: null,
        onPicked: (_) => calls++)));
    await tester.tap(find.byKey(VideoVersionChip.chipKey));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(calls, 0);
  });
}
