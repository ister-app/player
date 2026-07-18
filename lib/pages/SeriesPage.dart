import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/seriesById.graphql.dart';
import 'package:player/graphql/setSeriesReadingDirection.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';
import 'package:player/utils/comic/ComicPreferences.dart';
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

  /// The detected series default (RTL for manga), remembered from the last
  /// result without an override so the "default" segment can keep naming it
  /// after the user picks an explicit direction.
  Enum$ReadingDirection? _detectedDefault;

  /// Optimistic selection while the mutation round-trips; null = server state.
  Enum$ReadingDirection? _pendingChoice;
  bool _choicePending = false;

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
        final series = _series;
        if (series != null && series.userReadingDirection == null) {
          // Without an override the effective direction *is* the default.
          _detectedDefault = series.readingDirection;
        }
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
        if (series != null)
          SliverToBoxAdapter(
            child: _constrained(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: _buildReadingDirectionRow(loc, series),
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

  /// "Reading direction: [Standaard (RTL) | LTR | RTL]". The choice is stored
  /// per user on the server; "default" clears the override so the detected
  /// series direction (RTL for manga) applies again.
  Widget _buildReadingDirectionRow(
      AppLocalizations loc, Query$seriesById$seriesById series) {
    final selected =
        _choicePending ? _pendingChoice : series.userReadingDirection;
    final defaultLabel = _detectedDefault == null
        ? loc.readingDirectionDefault('LTR')
        : loc.readingDirectionDefault(
            _detectedDefault == Enum$ReadingDirection.RTL ? 'RTL' : 'LTR');
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(loc.readingDirection,
            style: Theme.of(context).textTheme.titleMedium),
        SegmentedButton<Enum$ReadingDirection?>(
          segments: [
            ButtonSegment(value: null, label: Text(defaultLabel)),
            ButtonSegment(
              value: Enum$ReadingDirection.LTR,
              label: Text(loc.readingDirectionLtr),
              icon: const Icon(Icons.format_textdirection_l_to_r),
            ),
            ButtonSegment(
              value: Enum$ReadingDirection.RTL,
              label: Text(loc.readingDirectionRtlShort),
              icon: const Icon(Icons.format_textdirection_r_to_l),
            ),
          ],
          selected: {selected},
          onSelectionChanged: (selection) =>
              unawaited(_saveReadingDirection(selection.first)),
        ),
      ],
    );
  }

  Future<void> _saveReadingDirection(Enum$ReadingDirection? choice) async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _pendingChoice = choice;
      _choicePending = true;
    });
    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(MutationOptions(
        document: documentNodeMutationsetSeriesReadingDirection,
        variables: Variables$Mutation$setSeriesReadingDirection(
          seriesId: widget.seriesId,
          direction: choice,
        ).toJson(),
      ));
      if (result.hasException) {
        throw result.exception!;
      }
      // Keep the reader's offline cache in step; a cleared override falls
      // back to the detected default we already know.
      final effective = choice ?? _detectedDefault;
      if (effective != null) {
        await ComicPreferences.setRightToLeft(
            widget.seriesId, effective == Enum$ReadingDirection.RTL);
      }
      _refetch?.call();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.couldNotSaveReadingDirection)));
      }
    } finally {
      if (mounted) setState(() => _choicePending = false);
    }
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
      title: book.title,
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
