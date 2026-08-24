import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:player/utils/AppLogStore.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('applog');
  });

  tearDown(() async {
    await root.delete(recursive: true);
  });

  Logger loggerFor(AppLogStore store) => Logger(
        filter: ProductionFilter(),
        printer: SimplePrinter(colors: false),
        output: store.output,
      );

  test('buffers before install and flushes with a session header', () async {
    final store = AppLogStore(rootOverride: root);
    final logger = loggerFor(store);
    logger.i('before install');
    expect(File('${root.path}/ister.log').existsSync(), isFalse);

    await store.install();
    logger.i('after install');

    final content = File('${root.path}/ister.log').readAsStringSync();
    expect(content, contains('==== Ister Player session'));
    expect(content, contains('before install'));
    expect(content, contains('after install'));
    expect(content.indexOf('session'), lessThan(content.indexOf('before')));
  });

  test('rotates one old generation past the size cap', () async {
    final store = AppLogStore(rootOverride: root, maxFileBytes: 500);
    final logger = loggerFor(store);
    await store.install();
    for (var i = 0; i < 30; i++) {
      logger.i('line $i ${'x' * 40}');
    }

    final old = File('${root.path}/ister.log.1');
    final current = File('${root.path}/ister.log');
    expect(old.existsSync(), isTrue);
    expect(current.existsSync(), isTrue);
    // The current file restarted after the last rotation, so it stays within
    // one event of the cap.
    expect(current.lengthSync(), lessThan(700));
    // Nothing was lost across the newest two generations.
    final combined = old.readAsStringSync() + current.readAsStringSync();
    expect(combined, contains('line 29'));
  });

  test('exportBytes concatenates generations and keeps the tail', () async {
    final store = AppLogStore(
        rootOverride: root, maxFileBytes: 500, maxExportBytes: 600);
    final logger = loggerFor(store);
    await store.install();
    for (var i = 0; i < 30; i++) {
      logger.i('line $i ${'x' * 40}');
    }

    final bytes = await store.exportBytes();
    expect(bytes, isNotNull);
    expect(bytes!.length, lessThanOrEqualTo(600));
    final text = utf8.decode(bytes, allowMalformed: true);
    expect(text, contains('line 29'));
  });

  test('without install the buffer stays bounded and exportable', () async {
    final store = AppLogStore(rootOverride: root);
    final logger = loggerFor(store);
    for (var i = 0; i < 250; i++) {
      logger.i('buffered $i');
    }

    final bytes = await store.exportBytes();
    final text = utf8.decode(bytes!);
    expect(text, isNot(contains('buffered 0\n')));
    expect(text, contains('buffered 249'));
    expect(File('${root.path}/ister.log').existsSync(), isFalse);
  });

  test('exportBytes is null when nothing was logged', () async {
    final store = AppLogStore(rootOverride: root);
    expect(await store.exportBytes(), isNull);
  });
}
