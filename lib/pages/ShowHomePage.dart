import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/setLibrarySorting.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/AlbumScroll.dart';
import '../components/BookScroll.dart';
import '../components/SeriesScroll.dart';
import '../components/AddPodcastSheet.dart';
import '../components/PodcastScroll.dart';
import '../components/MovieScroll.dart';
import '../components/TvShowScroll.dart';
import '../l10n/app_localizations.dart';
import '../utils/LoggerService.dart';

@RoutePage()
class ShowHomePage extends StatefulWidget {
  final String serverName;

  const ShowHomePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ShowHomePage> createState() => _ShowHomePageState();
}

class _ShowHomePageState extends State<ShowHomePage> {
  String? _selectedLibraryId;
  Enum$LibraryType? _selectedLibraryType;
  // The grid sort key + direction for the selected library. Seeded from the library's
  // server-stored preference and written back through setLibrarySorting.
  Enum$SortingEnum _sorting = Enum$SortingEnum.NAME;
  Enum$SortingOrder _sortingOrder = Enum$SortingOrder.ASCENDING;
  // Library ID whose stored sort preference we've already seeded into _sorting/_sortingOrder.
  String? _sortSeededForLibraryId;
  Refetch? _refetchLibraries;
  int _refreshCount = 0;

  static const _kSelectedLibraryKey = 'selected_library_id';
  static const _kSelectedLibraryTypeKey = 'selected_library_type';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadSavedLibrary();
  }

  Future<void> _loadSavedLibrary() async {
    final saved = await _prefs.getString('${_kSelectedLibraryKey}_${widget.serverName}');
    final savedType = await _prefs.getString('${_kSelectedLibraryTypeKey}_${widget.serverName}');
    if (mounted && saved != null) {
      setState(() {
        _selectedLibraryId = saved;
        // Restore the type too so we render the right widget immediately
        // instead of briefly defaulting to MovieScroll. The libraries query
        // below still corrects it if the stored type is stale/missing.
        _selectedLibraryType = savedType == null
            ? null
            : Enum$LibraryType.values.firstWhere(
                (t) => t.name == savedType,
                orElse: () => Enum$LibraryType.$unknown);
      });
    }
  }

  Future<void> _selectLibrary(Query$libraries$libraries lib) async {
    setState(() {
      _selectedLibraryId = lib.id;
      _selectedLibraryType = lib.type;
      _sorting = lib.sorting;
      _sortingOrder = lib.sortingOrder;
      _sortSeededForLibraryId = lib.id;
    });
    await _prefs.setString('${_kSelectedLibraryKey}_${widget.serverName}', lib.id);
    await _prefs.setString('${_kSelectedLibraryTypeKey}_${widget.serverName}', lib.type.name);
  }

  /// Persists the grid sort choice for the selected library on the server (so every client of
  /// this user follows it) and rebuilds the grid via its [ValueKey] to re-run the query.
  Future<void> _setSorting(BuildContext context, Enum$SortingEnum sorting,
      Enum$SortingOrder order) async {
    final libraryId = _selectedLibraryId;
    if (libraryId == null ||
        (sorting == _sorting && order == _sortingOrder)) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final client = GraphQLProvider.of(context).value;
    final previousSorting = _sorting;
    final previousOrder = _sortingOrder;

    setState(() {
      _sorting = sorting;
      _sortingOrder = order;
    });

    final result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetLibrarySorting,
      variables: {
        'libraryId': libraryId,
        'sorting': sorting.name,
        'sortingOrder': order.name,
      },
    ));
    if (!mounted) return;
    if (result.hasException) {
      LoggerService().logger.e(result.exception);
      setState(() {
        _sorting = previousSorting;
        _sortingOrder = previousOrder;
      });
      messenger.showSnackBar(SnackBar(content: Text(loc.sortOrderFailed)));
    }
  }

  void triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _refresh() async {
    try {
      if (_refetchLibraries != null) await _refetchLibraries!();
    } catch (e) {
      LoggerService().logger.w('Failed to refetch libraries: $e');
    }
    if (!mounted) return;
    setState(() {
      _refreshCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerylibraries,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        _refetchLibraries = refetch;

        final libraries = result.data == null
            ? <Query$libraries$libraries>[]
            : (Query$libraries.fromJson(result.data!).libraries ??
                <Query$libraries$libraries>[]);

        // Resolve type for a restored library ID, or auto-select first
        if (libraries.isNotEmpty) {
          final match = _selectedLibraryId != null
              ? libraries.cast<Query$libraries$libraries?>().firstWhere(
                  (l) => l!.id == _selectedLibraryId,
                  orElse: () => null)
              : null;
          if (match != null &&
              (_selectedLibraryType != match.type ||
                  _sortSeededForLibraryId != match.id)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _selectedLibraryType = match.type;
                // Seed the grid sort from the library's server-stored preference once, without
                // clobbering a choice the user makes later in the session.
                if (_sortSeededForLibraryId != match.id) {
                  _sorting = match.sorting;
                  _sortingOrder = match.sortingOrder;
                  _sortSeededForLibraryId = match.id;
                }
              });
            });
          } else if (_selectedLibraryId == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _selectLibrary(libraries.first);
            });
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.library),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => AutoRouter.of(context).push(
                  SearchRoute(libraryId: _selectedLibraryId),
                ),
              ),
              if (_selectedLibraryType == Enum$LibraryType.PODCAST)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: AppLocalizations.of(context)!.addPodcast,
                  onPressed: () => showAddPodcastSheet(
                    context,
                    onSubscribed: triggerRefresh,
                  ),
                ),
              if (_selectedLibraryId != null &&
                  _selectedLibraryType != Enum$LibraryType.PODCAST)
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  tooltip: AppLocalizations.of(context)!.shufflePlay,
                  onPressed: () {
                    final client = GraphQLProvider.of(context).value;
                    MediaPlayerHandler.instance.startLibraryShuffle(
                      client,
                      widget.serverName,
                      _selectedLibraryId!,
                    );
                  },
                ),
              if (_selectedLibraryId != null)
                MenuAnchor(
                  menuChildren: _sortMenuItems(context),
                  builder: (context, controller, child) {
                    return IconButton(
                      icon: const Icon(Icons.sort),
                      tooltip: AppLocalizations.of(context)!.sortBy,
                      onPressed: () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                    );
                  },
                ),
              if (libraries.isNotEmpty)
                MenuAnchor(
                  menuChildren: libraries.map((lib) => MenuItemButton(
                    onPressed: () => _selectLibrary(lib),
                    child: Text(lib.name),
                  )).toList(),
                  builder: (context, controller, child) {
                    final selectedName = _selectedLibraryId == null
                        ? ''
                        : libraries.firstWhere((l) => l.id == _selectedLibraryId, orElse: () => libraries.first).name;
                    return TextButton(
                      onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(selectedName),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: triggerRefresh,
              ),
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    // The sort key/order are part of the key so changing them rebuilds the grid and re-runs the
    // query from page 0 (pages in the old and new order must never share one list).
    final key = ValueKey('${_selectedLibraryId ?? 'all'}-$_refreshCount'
        '-${_sorting.name}-${_sortingOrder.name}');
    if (_selectedLibraryId == null) {
      return TvShowScroll(
        key: key,
        serverName: widget.serverName,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.SHOW) {
      return TvShowScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MUSIC) {
      return AlbumScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.BOOK) {
      return BookScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.COMIC) {
      return SeriesScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.PODCAST) {
      return PodcastScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MOVIE) {
      return MovieScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _sorting,
        sortingOrder: _sortingOrder,
      );
    } else {
      // Type not resolved yet (e.g. restored ID without a stored type). Wait for
      // the libraries query rather than guessing a widget and querying the wrong
      // content type against the library.
      return const Center(child: CircularProgressIndicator());
    }
  }

  /// The sort options offered for the selected library. Release-year sorting is hidden for
  /// podcasts, which have no release year (the server folds it onto the title as a safety net).
  List<Widget> _sortMenuItems(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final items = <Widget>[
      _sortMenuItem(context, loc.sortNameAsc,
          Enum$SortingEnum.NAME, Enum$SortingOrder.ASCENDING),
      _sortMenuItem(context, loc.sortNameDesc,
          Enum$SortingEnum.NAME, Enum$SortingOrder.DESCENDING),
      _sortMenuItem(context, loc.sortDateAddedNewest,
          Enum$SortingEnum.DATE_CREATED, Enum$SortingOrder.DESCENDING),
      _sortMenuItem(context, loc.sortDateAddedOldest,
          Enum$SortingEnum.DATE_CREATED, Enum$SortingOrder.ASCENDING),
    ];
    if (_selectedLibraryType != Enum$LibraryType.PODCAST) {
      items.add(_sortMenuItem(context, loc.sortReleaseYearNewest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.DESCENDING));
      items.add(_sortMenuItem(context, loc.sortReleaseYearOldest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.ASCENDING));
    }
    return items;
  }

  Widget _sortMenuItem(BuildContext context, String label,
      Enum$SortingEnum sorting, Enum$SortingOrder order) {
    final selected = _sorting == sorting && _sortingOrder == order;
    return MenuItemButton(
      onPressed: () => _setSorting(context, sorting, order),
      child: ListTile(
        leading: Icon(selected ? Icons.check : Icons.sort),
        title: Text(label),
      ),
    );
  }
}
