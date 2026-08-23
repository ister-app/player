/// The `/comic/{mediaFileId}/manifest` response: what the volume is and, for
/// cbz, the ordered page list. The client picks its reader from [format].
class ComicManifest {
  ComicManifest({
    required this.mediaFileId,
    required this.bookId,
    required this.format,
    this.pageCount,
    this.pages = const [],
  });

  final String mediaFileId;
  final String bookId;

  /// `CBZ`, `PDF` or `EPUB`.
  final String format;

  /// Cbz image count or pdf page count; null when the file was never analyzed.
  final int? pageCount;

  /// The cbz pages in reading order; empty for pdf/epub.
  final List<ComicPageInfo> pages;

  Map<String, dynamic> toJson() => {
        'mediaFileId': mediaFileId,
        'bookId': bookId,
        'format': format,
        'pageCount': pageCount,
        'pages': [for (final p in pages) p.toJson()],
      };

  static ComicManifest fromJson(Map<String, dynamic> json) => ComicManifest(
        mediaFileId: '${json['mediaFileId']}',
        bookId: '${json['bookId']}',
        format: '${json['format']}',
        pageCount: (json['pageCount'] as num?)?.toInt(),
        pages: [
          for (final page in (json['pages'] as List<dynamic>? ?? []))
            if (page is Map<String, dynamic>) ComicPageInfo.fromJson(page),
        ],
      );
}

class ComicPageInfo {
  ComicPageInfo({required this.index, required this.name, required this.size});

  final int index;
  final String name;
  final int size;

  Map<String, dynamic> toJson() => {'index': index, 'name': name, 'size': size};

  static ComicPageInfo fromJson(Map<String, dynamic> json) => ComicPageInfo(
        index: (json['index'] as num?)?.toInt() ?? 0,
        name: '${json['name']}',
        size: (json['size'] as num?)?.toInt() ?? 0,
      );
}
