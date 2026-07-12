import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/AlbumSlide.dart';
import 'package:player/components/BookSlide.dart';
import 'package:player/components/PodcastSlide.dart';
import 'package:player/components/MovieSlide.dart';
import 'package:player/components/TvShowSlide.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';

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
  Refetch? _refetchLibraries;
  final Map<String, Refetch> _refetchSlides = {};
  bool _recentViewEmpty = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _safeRefetch(Refetch refetch, String label) async {
    try {
      await refetch();
    } catch (e) {
      LoggerService().logger.w("Could not refetch $label: $e");
    }
  }

  Future<void> _refresh() async {
    LoggerService().logger.i("refreshing");
    await Future.wait([
      if (_refetchRecent != null) _safeRefetch(_refetchRecent!, "recent"),
      if (_refetchLibraries != null) _safeRefetch(_refetchLibraries!, "libraries"),
      ..._refetchSlides.entries.map((e) => _safeRefetch(e.value, "slide ${e.key}")),
    ]);
    if (!mounted) return;
    setState(() {
      _recentViewEmpty = false;
    });
  }

  void _setRecentViewEmpty() {
    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _recentViewEmpty = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    ClientManager.instance.lastClientUsed = null;
                    AutoRouter.of(context).replace(HomeRoute());
                  },
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(AppLocalizations.of(context)!.switchServer),
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
              if (refetch != null) _refetchLibraries = refetch;
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
                                      onRefetch: (r) {
                                        if (r != null) _refetchSlides[library.id] = r;
                                      },
                                    )
                                  : library.type == Enum$LibraryType.MUSIC
                                      ? AlbumSlide(
                                          serverName: widget.serverName,
                                          libraryId: library.id,
                                          onRefetch: (r) {
                                            if (r != null) _refetchSlides[library.id] = r;
                                          },
                                        )
                                      : library.type == Enum$LibraryType.BOOK
                                          ? BookSlide(
                                              serverName: widget.serverName,
                                              libraryId: library.id,
                                              onRefetch: (r) {
                                                if (r != null) _refetchSlides[library.id] = r;
                                              },
                                            )
                                          : library.type == Enum$LibraryType.PODCAST
                                          ? PodcastSlide(
                                              serverName: widget.serverName,
                                              libraryId: library.id,
                                              onRefetch: (r) {
                                                if (r != null) _refetchSlides[library.id] = r;
                                              },
                                            )
                                          : MovieSlide(
                                              serverName: widget.serverName,
                                              libraryId: library.id,
                                              onRefetch: (r) {
                                                if (r != null) _refetchSlides[library.id] = r;
                                              },
                                            )),
                        ]),
                  ]);
            },
          )),
    );
  }
}
