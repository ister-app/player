import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:player/utils/comic/ComicPageSource.dart';
import 'package:player/utils/comic/ComicResourceClient.dart';

/// Pdf pages rendered locally by pdfium, fed by ranged reads of the node's
/// `/comic/{id}/file` endpoint — a large volume never needs a full download,
/// and every read carries a fresh stream token. Rendered pages live in
/// Flutter's regular image cache (the provider key is document/page/width).
///
/// Not supported on web: pdfrx has no custom-read source there.
class PdfPageSource implements ComicPageSource {
  PdfPageSource._(this._document);

  final PdfDocument _document;

  static const int _defaultPageWidth = 1600;
  static const int _thumbnailWidth = CbzPageSource.thumbnailWidth;

  static Future<PdfPageSource> open(ComicResourceClient client) async {
    await pdfrxFlutterInitialize();
    final fileSize = await client.fileSize();
    if (fileSize == null || fileSize <= 0) {
      throw ComicResourceException('file size', 0);
    }
    final document = await PdfDocument.openCustom(
      read: (buffer, position, size) async {
        final bytes = await client.readRange(position, size);
        buffer.setRange(0, bytes.length, bytes);
        return bytes.length;
      },
      fileSize: fileSize,
      sourceName: 'comic-${client.serverName}-${client.mediaFileId}',
    );
    return PdfPageSource._(document);
  }

  @override
  int get pageCount => _document.pages.length;

  @override
  ImageProvider pageImage(int index, {int? targetWidth}) =>
      _PdfPageImageProvider(
        source: this,
        pageIndex: index,
        width: targetWidth ?? _defaultPageWidth,
      );

  @override
  ImageProvider thumbnail(int index) => _PdfPageImageProvider(
        source: this,
        pageIndex: index,
        width: _thumbnailWidth,
      );

  Future<ui.Image> _render(int pageIndex, int width) async {
    final page = _document.pages[pageIndex];
    final scale = width / page.width;
    final rendered = await page.render(
      fullWidth: width.toDouble(),
      fullHeight: page.height * scale,
    );
    if (rendered == null) {
      throw StateError('Rendering pdf page $pageIndex failed');
    }
    try {
      return await rendered.createImage();
    } finally {
      rendered.dispose();
    }
  }

  @override
  void dispose() => unawaited(_document.dispose());
}

/// Keyed on (document, page, width) so Flutter's image cache deduplicates and
/// evicts rendered pages like any other image.
class _PdfPageImageProvider extends ImageProvider<_PdfPageImageProvider> {
  const _PdfPageImageProvider({
    required this.source,
    required this.pageIndex,
    required this.width,
  });

  final PdfPageSource source;
  final int pageIndex;
  final int width;

  @override
  Future<_PdfPageImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
          _PdfPageImageProvider key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(_loadInfo());

  Future<ImageInfo> _loadInfo() async =>
      ImageInfo(image: await source._render(pageIndex, width));

  @override
  bool operator ==(Object other) =>
      other is _PdfPageImageProvider &&
      other.source == source &&
      other.pageIndex == pageIndex &&
      other.width == width;

  @override
  int get hashCode => Object.hash(source, pageIndex, width);
}
