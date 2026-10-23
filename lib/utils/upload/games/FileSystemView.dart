import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// One directory entry as the scanner sees it.
class FsEntry {
  const FsEntry({required this.name, required this.path, required this.isDirectory});
  final String name;
  final String path;
  final bool isDirectory;
}

/// The little the game scanner needs from a file system, so the scan logic
/// is pure and a test can feed it an in-memory tree. Paths are `/`-joined
/// (dart:io accepts that on Windows too).
abstract class FileSystemView {
  Future<List<FsEntry>> list(String directory);
  Future<bool> exists(String path);
  Future<bool> isDirectory(String path);
  Future<int> length(String path);
  Future<Uint8List> readBytes(String path);
  Future<String> readString(String path);

  String join(String directory, String name) => directory.endsWith('/') ? '$directory$name' : '$directory/$name';

  static String baseName(String path) {
    final trimmed = path.replaceAll(r'\', '/').replaceAll(RegExp(r'/+$'), '');
    return trimmed.substring(trimmed.lastIndexOf('/') + 1);
  }
}

/// The real disk. Symlinks are not followed: a link into the install root
/// (or a loop) must not drag its target into a scan.
class IoFileSystemView extends FileSystemView {
  @override
  Future<List<FsEntry>> list(String directory) async {
    final entries = <FsEntry>[];
    try {
      await for (final entity in Directory(directory).list(followLinks: false)) {
        final name = FileSystemView.baseName(entity.path);
        if (entity is Directory) {
          entries.add(FsEntry(name: name, path: entity.path, isDirectory: true));
        } else if (entity is File) {
          entries.add(FsEntry(name: name, path: entity.path, isDirectory: false));
        }
      }
    } on FileSystemException {
      // Unreadable or vanished: nothing to offer from here.
    }
    entries.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return entries;
  }

  @override
  Future<bool> exists(String path) async => await File(path).exists() || await Directory(path).exists();

  @override
  Future<bool> isDirectory(String path) => Directory(path).exists();

  @override
  Future<int> length(String path) => File(path).length();

  @override
  Future<Uint8List> readBytes(String path) => File(path).readAsBytes();

  @override
  Future<String> readString(String path) => File(path).readAsString();
}

/// An in-memory tree for tests: `files` maps absolute `/`-paths to contents;
/// directories exist implicitly (or explicitly, empty, through [directories]).
class MemoryFileSystemView extends FileSystemView {
  MemoryFileSystemView(Map<String, List<int>> files, {Set<String> directories = const {}})
      : _files = {for (final e in files.entries) _norm(e.key): Uint8List.fromList(e.value)},
        _directories = {for (final d in directories) _norm(d)};

  final Map<String, Uint8List> _files;
  final Set<String> _directories;

  static String _norm(String path) => path.replaceAll(RegExp(r'/+$'), '');

  @override
  Future<List<FsEntry>> list(String directory) async {
    final base = '${_norm(directory)}/';
    final names = <String, bool>{};
    for (final path in [..._files.keys, ..._directories]) {
      if (!path.startsWith(base)) continue;
      final rest = path.substring(base.length);
      final slash = rest.indexOf('/');
      if (slash < 0) {
        names[rest] = _directories.contains(path);
      } else {
        names[rest.substring(0, slash)] = true;
      }
    }
    final entries = [for (final e in names.entries) FsEntry(name: e.key, path: '$base${e.key}', isDirectory: e.value)];
    entries.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return entries;
  }

  @override
  Future<bool> exists(String path) async => _files.containsKey(_norm(path)) || await isDirectory(path);

  @override
  Future<bool> isDirectory(String path) async {
    final p = _norm(path);
    return _directories.contains(p) || [..._files.keys, ..._directories].any((f) => f.startsWith('$p/'));
  }

  @override
  Future<int> length(String path) async => lengthSync(path);

  int lengthSync(String path) => _files[_norm(path)]?.length ?? (throw FileSystemException('missing', path));

  @override
  Future<Uint8List> readBytes(String path) async =>
      _files[_norm(path)] ?? (throw FileSystemException('missing', path));

  @override
  Future<String> readString(String path) async => utf8.decode(await readBytes(path), allowMalformed: true);
}
