import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/components/reader/ReaderChrome.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:player/pages/ComicReaderPage.dart';
import 'package:player/utils/comic/ComicPageSource.dart';
import 'package:player/utils/comic/ComicPreferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// A 1×1 transparent PNG; every page image in the tests is this.
final Uint8List _pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==');

/// An image that never produces a frame — stands in for a page still coming
/// off the network.
class _NeverDecodesImage extends ImageProvider<_NeverDecodesImage> {
  @override
  Future<_NeverDecodesImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<_NeverDecodesImage>(this);

  @override
  ImageStreamCompleter loadImage(
          _NeverDecodesImage key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(Completer<ImageInfo>().future);
}

String _manifest(int pages, {String format = 'CBZ'}) => json.encode({
      'mediaFileId': 'file-1',
      'bookId': 'book-1',
      'format': format,
      'pageCount': pages,
      // Like the server: the page list is cbz-only, a pdf manifest carries
      // just the count.
      'pages': [
        if (format == 'CBZ')
          for (var i = 0; i < pages; i++)
            {'index': i, 'name': 'page$i.png', 'size': 100},
      ],
    });

MockClient _fakeServer(
  List<Map<String, dynamic>> progressPosts, {
  String? savedLocation,
  double savedProgress = 0,
  String format = 'CBZ',
}) =>
    MockClient((request) async {
      final path = request.url.path;
      if (path.endsWith('/manifest')) {
        return http.Response(_manifest(10, format: format), 200);
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

/// GraphQL responder for the reader's series query: the effective reading
/// direction plus the volume list (for the next-volume affordance).
MockClient _fakeGraphQL({
  String direction = 'LTR',
  bool withNextVolume = false,
}) =>
    MockClient((request) async {
      return http.Response(
        json.encode({
          'data': {
            '__typename': 'Query',
            'seriesById': {
              '__typename': 'Series',
              'id': 'series-1',
              'readingDirection': direction,
              'books': [
                {
                  '__typename': 'Book',
                  'id': 'book-1',
                  'title': 'Volume 1',
                  'seriesIndex': 1.0,
                  'epubFiles': [
                    {
                      '__typename': 'EpubFile',
                      'id': 'file-1',
                      'format': 'CBZ',
                      'directory': {
                        '__typename': 'Directory',
                        'node': {
                          '__typename': 'Node',
                          'url': 'https://node.example'
                        }
                      }
                    }
                  ],
                },
                if (withNextVolume)
                  {
                    '__typename': 'Book',
                    'id': 'book-2',
                    'title': 'Volume 2',
                    'seriesIndex': 2.0,
                    'epubFiles': [
                      {
                        '__typename': 'EpubFile',
                        'id': 'file-2',
                        'format': 'CBZ',
                        'directory': {
                          '__typename': 'Directory',
                          'node': {
                            '__typename': 'Node',
                            'url': 'https://node.example'
                          }
                        }
                      }
                    ],
                  },
              ],
            }
          }
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

Widget _app({http.Client? graphQLClient}) => GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        link: HttpLink('https://api.example/graphql',
            httpClient: graphQLClient ?? _fakeGraphQL()),
        cache: GraphQLCache(),
      )),
      child: const MaterialApp(
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

  testWidgets('a page that has not decoded shows a skeleton, not black',
      (tester) async {
    CbzPageSource.providerFactory = (_, __) => _NeverDecodesImage();
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      // Not pumpAndSettle: the skeleton shimmer never settles.
      for (var i = 0;
          i < 40 && find.text('Page 1 of 10').evaluate().isEmpty;
          i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      // The comic itself is open (the page label is up) while its artwork is
      // still coming, and that wait is a skeleton rather than a black screen.
      expect(find.text('Page 1 of 10'), findsOneWidget);
      expect(find.byType(ComicPageSkeleton), findsWidgets);
    }, () => _fakeServer([]));
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

  testWidgets(
      'a pdf reads through the same server-rendered page path as a cbz',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // The empty pages[] list of a pdf manifest must not matter: paging works
      // off pageCount, through CbzPageSource (server-rasterized pages).
      expect(find.text('Page 1 of 10'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);
    }, () => _fakeServer([], format: 'PDF'));
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

  testWidgets('the RTL toggle reverses paging for this session only',
      (tester) async {
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

    // Session-only: a fresh open follows the server preference (LTR) again.
    await http.runWithClient(() async {
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(
          tester.widget<PageView>(find.byType(PageView)).reverse, isFalse);
    }, () => _fakeServer([]));
  });

  testWidgets('the server-stored series preference opens right-to-left',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app(graphQLClient: _fakeGraphQL(direction: 'RTL')));
      await tester.pumpAndSettle();

      expect(tester.widget<PageView>(find.byType(PageView)).reverse, isTrue);
    }, () => _fakeServer([]));

    // And it was written through to the offline cache.
    expect(await ComicPreferences.getRightToLeft('series-1'), isTrue);
  });

  testWidgets('an unreachable server falls back to the cached direction',
      (tester) async {
    await ComicPreferences.setRightToLeft('series-1', true);
    final failingGraphQL =
        MockClient((request) async => http.Response('boom', 500));

    await http.runWithClient(() async {
      await tester.pumpWidget(_app(graphQLClient: failingGraphQL));
      await tester.pumpAndSettle();

      expect(tester.widget<PageView>(find.byType(PageView)).reverse, isTrue);
    }, () => _fakeServer([]));
  });

  testWidgets('tap zones page and the middle toggles the chrome',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // Default surface is 800×600: right zone > 576, left zone < 224.
      await tester.tapAt(const Offset(750, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);

      await tester.tapAt(const Offset(50, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Page 1 of 10'), findsOneWidget);

      // The middle toggles the overlay chrome without changing the page.
      bool chromeShown() => tester
          .widgetList<ReaderChrome>(find.byType(ReaderChrome))
          .every((chrome) => chrome.visible);
      expect(chromeShown(), isTrue);
      await tester.tapAt(const Offset(400, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(chromeShown(), isFalse);
      expect(find.text('Page 1 of 10'), findsOneWidget); // page unchanged
      await tester.tapAt(const Offset(400, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(chromeShown(), isTrue);
    }, () => _fakeServer([]));
  });

  testWidgets('tap zones mirror under RTL', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app(graphQLClient: _fakeGraphQL(direction: 'RTL')));
      await tester.pumpAndSettle();

      // Right-to-left: the visual *left* edge advances.
      await tester.tapAt(const Offset(50, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);

      await tester.tapAt(const Offset(750, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Page 1 of 10'), findsOneWidget);
    }, () => _fakeServer([]));
  });

  testWidgets('toggling the chrome does not resize the page area',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      final withChrome = tester.getSize(find.byType(PageView));
      await tester.tapAt(const Offset(400, 300));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      final withoutChrome = tester.getSize(find.byType(PageView));

      expect(withoutChrome, withChrome);
    }, () => _fakeServer([]));
  });

  testWidgets('the spread-mode button forces single or double pages',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // Auto on a wide viewport: pages pair up.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 2-3 of 10'), findsOneWidget);

      // auto → single: the same page stands alone.
      await tester.tap(find.byIcon(Icons.auto_awesome_motion));
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 10'), findsOneWidget);

      // single → double: paired again.
      await tester.tap(find.byIcon(Icons.filter_1));
      await tester.pumpAndSettle();
      expect(find.text('Page 2-3 of 10'), findsOneWidget);

      // Back to auto: ComicPreferences holds the first test's in-memory
      // store (static SharedPreferencesAsync), so a persisted double mode
      // would leak into the tests that follow.
      await tester.tap(find.byIcon(Icons.auto_stories));
      await tester.pumpAndSettle();
    }, () => _fakeServer([]));
  });

  testWidgets('the last page offers the next volume of the series',
      (tester) async {
    await http.runWithClient(() async {
      await tester
          .pumpWidget(_app(graphQLClient: _fakeGraphQL(withNextVolume: true)));
      await tester.pumpAndSettle();

      expect(find.text('Next volume'), findsNothing);

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('10'), 200,
          scrollable: find.byType(Scrollable).last);
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      expect(find.text('Next volume'), findsOneWidget);
    }, () => _fakeServer([]));
  });

