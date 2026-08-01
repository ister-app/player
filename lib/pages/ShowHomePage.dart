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
import '../components/LibraryDiscoverView.dart';
import '../components/SeriesScroll.dart';
import '../components/AddPodcastSheet.dart';
import '../components/PodcastScroll.dart';
import '../components/MovieScroll.dart';
import '../components/TvShowScroll.dart';
import '../l10n/app_localizations.dart';
import '../utils/LibraryIcons.dart';
import '../utils/LibrarySelectionNotifier.dart';
import '../utils/LoggerService.dart';
import 'package:player/utils/PermissionsService.dart';

@RoutePage()
class ShowHomePage extends StatefulWidget {
  final String serverName;

  /// URL context, so a bookmark pins a specific library and view. Absent on
  /// the plain `/library` tab path — then the device's saved selection (or
  /// the first library) applies and the URL is upgraded via replaceState.
  final String? libraryId;

  /// `'discover'` or `'browse'`; anything else falls back to the saved pref.
  final String? view;

  const ShowHomePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam('libraryId') this.libraryId,
    @QueryParam('view') this.view,
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
  // Discover (carousels) vs. Browse (the sortable grid); remembered per server.
  bool _discoverView = true;
  Refetch? _refetchLibraries;
  int _refreshCount = 0;

  static const _kSelectedLibraryKey = 'selected_library_id';
  static const _kSelectedLibraryTypeKey = 'selected_library_type';
  static const _kLibraryViewKey = 'library_view';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _showAdminActions = true;

  @override
  void initState() {
    super.initState();
    PermissionsService().adminStatusFor(widget.serverName).then((status) {
      if (mounted && status == AdminStatus.notAdmin) {
        setState(() => _showAdminActions = false);
      }
    });
    // Both paths matter: the listener when this tab is already alive behind
    // the tab bar, the direct call when the header tap builds it fresh.
    // Precedence: URL params > pending home-page pick > saved prefs.
    pendingLibrarySelection.addListener(_consumePendingSelection);
    if (widget.libraryId != null) {
      _applyUrlParams();
    } else if (pendingLibrarySelection.value != null) {
      _consumePendingSelection();
    } else {
      _loadSavedLibrary();
    }
  }

  @override
  void didUpdateWidget(covariant ShowHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Browser back/forward between query-param states arrives as an in-place
    // page update. Adopt it only when it actually differs from our state —
    // our own _reflectUrl round-trip comes back matching and must be a no-op.
    final urlChanged = widget.libraryId != oldWidget.libraryId ||
        widget.view != oldWidget.view;
    if (!urlChanged) return;
    final libDiffers =
        widget.libraryId != null && widget.libraryId != _selectedLibraryId;
    final viewDiffers = (widget.view == 'browse' && _discoverView) ||
        (widget.view == 'discover' && !_discoverView);
    if (libDiffers || viewDiffers) _applyUrlParams();
  }

  @override
  void dispose() {
    pendingLibrarySelection.removeListener(_consumePendingSelection);
    super.dispose();
  }

  /// Adopts the route's query params into the page state. The libraries query
  /// resolves the library's type and seeds the sort, as it does for a
  /// prefs-restored ID; prefs are updated so the choice sticks on-device too.
  void _applyUrlParams() {
    setState(() {
      if (widget.libraryId != null &&
          widget.libraryId != _selectedLibraryId) {
        _selectedLibraryId = widget.libraryId;
        _selectedLibraryType = null;
        _sortSeededForLibraryId = null;
      }
      if (widget.view == 'browse' || widget.view == 'discover') {
        _discoverView = widget.view == 'discover';
      }
    });
    if (widget.libraryId != null) {
      _prefs.setString(
          '${_kSelectedLibraryKey}_${widget.serverName}', widget.libraryId!);
    }
    if (widget.view == 'browse' || widget.view == 'discover') {
      _prefs.setString(
          '${_kLibraryViewKey}_${widget.serverName}', widget.view!);
    }
  }

  /// Mirrors the current selection into the address bar (replaceState — no
  /// history entry per library switch), making the tab bookmarkable.
  void _reflectUrl() {
    if (!mounted || _selectedLibraryId == null) return;
    // Not under a router (widget tests mount the page directly): nothing to
    // reflect into.
    final scope = context.findAncestorWidgetOfExactType<RouteDataScope>();
    if (scope == null) return;
    // Only while this tab is the active route: reflecting from a background
    // keep-alive tab would navigate the tab bar over to the library tab.
    if (!scope.routeData.isActive) return;
    final router = context.router;
    router.markUrlStateForReplace();
    router.navigate(ShowHomeRoute(
      libraryId: _selectedLibraryId,
      view: _discoverView ? 'discover' : 'browse',
    ));
  }

  /// Applies a library picked on the home page: select it, switch to the
  /// Browse grid and persist all three choices, then clear the notifier.
  void _consumePendingSelection() {
    final pending = pendingLibrarySelection.value;
    if (pending == null || pending.serverName != widget.serverName) return;
    pendingLibrarySelection.value = null;
    if (!mounted) return;
    setState(() {
      _selectedLibraryId = pending.libraryId;
      _selectedLibraryType = pending.libraryType;
      // Let the libraries query reseed the grid sort for the new library.
      _sortSeededForLibraryId = null;
      _discoverView = false;
    });
    _prefs.setString(
        '${_kSelectedLibraryKey}_${widget.serverName}', pending.libraryId);
    _prefs.setString('${_kSelectedLibraryTypeKey}_${widget.serverName}',
        pending.libraryType.name);
    _prefs.setString('${_kLibraryViewKey}_${widget.serverName}', 'browse');
    // Post-frame: the pick arrives while the tab switch is still in flight,
    // so this tab only becomes the active route after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _reflectUrl());
  }

