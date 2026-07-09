import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/TvShowSeasonExpansionPanelList.dart';
import '../utils/LoggerService.dart';

@RoutePage()
class ShowOverviewPage extends StatelessWidget {
  const ShowOverviewPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @PathParam('showId') required this.showId,
  });

  final String serverName;
  final String showId;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          // document: gql(getEpisodesRecentWatched),
          document: documentNodeQueryshowById,
          variables: Map.of({"id": showId})),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          LoggerService().logger.e(result.exception);
        }

        // Only show the skeleton on a cold load. With the default
        // cacheAndNetwork policy `isLoading` stays true while cached data is
        // already available, and skeletonizing that would flash the layout.
        final loading = result.data == null && result.isLoading;
        final show = (!loading && result.data != null)
            ? Query$showById.fromJson(result.data!).showById
            : null;

        Widget title;
        Widget body;
        if (loading) {
          title = Skeletonizer(enabled: true, child: Text(BoneMock.name));
          body = getContent(null);
        } else if (result.hasException) {
          title = Text("Show");
          body = Text(result.exception.toString());
        } else if (show == null) {
          title = Text("Show");
          body = Text(AppLocalizations.of(context)!.noShowFound);
        } else {
          title = Text(show.name);
          body = getContent(show.seasons);
        }

        return Scaffold(
          appBar: AppBar(
            leading: AutoLeadingButton(),
            title: title,
          ),
          body: body,
        );
      },
    );
  }

  /// The nested [AutoRouter] (ShowOverviewContentPage) is always mounted, so
  /// the hero image, title, description and cast own their own single
  /// skeleton→content transition. Only the season column is skeletonized here,
  /// with placeholder seasons so it keeps its size while loading.
  SingleChildScrollView getContent(
      List<Query$showById$showById$seasons>? seasons) {
    final loading = seasons == null;
    final displaySeasons = seasons ??
        List.generate(
          _skeletonSeasonCount,
          (i) => Query$showById$showById$seasons(id: 'skeleton-$i', number: i + 1),
        );

    return SingleChildScrollView(
        child: Center(
            child: Container(
                // alignment: Alignment.center,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 1600),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Wrap(children: [
                    Container(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth < 1280
                                ? constraints.maxWidth
                                : constraints.maxWidth - 480),
                        child: AutoRouter()),
                    Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth < 1280
                                ? constraints.maxWidth
                                : 480),
                        child: Skeletonizer(
                          enabled: loading,
                          child: TvShowSeasonExpansionPanelList(
                            serverName: serverName,
                            seasons: displaySeasons,
                          ),
                        ))
                  ]);
                }))));
  }
}

const _skeletonSeasonCount = 3;
