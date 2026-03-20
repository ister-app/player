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

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: documentNodeQuerylibraries,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        final libraries = result.data == null
            ? <Query$libraries$libraries>[]
            : (Query$libraries.fromJson(result.data!).libraries ??
                <Query$libraries$libraries>[]);

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.library),
            actions: [
              if (libraries.isNotEmpty)
                DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedLibraryId,
                    items: [
                      ...libraries.map((lib) => DropdownMenuItem<String?>(
                            value: lib.id,
                            child: Text(lib.name),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLibraryId = value;
                        _selectedLibraryType = value == null
                            ? null
                            : libraries
                                .firstWhere((l) => l.id == value)
                                .type;
                      });
                    },
                  ),
                ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_selectedLibraryId == null) {
      // Show all: shows + movies
      return Column(
        children: [
          Expanded(
            child: TvShowScroll(serverName: widget.serverName),
          ),
        ],
      );
    } else if (_selectedLibraryType == Enum$LibraryType.SHOW) {
      return TvShowScroll(
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    } else {
      return MovieScroll(
        serverName: widget.serverName,
        libraryId: _selectedLibraryId,
      );
    }
  }
}
