import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:player/utils/epub/EpubPackage.dart';

/// The scheme chapter image srcs are rewritten to; the reader's widget
/// factory maps `epub:///<entry>` back to a tokenized resource URL at build
/// time, so cached chapter HTML never embeds a (expirable) stream token.
const String epubResourceScheme = 'epub';

/// One top-level block of a chapter document (a paragraph, heading, image,
/// table, …), rendered as a single list item by the reader. The block index
/// in [ChapterContent.blocks] is what the locator stores: it does not depend
/// on font size or viewport.
class ChapterBlock {
  ChapterBlock({
    required this.outerHtml,
    required this.ids,
    required this.charCount,
  });

  final String outerHtml;

  /// All element ids inside the block (SMIL text fragments usually sit on
  /// nested spans).
  final Set<String> ids;

  /// Text length, used to weight chapters for the whole-book progress
  /// fraction.
  final int charCount;
}

class ChapterContent {
  ChapterContent({required this.blocks, required Map<String, int> idToBlock})
      : _idToBlock = idToBlock;

  final List<ChapterBlock> blocks;
  final Map<String, int> _idToBlock;

  int get charCount =>
      blocks.fold(0, (total, block) => total + block.charCount);

  /// The block containing the element with [id], or null.
  int? blockIndexForId(String id) => _idToBlock[id];

  /// Parses a chapter document into blocks. [docDir] is the entry's directory
  /// prefix; relative image references are resolved against it and rewritten
  /// to `epub:///<entry>` URLs.
  static ChapterContent parse(String content, String docDir) {
    final document = html_parser.parse(content);
    final body = document.body;
    final blocks = <ChapterBlock>[];
    final idToBlock = <String, int>{};
    if (body == null) return ChapterContent(blocks: blocks, idToBlock: idToBlock);

    _rewriteResourceRefs(body, docDir);

    void emit(dom.Node node) {
      final String outerHtml;
      final ids = <String>{};
      int charCount;
      if (node is dom.Element) {
        _collectIds(node, ids);
        outerHtml = node.outerHtml;
        charCount = node.text.trim().length;
      } else {
        final text = node.text?.trim() ?? '';
        if (text.isEmpty) return;
        outerHtml = '<p>${const HtmlEscape().convert(text)}</p>';
        charCount = text.length;
      }
      if (outerHtml.isEmpty) return;
      final index = blocks.length;
      for (final id in ids) {
        idToBlock.putIfAbsent(id, () => index);
      }
      blocks.add(ChapterBlock(
        outerHtml: outerHtml,
        ids: ids,
        charCount: charCount,
      ));
    }

    void flatten(dom.Element parent) {
      for (final node in parent.nodes) {
        if (node is dom.Element) {
          if (_isSkipped(node)) continue;
          if (_isWrapper(node)) {
            // A wrapper that carries an id still needs it reachable for TOC
            // fragments/SMIL: map it to the first block emitted inside.
            final id = node.attributes['id'];
            if (id != null) {
              idToBlock.putIfAbsent(id, () => blocks.length);
            }
            flatten(node);
          } else {
            emit(node);
          }
        } else if (node is dom.Text && node.text.trim().isNotEmpty) {
          emit(node);
        }
      }
    }

    flatten(body);
    return ChapterContent(blocks: blocks, idToBlock: idToBlock);
  }

  static const Set<String> _wrapperTags = {
    'div',
    'section',
    'article',
    'main',
    'aside',
    'header',
    'footer',
    'body',
  };

  static const Set<String> _blockInsideWrapperTags = {
    'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'ul', 'ol', 'table',
    'figure', 'img', 'image', 'svg', 'pre', 'hr', 'dl',
    ..._wrapperTagsList,
  };

  static const List<String> _wrapperTagsList = [
    'div', 'section', 'article', 'main', 'aside', 'header', 'footer',
  ];

  /// A wrapper is a container whose children are themselves blocks; its
  /// children are flattened into separate blocks. A `<div>` holding running
  /// text (inline nodes) is a block of its own.
  static bool _isWrapper(dom.Element element) {
    if (!_wrapperTags.contains(element.localName)) return false;
    return element.nodes.every((node) {
      if (node is dom.Element) {
        return _blockInsideWrapperTags.contains(node.localName) ||
            _isSkipped(node);
      }
      return node is! dom.Text || node.text.trim().isEmpty;
    });
  }

  static bool _isSkipped(dom.Element element) =>
      element.localName == 'script' ||
      element.localName == 'style' ||
      element.localName == 'link' ||
      element.localName == 'audio' ||
      element.localName == 'video';

  static void _collectIds(dom.Element element, Set<String> ids) {
    final id = element.attributes['id'];
    if (id != null && id.isNotEmpty) ids.add(id);
    for (final child in element.children) {
      _collectIds(child, ids);
    }
  }

  /// Rewrites `img src`, `source srcset` and SVG `image xlink:href` to
  /// absolute `epub:///` entry URLs.
  static void _rewriteResourceRefs(dom.Element body, String docDir) {
    for (final img in body.querySelectorAll('img')) {
      final src = img.attributes['src'];
      if (src != null && !src.contains('://')) {
        img.attributes['src'] = _entryUrl(docDir, src);
      }
      img.attributes.remove('srcset');
    }
    // SVG <image> elements keep their namespaced xlink:href attribute; the
    // html package stores those under AttributeName keys, so match on the
    // attribute's local name.
    for (final image in _descendantsByLocalName(body, 'image')) {
      for (final entry in image.attributes.entries.toList()) {
        final key = entry.key;
        final localName = key is dom.AttributeName ? key.name : key.toString();
        if (localName != 'href') continue;
        if (!entry.value.contains('://')) {
          image.attributes[key] = _entryUrl(docDir, entry.value);
        }
      }
    }
  }

  static Iterable<dom.Element> _descendantsByLocalName(
      dom.Element root, String localName) sync* {
    for (final child in root.children) {
      if (child.localName == localName) yield child;
      yield* _descendantsByLocalName(child, localName);
    }
  }

  static String _entryUrl(String docDir, String href) =>
      '$epubResourceScheme:///${EpubPackage.resolveHref(docDir, href)}';

  /// The zip entry path of an `epub:///` URL, or null for other schemes.
  static String? entryPathFromUrl(String url) {
    const prefix = '$epubResourceScheme:///';
    return url.startsWith(prefix) ? url.substring(prefix.length) : null;
  }
}
