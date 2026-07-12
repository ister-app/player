import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/bookById.graphql.dart';
import 'package:player/graphql/fragmentChapter.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/ReaderLauncher.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/MusicDetailHero.dart';
import '../components/RatingStars.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class BookPage extends StatefulWidget {
  const BookPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('bookId') required this.bookId,
    @QueryParam('playQueueId') this.playQueueId,
  });

  final String serverName;
  final String bookId;
  final String? playQueueId;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Query$bookById$bookById? _book;

  List<Fragment$fragmentChapter> get _chapters => _book?.chapters ?? [];

  bool get _hasListenableChapter =>
      _chapters.any((chapter) => chapter.mediaFile?.isNotEmpty == true);

  Query$bookById$bookById$epubFiles? get _epubFile {
    final files = _book?.epubFiles;
    if (files == null || files.isEmpty) return null;
    // Prefer the plain edition for reading; a read-aloud epub still works.
    return files.where((f) => f.mediaOverlays != true).firstOrNull ??
        files.first;
  }

  Query$bookById$bookById$epubFiles? get _readAloudEpubFile {
    final files = _book?.epubFiles;
    if (files == null) return null;
    return files.where((f) => f.mediaOverlays == true).firstOrNull;
  }

  double? get _readingProgress => _book?.watchStatus
      ?.where((status) => status.readingProgress != null)
      .firstOrNull
      ?.readingProgress;

  void _listen(BuildContext context, {String? chapterId}) {
    final client = GraphQLProvider.of(context).value;
    // Resume at the first unfinished chapter when none was tapped explicitly.
    final startChapter = chapterId ?? _firstUnfinishedChapterId();
    MediaPlayerHandler.instance.startPlayQueueForBook(
      client,
      widget.playQueueId,
      widget.bookId,
      startChapter,
      widget.serverName,
    );
  }

  String? _firstUnfinishedChapterId() {
    for (final chapter in _chapters) {
      if (chapter.mediaFile?.isNotEmpty != true) continue;
      final status = chapter.watchStatus?.firstOrNull;
      if (status == null || !status.watched) return chapter.id;
    }
    return _chapters
        .where((chapter) => chapter.mediaFile?.isNotEmpty == true)
        .firstOrNull
        ?.id;
  }

  Future<void> _read(BuildContext context,
      Query$bookById$bookById$epubFiles epubFile) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final opened = await ReaderLauncher.open(
      nodeUrl: epubFile.directory.node.url,
      epubMediaFileId: epubFile.id,
      bookId: widget.bookId,
      serverName: widget.serverName,
      title: _book != null
          ? (MetadataUtil.getTitle(_book!.metadata) ?? _book!.name)
          : null,
    );
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(loc.couldNotOpenReader)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerybookById,
        variables: {'id': widget.bookId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(result.exception.toString())),
          );
        }

        if (result.data == null) {
          return Scaffold(
            body: Skeletonizer(
              enabled: true,
              child: _buildContent(),
            ),
          );
        }

        _book = Query$bookById.fromJson(result.data!).bookById;
        return Scaffold(body: _buildContent());
      },
    );
  }

  Widget _buildContent() {
    final loc = AppLocalizations.of(context)!;
    final book = _book;
    final description =
        book != null ? MetadataUtil.getDescription(book.metadata) : null;
    final metaLine = book != null ? MetadataUtil.getMetaLine(book.metadata) : null;
    final epubFile = _epubFile;
    final readAloudFile = _readAloudEpubFile;
    final readingProgress = _readingProgress;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHeader(context, book),
          ),
        ),
        SliverToBoxAdapter(
          child: _constrained(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (_hasListenableChapter)
                    FilledButton.icon(
                      onPressed: book != null ? () => _listen(context) : null,
                      icon: const Icon(Icons.headphones),
                      label: Text(loc.listen),
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                    ),
                  if (epubFile != null)
                    FilledButton.icon(
                      onPressed:
                          book != null ? () => _read(context, epubFile) : null,
                      icon: const Icon(Icons.menu_book),
                      label: Text(loc.read),
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                    ),
                  if (readAloudFile != null)
                    FilledButton.icon(
                      onPressed: book != null
                          ? () => _read(context, readAloudFile)
                          : null,
                      icon: const Icon(Icons.record_voice_over),
                      label: Text(loc.readAloud),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (readingProgress != null && readingProgress > 0)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                            value: readingProgress.clamp(0.0, 1.0)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(readingProgress * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (metaLine != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  metaLine,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ),
        if (book != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: RatingStars(
                  mediaType: Enum$RatingMediaType.BOOK,
                  mediaId: book.id,
                  rating: book.rating,
                ),
              ),
            ),
          ),
        if (description != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                  ],
                ),
              ),
            ),
          ),
        if (_chapters.isNotEmpty)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  loc.chapters,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        if (_chapters.isNotEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _chapters.length,
                  itemBuilder: (context, index) =>
                      _buildChapterTile(context, _chapters[index]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChapterTile(
      BuildContext context, Fragment$fragmentChapter chapter) {
    final loc = AppLocalizations.of(context)!;
    final hasFile = chapter.mediaFile?.isNotEmpty == true;
    final title = MetadataUtil.getTitle(chapter.metadata) ??
        '${loc.chapter} ${chapter.number}';
    final durationMs = chapter.mediaFile?.firstOrNull?.durationInMilliseconds;
    final durationText = durationMs != null && durationMs > 0
        ? DurationUtil.format(Duration(milliseconds: durationMs))
        : null;
    final status = chapter.watchStatus?.firstOrNull;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Opacity(
      opacity: hasFile ? 1.0 : 0.5,
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: SizedBox(
          width: 28,
          child: status?.watched == true
              ? Icon(Icons.check, size: 18, color: mutedColor)
              : Text(
                  '${chapter.number}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: mutedColor),
                ),
        ),
        title: Text(title),
        subtitle: durationText != null
            ? Text(
                durationText,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: mutedColor),
              )
            : null,
        onTap: hasFile ? () => _listen(context, chapterId: chapter.id) : null,
      ),
    );
  }

  Widget _constrained(Widget child) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1600),
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Query$bookById$bookById? book) {
    final img = book != null
        ? ImageUtil.getImageByType(book.images, ImageTypes.cover)
        : null;
    final imageUrl = img != null
        ? ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(widget.serverName))
        : null;

    return MusicDetailHero(
      imageUrl: imageUrl,
      blurHash: img?.blurHash,
      title: book != null
          ? (MetadataUtil.getTitle(book.metadata) ?? book.name)
          : null,
      subtitle: book?.author.name,
      onSubtitleTap: book != null
          ? () => AutoRouter.of(context)
              .push(PersonRoute(personId: book.author.id))
          : null,
    );
  }
}
