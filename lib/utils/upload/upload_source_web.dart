import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'UploadSource.dart';

const bool supported = true;

/// `<input type="file" webkitdirectory>`: the one way a browser hands over a
/// whole folder with its structure (`webkitRelativePath`). file_picker has no
/// directory mode on web.
Future<UploadSourceFolder?> pickFolder() {
  final completer = Completer<UploadSourceFolder?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..multiple = true
    ..style.display = 'none';
  input.setAttribute('webkitdirectory', '');
  web.document.body?.append(input);

  void finish(UploadSourceFolder? folder) {
    input.remove();
    if (!completer.isCompleted) completer.complete(folder);
  }

  input.addEventListener(
      'change',
      ((web.Event _) {
        final list = input.files;
        if (list == null || list.length == 0) return finish(null);
        String? folderName;
        final files = <UploadSourceFile>[];
        for (var i = 0; i < list.length; i++) {
          final file = list.item(i)!;
          // "Picked Folder/Season 01/e01.mkv": the first segment is the folder itself
          final full = file.webkitRelativePath;
          final slash = full.indexOf('/');
          if (slash < 0) continue;
          folderName ??= full.substring(0, slash);
          final relative = full.substring(slash + 1);
          if (!isUploadableRelativePath(relative)) continue;
          files.add(_WebFile(file, relative));
        }
        files.sort((a, b) => a.relativePath.compareTo(b.relativePath));
        finish(UploadSourceFolder(name: folderName ?? '', files: files));
      }).toJS);
  // Browsers fire "cancel" when the dialog is dismissed; without it the future would hang.
  input.addEventListener('cancel', ((web.Event _) => finish(null)).toJS);
  input.click();
  return completer.future;
}

class _WebFile implements UploadSourceFile {
  _WebFile(this._file, this.relativePath);
  final web.File _file;
  @override
  final String relativePath;

  @override
  int get size => _file.size;

  /// One slice, read in one go: a chunk is the unit the uploader asks for, and
  /// it bounds how much of the file is in memory at once.
  @override
  Stream<List<int>> openRead(int start, int end) async* {
    final buffer = await _file.slice(start, end).arrayBuffer().toDart;
    yield Uint8List.view(buffer.toDart);
  }
}
