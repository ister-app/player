import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'UploadSource.dart';
import 'upload_source_native.dart';

/// Every non-web platform: desktop reads the picked folder with `dart:io`,
/// Android and iOS go through the native bridge (see upload_source_native.dart).
bool get supported =>
    Platform.isLinux || Platform.isWindows || Platform.isMacOS || Platform.isAndroid || Platform.isIOS;

Future<UploadSourceFolder?> pickFolder() async {
  if (Platform.isAndroid || Platform.isIOS) return pickNativeFolder();
  final path = await FilePicker.getDirectoryPath();
  if (path == null) return null;
  return folderFromDirectory(Directory(path));
}

/// Split out so tests can point it at a temp directory.
Future<UploadSourceFolder> folderFromDirectory(Directory root) async {
  final rootPath = root.absolute.path;
  final prefix = rootPath.endsWith(Platform.pathSeparator) ? rootPath : '$rootPath${Platform.pathSeparator}';
  final files = <UploadSourceFile>[];
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    final absolute = entity.absolute.path;
    if (!absolute.startsWith(prefix)) continue;
    final relative = absolute.substring(prefix.length).replaceAll(Platform.pathSeparator, '/');
    if (!isUploadableRelativePath(relative)) continue;
    files.add(_IoFile(entity, relative, await entity.length()));
  }
  files.sort((a, b) => a.relativePath.compareTo(b.relativePath));
  final trimmed = rootPath.endsWith(Platform.pathSeparator) ? rootPath.substring(0, rootPath.length - 1) : rootPath;
  return UploadSourceFolder(name: trimmed.substring(trimmed.lastIndexOf(Platform.pathSeparator) + 1), files: files);
}

class _IoFile implements UploadSourceFile {
  _IoFile(this._file, this.relativePath, this.size);
  final File _file;
  @override
  final String relativePath;
  @override
  final int size;

  @override
  Stream<List<int>> openRead(int start, int end) => _file.openRead(start, end);
}
