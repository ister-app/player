import 'upload_source_stub.dart'
    if (dart.library.io) 'upload_source_io.dart'
    if (dart.library.js_interop) 'upload_source_web.dart' as platform;

/// One file of a picked folder. Bytes are only ever read a range at a time:
/// a 40 GB film must never be loaded into memory, on any platform.
abstract class UploadSourceFile {
  /// Relative to the picked folder, `/`-separated, without the folder's own name.
  String get relativePath;
  int get size;

  /// Bytes `[start, end)`.
  Stream<List<int>> openRead(int start, int end);
}

/// A folder the admin picked to upload.
class UploadSourceFolder {
  UploadSourceFolder({required this.name, required this.files});

  /// The folder's own name: the default for the name it gets on the server.
  final String name;
  final List<UploadSourceFile> files;

  int get totalBytes => files.fold(0, (sum, f) => sum + f.size);
}

/// Whether this platform can pick a folder and read its files.
bool get uploadSourceSupported => platform.supported;

/// Lets the admin pick a folder; null when they cancelled.
Future<UploadSourceFolder?> pickUploadFolder() => platform.pickFolder();

/// Hidden files and OS droppings never belong in a library, and the server
/// rejects dot-prefixed names anyway: leaving them out here keeps them from
/// cluttering the preview as "invalid".
bool isUploadableRelativePath(String relativePath) {
  for (final segment in relativePath.split('/')) {
    if (segment.isEmpty || segment.startsWith('.')) return false;
    final lower = segment.toLowerCase();
    if (lower == 'thumbs.db' || lower == 'desktop.ini') return false;
  }
  return true;
}
