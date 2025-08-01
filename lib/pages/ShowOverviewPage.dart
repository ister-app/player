import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/showById.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/TvShowSeasonExpansionPanelList.dart';
import '../graphql/fragmentImages.graphql.dart';

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
        Widget title = Text("Show");
        Widget body = Text("Body");

        if (result.hasException) {
          print(result.data);
          body = Text(result.exception.toString());
        }

        if (result.isLoading) {
          title = Skeletonizer(enabled: true, child: Text(BoneMock.name));
          body = Skeletonizer(enabled: true, child: getContent(false, null));
        } else {
          final parsedData = Query$showById.fromJson(result.data!);

          Query$showById$showById? show = parsedData.showById;

          List<Fragment$fragmentImages>? images = show?.images
              ?.map((e) => Fragment$fragmentImages.fromJson(e.toJson()))
              .toList();

          if (show == null) {
            body = const Text('No show');
          } else {
            title = Text(show.name);
            body = getContent(true, show.seasons);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: title,
          ),
          body: body,
        );
      },
    );
  }

  SingleChildScrollView getContent(
      bool showAutoRouter, List<Query$showById$showById$seasons>? seasons) {
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
                        child: showAutoRouter
                            ? AutoRouter()
                            : Container(
                                height: constraints.maxWidth < 1280 ? 300 : 500,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(color: Colors.grey),
                              )),
                    Container(
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth < 1280
                                ? constraints.maxWidth
                                : 480),
                        child: seasons != null
                            ? TvShowSeasonExpansionPanelList(
                                serverName: serverName,
                                seasons: seasons,
                              )
                            : Container())
                  ]);
                }))));
  }
}
