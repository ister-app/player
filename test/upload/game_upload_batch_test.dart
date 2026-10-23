import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/upload/GameFoundProbe.dart';
import 'package:player/utils/upload/UploadApi.dart';
import 'package:player/utils/upload/UploadModels.dart';
import 'package:player/utils/upload/UploadResumeStore.dart';
import 'package:player/utils/upload/games/GameLibraryIndex.dart';
import 'package:player/utils/upload/games/GameSourceMaterialiser.dart';
import 'package:player/utils/upload/games/GameUploadBatch.dart';
import 'package:player/utils/upload/games/GameUploadCandidate.dart';
import 'package:player/utils/upload/UploadRunner.dart';
import 'package:player/utils/upload/UploadSource.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// A fake node: every session gets one file; what the session answers is
/// scripted per root name.
class FakeNode {
  final calls = <String>[];
  final Map<String, int> statusByRoot = {};
  final Map<String, String> rootOfSession = {};

  /// Roots whose first file never completes (the node answers 500).
  final Set<String> failCompleteFor = {'Souls'};
  int sessions = 0;
  int busyLeft = 0;

  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path;
    calls.add('${request.method} $path');
    String json(Object body) => jsonEncode(body);
    if (path == '/library-upload/sessions') {
      final plan = (jsonDecode(request.body) as Map).cast<String, dynamic>();
      final root = plan['rootName'] as String;
      if (busyLeft > 0) {
        busyLeft--;
        return http.Response(json({'detail': 'too many uploads'}), 429, headers: {'retry-after': '1'});
      }
      final status = statusByRoot[root] ?? 200;
      if (status == 400) return http.Response(json({'detail': 'Nothing to upload: every file exists'}), 400);
      if (status != 200) return http.Response(json({'detail': 'boom'}), status);
      final id = 's${++sessions}';
      rootOfSession[id] = root;
      final entries = plan['entries'] as List;
      return http.Response(
          json({
            'sessionId': id,
            'status': 'ACTIVE',
            'files': [
              for (final (i, e) in entries.indexed)
                {'fileId': 'f$i', 'relativePath': e['relativePath'], 'targetPath': 'x', 'size': e['size'], 'chunkSize': 16, 'receivedBytes': 0, 'status': 'PENDING'}
            ],
            'skipped': [],
          }),
          200);
    }
    if (path.endsWith('/chunk')) {
      return http.Response(json({'fileId': 'f', 'receivedBytes': request.bodyBytes.length, 'status': 'UPLOADING'}), 200);
    }
    if (path.endsWith('/complete')) {
      final session = path.split('/')[path.split('/').indexOf('sessions') + 1];
      if (path.contains('/f0/') && failCompleteFor.contains(rootOfSession[session])) {
        return http.Response(json({'detail': 'disk full'}), 500);
      }
      return http.Response(json({'fileId': 'f', 'receivedBytes': 3, 'status': 'COMPLETED'}), 200);
    }
    if (path.endsWith('/abort')) return http.Response('', 204);
    return http.Response('nope', 404);
  }
}

GameUploadCandidate rom(String title, {String? year}) => GameUploadCandidate(
      platform: Enum$GamePlatform.SNES,
      platformFolder: 'snes',
      title: title,
      year: year,
      kind: GameCandidateKind.romFile,
      sourcePath: '/roms/snes/$title.sfc',
      files: [(relativePath: '$title.sfc', absolutePath: '/roms/snes/$title.sfc', size: 3)],
    );

const ps3 = GameUploadCandidate(
  platform: Enum$GamePlatform.PS3,
  platformFolder: 'ps3',
  title: 'Souls',
  kind: GameCandidateKind.tree,
  sourcePath: '/dumps/Souls',
);

final directory = UploadDirectory(
  id: 'd1', name: 'games', libraryId: 'l1', libraryName: 'Games', libraryType: 'GAME', storageKind: 'LOCAL',
  path: '/media/games', nodeName: 'n', nodeUrl: 'http://node', freeBytes: null, writable: true,
);

