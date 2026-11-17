/// Whether [url] points at a downloaded file rather than a server stream.
///
/// Downloads are plain file-system paths: `/…` on POSIX, `C:\\…` or a UNC
/// share on Windows. Missing the Windows forms made a downloaded video look
/// like a server stream there — a stream token was appended to the path and
/// the mirrored subtitles were skipped.
bool isLocalMediaUrl(String url) =>
    url.startsWith('/') ||
    url.startsWith('file:') ||
    url.startsWith(r'\\') ||
    _windowsDrivePath.hasMatch(url);

final RegExp _windowsDrivePath = RegExp(r'^[A-Za-z]:[\\/]');
