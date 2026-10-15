/// Whether [url] points at a downloaded file rather than a server stream.
bool isLocalMediaUrl(String url) =>
    url.startsWith('/') || url.startsWith('file:');
