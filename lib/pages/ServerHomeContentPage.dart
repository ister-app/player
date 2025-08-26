import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/TvShowSlide.dart';
import 'package:player/graphql/scanLibrary.graphql.dart';

import '../components/RecentCarouselView.dart';
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

  Refetch? _refetchTvshow;
  bool _tvshowViewEmpty = false;

  Future<void> _refresh() async {
    LoggerService().logger.i("refreshing");
    if (_refetchRecent != null) {
      await _refetchRecent!();
    }
    if (_refetchTvshow != null) {
      await _refetchTvshow!();
    }
    setState(() {
      _recentViewEmpty = false;
      _tvshowViewEmpty = false;
    });
  }

  void _setRecentViewEmpty() {
    // Use a delayed call to avoid calling setState during build
    Future.microtask(() {
      setState(() {
        _recentViewEmpty = true;
      });
    });
  }

  void _setTvshowViewEmpty() {
    // Use a delayed call to avoid calling setState during build
    Future.microtask(() {
      setState(() {
        _tvshowViewEmpty = true;
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
                  onPressed: _refresh,
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
          onRefresh: _refresh,
          child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _recentViewEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(5),
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
                _tvshowViewEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "${AppLocalizations.of(context)!.recentlyAddedShows}:",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                _tvshowViewEmpty
                    ? Container()
                    : SizedBox(
                        height: 200,
                        child: Tvshowslide(
                          serverName: widget.serverName,
                          onRefetch: (refetch) {
                            _refetchTvshow = refetch;
                          },
                          onEmptyView: _setTvshowViewEmpty,
                        ))
              ])),
    );
  }

  Future<void> scanLibrary(GraphQLClient graphQLClient) async {
    final MutationOptions options = MutationOptions(
      document: documentNodeMutationscanLibrary,
    );
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      return;
    }
  }
}
