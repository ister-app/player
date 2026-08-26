import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every network image in the app must be keyed on a url without the stream
/// token: tokens are minted per app start and rotate within one, so a
/// token-keyed entry is a fresh download every time. `ImageUtil.cacheKeyFor`
/// derives the key; this test is what stops the next call site from forgetting
/// it, since there is no wrapper widget to funnel them through (the call sites
/// differ too much in fade and sizing to share one).
void main() {
  test('every CachedNetworkImage(Provider) passes a cacheKey', () {
    final offenders = <String>[];
    final pattern = RegExp(r'\bCachedNetworkImage(Provider)?\(');

    for (final file in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        final args = _argumentList(source, match.end - 1);
        if (!args.contains('cacheKey:')) {
          final line = '\n'.allMatches(source.substring(0, match.start)).length + 1;
          offenders.add('${file.path}:$line');
        }
      }
    }

    expect(offenders, isEmpty,
        reason: 'Pass cacheKey: ImageUtil.cacheKeyFor(<the url>) at: '
            '${offenders.join(', ')}');
  });
}

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
