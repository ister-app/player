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

/// One file of a tree, as plain data: what [materialiseDirectory] returns so
/// a listing can run in another isolate and come back without `File` objects.
typedef MaterialisedFile = ({String relativePath, String absolutePath, int size});

/// Desktop only: a mobile pick was a content URI, not a path.
Future<UploadSourceFolder?> reopenFolder(String path) async {
  if (Platform.isAndroid || Platform.isIOS) return null;
  final dir = Directory(path);
  if (!await dir.exists()) return null;
  return folderFromDirectory(dir);
}

/// Split out so tests can point it at a temp directory.
Future<UploadSourceFolder> folderFromDirectory(Directory root) async {
  final rootPath = root.absolute.path;
  final trimmed = rootPath.endsWith(Platform.pathSeparator) ? rootPath.substring(0, rootPath.length - 1) : rootPath;
  return folderFromFiles(trimmed.substring(trimmed.lastIndexOf(Platform.pathSeparator) + 1), await materialiseDirectory(root),
      path: trimmed);
}

/// Lists every uploadable file under [root], relative to it (`/`-separated),
/// with [prefix] (e.g. `installdir/`) put in front of each relative path.
/// Sorted by relative path. Pure `dart:io`, safe inside `Isolate.run`.
Future<List<MaterialisedFile>> materialiseDirectory(Directory root, {String prefix = ''}) async {
  final rootPath = root.absolute.path;
  final base = rootPath.endsWith(Platform.pathSeparator) ? rootPath : '$rootPath${Platform.pathSeparator}';
  final files = <MaterialisedFile>[];
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    final absolute = entity.absolute.path;
    if (!absolute.startsWith(base)) continue;
    final relative = absolute.substring(base.length).replaceAll(Platform.pathSeparator, '/');
    if (!isUploadableRelativePath(relative)) continue;
    files.add((relativePath: '$prefix$relative', absolutePath: absolute, size: await entity.length()));
  }
  files.sort((a, b) => a.relativePath.compareTo(b.relativePath));
  return files;
}

/// A folder built from an explicit file list — a scanned game whose files
/// are not one directory (a loose ROM with its companions, a Steam manifest
/// next to its install tree).
UploadSourceFolder folderFromFiles(String name, List<MaterialisedFile> files, {String? path}) => UploadSourceFolder(
      name: name,
      path: path,
      files: [for (final f in files) IoUploadFile(File(f.absolutePath), f.relativePath, f.size)],
    );

/// A file on this machine's disk, read a range at a time.
class IoUploadFile implements UploadSourceFile {
  IoUploadFile(this._file, this.relativePath, this.size);
  final File _file;
  @override
  final String relativePath;
  @override
  final int size;

  @override
  Stream<List<int>> openRead(int start, int end) => _file.openRead(start, end);
}
