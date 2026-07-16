import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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
    return resolved.isNotEmpty ? CachedNetworkImageProvider(resolved) : null;
  }
}
