import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/AlbumSlide.dart';
import 'package:player/components/BookSlide.dart';
import 'package:player/components/PodcastSlide.dart';
import 'package:player/components/SeriesSlide.dart';
import 'package:player/components/MovieSlide.dart';
import 'package:player/components/TvShowSlide.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';

import '../components/RecentCarouselView.dart';
import '../components/RowHeader.dart';
import '../l10n/app_localizations.dart';
import '../pages/MediaListPage.dart';
import '../utils/LibrarySelectionNotifier.dart';
import '../utils/LoggerService.dart';
import '../utils/TabNavigationNotifier.dart';

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

  /// Configured servers for the title switcher; loaded once from preferences.
  List<String> _servers = [];

  @override
  void initState() {
    super.initState();
    WellKnownService.getServers().then((servers) {
      if (mounted) setState(() => _servers = servers);
    });
  }

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

  /// The server switcher, doubling as the page title: the current server's
  /// friendly name in title typography with a dropdown of all configured
  /// servers and a way back to the server overview (add/remove servers) —
  /// the same pattern as the library switcher on the library tab. A
  /// TextButton so it's D-pad focusable on its own.
  Widget _serverTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    String nameOf(String id) => WellKnownService.getCached(id)?.name ?? id;
    return MenuAnchor(
      menuChildren: [
        ..._servers.map((server) {
          final isCurrent = server == widget.serverName;
          return MenuItemButton(
            onPressed: isCurrent
                ? null
                : () {
                    // Same recipe as ServerList.goToServerRoute: remember the
                    // pick so the next cold start lands here again.
                    ClientManager.instance.lastClientUsed = server;
                    AutoRouter.of(context)
                        .replace(ServerHomeRoute(serverName: server));
                  },
            // A minimum width keeps short names from wrapping: the menu sizes
            // to the items' intrinsic width, and the ListTile squeezes its
            // title between the leading icon and the check otherwise.
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 220),
              child: ListTile(
                leading: const Icon(Icons.dns),
                title: Text(nameOf(server)),
                trailing: isCurrent ? const Icon(Icons.check) : null,
              ),
            ),
          );
        }),
        if (_servers.isNotEmpty) const Divider(height: 1),
        MenuItemButton(
          onPressed: () {
            // Without this, ServerList jumps straight back to the last used
            // server instead of showing the overview.
            ClientManager.instance.lastClientUsed = null;
            AutoRouter.of(context).replace(HomeRoute());
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220),
            child: ListTile(
              leading: const Icon(Icons.arrow_back),
              title: Text(loc.backToServerOverview),
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  nameOf(widget.serverName),
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _serverTitle(context),
        titleSpacing: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refreshPage,
            onPressed: triggerRefresh,
          ),
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
                        : RowHeader(
                            label: AppLocalizations.of(context)!.watchNext,
                            onTap: () => AutoRouter.of(context).push(
                              MediaListRoute(
                                  kindName: MediaListKind.watchNext.urlValue),
                            ),
                          ),
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
                          RowHeader(
                            label: library.name,
                            onTap: () {
                              // Announce the pick and switch to the library
                              // tab; ShowHomePage consumes and persists it.
                              pendingLibrarySelection.value =
                                  PendingLibrarySelection(
                                serverName: widget.serverName,
                                libraryId: library.id,
                                libraryType: library.type,
                              );
                              tabNavigationNotifier.value = 1;
                            },
                          ),
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
                                          : library.type == Enum$LibraryType.COMIC
                                          ? SeriesSlide(
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
