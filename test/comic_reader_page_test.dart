import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ComicReaderPage.dart';
import 'package:player/utils/comic/ComicPageSource.dart';
import 'package:player/utils/comic/ComicPreferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// A 1×1 transparent PNG; every page image in the tests is this.
final Uint8List _pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==');

String _manifest(int pages) => json.encode({
      'mediaFileId': 'file-1',
      'bookId': 'book-1',
      'format': 'CBZ',
      'pageCount': pages,
      'pages': [
        for (var i = 0; i < pages; i++)
          {'index': i, 'name': 'page$i.png', 'size': 100},
      ],
    });

MockClient _fakeServer(
  List<Map<String, dynamic>> progressPosts, {
  String? savedLocation,
  double savedProgress = 0,
}) =>
    MockClient((request) async {
      final path = request.url.path;
      if (path.endsWith('/manifest')) {
        return http.Response(_manifest(10), 200);
      }
      if (path.endsWith('/book-progress')) {
        return http.Response(
            json.encode({
              'bookId': 'book-1',
              'reading': savedLocation == null && savedProgress == 0
                  ? null
                  : {
                      'location': savedLocation,
                      'mediaFileId': 'file-1',
                      'progress': savedProgress,
                      'updatedAt': '2026-07-16T10:00:00Z',
                    },
              'chapters': [],
            }),
            200);
      }
      if (path.endsWith('/reading-progress')) {
        progressPosts.add(json.decode(request.body) as Map<String, dynamic>);
        return http.Response('{"bookId":"book-1"}', 200);
      }
      return http.Response('not found', 404);
    });

Widget _app() => const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      home: ComicReaderPage(
        serverName: 'test-server',
        bookId: 'book-1',
        mediaFileId: 'file-1',
        nodeUrl: 'https://node.example',
        title: 'Test Comic',
        seriesId: 'series-1',
      ),
    );

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    CbzPageSource.providerFactory = (_, __) => MemoryImage(_pixel);
  });

  tearDown(() {
    CbzPageSource.providerFactory = null;
  });

  testWidgets('opens at the first page and shows the page label',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Test Comic'), findsOneWidget);
      expect(find.text('Page 1 of 10'), findsOneWidget);
    }, () => _fakeServer([]));
  });

  testWidgets('resumes at the saved locator page', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Page 8 of 10'), findsOneWidget);
    },
        () => _fakeServer([],
            savedLocation: 'ister-comic:v1;page=7;pct=0.7',
            savedProgress: 0.7));
  });

  testWidgets('an unparseable location falls back to the progress fraction',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // 0.5 × 10 pages = page index 5.
      expect(find.text('Page 6 of 10'), findsOneWidget);
    },
        () => _fakeServer([],
            savedLocation: 'epubcfi(/6/4!/4/2)', savedProgress: 0.5));
  });

  testWidgets('arrow keys page and the position is reported', (tester) async {
    final posts = <Map<String, dynamic>>[];
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Page 1 of 10'), findsOneWidget);

      // The debounced save fires 1.5s after the page change.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    }, () => _fakeServer(posts));

    expect(posts, isNotEmpty);
    expect(posts.first['bookId'], 'book-1');
    expect(posts.first['readingLocationMediaFileId'], 'file-1');
    expect(posts.first['location'], startsWith('ister-comic:v1;page='));
  });

  testWidgets('the RTL toggle reverses paging and persists', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(
          tester.widget<PageView>(find.byType(PageView)).reverse, isFalse);

      await tester.tap(find.byIcon(Icons.format_textdirection_l_to_r));
      await tester.pumpAndSettle();
      expect(tester.widget<PageView>(find.byType(PageView)).reverse, isTrue);

      // Right-to-left: arrow-left advances.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);
    }, () => _fakeServer([]));

    // Persisted per series: a fresh open starts right-to-left.
    await http.runWithClient(() async {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(tester.widget<PageView>(find.byType(PageView)).reverse, isTrue);
    }, () => _fakeServer([]));
  });

  testWidgets('the thumbnail sheet jumps to a page', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();

      expect(find.text('Page 3 of 10'), findsOneWidget);
    }, () => _fakeServer([]));
  });

  testWidgets(
      'a wide viewport shows spreads and labels them as a page range',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    // ComicPreferences holds the first test's in-memory store (static
    // SharedPreferencesAsync), so the RTL test's toggle leaks in here.
    await ComicPreferences.setRightToLeft('series-1', false);

    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // The cover stands alone; then pages pair up.
      expect(find.text('Page 1 of 10'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 2-3 of 10'), findsOneWidget);

      // The last spread is reachable and shows the final pair.
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
      }
      expect(find.text('Page 8-9 of 10'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 10 of 10'), findsOneWidget);
    }, () => _fakeServer([]));
  });

  testWidgets('reaching the last page reports progress 1.0', (tester) async {
    final posts = <Map<String, dynamic>>[];
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('10'), 200,
          scrollable: find.byType(Scrollable).last);
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(find.text('Page 10 of 10'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    }, () => _fakeServer(posts));

    expect(posts, isNotEmpty);
    expect(posts.last['location'], contains('page=9'));
    expect(posts.last['progress'], closeTo(1.0, 1e-6));
  });
}
