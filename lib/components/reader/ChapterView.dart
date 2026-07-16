import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:player/components/reader/ReaderWidgetFactory.dart';
import 'package:player/utils/epub/ChapterContent.dart';
import 'package:player/utils/epub/ReaderPreferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// One chapter of an epub as a lazily-built scrolling list, one list item per
/// top-level block. The block granularity is what makes everything else work:
/// the visible block index is the stored reading position, `jumpTo` restores
/// it, and read-aloud highlighting only rebuilds the block the active sentence
/// is in.
class ChapterView extends StatelessWidget {
  const ChapterView({
    super.key,
    required this.content,
    required this.theme,
    required this.fontScale,
    required this.resourceUrl,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.scrollOffsetController,
    this.initialBlockIndex = 0,
    this.initialAlignment = 0,
    this.highlightFragment,
    this.onBlockTap,
    this.onLinkTap,
  });

  final ChapterContent content;
  final ReaderTheme theme;
  final double fontScale;
  final String Function(String entryPath) resourceUrl;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final ScrollOffsetController scrollOffsetController;
  final int initialBlockIndex;
  final double initialAlignment;

  /// Element id of the sentence the read-aloud audio is at; highlighted like
  /// the web reader's `-epub-media-overlay-active` class.
  final String? highlightFragment;
  final void Function(int blockIndex, ChapterBlock block)? onBlockTap;
  final void Function(String url)? onLinkTap;

  static const double _maxTextWidth = 700;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: theme.foreground,
      fontSize: 16 * fontScale,
      height: 1.6,
    );
    return ScrollablePositionedList.builder(
      itemCount: content.blocks.length,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetController: scrollOffsetController,
      initialScrollIndex:
          initialBlockIndex.clamp(0, content.blocks.length - 1),
      initialAlignment: initialAlignment,
      padding: const EdgeInsets.symmetric(vertical: 32),
      itemBuilder: (context, index) {
        final block = content.blocks[index];
        final highlighted = highlightFragment != null &&
            block.ids.contains(highlightFragment);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap:
              onBlockTap != null ? () => onBlockTap!(index, block) : null,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxTextWidth),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: HtmlWidget(
                  block.outerHtml,
                  // A stable key: the widget must update in place when the
                  // active sentence moves, never be torn down — a teardown
                  // re-parses the block and momentarily collapses its height,
                  // which makes the whole page jump on every sentence.
                  key: ValueKey('block-$index'),
                  // Restyles (synchronously) when the active sentence enters,
                  // leaves or moves within this block.
                  rebuildTriggers: [highlighted ? highlightFragment : null],
                  factoryBuilder: () =>
                      ReaderWidgetFactory(resourceUrl: resourceUrl),
                  textStyle: textStyle,
                  customStylesBuilder: (element) =>
                      highlighted && element.id == highlightFragment
                          ? const {
                              'background-color': 'rgba(255, 213, 79, 0.55)',
                            }
                          : null,
                  onTapUrl: onLinkTap != null
                      ? (url) {
                          onLinkTap!(url);
                          return true;
                        }
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
