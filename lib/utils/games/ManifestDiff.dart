import 'GameApi.dart';

/// What an update has to do: the files to fetch (new, or changed in size or
/// modification time), the files to delete (gone from the server), and
/// whether an archive that gets unpacked is among the changed ones.
class ManifestDiff {
  const ManifestDiff({required this.fetch, required this.delete, required this.unchanged});

  final List<GameManifestFile> fetch;
  final List<GameManifestFile> delete;
  final List<GameManifestFile> unchanged;

  int get bytesToFetch => fetch.fold(0, (a, f) => a + f.size);
  bool get isEmpty => fetch.isEmpty && delete.isEmpty;
  bool get entryChanged => fetch.any((f) => f.entry);

  /// Compares the manifest the files were installed from with the server's
  /// current one. Without an old manifest every file is fetched (the size
  /// check on disk still skips what is already there).
  static ManifestDiff between(GameManifest? old, GameManifest current) {
    final before = {for (final f in old?.files ?? const <GameManifestFile>[]) f.path: f};
    final fetch = <GameManifestFile>[];
    final unchanged = <GameManifestFile>[];
    for (final file in current.files) {
      final was = before.remove(file.path);
      if (was != null && was.size == file.size && was.lastModified == file.lastModified) {
        unchanged.add(file);
      } else {
        fetch.add(file);
      }
    }
    return ManifestDiff(fetch: fetch, delete: before.values.toList(), unchanged: unchanged);
  }
}
