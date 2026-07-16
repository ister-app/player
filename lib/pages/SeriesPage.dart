import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/seriesById.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/CarouselItemView.dart';
import '../components/MusicDetailHero.dart';
import '../components/SeriesCarouselTile.dart';
import '../l10n/app_localizations.dart';

/// A comic series: cover, description and the volumes in series order. Tapping
/// a volume opens its book page, where reading starts.
@RoutePage()
class SeriesPage extends StatefulWidget {
  const SeriesPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('seriesId') required this.seriesId,
  });

  final String serverName;
  final String seriesId;

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  Query$seriesById$seriesById? _series;
  VoidCallback? _refetch;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQueryseriesById,
        variables: {'id': widget.seriesId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        _refetch = refetch;
        if (result.hasException) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(result.exception.toString())),
          );
        }

        if (result.data == null) {
          return Scaffold(
            body: Skeletonizer(enabled: true, child: _buildContent()),
          );
        }

        _series = Query$seriesById.fromJson(result.data!).seriesById;
        return Scaffold(body: _buildContent());
      },
    );
  }

  Widget _buildContent() {
    final loc = AppLocalizations.of(context)!;
    final series = _series;
    final description =
        series != null ? MetadataUtil.getDescription(series.metadata) : null;
    final books = series?.books ?? [];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          stretch: true,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildHeader(series),
          ),
        ),
        if (description != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
        if (books.isNotEmpty)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  loc.volumes,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: _constrained(
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: SeriesCarouselTile.coverAspectRatio,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) =>
                  _buildVolumeTile(books[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeTile(Query$seriesById$seriesById$books book) {
    final img = ImageUtil.getImageByType(book.images, ImageTypes.cover);
    final status = book.watchStatus
        ?.where((status) =>
            status.watched || (status.readingProgress ?? 0) > 0)
        .firstOrNull;
    final progress = status?.watched == true
        ? 1.0
        : status?.readingProgress?.clamp(0.0, 1.0);
    final index = book.seriesIndex;
    final indexLabel = index == null
        ? ''
        : '#${index == index.roundToDouble() ? index.round() : index}';

    return CarouselItemView(
      serverName: widget.serverName,
      title: MetadataUtil.getTitle(book.metadata) ?? book.title,
      subTitle: indexLabel,
      imageUrl: ImageUtil.buildUrl(img,
          token: StreamTokenService.getToken(widget.serverName)),
      blurHash: img?.blurHash,
      progress: progress,
      placeholderIcon: Icons.auto_stories,
      portraitArtwork: true,
      onTap: () async {
        await AutoRouter.of(context).push(BookRoute(bookId: book.id));
        // Reading happened: refresh the volume progress bars.
        _refetch?.call();
      },
    );
  }

  Widget _buildHeader(Query$seriesById$seriesById? series) {
    final img = series != null
        ? (series.cover ??
            ImageUtil.getImageByType(series.images, ImageTypes.cover))
        : null;
    return MusicDetailHero(
      imageUrl: img != null
          ? ImageUtil.buildUrl(img,
              token: StreamTokenService.getToken(widget.serverName))
          : null,
      blurHash: img?.blurHash,
      placeholderIcon: Icons.auto_stories,
      coverAspectRatio: SeriesCarouselTile.coverAspectRatio,
      title: series != null
          ? MetadataUtil.titleWithYear(series.name, series.startYear)
          : null,
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
}
