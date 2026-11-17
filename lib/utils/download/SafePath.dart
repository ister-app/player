import 'dart:io';

import 'DownloadHttp.dart';

/// Whether [path] is a plain relative path that stays inside the directory
/// it is joined onto: not empty, not absolute (POSIX, drive letter or UNC)
/// and without a `..` segment — split on both separators, because a name
/// that is harmless on Linux (`..\..\x`) climbs out on Windows.
///
/// Every file name that comes from outside — a server manifest, an HLS
/// playlist, an epub's OPF, a save archive — goes through this before it
/// becomes a path on disk.
bool isSafeRelativePath(String path) {
  if (path.isEmpty) return false;
  if (path.startsWith('/') || path.startsWith(r'\')) return false;
  if (_driveLetter.hasMatch(path)) return false;
  return !path.split(_separators).any((segment) => segment == '..');
}

final RegExp _driveLetter = RegExp(r'^[A-Za-z]:');
final RegExp _separators = RegExp(r'[/\\]');

/// [name] inside [dir], or a permanent [DownloadFailure] when the name would
/// leave it.
File safeFile(Directory dir, String name) {
  if (!isSafeRelativePath(name)) {
    throw DownloadFailure('unsafe file name: $name');
  }
  return File('${dir.path}/$name');
}
