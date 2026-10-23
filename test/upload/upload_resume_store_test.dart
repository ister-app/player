import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/upload/UploadResumeStore.dart';
import 'package:player/utils/upload/games/GameUploadCandidate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() => SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty());

  test('reads the first shape (session only) as needing a new pick', () async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString('upload_session_srv', jsonEncode({'sessionId': 's1', 'nodeUrl': 'http://n', 's3': true}));
    final stored = await UploadResumeStore('srv', prefs: prefs).load();
    expect(stored!.sessionId, 's1');
    expect(stored.s3, isTrue);
    expect(stored.sourcePath, isNull);
    expect(stored.batch, isNull);
  });

  test('a batch round-trips with its current game, queue and done titles', () async {
    final store = UploadResumeStore('srv');
    const rom = GameUploadCandidate(
      platform: Enum$GamePlatform.SNES,
      platformFolder: 'snes',
      title: 'Game',
      year: '1999',
      kind: GameCandidateKind.romFile,
      sourcePath: '/roms/snes/Game.sfc',
      files: [(relativePath: 'Game.sfc', absolutePath: '/roms/snes/Game.sfc', size: 3)],
    );
    const tree = GameUploadCandidate(
      platform: Enum$GamePlatform.PS3,
      platformFolder: 'ps3',
      title: 'Souls',
      kind: GameCandidateKind.tree,
      sourcePath: '/dumps/Souls',
      titleId: 'BLUS30443',
    );
    await store.save(const StoredUpload(
      sessionId: 's2',
      nodeUrl: 'http://n',
      s3: false,
      batch: StoredBatch(directoryId: 'd1', libraryId: 'l1', overwrite: true, current: rom, queue: [tree], done: ['Earlier']),
    ));
    final back = (await store.load())!;
    expect(back.sessionId, 's2');
    final batch = back.batch!;
    expect(batch.overwrite, isTrue);
    expect(batch.current!.id, rom.id);
    expect(batch.current!.files!.single.size, 3);
    expect(batch.queue.single.titleId, 'BLUS30443');
    expect(batch.queue.single.files, isNull);
    expect(batch.done, ['Earlier']);

    await store.clear();
    expect(await store.load(), isNull);
  });

  test('garbage is dropped rather than thrown', () async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString('upload_session_srv', '{"nope": 1}');
    expect(await UploadResumeStore('srv', prefs: prefs).load(), isNull);
    expect(await prefs.getString('upload_session_srv'), isNull);
  });
}
