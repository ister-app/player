import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/analyzeDataForLibrary.graphql.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _refresh() async {
    try {
      if (_refetchLibraries != null) await _refetchLibraries!();
    } catch (e) {
      LoggerService().logger.w('Failed to refetch libraries: $e');
    }
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

        // Auto-select first library when loaded
        if (_selectedLibraryId == null && libraries.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _selectedLibraryId = libraries.first.id;
              _selectedLibraryType = libraries.first.type;
            });
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.library),
            actions: [
              if (libraries.isNotEmpty)
                MenuAnchor(
                  menuChildren: libraries.map((lib) => MenuItemButton(
                    onPressed: () {
                      setState(() {
                        _selectedLibraryId = lib.id;
                        _selectedLibraryType = lib.type;
                      });
                    },
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
    } else {
      return MovieScroll(
        key: key,
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    }
  }
}
