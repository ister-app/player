import 'package:file_picker/file_picker.dart';

/// A folder dialog that answers with a filesystem path, for the desktop-only
/// callers (games root, Steam library, upload folder).
///
/// `FilePicker.pickDirectory` returns a [Uri] because Android hands out
/// `content://` URIs that have no path; on desktop it is always a `file` URI.
/// Anything else has no path to give, so it counts as "nothing picked".
Future<String?> pickDirectoryPath({String? dialogTitle}) async {
  final uri = await FilePicker.pickDirectory(dialogTitle: dialogTitle);
  if (uri == null || !uri.isScheme('file')) return null;
  return uri.toFilePath();
}
