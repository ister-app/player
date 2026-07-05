import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForLibrary.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/AlbumScroll.dart';
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
    });
    await _prefs.setString('${_kSelectedLibraryKey}_${widget.serverName}', lib.id);
    await _prefs.setString('${_kSelectedLibraryTypeKey}_${widget.serverName}', lib.type.name);
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
          if (match != null && _selectedLibraryType != match.type) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _selectedLibraryType = match.type;
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
              if (_selectedLibraryId != null)
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
              if (_selectedLibraryId != null)
                MenuAnchor(
                  menuChildren: <Widget>[
                    MenuItemButton(
                      onPressed: () async {
                        final client = GraphQLProvider.of(context).value;
                        await client.mutate(MutationOptions(
                          document: documentNodeMutationanalyzeDataForLibraryMutation,
                          variables: {'libraryId': _selectedLibraryId},
                        ));
                      },
                      child: ListTile(
                        leading: const Icon(Icons.analytics),
                        title: Text(AppLocalizations.of(context)!.analyzeLibrary),
                      ),
                    ),
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
    final key = ValueKey('${_selectedLibraryId ?? 'all'}-$_refreshCount');
    if (_selectedLibraryId == null) {
      return TvShowScroll(
        key: key,
        serverName: widget.serverName,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.SHOW) {
      return TvShowScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MUSIC) {
      return AlbumScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    } else if (_selectedLibraryType == Enum$LibraryType.MOVIE) {
      return MovieScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    } else {
      // Type not resolved yet (e.g. restored ID without a stored type). Wait for
      // the libraries query rather than guessing a widget and querying the wrong
      // content type against the library.
      return const Center(child: CircularProgressIndicator());
    }
  }
}
