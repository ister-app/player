import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/download/DownloadHttp.dart';
import 'package:player/utils/download/SafePath.dart';

void main() {
  test('plain relative names are safe', () {
    for (final path in [
      'seg_0001.ts',
      'audio/seg 1.aac',
      'OEBPS/Text/chapter one.xhtml',
      'a..b/c',
      '.hidden',
      r'saves\slot1.sav',
    ]) {
      expect(isSafeRelativePath(path), isTrue, reason: path);
    }
  });

  test('names that leave the directory are not', () {
    for (final path in [
      '',
      '..',
      '../x',
      'a/../../x',
      r'..\..\x',
      r'a\..\..\x',
      '/etc/passwd',
      r'\\nas\share\x',
      r'C:\Windows\x',
      'c:/x',
    ]) {
      expect(isSafeRelativePath(path), isFalse, reason: path);
    }
  });

  test('safeFile joins a safe name and refuses the rest', () {
    final dir = Directory('/data/downloads/mf');
    expect(safeFile(dir, 'audio/seg.ts').path, '/data/downloads/mf/audio/seg.ts');
    expect(() => safeFile(dir, '../other/master.m3u8'),
        throwsA(isA<DownloadFailure>().having((e) => e.transient, 'transient', isFalse)));
  });
}
