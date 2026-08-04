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
import '../components/ArtistScroll.dart';
import '../components/BookScroll.dart';
import '../components/EpisodeScroll.dart';
import '../components/LibraryDiscoverView.dart';
import '../components/SeriesScroll.dart';
import '../components/AddPodcastSheet.dart';
import '../components/PodcastScroll.dart';
import '../components/MovieScroll.dart';
import '../components/TrackScroll.dart';
import '../components/TvShowScroll.dart';
import '../components/PlaylistEditSheet.dart';
import '../components/filter/FilterSheet.dart';
import '../l10n/app_localizations.dart';
import '../utils/BrowseKind.dart';
import '../utils/filter/FilterCatalog.dart';
import '../utils/filter/MediaFilterModel.dart';
import '../utils/LibraryIcons.dart';
import '../utils/LibrarySelectionNotifier.dart';
import '../utils/LoggerService.dart';
import '../utils/PlaylistService.dart';
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

  /// A [BrowseKind] name (e.g. `'tracks'`); anything else falls back to the
  /// saved pref / the library type's default kind.
  final String? kind;

  /// `'grid'` or `'list'`; anything else falls back to the saved pref.
  final String? layout;

  /// A [MediaFilterModel] as JSON; invalid JSON falls back to the saved pref.
  final String? filter;

  const ShowHomePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam('libraryId') this.libraryId,
    @QueryParam('view') this.view,
    @QueryParam('kind') this.kind,
    @QueryParam('layout') this.layout,
    @QueryParam('filter') this.filter,
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
  // What the Browse grid lists (albums/artists/tracks, shows/episodes); null =
  // the library type's default kind. Remembered per library.
  BrowseKind? _browseKind;
  // The sort of the non-default kinds is a device-local preference (the
  // server-stored library sort keeps belonging to the default kind).
  Enum$SortingEnum? _kindSorting;
  Enum$SortingOrder? _kindSortingOrder;
  // Grid vs list layout for the Browse view; remembered per server.
  bool _listLayout = false;
  // The custom filter of the Browse grid; remembered per library + kind.
  MediaFilterModel? _filter;
  Refetch? _refetchLibraries;
  int _refreshCount = 0;

  static const _kSelectedLibraryKey = 'selected_library_id';
  static const _kSelectedLibraryTypeKey = 'selected_library_type';
  static const _kLibraryViewKey = 'library_view';
  static const _kBrowseKindKey = 'library_browse_kind';
  static const _kBrowseLayoutKey = 'library_browse_layout';
  static const _kKindSortingKey = 'library_kind_sorting';
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
    // The layout pref applies on every path; an explicit URL layout wins.
    if (widget.layout != 'grid' && widget.layout != 'list') {
      _prefs.getString('${_kBrowseLayoutKey}_${widget.serverName}').then((saved) {
        if (mounted && saved != null) {
          setState(() => _listLayout = saved == 'list');
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant ShowHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Browser back/forward between query-param states arrives as an in-place
    // page update. Adopt it only when it actually differs from our state —
    // our own _reflectUrl round-trip comes back matching and must be a no-op.
    final urlChanged = widget.libraryId != oldWidget.libraryId ||
        widget.view != oldWidget.view ||
        widget.kind != oldWidget.kind ||
        widget.layout != oldWidget.layout ||
        widget.filter != oldWidget.filter;
    if (!urlChanged) return;
    final libDiffers =
        widget.libraryId != null && widget.libraryId != _selectedLibraryId;
    final viewDiffers = (widget.view == 'browse' && _discoverView) ||
        (widget.view == 'discover' && !_discoverView);
    final urlKind = _parseKind(widget.kind);
    final kindDiffers = urlKind != null && urlKind != _browseKind;
    final layoutDiffers = (widget.layout == 'list' && !_listLayout) ||
        (widget.layout == 'grid' && _listLayout);
    final filterDiffers = widget.filter != _filter?.encode();
    if (libDiffers || viewDiffers || kindDiffers || layoutDiffers ||
        filterDiffers) {
      _applyUrlParams();
    }
  }

  static BrowseKind? _parseKind(String? name) => BrowseKind.values
      .cast<BrowseKind?>()
      .firstWhere((k) => k!.name == name, orElse: () => null);

  @override
  void dispose() {
    pendingLibrarySelection.removeListener(_consumePendingSelection);
    super.dispose();
  }

  /// Adopts the route's query params into the page state. The libraries query
  /// resolves the library's type and seeds the sort, as it does for a
  /// prefs-restored ID; prefs are updated so the choice sticks on-device too.
  void _applyUrlParams() {
    final urlKind = _parseKind(widget.kind);
    final libraryChanged = widget.libraryId != null &&
        widget.libraryId != _selectedLibraryId;
    setState(() {
      if (libraryChanged) {
        _selectedLibraryId = widget.libraryId;
        _selectedLibraryType = null;
        _sortSeededForLibraryId = null;
        _browseKind = null;
        _kindSorting = null;
        _kindSortingOrder = null;
      }
      if (widget.view == 'browse' || widget.view == 'discover') {
        _discoverView = widget.view == 'discover';
      }
      if (urlKind != null) _browseKind = urlKind;
      if (widget.layout == 'grid' || widget.layout == 'list') {
        _listLayout = widget.layout == 'list';
      }
      // The filter is state + URL only (not persisted): a bookmark restores
      // it, a library switch clears it.
      _filter = MediaFilterModel.decode(widget.filter);
    });
    if (widget.libraryId != null) {
      _prefs.setString(
          '${_kSelectedLibraryKey}_${widget.serverName}', widget.libraryId!);
    }
    if (widget.view == 'browse' || widget.view == 'discover') {
      _prefs.setString(
          '${_kLibraryViewKey}_${widget.serverName}', widget.view!);
    }
    if (urlKind != null && widget.libraryId != null) {
      _prefs.setString(
          _browseKindPrefKey(widget.libraryId!), urlKind.name);
      _loadKindSorting(widget.libraryId!, urlKind);
    } else if (libraryChanged) {
      _restoreBrowseKind(widget.libraryId!);
    }
    if (widget.layout == 'grid' || widget.layout == 'list') {
      _prefs.setString(
          '${_kBrowseLayoutKey}_${widget.serverName}', widget.layout!);
    }
  }

  String _browseKindPrefKey(String libraryId) =>
      '${_kBrowseKindKey}_${widget.serverName}_$libraryId';

  String _kindSortingPrefKey(String libraryId, BrowseKind kind) =>
      '${_kKindSortingKey}_${widget.serverName}_${libraryId}_${kind.name}';

  /// Restores the remembered browse kind (and its device-local sort) of a
  /// library; leaves the default kind in place when nothing was saved.
  Future<void> _restoreBrowseKind(String libraryId) async {
    final saved = await _prefs.getString(_browseKindPrefKey(libraryId));
    final kind = _parseKind(saved);
    if (!mounted || kind == null || libraryId != _selectedLibraryId) return;
    setState(() => _browseKind = kind);
    await _loadKindSorting(libraryId, kind);
  }

  /// Seeds [_kindSorting]/[_kindSortingOrder] from the device-local pref of
  /// the given kind (null → the kind's own default applies).
  Future<void> _loadKindSorting(String libraryId, BrowseKind kind) async {
    final saved = await _prefs.getString(_kindSortingPrefKey(libraryId, kind));
    if (!mounted || _selectedLibraryId != libraryId) return;
    final parts = saved?.split(':');
    setState(() {
      _kindSorting = parts == null || parts.length != 2
          ? null
          : Enum$SortingEnum.values
              .cast<Enum$SortingEnum?>()
              .firstWhere((s) => s!.name == parts[0], orElse: () => null);
      _kindSortingOrder = parts == null || parts.length != 2
          ? null
          : Enum$SortingOrder.values
              .cast<Enum$SortingOrder?>()
              .firstWhere((o) => o!.name == parts[1], orElse: () => null);
    });
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
      kind: _browseKind?.name,
      layout: _listLayout ? 'list' : null,
      filter: _filter?.encode(),
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
      _browseKind = null;
      _kindSorting = null;
      _kindSortingOrder = null;
      _filter = null;
    });
    _restoreBrowseKind(pending.libraryId);
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
      await _restoreBrowseKind(saved);
    }
  }

  Future<void> _selectLibrary(Query$libraries$libraries lib) async {
    setState(() {
      _selectedLibraryId = lib.id;
      _selectedLibraryType = lib.type;
      _sorting = lib.sorting;
      _sortingOrder = lib.sortingOrder;
      _sortSeededForLibraryId = lib.id;
      _browseKind = null;
      _kindSorting = null;
      _kindSortingOrder = null;
      _filter = null;
    });
    _reflectUrl();
    _restoreBrowseKind(lib.id);
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

  /// The kind the Browse grid actually shows: the user's choice when it is
  /// valid for the library type, else the type's default (first) kind. Null
  /// for single-kind types.
  BrowseKind? get _effectiveKind {
    final kinds = browseKindsFor(_selectedLibraryType);
    if (kinds.isEmpty) return null;
    if (_browseKind != null && kinds.contains(_browseKind)) return _browseKind;
    return kinds.first;
  }

  /// Whether the current kind is the type's default one. The default kind
  /// follows the server-stored library sort; the others sort device-locally.
  bool get _isDefaultKind {
    final kinds = browseKindsFor(_selectedLibraryType);
    return kinds.isEmpty || _effectiveKind == kinds.first;
  }

  static (Enum$SortingEnum, Enum$SortingOrder) _kindSortDefaults(
      BrowseKind kind) {
    // The library-wide episode list reads as a feed: newest additions first.
    return kind == BrowseKind.episodes
        ? (Enum$SortingEnum.DATE_CREATED, Enum$SortingOrder.DESCENDING)
        : (Enum$SortingEnum.NAME, Enum$SortingOrder.ASCENDING);
  }

  Enum$SortingEnum get _effectiveSorting => _isDefaultKind
      ? _sorting
      : _kindSorting ?? _kindSortDefaults(_effectiveKind!).$1;

  Enum$SortingOrder get _effectiveSortingOrder => _isDefaultKind
      ? _sortingOrder
      : _kindSortingOrder ?? _kindSortDefaults(_effectiveKind!).$2;

  Future<void> _setBrowseKind(BrowseKind kind) async {
    final libraryId = _selectedLibraryId;
    if (libraryId == null || kind == _effectiveKind) return;
    setState(() {
      _browseKind = kind;
      _kindSorting = null;
      _kindSortingOrder = null;
      // A filter is field-typed per kind; it cannot survive a kind switch.
      _filter = null;
    });
    _reflectUrl();
    await _prefs.setString(_browseKindPrefKey(libraryId), kind.name);
    await _loadKindSorting(libraryId, kind);
  }

  Future<void> _toggleLayout() async {
    setState(() => _listLayout = !_listLayout);
    _reflectUrl();
    await _prefs.setString('${_kBrowseLayoutKey}_${widget.serverName}',
        _listLayout ? 'list' : 'grid');
  }

  /// Persists the grid sort choice. For the type's default kind it goes to the
  /// server via setLibrarySorting (so every client of this user follows it);
  /// for the other kinds it is a device-local preference, so switching kinds
  /// never clobbers the shared library sort.
  Future<void> _setSorting(BuildContext context, Enum$SortingEnum sorting,
      Enum$SortingOrder order) async {
    final libraryId = _selectedLibraryId;
    if (libraryId == null ||
        (sorting == _effectiveSorting && order == _effectiveSortingOrder)) {
      return;
    }
    if (!_isDefaultKind) {
      setState(() {
        _kindSorting = sorting;
        _kindSortingOrder = order;
      });
      await _prefs.setString(_kindSortingPrefKey(libraryId, _effectiveKind!),
          '${sorting.name}:${order.name}');
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

  /// The filter kind of the current browse view; null = no filter support.
  Enum$FilterKind? get _filterKind =>
      FilterCatalog.kindFor(_selectedLibraryType, _effectiveKind);

  void _setFilter(MediaFilterModel? filter) {
    setState(() => _filter = filter);
    _reflectUrl();
  }

  void _openFilterSheet(BuildContext context) {
    final kind = _filterKind;
    if (kind == null) return;
    showFilterSheet(
      context,
      kind: kind,
      libraryId: _selectedLibraryId,
      initial: _filter,
      onApply: _setFilter,
    );
  }

  /// The browse controls under the view switch: kind pills (only for types
  /// with more than one kind), the sort menu, the custom filter and the
  /// grid/list toggle.
  Widget _sortBar(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final kinds = browseKindsFor(_selectedLibraryType);
    final colors = Theme.of(context).colorScheme;
    final filterKind = _filterKind;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (kinds.length > 1)
                        for (final kind in kinds) ...[
                          _kindPill(context, kind),
                          const SizedBox(width: 4),
                        ],
                      MenuAnchor(
                        menuChildren: _sortMenuItems(context),
                        builder: (context, controller, child) {
                          return TextButton.icon(
                            icon: const Icon(Icons.sort),
                            label: Text(_currentSortLabel(context)),
                            onPressed: () => controller.isOpen
                                ? controller.close()
                                : controller.open(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (filterKind != null)
                IconButton(
                  icon: Icon(
                    _filter != null ? Icons.filter_alt : Icons.filter_alt_outlined,
                    color: _filter != null ? colors.primary : null,
                  ),
                  tooltip: loc.customFilter,
                  onPressed: () => _openFilterSheet(context),
                ),
              IconButton(
                icon: Icon(_listLayout ? Icons.grid_view : Icons.view_list),
                tooltip: _listLayout ? loc.viewAsGrid : loc.viewAsList,
                onPressed: _toggleLayout,
              ),
            ],
          ),
          if (_filter != null && filterKind != null)
            _activeFilterRow(context, filterKind),
        ],
      ),
    );
  }

  /// The active-filter chip plus, for playable kinds, play/shuffle actions
  /// that turn the filtered result into a FILTER play queue.
  Widget _activeFilterRow(BuildContext context, Enum$FilterKind filterKind) {
    final loc = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            InputChip(
              avatar: const Icon(Icons.filter_alt, size: 18),
              label: Text(
                  loc.filterActiveChip(_filter?.conditionCount ?? 0)),
              onPressed: () => _openFilterSheet(context),
              onDeleted: () => _setFilter(null),
            ),
            if (FilterCatalog.isPlayable(filterKind)) ...[
              IconButton(
                icon: const Icon(Icons.play_arrow),
                tooltip: loc.filterPlayResults,
                onPressed: () => _playFiltered(context, filterKind, false),
              ),
              IconButton(
                icon: const Icon(Icons.shuffle),
                tooltip: loc.shufflePlay,
                onPressed: () => _playFiltered(context, filterKind, true),
              ),
              if (_selectedLibraryId != null)
                IconButton(
                  icon: const Icon(Icons.playlist_add),
                  tooltip: loc.filterSaveAsPlaylist,
                  onPressed: () => _saveFilterAsPlaylist(context, filterKind),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Turns the active browse filter into a smart playlist of the selected
  /// library: same filter, kind and grid sort, so browsing the playlist shows
  /// what the grid shows. Only offered for playable kinds — the server rejects
  /// a smart playlist over albums/artists/shows.
  Future<void> _saveFilterAsPlaylist(
      BuildContext context, Enum$FilterKind filterKind) async {
    final filter = _filter;
    final libraryId = _selectedLibraryId;
    if (filter == null || libraryId == null) return;
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final client = GraphQLProvider.of(context).value;

    final name = await showPlaylistNameDialog(context, loc.filterSaveAsPlaylist);
    if (name == null) return;

    final playlist = await PlaylistService.create(
      client,
      name: name,
      libraryId: libraryId,
      type: Enum$PlaylistType.SMART,
      filter: filter,
      filterKind: filterKind,
      sorting: _effectiveSorting,
      sortingOrder: _effectiveSortingOrder,
    );
    if (!mounted) return;
    if (playlist == null) {
      messenger.showSnackBar(
          SnackBar(content: Text(loc.filterPlaylistSaveFailed)));
      return;
    }
    messenger.showSnackBar(SnackBar(
      content: Text(loc.filterPlaylistCreated(playlist.name)),
      action: SnackBarAction(
        label: loc.filterPlaylistOpen,
        // Resolved on tap: the page's own context is the router descendant,
        // and it outlives the snackbar.
        onPressed: () => AutoRouter.of(this.context)
            .push(PlaylistRoute(playlistId: playlist.id)),
      ),
    ));
  }

  void _playFiltered(
      BuildContext context, Enum$FilterKind filterKind, bool shuffle) {
    final filter = _filter;
    if (filter == null) return;
    final client = GraphQLProvider.of(context).value;
    MediaPlayerHandler.instance.startFilteredPlay(
      client,
      widget.serverName,
      filter.toInput(),
      filterKind,
      libraryId: _selectedLibraryId,
      sorting: _effectiveSorting,
      sortingOrder: _effectiveSortingOrder,
      shuffle: shuffle,
    );
  }

  /// A browse-kind pill, same styling as the Discover/Browse pills.
  Widget _kindPill(BuildContext context, BrowseKind kind) {
    final colors = Theme.of(context).colorScheme;
    final selected = _effectiveKind == kind;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: selected ? colors.onSurface : colors.onSurfaceVariant,
        shape: StadiumBorder(
          side: selected
              ? BorderSide(color: colors.outline)
              : BorderSide.none,
        ),
      ),
      onPressed: () => _setBrowseKind(kind),
      child: Text(_kindLabel(context, kind)),
    );
  }

  String _kindLabel(BuildContext context, BrowseKind kind) {
    final loc = AppLocalizations.of(context)!;
    switch (kind) {
      case BrowseKind.albums:
        return loc.browseKindAlbums;
      case BrowseKind.artists:
        return loc.browseKindArtists;
      case BrowseKind.tracks:
        return loc.browseKindTracks;
      case BrowseKind.shows:
        return loc.browseKindShows;
      case BrowseKind.episodes:
        return loc.browseKindEpisodes;
    }
  }

  String _currentSortLabel(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ascending = _effectiveSortingOrder == Enum$SortingOrder.ASCENDING;
    final airDate = _effectiveKind == BrowseKind.episodes;
    switch (_effectiveSorting) {
      case Enum$SortingEnum.DATE_CREATED:
        return ascending ? loc.sortDateAddedOldest : loc.sortDateAddedNewest;
      case Enum$SortingEnum.RELEASE_YEAR:
        if (airDate) {
          return ascending ? loc.sortAirDateOldest : loc.sortAirDateNewest;
        }
        return ascending
            ? loc.sortReleaseYearOldest
            : loc.sortReleaseYearNewest;
      default:
        return ascending ? loc.sortNameAsc : loc.sortNameDesc;
    }
  }

  Widget _buildBody() {
    // The sort key/order and browse kind are part of the key so changing them rebuilds the grid
    // and re-runs the query from page 0 (pages in the old and new order must never share one
    // list). The grid/list layout is deliberately NOT in the key: it is a plain parameter, so
    // toggling it keeps the already-loaded pages.
    final key = ValueKey('${_selectedLibraryId ?? 'all'}-$_refreshCount'
        '-${_effectiveSorting.name}-${_effectiveSortingOrder.name}-'
        '${_discoverView ? 'discover' : 'browse'}'
        '-${_effectiveKind?.name ?? 'default'}'
        '-${_filter?.encode() ?? 'nofilter'}');
    final filterInput = _filter?.toInput();
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
        filter: filterInput,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.SHOW) {
      if (_effectiveKind == BrowseKind.episodes) {
        return EpisodeScroll(
          key: key,
          serverName: widget.serverName,
          filter: filterInput,
          libraryId: _selectedLibraryId,
          sorting: _effectiveSorting,
          sortingOrder: _effectiveSortingOrder,
          listLayout: _listLayout,
        );
      }
      return TvShowScroll(
        key: key,
        serverName: widget.serverName,
        filter: filterInput,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MUSIC) {
      if (_effectiveKind == BrowseKind.artists) {
        return ArtistScroll(
          key: key,
          serverName: widget.serverName,
          filter: filterInput,
          libraryId: _selectedLibraryId,
          sorting: _effectiveSorting,
          sortingOrder: _effectiveSortingOrder,
          listLayout: _listLayout,
        );
      }
      if (_effectiveKind == BrowseKind.tracks) {
        return TrackScroll(
          key: key,
          serverName: widget.serverName,
          filter: filterInput,
          libraryId: _selectedLibraryId,
          sorting: _effectiveSorting,
          sortingOrder: _effectiveSortingOrder,
          listLayout: _listLayout,
        );
      }
      return AlbumScroll(
        key: key,
        serverName: widget.serverName,
        filter: filterInput,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.BOOK) {
      return BookScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.COMIC) {
      return SeriesScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.PODCAST) {
      return PodcastScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MOVIE) {
      return MovieScroll(
        key: key,
        serverName: widget.serverName,
        filter: filterInput,
        libraryId: _selectedLibraryId,
        sorting: _effectiveSorting,
        sortingOrder: _effectiveSortingOrder,
        listLayout: _listLayout,
      );
    } else {
      // Type not resolved yet (e.g. restored ID without a stored type). Wait for
      // the libraries query rather than guessing a widget and querying the wrong
      // content type against the library.
      return const Center(child: CircularProgressIndicator());
    }
  }

  /// The sort options offered for the selected library and browse kind.
  /// Release-year sorting is hidden for podcasts, which have no release year
  /// (the server folds it onto the title as a safety net), and for artists,
  /// where it would be meaningless; for episodes it is labelled as air date.
  List<Widget> _sortMenuItems(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final kind = _effectiveKind;
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
    if (kind == BrowseKind.episodes) {
      items.add(_sortMenuItem(context, loc.sortAirDateNewest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.DESCENDING));
      items.add(_sortMenuItem(context, loc.sortAirDateOldest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.ASCENDING));
    } else if (_selectedLibraryType != Enum$LibraryType.PODCAST &&
        kind != BrowseKind.artists) {
      items.add(_sortMenuItem(context, loc.sortReleaseYearNewest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.DESCENDING));
      items.add(_sortMenuItem(context, loc.sortReleaseYearOldest,
          Enum$SortingEnum.RELEASE_YEAR, Enum$SortingOrder.ASCENDING));
    }
    return items;
  }

  Widget _sortMenuItem(BuildContext context, String label,
      Enum$SortingEnum sorting, Enum$SortingOrder order) {
    final selected =
        _effectiveSorting == sorting && _effectiveSortingOrder == order;
    return MenuItemButton(
      onPressed: () => _setSorting(context, sorting, order),
      child: ListTile(
        leading: Icon(selected ? Icons.check : Icons.sort),
        title: Text(label),
      ),
    );
  }
}
