import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/reader/ChapterView.dart';
import 'package:player/utils/epub/ChapterContent.dart';
import 'package:player/utils/epub/ReaderPreferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Regression test for the read-aloud "jumping screen": advancing the
/// highlighted sentence must not move the scroll position or collapse the
/// highlighted block.
void main() {
  final chapterHtml = StringBuffer('<html><body>');
  for (var block = 0; block < 12; block++) {
    chapterHtml.write('<p>');
    for (var sentence = 0; sentence < 4; sentence++) {
      chapterHtml.write(
          '<span id="b${block}s$sentence">Sentence $sentence of paragraph '
          '$block with a reasonable amount of text in it.</span> ');
    }
    chapterHtml.write('</p>');
  }
  chapterHtml.write('</body></html>');
  final content = ChapterContent.parse(chapterHtml.toString(), '');

  Widget app(String? highlight, ItemPositionsListener positions) =>
      MaterialApp(
        home: Scaffold(
          body: ChapterView(
            content: content,
            theme: ReaderTheme.light,
            fontScale: 1.0,
            resourceUrl: (entry) => 'https://example.com/$entry',
            itemScrollController: ItemScrollController(),
            itemPositionsListener: positions,
            scrollOffsetController: ScrollOffsetController(),
            // Anchored mid-chapter, like resuming at a saved position.
            initialBlockIndex: 3,
            highlightFragment: highlight,
          ),
        ),
      );

  testWidgets('advancing the highlight keeps the scroll position stable',
      (tester) async {
    final positions = ItemPositionsListener.create();
    await tester.pumpWidget(app(null, positions));
    await tester.pumpAndSettle();

    double topEdgeOf(int index) => positions.itemPositions.value
        .firstWhere((position) => position.index == index)
        .itemLeadingEdge;

    final baselineTop = topEdgeOf(3);
    final baselineVisible =
        positions.itemPositions.value.map((p) => p.index).toSet();

    // Walk the highlight through the sentences of the anchor paragraph and
    // the next one, like read-aloud does, and verify the viewport never
    // moves.
    for (final fragment in ['b3s0', 'b3s1', 'b3s2', 'b4s0', 'b4s1']) {
      await tester.pumpWidget(app(fragment, positions));
      await tester.pump();

      final visible =
          positions.itemPositions.value.map((p) => p.index).toSet();
      expect(visible, baselineVisible,
          reason: 'visible blocks changed while highlighting $fragment');
      expect(topEdgeOf(3), moreOrLessEquals(baselineTop, epsilon: 0.001),
          reason: 'scroll position moved while highlighting $fragment');
    }
  });
}
