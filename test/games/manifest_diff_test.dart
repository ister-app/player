import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/GameApi.dart';
import 'package:player/utils/games/ManifestDiff.dart';

GameManifest manifest(List<GameManifestFile> files, {String? version}) => GameManifest(
      gameId: 'g',
      platform: 'PC',
      form: 'PC_PORTABLE_ZIP',
      entryPath: null,
      titleId: null,
      steamAppId: null,
      steamInstallDir: null,
      totalBytes: files.fold(0, (a, f) => a + f.size),
      files: files,
      etag: null,
      version: version,
    );

void main() {
  test('new, changed and removed files are told apart', () {
    final old = manifest([
      const GameManifestFile(path: 'same.bin', size: 10, entry: false, lastModified: 't1'),
      const GameManifestFile(path: 'grown.bin', size: 10, entry: false, lastModified: 't1'),
      const GameManifestFile(path: 'touched.bin', size: 10, entry: false, lastModified: 't1'),
      const GameManifestFile(path: 'gone.bin', size: 10, entry: false, lastModified: 't1'),
    ]);
    final current = manifest([
      const GameManifestFile(path: 'same.bin', size: 10, entry: false, lastModified: 't1'),
      const GameManifestFile(path: 'grown.bin', size: 20, entry: false, lastModified: 't1'),
      const GameManifestFile(path: 'touched.bin', size: 10, entry: false, lastModified: 't2'),
      const GameManifestFile(path: 'new.zip', size: 5, entry: true, lastModified: 't2'),
    ]);
    final diff = ManifestDiff.between(old, current);
    expect(diff.fetch.map((f) => f.path), ['grown.bin', 'touched.bin', 'new.zip']);
    expect(diff.delete.map((f) => f.path), ['gone.bin']);
    expect(diff.unchanged.map((f) => f.path), ['same.bin']);
    expect(diff.bytesToFetch, 35);
    expect(diff.entryChanged, isTrue);
    expect(diff.isEmpty, isFalse);
  });

  test('without an old manifest everything is fetched', () {
    final current = manifest([const GameManifestFile(path: 'a', size: 1, entry: false)]);
    final diff = ManifestDiff.between(null, current);
    expect(diff.fetch.length, 1);
    expect(diff.delete, isEmpty);
  });

  test('identical manifests are an empty diff', () {
    final files = [const GameManifestFile(path: 'a', size: 1, entry: true, lastModified: 't')];
    final diff = ManifestDiff.between(manifest(files), manifest(files));
    expect(diff.isEmpty, isTrue);
    expect(diff.entryChanged, isFalse);
  });

  test('the manifest survives a JSON round trip for the diff', () {
    final files = [const GameManifestFile(path: 'a/b.bin', size: 7, entry: true, lastModified: 't')];
    final restored = GameManifest.fromJson(manifest(files, version: 'v1').toJson());
    expect(restored.version, 'v1');
    expect(ManifestDiff.between(restored, manifest(files)).isEmpty, isTrue);
  });
}
