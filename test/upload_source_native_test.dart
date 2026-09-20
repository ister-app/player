import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/upload_source_native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final reads = <(int, int)>[];
  Map<String, dynamic>? picked;

  setUp(() {
    reads.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(uploadSourceChannel, (call) async {
      switch (call.method) {
        case 'pickFolder':
          return picked;
        case 'read':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final offset = args['offset'] as int;
          final length = args['length'] as int;
          reads.add((offset, length));
          // a 2.5 MiB file whose bytes are their own offset
          const size = 5 * (1 << 19);
          final end = offset + length > size ? size : offset + length;
          return Uint8List.fromList([for (var i = offset; i < end; i++) i % 251]);
      }
      return null;
    });
  });

  tearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(uploadSourceChannel, null));

  test('a cancelled picker is null', () async {
    picked = null;
    expect(await pickNativeFolder(), isNull);
  });

  test('lists the picked tree, sorted, without hidden files', () async {
    picked = {
      'name': 'The Show (2019)',
      'files': [
        {'id': 'content://tree/2', 'relativePath': 'poster.jpg', 'size': 7},
        {'id': 'content://tree/1', 'relativePath': 'Season 01/e01.mkv', 'size': 5 * (1 << 19)},
        {'id': 'content://tree/3', 'relativePath': '.nomedia', 'size': 0},
      ],
    };
    final folder = (await pickNativeFolder())!;
    expect(folder.name, 'The Show (2019)');
    expect(folder.files.map((f) => f.relativePath), ['Season 01/e01.mkv', 'poster.jpg']);
  });

  test('reads a range in bounded pieces and stops at the end of the range', () async {
    picked = {
      'name': 'x',
      'files': [
        {'id': 'content://tree/1', 'relativePath': 'e01.mkv', 'size': 5 * (1 << 19)}
      ],
    };
    final file = (await pickNativeFolder())!.files.single;

    final bytes = await file.openRead(100, 100 + nativeReadSize + 10).expand((b) => b).toList();

    expect(reads, [(100, nativeReadSize), (100 + nativeReadSize, 10)]);
    expect(bytes.length, nativeReadSize + 10);
    expect(bytes.first, 100 % 251);
    expect(bytes.last, (100 + nativeReadSize + 9) % 251);
  });

  test('a file that ends early ends the stream instead of looping', () async {
    picked = {
      'name': 'x',
      'files': [
        {'id': 'content://tree/1', 'relativePath': 'e01.mkv', 'size': 9999999}
      ],
    };
    final file = (await pickNativeFolder())!.files.single;
    const realSize = 5 * (1 << 19);

    final bytes = await file.openRead(realSize - 5, realSize + 50).expand((b) => b).toList();

    expect(bytes.length, 5);
    expect(reads.length, 2, reason: 'the short read, then the empty one that ends it');
  });
}
