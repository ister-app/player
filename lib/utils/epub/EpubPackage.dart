import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:player/utils/epub/EpubResourceClient.dart';
import 'package:xml/xml.dart';

/// The parsed structure of an epub: OPF metadata, manifest, spine and table of
/// contents. The server persists none of this — like the old web reader, the
/// client reads container.xml and the OPF itself through the resource
/// endpoint.
class EpubPackage {
  EpubPackage({
    required this.title,
    required this.fixedLayout,
    required this.opfDir,
    required this.manifest,
    required this.spine,
    required this.toc,
  });

  final String? title;

  /// `rendition:layout: pre-paginated` books are laid out per page and will
  /// not reflow well; the reader shows a warning banner for them.
  final bool fixedLayout;

  /// Directory prefix of the OPF; manifest hrefs are relative to it.
  final String opfDir;

  final Map<String, EpubManifestItem> manifest;
  final List<EpubSpineItem> spine;
  final List<EpubTocEntry> toc;

  bool get hasMediaOverlays =>
      manifest.values.any((item) =>
          item.mediaOverlayId != null ||
          item.mediaType == 'application/smil+xml');

  static Future<EpubPackage> load(EpubResourceClient client) async {
    final container = await client.xml('META-INF/container.xml');
    final rootfile = _elements(container.rootElement, 'rootfile')
        .where((element) => element.getAttribute('full-path') != null)
        .firstOrNull;
    if (rootfile == null) {
      throw const EpubStructureException('container.xml has no rootfile');
    }
    final opfPath = rootfile.getAttribute('full-path')!;
    final opfDir = opfPath.contains('/')
        ? opfPath.substring(0, opfPath.lastIndexOf('/') + 1)
        : '';
    final opf = await client.xml(opfPath);
    final root = opf.rootElement;

    final title = _elements(root, 'title')
        .map((element) => element.innerText.trim())
        .where((text) => text.isNotEmpty)
        .firstOrNull;
    final fixedLayout = _elements(root, 'meta').any((element) =>
        element.getAttribute('property') == 'rendition:layout' &&
        element.innerText.trim() == 'pre-paginated');

    final manifest = <String, EpubManifestItem>{};
    final manifestElement = _elements(root, 'manifest').firstOrNull;
    for (final item
        in manifestElement == null ? <XmlElement>[] : _elements(manifestElement, 'item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      if (id == null || href == null) continue;
      manifest[id] = EpubManifestItem(
        id: id,
        href: resolveHref(opfDir, href),
        mediaType: item.getAttribute('media-type') ?? '',
        mediaOverlayId: item.getAttribute('media-overlay'),
        properties: (item.getAttribute('properties') ?? '')
            .split(RegExp(r'\s+'))
            .where((property) => property.isNotEmpty)
            .toSet(),
      );
    }

    final spine = <EpubSpineItem>[];
    final spineElement = _elements(root, 'spine').firstOrNull;
    for (final itemref
        in spineElement == null ? <XmlElement>[] : _elements(spineElement, 'itemref')) {
      final idref = itemref.getAttribute('idref');
      final item = idref == null ? null : manifest[idref];
      if (item == null) continue;
      spine.add(EpubSpineItem(
        idref: idref!,
        href: item.href,
        linear: itemref.getAttribute('linear') != 'no',
      ));
    }

    final toc = await _loadToc(client, manifest, spineElement);

    return EpubPackage(
      title: title,
      fixedLayout: fixedLayout,
      opfDir: opfDir,
      manifest: manifest,
      spine: spine,
      toc: toc,
    );
  }

  /// EPUB 3 nav document first, NCX as the EPUB 2 fallback; an empty list when
  /// the book has neither (the reader then offers the spine as chapters).
  static Future<List<EpubTocEntry>> _loadToc(
    EpubResourceClient client,
    Map<String, EpubManifestItem> manifest,
    XmlElement? spineElement,
  ) async {
    final nav = manifest.values
        .where((item) => item.properties.contains('nav'))
        .firstOrNull;
    if (nav != null) {
      try {
        return _parseNav(await client.text(nav.href), _dirOf(nav.href));
      } catch (_) {
        // Fall through to NCX.
      }
    }
    final ncxId = spineElement?.getAttribute('toc');
    final ncx = (ncxId != null ? manifest[ncxId] : null) ??
        manifest.values
            .where((item) => item.mediaType == 'application/x-dtbncx+xml')
            .firstOrNull;
    if (ncx != null) {
      try {
        return _parseNcx(await client.xml(ncx.href), _dirOf(ncx.href));
      } catch (_) {
        // No usable TOC.
      }
    }
    return const [];
  }

  /// nav.xhtml is HTML; parse it leniently and walk the `toc` nav's nested
  /// lists.
  static List<EpubTocEntry> _parseNav(String content, String navDir) {
    final document = html_parser.parse(content);
    final navs = document.getElementsByTagName('nav');
    final tocNav = navs
            .where((nav) =>
                (nav.attributes['epub:type'] ?? nav.attributes['role'] ?? '')
                    .contains('toc'))
            .firstOrNull ??
        navs.firstOrNull;
    if (tocNav == null) return const [];
    final entries = <EpubTocEntry>[];
    void walk(dom.Element element, int depth) {
      for (final list in element.children) {
        if (list.localName != 'ol' && list.localName != 'ul') continue;
        for (final item in list.children) {
          if (item.localName != 'li') continue;
          final anchor = item.getElementsByTagName('a').firstOrNull;
          final href = anchor?.attributes['href'];
          if (anchor != null && href != null && href.isNotEmpty) {
            entries.add(EpubTocEntry.fromHref(
              label: anchor.text.trim(),
              rawHref: href,
              dir: navDir,
              depth: depth,
            ));
          }
          walk(item, depth + 1);
        }
      }
    }

    walk(tocNav, 0);
    return entries;
  }

  static List<EpubTocEntry> _parseNcx(XmlDocument ncx, String ncxDir) {
    final entries = <EpubTocEntry>[];
    void walk(XmlElement element, int depth) {
      for (final navPoint in element.childElements
          .where((child) => child.name.local == 'navPoint')) {
        final label = _elements(navPoint, 'text')
                .map((text) => text.innerText.trim())
                .firstOrNull ??
            '';
        final src = _elements(navPoint, 'content')
            .map((content) => content.getAttribute('src'))
            .firstOrNull;
        if (src != null && src.isNotEmpty) {
          entries.add(EpubTocEntry.fromHref(
            label: label,
            rawHref: src,
            dir: ncxDir,
            depth: depth,
          ));
        }
        walk(navPoint, depth + 1);
      }
    }

    final navMap = _elements(ncx.rootElement, 'navMap').firstOrNull;
    if (navMap != null) walk(navMap, 0);
    return entries;
  }

  int spineIndexForHref(String href) =>
      spine.indexWhere((item) => item.href == href);

  int spineIndexForIdref(String idref) =>
      spine.indexWhere((item) => item.idref == idref);

  int spineIndexForTocEntry(EpubTocEntry entry) =>
      spineIndexForHref(entry.href);

  /// The SMIL manifest item carrying a spine item's media overlay, if any.
  EpubManifestItem? mediaOverlayForSpineIndex(int spineIndex) {
    if (spineIndex < 0 || spineIndex >= spine.length) return null;
    final overlayId = manifest[spine[spineIndex].idref]?.mediaOverlayId;
    return overlayId == null ? null : manifest[overlayId];
  }

  /// Resolves an href relative to a directory prefix, collapsing `../` and
  /// decoding percent-escapes so the result matches the zip entry name.
  static String resolveHref(String dir, String href) {
    final decoded = _tryDecode(href);
    final parts = ('$dir$decoded').split('/');
    final out = <String>[];
    for (final part in parts) {
      if (part == '..') {
        if (out.isNotEmpty) out.removeLast();
      } else if (part != '.' && part.isNotEmpty) {
        out.add(part);
      }
    }
    return out.join('/');
  }

  static String _dirOf(String entryPath) => entryPath.contains('/')
      ? entryPath.substring(0, entryPath.lastIndexOf('/') + 1)
      : '';

  static String _tryDecode(String value) {
    try {
      return Uri.decodeFull(value);
    } on ArgumentError {
      return value;
    }
  }

  /// Namespace-agnostic descendant lookup: OPF/NCX documents mix default and
  /// prefixed namespaces, so match on the local name only.
  static Iterable<XmlElement> _elements(XmlElement root, String localName) =>
      root.descendantElements.where((element) => element.name.local == localName);
}

class EpubManifestItem {
  EpubManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    this.mediaOverlayId,
    this.properties = const {},
  });

  final String id;

  /// Resolved zip entry path (relative to the epub root, not the OPF).
  final String href;
  final String mediaType;
  final String? mediaOverlayId;
  final Set<String> properties;
}

class EpubSpineItem {
  EpubSpineItem({required this.idref, required this.href, this.linear = true});

  final String idref;
  final String href;
  final bool linear;
}

class EpubTocEntry {
  EpubTocEntry({
    required this.label,
    required this.href,
    this.fragment,
    this.depth = 0,
  });

  factory EpubTocEntry.fromHref({
    required String label,
    required String rawHref,
    required String dir,
    required int depth,
  }) {
    final hashIndex = rawHref.indexOf('#');
    final path = hashIndex >= 0 ? rawHref.substring(0, hashIndex) : rawHref;
    final fragment = hashIndex >= 0 ? rawHref.substring(hashIndex + 1) : null;
    return EpubTocEntry(
      label: label,
      href: EpubPackage.resolveHref(dir, path),
      fragment: fragment != null && fragment.isNotEmpty ? fragment : null,
      depth: depth,
    );
  }

  final String label;

  /// Resolved zip entry path of the target document.
  final String href;

  /// Element id inside the document, when the entry points mid-chapter.
  final String? fragment;
  final int depth;
}

class EpubStructureException implements Exception {
  const EpubStructureException(this.message);

  final String message;

  @override
  String toString() => 'Invalid epub: $message';
}
