import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/upload/upload_source_io.dart';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('upload-source');
    final show = Directory('${root.path}/The Show (2019)');
    await File('${show.path}/Season 01/e01.mkv').create(recursive: true).then((f) => f.writeAsBytes(List.generate(100, (i) => i)));
    await File('${show.path}/poster.jpg').create(recursive: true).then((f) => f.writeAsString('jpg'));
    await File('${show.path}/.DS_Store').create().then((f) => f.writeAsString('x'));
    await File('${show.path}/.hidden/secret.mkv').create(recursive: true);
  });

  tearDown(() => root.delete(recursive: true));

  test('lists a folder relative to itself, without hidden files, and reads ranges', () async {
    final folder = await folderFromDirectory(Directory('${root.path}/The Show (2019)'));

    expect(folder.name, 'The Show (2019)');
    expect(folder.files.map((f) => f.relativePath), ['Season 01/e01.mkv', 'poster.jpg']);
    expect(folder.totalBytes, 103);

    final episode = folder.files.first;
    final range = await episode.openRead(10, 15).expand((b) => b).toList();
    expect(range, [10, 11, 12, 13, 14]);
  });

  test('a trailing separator on the picked path does not change the folder name', () async {
    final folder = await folderFromDirectory(Directory('${root.path}/The Show (2019)/'));
    expect(folder.name, 'The Show (2019)');
    expect(folder.files, hasLength(2));
  });
}