  Future<void> _loadSavedLibrary() async {
    final saved = await _prefs.getString('${_kSelectedLibraryKey}_${widget.serverName}');
    final savedType = await _prefs.getString('${_kSelectedLibraryTypeKey}_${widget.serverName}');
    final savedView = await _prefs.getString('${_kLibraryViewKey}_${widget.serverName}');
    if (mounted && savedView != null) {
      setState(() => _discoverView = savedView != 'browse');
    }
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
      // Upgrade the bare /library URL to a bookmarkable one.
      _reflectUrl();
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
    _reflectUrl();
    await _prefs.setString('${_kSelectedLibraryKey}_${widget.serverName}', lib.id);
    await _prefs.setString('${_kSelectedLibraryTypeKey}_${widget.serverName}', lib.type.name);
  }

  Future<void> _setDiscoverView(bool discover) async {
    if (discover == _discoverView) return;
    setState(() => _discoverView = discover);
    _reflectUrl();
    await _prefs.setString('${_kLibraryViewKey}_${widget.serverName}',
        discover ? 'discover' : 'browse');
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
            title: _libraryTitle(context, libraries),
            titleSpacing: 8,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => AutoRouter.of(context).push(
                  SearchRoute(libraryId: _selectedLibraryId),
                ),
              ),
              if (_selectedLibraryType == Enum$LibraryType.PODCAST &&
                  _showAdminActions)
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
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: triggerRefresh,
              ),
            ],
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            // The view selector and sort bar live in the header slivers so
            // they scroll away with the content (the inner scrollables opt in
            // via primary: true).
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (_selectedLibraryId != null) _viewSelector(context),
                      if (_selectedLibraryId != null && !_discoverView)
                        _sortBar(context),
                    ],
                  ),
                ),
              ],
              body: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  /// The library switcher, doubling as the page title: the selected library's
  /// name in title typography with a dropdown menu of all libraries. Falls
  /// back to the static "Library" title while the list is still loading. A
  /// TextButton so it's D-pad focusable on its own.
  Widget _libraryTitle(
      BuildContext context, List<Query$libraries$libraries> libraries) {
    if (libraries.isEmpty || _selectedLibraryId == null) {
      return Text(AppLocalizations.of(context)!.library);
    }
    final selected = libraries.firstWhere((l) => l.id == _selectedLibraryId,
        orElse: () => libraries.first);
    final colors = Theme.of(context).colorScheme;
    return MenuAnchor(
      menuChildren: libraries.map((lib) {
        final isSelected = lib.id == selected.id;
        return MenuItemButton(
          onPressed: () => _selectLibrary(lib),
          // A minimum width keeps short names from wrapping: the menu sizes
          // to the items' intrinsic width, and the ListTile squeezes its
          // title between the leading icon and the check otherwise.
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220),
            child: ListTile(
              leading: Icon(libraryTypeIcon(lib.type)),
              title: Text(lib.name),
              trailing: isSelected ? const Icon(Icons.check) : null,
            ),
          ),
        );
      }).toList(),
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
                  selected.name,
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

  /// The Discover/Browse switch: left-aligned text pills where only the
  /// active view carries an outline. TextButtons are D-pad focusable on
  /// their own.
  Widget _viewSelector(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _viewPill(context, loc.viewDiscover, true),
              const SizedBox(width: 4),
              _viewPill(context, loc.viewBrowse, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewPill(BuildContext context, String label, bool discover) {
    final colors = Theme.of(context).colorScheme;
    final selected = _discoverView == discover;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: selected ? colors.onSurface : colors.onSurfaceVariant,
        shape: StadiumBorder(
          side: selected
              ? BorderSide(color: colors.outline)
              : BorderSide.none,
        ),
      ),
      onPressed: () => _setDiscoverView(discover),
      child: Text(label),
    );
  }

  /// The grid's sort control, shown under the view switch while browsing.
  Widget _sortBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: MenuAnchor(
          menuChildren: _sortMenuItems(context),
          builder: (context, controller, child) {
            return TextButton.icon(
              icon: const Icon(Icons.sort),
              label: Text(_currentSortLabel(context)),
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            );
          },
        ),
      ),
    );
  }

  String _currentSortLabel(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ascending = _sortingOrder == Enum$SortingOrder.ASCENDING;
    switch (_sorting) {
      case Enum$SortingEnum.DATE_CREATED:
        return ascending ? loc.sortDateAddedOldest : loc.sortDateAddedNewest;
      case Enum$SortingEnum.RELEASE_YEAR:
        return ascending
            ? loc.sortReleaseYearOldest
            : loc.sortReleaseYearNewest;
      default:
        return ascending ? loc.sortNameAsc : loc.sortNameDesc;
    }
  }

  Widget _buildBody() {
    // The sort key/order are part of the key so changing them rebuilds the grid and re-runs the
    // query from page 0 (pages in the old and new order must never share one list).
    final key = ValueKey('${_selectedLibraryId ?? 'all'}-$_refreshCount'
        '-${_sorting.name}-${_sortingOrder.name}-'
        '${_discoverView ? 'discover' : 'browse'}');
    if (_discoverView &&
        _selectedLibraryId != null &&
        _selectedLibraryType != null &&
        _selectedLibraryType != Enum$LibraryType.$unknown) {
      return LibraryDiscoverView(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId!,
        libraryType: _selectedLibraryType!,
      );
    }
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