  testWidgets('no next-volume affordance when this is the last volume',
      (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('10'), 200,
          scrollable: find.byType(Scrollable).last);
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      expect(find.text('Next volume'), findsNothing);
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

  testWidgets('the two placeholders of a spread touch, like the pages do',
      (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await ComicPreferences.setRightToLeft('series-1', false);
    CbzPageSource.providerFactory = (_, __) => _NeverDecodesImage();

    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(find.text('Page 2-3 of 10'), findsOneWidget);

      // Page images never decode in a widget test, so both halves of the
      // spread show the placeholder: they must sit flush against each other,
      // exactly where the decoded pages will, or the spread visibly jumps
      // apart as it loads.
      // The AspectRatio, not the ComicPageSkeleton element: the painted page
      // block is what has to line up, and a wrapper could fill the slot while
      // the block inside it sits anywhere.
      final placeholders = find.descendant(
          of: find.descendant(
              of: find.byType(PageView),
              matching: find.byType(ComicPageSkeleton)),
          matching: find.byType(AspectRatio));
      expect(placeholders, findsNWidgets(2));
      final boxes = [
        for (var i = 0; i < 2; i++) tester.getRect(placeholders.at(i)),
      ]..sort((a, b) => a.left.compareTo(b.left));
      expect(boxes.first.right, moreOrLessEquals(boxes.last.left, epsilon: 0.5));
      expect(boxes.first.height, moreOrLessEquals(boxes.last.height));
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

  testWidgets('opens windowed and the fullscreen toggle persists',
      (tester) async {
    // The static in-memory store leaks between tests; start from a known
    // state.
    await ComicPreferences.setFullscreen(false);
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.fullscreen), findsOneWidget);
      expect(find.byIcon(Icons.fullscreen_exit), findsNothing);

      await tester.tap(find.byIcon(Icons.fullscreen));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.fullscreen_exit), findsOneWidget);
      expect(await ComicPreferences.getFullscreen(), isTrue);
    }, () => _fakeServer([]));
  });

  testWidgets('restores fullscreen from the saved preference', (tester) async {
    await ComicPreferences.setFullscreen(true);
    await http.runWithClient(() async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.fullscreen_exit), findsOneWidget);
    }, () => _fakeServer([]));
    await ComicPreferences.setFullscreen(false);
  });
}
