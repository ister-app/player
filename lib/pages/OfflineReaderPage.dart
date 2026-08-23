import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/pages/ComicReaderPage.dart';
import 'package:player/pages/ReaderPage.dart';

/// The epub reader reached from the downloads page: lives on the root router
/// (no server shell, no GraphQL provider) and reads the mirrored package.
@RoutePage()
class OfflineReaderPage extends StatelessWidget {
  const OfflineReaderPage({
    super.key,
    @PathParam('serverName') required this.serverName,
    @PathParam('bookId') required this.bookId,
    @PathParam('mediaFileId') required this.mediaFileId,
    @QueryParam('nodeUrl') this.nodeUrl,
    @QueryParam('title') this.title,
  });

  final String serverName;
  final String bookId;
  final String mediaFileId;
  final String? nodeUrl;
  final String? title;

  @override
  Widget build(BuildContext context) => ReaderPage(
        serverName: serverName,
        bookId: bookId,
        mediaFileId: mediaFileId,
        nodeUrl: nodeUrl,
        title: title,
      );
}

/// The comic reader reached from the downloads page (see [OfflineReaderPage]).
@RoutePage()
class OfflineComicReaderPage extends StatelessWidget {
  const OfflineComicReaderPage({
    super.key,
    @PathParam('serverName') required this.serverName,
    @PathParam('bookId') required this.bookId,
    @PathParam('mediaFileId') required this.mediaFileId,
    @QueryParam('nodeUrl') this.nodeUrl,
    @QueryParam('title') this.title,
  });

  final String serverName;
  final String bookId;
  final String mediaFileId;
  final String? nodeUrl;
  final String? title;

  @override
  Widget build(BuildContext context) => ComicReaderPage(
        serverName: serverName,
        bookId: bookId,
        mediaFileId: mediaFileId,
        nodeUrl: nodeUrl,
        title: title,
      );
}
