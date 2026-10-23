import 'dart:io';
import 'dart:isolate';

import '../UploadSource.dart';
import '../upload_source_io.dart';
import 'FileSystemView.dart';
import 'GameUploadCandidate.dart';

/// The file list a candidate uploads. ROM candidates carry theirs from the
/// scan; a PS3 dump or a Steam tree is listed here, off the UI isolate,
/// only when the game is ticked or about to go up.
class GameSourceMaterialiser {
  GameSourceMaterialiser({Future<List<MaterialisedFile>> Function(String directory, String prefix)? listTree})
      : _listTree = listTree ?? _inIsolate;

  final Future<List<MaterialisedFile>> Function(String directory, String prefix) _listTree;

  static Future<List<MaterialisedFile>> _inIsolate(String directory, String prefix) =>
      Isolate.run(() => materialiseDirectory(Directory(directory), prefix: prefix));

  Future<List<MaterialisedFile>> files(GameUploadCandidate candidate) async {
    switch (candidate.kind) {
      case GameCandidateKind.romFolder:
      case GameCandidateKind.romFile:
        return candidate.files ?? const [];
      case GameCandidateKind.tree:
        return _listTree(candidate.sourcePath, '');
      case GameCandidateKind.steam:
        final manifest = candidate.steamManifestPath!;
        final installDir = candidate.steamInstallDir!;
        final tree = await _listTree(installDir, '${FileSystemView.baseName(installDir)}/');
        return [
          (
            relativePath: FileSystemView.baseName(manifest),
            absolutePath: manifest,
            size: await File(manifest).length(),
          ),
          ...tree,
        ];
    }
  }

  Future<UploadSourceFolder> folder(GameUploadCandidate candidate) async =>
      folderFromFiles(candidate.rootName, await files(candidate));
}
