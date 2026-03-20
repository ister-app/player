import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/MovieSlide.dart';
import 'package:player/components/TvShowSlide.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/scanLibrary.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/RecentCarouselView.dart';
import '../graphql/analyzeLibrary.graphql.dart';
import '../l10n/app_localizations.dart';
import '../utils/LoggerService.dart';

@RoutePage()
class ServerHomeContentPage extends StatefulWidget {
  const ServerHomeContentPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<StatefulWidget> createState() => _ServerHomeContentPageState();
}

class _ServerHomeContentPageState extends State<ServerHomeContentPage> {
  Refetch? _refetchRecent;
  bool _recentViewEmpty = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _refresh() async {
    LoggerService().logger.i("refreshing");
    try {
      if (_refetchRecent != null) {
        await _refetchRecent!();
      }
    } catch (e) {
      LoggerService().logger.w("Could not refetch recent: $e");
    }
    setState(() {
      _recentViewEmpty = false;
    });
  }

  void _setRecentViewEmpty() {
    Future.microtask(() {
      setState(() {
        _recentViewEmpty = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GraphQLClient graphQLClient = GraphQLProvider.of(context).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
        actions: [
          MenuAnchor(
            menuChildren: <Widget>[
              MenuItemButton(
                  onPressed: () => triggerRefresh(),
                  child: ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(AppLocalizations.of(context)!.refreshPage),
                  )),
              MenuItemButton(
                  onPressed: () {
                    scanLibrary(graphQLClient);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.loop),
                    title: Text(AppLocalizations.of(context)!.scanLibrary),
                  )),
              MenuItemButton(
                  onPressed: () {
                    analyzeLibrary(graphQLClient);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.loop),
                    title: Text(AppLocalizations.of(context)!.analyzeLibrary),
                  )),
              MenuItemButton(
                  onPressed: () {
                    ClientManager.instance.lastClientUsed = null;
                    AutoRouter.of(context).replace(HomeRoute());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Switch server"),
                  )),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Query(
            options: QueryOptions(
              document: documentNodeQuerylibraries,
              fetchPolicy: FetchPolicy.cacheAndNetwork,
            ),
            builder: (QueryResult libraryResult,
                {Refetch? refetch, FetchMore? fetchMore}) {
              final libraries = libraryResult.data == null
                  ? <Query$libraries$libraries>[]
                  : (Query$libraries.fromJson(libraryResult.data!).libraries ??
                      <Query$libraries$libraries>[]);

              return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _recentViewEmpty
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "${AppLocalizations.of(context)!.watchNext}:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )),
                    _recentViewEmpty
                        ? Container()
                        : SizedBox(
                            height: 200,
                            child: RecentCarouselView(
                              serverName: widget.serverName,
                              onRefetch: (refetch) {
                                _refetchRecent = refetch;
                              },
                              onEmptyView: _setRecentViewEmpty,
                            )),
                    ...libraries.expand((library) => [
                          Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "${library.name}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                              height: 200,
                              child: library.type == Enum$LibraryType.SHOW
                                  ? TvShowSlide(
                                      serverName: widget.serverName,
                                      libraryId: library.id,
                                    )
                                  : MovieSlide(
                                      serverName: widget.serverName,
                                      libraryId: library.id,
                                    )),
                        ]),
                  ]);
            },
          )),
    );
  }

  Future<void> scanLibrary(GraphQLClient graphQLClient) async {
    LoggerService().logger.i("scanLibrary");
    final MutationOptions options = MutationOptions(
      document: documentNodeMutationscanLibrary,
    );
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return;
    }
  }

  Future<void> analyzeLibrary(GraphQLClient graphQLClient) async {
    LoggerService().logger.i("analyzeLibrary");
    final MutationOptions options = MutationOptions(
      document: documentNodeMutationanalyzeLibrary,
    );
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return;
    }
  }
}
