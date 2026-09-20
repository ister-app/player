import 'dart:math';

import 'package:flutter/services.dart';

import 'UploadSource.dart';

/// The folder picker of Android and iOS, over a platform channel.
///
/// `dart:io` cannot do this there. On Android a picked tree is a
/// storage-access-framework URI: the path file_picker derives from it is not
/// listable on Android 11+, and srt/nfo/epub files fall outside the media
/// permissions anyway. On iOS access to a picked folder is security-scoped and
/// has to be opened and closed natively. So the native side lists the tree and
/// hands out byte ranges; nothing here ever sees a path.
const MethodChannel uploadSourceChannel = MethodChannel('app.ister.player/upload_source');

/// Bytes per channel call. A chunk of the upload is 16 MB or more; pulling it
/// across in pieces keeps a single message — which is copied on both sides of
/// the channel — small.
const int nativeReadSize = 1 << 20;

Future<UploadSourceFolder?> pickNativeFolder() async {
  final result = await uploadSourceChannel.invokeMapMethod<String, dynamic>('pickFolder');
  if (result == null) return null;
  final files = <UploadSourceFile>[];
  for (final raw in (result['files'] as List? ?? const [])) {
    final file = (raw as Map).cast<String, dynamic>();
    final relativePath = file['relativePath'] as String;
    if (!isUploadableRelativePath(relativePath)) continue;
    files.add(_NativeFile(file['id'] as String, relativePath, (file['size'] as num).toInt()));
  }
  files.sort((a, b) => a.relativePath.compareTo(b.relativePath));
  return UploadSourceFolder(name: result['name'] as String? ?? '', files: files);
}

class _NativeFile implements UploadSourceFile {
  _NativeFile(this._id, this.relativePath, this.size);

  /// Opaque to Dart: a document URI on Android, a path inside the scoped folder on iOS.
  final String _id;
  @override
  final String relativePath;
  @override
  final int size;

  @override
  Stream<List<int>> openRead(int start, int end) async* {
    var offset = start;
    while (offset < end) {
      final length = min(nativeReadSize, end - offset);
      final bytes = await uploadSourceChannel
          .invokeMethod<Uint8List>('read', {'id': _id, 'offset': offset, 'length': length});
      if (bytes == null || bytes.isEmpty) {
        // The file shrank or went away under us; the server notices the short chunk.
        return;
      }
      yield bytes;
      offset += bytes.length;
    }
  }
}