void main() {
  late FakeNode node;
  late UploadResumeStore store;
  late int indexLoads;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    node = FakeNode();
    store = UploadResumeStore('srv');
    indexLoads = 0;
  });

  GameUploadBatch batch(List<GameUploadCandidate> candidates, {bool withIndex = true}) => GameUploadBatch(
        api: UploadApi('srv', httpClient: MockClient(node.handle), bearer: (_) async => 'Bearer t'),
        directory: directory,
        candidates: candidates,
        overwrite: false,
        store: store,
        materialiser: GameSourceMaterialiser(
            listTree: (dir, prefix) async => [(relativePath: '${prefix}PS3_GAME/PARAM.SFO', absolutePath: '$dir/PS3_GAME/PARAM.SFO', size: 3)]),
        runnerFactory: fakeRunner,
        indexLoader: withIndex
            ? (libraryId) async {
                indexLoads++;
                return GameLibraryIndex({
                  if (indexLoads >= 2)
                    GameLibraryIndex.key(Enum$GamePlatform.SNES, 'Alpha'): const FoundGame(
                        id: 'g1', title: 'Alpha', platform: Enum$GamePlatform.SNES, form: Enum$GameForm.ROM, savePathSource: 'NONE'),
                });
              }
            : null,
        sleep: (_) async {},
        probeInterval: const Duration(milliseconds: 1),
        probePatience: const Duration(milliseconds: 10),
      );

  test('uploads the games one after the other, skips what the server has, keeps going past a failure', () async {
    node.statusByRoot['Beta'] = 400;
    final b = batch([rom('Alpha'), rom('Beta'), ps3, rom('Gamma', year: '2001')]);
    final phases = <String>[];
    b.addListener(() => phases.add(b.items.map((i) => i.phase.name[0]).join()));
    await b.start();
    expect(b.items.map((i) => i.phase), [GameUploadPhase.done, GameUploadPhase.skipped, GameUploadPhase.failed, GameUploadPhase.done]);
    expect(b.items[1].message, contains('Nothing to upload'));
    expect(b.items[2].runner!.failedCount, 1, reason: 'the complete of its file returned 500');
    expect(b.doneCount, 2);
    expect(b.skippedCount, 1);
    expect(b.failedCount, 1);
    expect(node.calls.where((c) => c == 'POST /library-upload/sessions').length, 4);
    expect(phases, contains('pqqq'), reason: 'strictly sequential');
    expect(phases.any((p) => p.startsWith('d') && p[1] == 'p'), isTrue, reason: 'Beta starts only after Alpha is done');
    expect(await store.load(), isNull, reason: 'forgotten once every game is terminal');
    // The end-of-batch sweep: the library listed Alpha on the second look.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(indexLoads, greaterThanOrEqualTo(2));
    expect(b.items[0].found!.id, 'g1');
    expect(b.items[3].found, isNull);
  });

  test('a busy server (429) is waited out', () async {
    node.busyLeft = 2;
    final b = batch([rom('Alpha')], withIndex: false);
    await b.start();
    expect(b.items.single.phase, GameUploadPhase.done);
    expect(node.calls.where((c) => c == 'POST /library-upload/sessions').length, 3);
  });

  test('the store holds the session in flight and the queue', () async {
    StoredUpload? seen;
    final b = batch([rom('Alpha'), rom('Beta'), ps3], withIndex: false);
    b.addListener(() async {
      if (b.current?.candidate.title == 'Alpha' && b.current?.phase == GameUploadPhase.uploading) seen ??= await store.load();
    });
    await b.start();
    expect(seen, isNotNull);
    expect(seen!.sessionId, 's1');
    expect(seen!.batch!.current!.title, 'Alpha');
    expect(seen!.batch!.queue.map((c) => c.title), ['Beta', 'Souls']);
    expect(seen!.batch!.libraryId, 'l1');
  });

  test('cancel aborts the game in flight and drops the rest', () async {
    final b = batch([rom('Alpha'), rom('Beta')], withIndex: false);
    Future<void>? cancelled;
    b.addListener(() {
      if (b.current?.phase == GameUploadPhase.uploading && !b.isCancelled) cancelled = b.cancel();
    });
    await b.start();
    await cancelled;
    expect(b.items.map((i) => i.phase), [GameUploadPhase.cancelled, GameUploadPhase.cancelled]);
    expect(node.calls, contains('POST /library-upload/sessions/s1/abort'));
    expect(await store.load(), isNull);
  });

  test('resumes a stored session for the first game without creating a new one', () async {
    final b = batch([rom('Alpha'), rom('Beta')], withIndex: false);
    b.resumeWith(UploadSession.fromJson({
      'sessionId': 'old',
      'status': 'ACTIVE',
      'files': [
        {'fileId': 'f0', 'relativePath': 'Alpha.sfc', 'size': 3, 'chunkSize': 16, 'receivedBytes': 0, 'status': 'PENDING'}
      ],
      'skipped': [],
    }));
    await b.start();
    expect(b.items.map((i) => i.phase), [GameUploadPhase.done, GameUploadPhase.done]);
    expect(node.calls.where((c) => c == 'POST /library-upload/sessions').length, 1, reason: 'only Beta needed a session');
    expect(node.calls, contains('POST /library-upload/sessions/old/files/f0/complete'));
  });

  test('retry failed runs the failed game again', () async {
    final b = batch([rom('Alpha'), ps3], withIndex: false);
    await b.start();
    expect(b.failedCount, 1);
    b.retryFailed();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    // The fake node fails the Souls file forever; the retry at least went through the runner again.
    expect(node.calls.where((c) => c.contains('/s2/files/f0/complete')).length, greaterThanOrEqualTo(2));
  });
}

/// A runner over sources that read nothing from disk: every byte is a one,
/// and retries wait for nothing.
UploadRunner fakeRunner({
  required UploadApi api,
  required String nodeUrl,
  required UploadSession session,
  required Map<String, UploadSourceFile> sources,
  required bool partsAddressedByNumber,
}) =>
    UploadRunner(
      api: api,
      nodeUrl: nodeUrl,
      session: session,
      sources: {for (final f in session.files) f.relativePath: _MemFile(f.relativePath, f.size)},
      partsAddressedByNumber: partsAddressedByNumber,
      maxAttempts: 2,
      backoff: (_) => Duration.zero,
      sleep: (_) async {},
    );

class _MemFile implements UploadSourceFile {
  _MemFile(this.relativePath, this.size);
  @override
  final String relativePath;
  @override
  final int size;
  @override
  Stream<List<int>> openRead(int start, int end) => Stream.value(List.filled(end - start, 1));
}
