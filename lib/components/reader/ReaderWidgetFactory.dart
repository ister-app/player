import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/utils/epub/ChapterContent.dart';

/// fwfh widget factory for chapter documents: resolves the `epub:///` entry
/// URLs that [ChapterContent] rewrote image references to into tokenized
/// resource URLs at build time, so cached chapter HTML never contains a stream
/// token that could expire.
class ReaderWidgetFactory extends WidgetFactory {
  ReaderWidgetFactory({required this.resourceUrl});

  /// Maps a zip entry path to its authenticated resource URL
  /// (EpubResourceClient.url).
  final String Function(String entryPath) resourceUrl;

  @override
  ImageProvider? imageProviderFromNetwork(String url) {
    final entryPath = ChapterContent.entryPathFromUrl(url);
    final resolved = entryPath != null ? resourceUrl(entryPath) : url;
    if (resolved.isEmpty) return null;
    // A downloaded epub resolves entries to absolute paths.
    if (resolved.startsWith('/')) return FileImage(File(resolved));
    // Prose illustrations are laid out by fwfh, so there is no width to read
    // here; 1080 physical pixels is past any reading column and still stops a
    // cover-sized scan from decoding at full size. (sizedUrl leaves /epub/
    // urls alone, so this is a decode cap only.)
    return ArtworkImage.providerFor(resolved, physicalWidth: 1080)!;
  }
}
