import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/pages/ReaderPage.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

const _container = '''
<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles>
</container>
''';

const _opf = '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:title>Widget Test Book</dc:title></metadata>
  <manifest>
    <item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    <item id="ch1" href="ch1.xhtml" media-type="application/xhtml+xml"/>
    <item id="ch2" href="ch2.xhtml" media-type="application/xhtml+xml"/>
  </manifest>
  <spine><itemref idref="ch1"/><itemref idref="ch2"/></spine>
</package>
''';

const _nav = '''
<html xmlns="http://www.w3.org/1999/xhtml"><body>
<nav epub:type="toc" xmlns:epub="http://www.idpf.org/2007/ops"><ol>
  <li><a href="ch1.xhtml">Hoofdstuk een</a></li>
  <li><a href="ch2.xhtml">Hoofdstuk twee</a></li>
</ol></nav>
</body></html>
''';

const _ch1 = '''
<html><body>
  <h1 id="h1">First chapter heading</h1>
  <p>Opening paragraph of chapter one.</p>
  <p>Second paragraph of chapter one.</p>
</body></html>
''';

const _ch2 = '''
<html><body>
  <h1 id="h2">Second chapter heading</h1>
  <p>Opening paragraph of chapter two.</p>
</body></html>
''';

/// The fixture "server": epub resources plus the two progress endpoints.
MockClient _fakeServer(List<Map<String, dynamic>> progressPosts) =>
    MockClient((request) async {
      final path = request.url.path;
      if (path.contains('/resource/')) {
        final entry = Uri.decodeComponent(path.split('/resource/').last);
        final body = switch (entry) {
          'META-INF/container.xml' => _container,
          'OEBPS/content.opf' => _opf,
          'OEBPS/nav.xhtml' => _nav,
          'OEBPS/ch1.xhtml' => _ch1,
          'OEBPS/ch2.xhtml' => _ch2,
          _ => null,
        };
        return http.Response(body ?? 'not found', body == null ? 404 : 200);
      }
      if (path.endsWith('/book-progress')) {
        return http.Response(
            '{"bookId":"book-1","reading":null,"chapters":[]}', 200);
      }
      if (path.endsWith('/reading-progress')) {
        progressPosts
            .add(json.decode(request.body) as Map<String, dynamic>);
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
      home: ReaderPage(
        serverName: 'test-server',
        bookId: 'book-1',
        mediaFileId: 'file-1',
        nodeUrl: 'https://node.example',
        title: 'Widget Test Book',
      ),
    );

/// Runs [body] with every `http.Client()` in the app replaced by the fixture
/// server (the reader creates its clients while widgets pump, inside this
/// zone).
Future<void> _withFakeServer(
  WidgetTester tester,
  List<Map<String, dynamic>> progressPosts,
  Future<void> Function() body,
) =>
    http.runWithClient(body, () => _fakeServer(progressPosts));

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('loads the book and renders the first chapter', (tester) async {
    await _withFakeServer(tester, [], () async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Widget Test Book'), findsOneWidget);
      expect(find.textContaining('First chapter heading', findRichText: true), findsOneWidget);
      expect(find.textContaining('Opening paragraph of chapter one', findRichText: true),
          findsOneWidget);
    });
  });

  testWidgets('navigates to another chapter through the TOC drawer',
      (tester) async {
    await _withFakeServer(tester, [], () async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.toc));
      await tester.pumpAndSettle();
      expect(find.text('Hoofdstuk twee'), findsOneWidget);

      await tester.tap(find.text('Hoofdstuk twee'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Second chapter heading', findRichText: true), findsOneWidget);
      expect(find.textContaining('First chapter heading', findRichText: true), findsNothing);
    });
  });

  testWidgets('next-chapter button advances and the position is reported',
      (tester) async {
    final posts = <Map<String, dynamic>>[];
    await _withFakeServer(tester, posts, () async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.skip_next));
      await tester.pumpAndSettle();
      expect(find.textContaining('Second chapter heading', findRichText: true), findsOneWidget);

      // The debounced save fires 1.5s after the chapter change.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    expect(posts, isNotEmpty);
    final post = posts.last;
    expect(post['bookId'], 'book-1');
    expect(post['readingLocationMediaFileId'], 'file-1');
    expect(post['location'], startsWith('ister:v1;spine=ch2'));
  });

  testWidgets('settings sheet changes the font size', (tester) async {
    await _withFakeServer(tester, [], () async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      double sizeOf(String text) {
        final renderParagraph = tester.renderObject<RenderParagraph>(
            find.textContaining(text, findRichText: true).first);
        return renderParagraph.text.style!.fontSize!;
      }

      final before = sizeOf('Opening paragraph of chapter one');

      await tester.tap(find.byIcon(Icons.text_fields));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.text_increase));
      await tester.pumpAndSettle();
      // Close the sheet.
      await tester.tapAt(const Offset(400, 100));
      await tester.pumpAndSettle();

      final after = sizeOf('Opening paragraph of chapter one');
      expect(after, greaterThan(before));
    });
  });
}
