import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/libraries.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../components/MovieScroll.dart';
import '../components/TvShowScroll.dart';
import '../l10n/app_localizations.dart';

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
    } catch (_) {}
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
                DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedLibraryId,
                    items: libraries.map((lib) => DropdownMenuItem<String?>(
                          value: lib.id,
                          child: Text(lib.name),
                        )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLibraryId = value;
                        _selectedLibraryType = value == null
                            ? null
                            : libraries.firstWhere((l) => l.id == value).type;
                      });
                    },
                  ),
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
