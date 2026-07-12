import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoggerService.dart';
import 'StreamTokenService.dart';

/// Opens the server-hosted epub reader web app for a book.
///
/// The reader is fully self-contained: it lazily fetches the epub's files
/// through the server's /epub resource endpoint (authenticated with the stream
/// token) and syncs the reading position itself via POST /reading-progress —
/// no Flutter↔JS bridge is needed. That makes launching it as a browser
/// surface safe on every platform: an in-app browser view (Custom Tab) on
/// mobile, a new tab on web, and the default browser on desktop (Linux has no
/// official Flutter webview).
class ReaderLauncher {
  ReaderLauncher._();

  /// Builds the reader URL on the node that owns [epubMediaFileId].
  static Uri buildReaderUrl({
    required String nodeUrl,
    required String epubMediaFileId,
    required String bookId,
    required String serverName,
    String? title,
  }) {
    final token = StreamTokenService.getToken(serverName);
    final base = nodeUrl.endsWith('/')
        ? nodeUrl.substring(0, nodeUrl.length - 1)
        : nodeUrl;
    return Uri.parse('$base/reader/index.html').replace(queryParameters: {
      'mediaFileId': epubMediaFileId,
      'bookId': bookId,
      if (token != null) 'token': token,
      if (title != null) 'title': title,
    });
  }

  static Future<bool> open({
    required String nodeUrl,
    required String epubMediaFileId,
    required String bookId,
    required String serverName,
    String? title,
  }) async {
    final url = buildReaderUrl(
      nodeUrl: nodeUrl,
      epubMediaFileId: epubMediaFileId,
      bookId: bookId,
      serverName: serverName,
      title: title,
    );
    try {
      final mode = kIsWeb
          ? LaunchMode.platformDefault
          : (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS)
              ? LaunchMode.inAppBrowserView
              : LaunchMode.externalApplication;
      return await launchUrl(url, mode: mode);
    } catch (error) {
      LoggerService().logger.e('Could not open reader: $error');
      return false;
    }
  }
}
