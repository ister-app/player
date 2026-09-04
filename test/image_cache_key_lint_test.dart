import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Network artwork goes through `ArtworkImage`, which is what keeps two
/// invariants from drifting:
///
/// * the cache key is the url without the stream token — tokens are minted per
///   app start and rotate within one, so a token-keyed entry is a fresh
///   download every time;
/// * the decode is capped to the painted size, with the right knob per
///   platform (`memCacheWidth` on native, `maxWidthDiskCache` under the web
///   HttpGet loader — see the widget's doc comment for why they are not
///   interchangeable).
///
/// Neither is visible at a call site, which is exactly why this test exists.
void main() {
  /// Files allowed to build their own image providers, with the reason.
  const allowed = <String, String>{
    'lib/components/ArtworkImage.dart': 'the wrapper itself',
    'lib/utils/comic/ComicPageSource.dart':
        'comic pages carry their own width parameter and page cache key',
    'lib/components/AddPodcastSheet.dart':
        'third-party podcast art: no server width, no shared cache manager',
  };

  List<File> dartFiles() => Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('every CachedNetworkImage(Provider) passes a cacheKey', () {
    final offenders = <String>[];
    final pattern = RegExp(r'\bCachedNetworkImage(Provider)?\(');

    for (final file in dartFiles()) {
      final source = file.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        final args = _argumentList(source, match.end - 1);
        if (!args.contains('cacheKey:')) {
          offenders.add('${file.path}:${_lineOf(source, match.start)}');
        }
      }
    }

    expect(offenders, isEmpty,
        reason: 'Pass cacheKey: ImageUtil.cacheKeyFor(<the url>) at: '
            '${offenders.join(', ')}');
  });

  test('artwork is built through ArtworkImage, not by hand', () {
    final offenders = <String>[];
    final pattern = RegExp(
        r'\b(CachedNetworkImage|CachedNetworkImageProvider|NetworkImage|Image\.network)\(');

    for (final file in dartFiles()) {
      if (allowed.containsKey(file.path)) continue;
      final source = file.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        offenders.add('${file.path}:${_lineOf(source, match.start)}');
      }
    }

    expect(offenders, isEmpty,
        reason: 'Use ArtworkImage (or ArtworkImage.providerFor) so the decode '
            'is capped to the painted size on every platform. Offenders: '
            '${offenders.join(', ')}');
  });
}

int _lineOf(String source, int offset) =>
    '\n'.allMatches(source.substring(0, offset)).length + 1;

/// The balanced argument list of the call whose `(` sits at [open].
String _argumentList(String source, int open) {
  var depth = 0;
  for (var i = open; i < source.length; i++) {
    final c = source[i];
    if (c == '(' || c == '[' || c == '{') {
      depth++;
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
      if (depth == 0) return source.substring(open + 1, i);
    }
  }
  fail('unbalanced argument list at offset $open');
}
