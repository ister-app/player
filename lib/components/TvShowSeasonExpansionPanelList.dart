import 'package:flutter/material.dart';
import 'package:player/components/TvShowSeasonList.dart';

import '../graphql/showById.graphql.dart';
import '../l10n/app_localizations.dart';

class TvShowSeasonExpansionPanelList extends StatefulWidget {
  final String serverName;
  final List<Query$showById$showById$seasons>? seasons;

  const TvShowSeasonExpansionPanelList({
    super.key,
    required this.serverName,
    required this.seasons,
  });

  @override
  State<TvShowSeasonExpansionPanelList> createState() =>
      _TvShowSeasonExpansionPanelListState();
}

class _TvShowSeasonExpansionPanelListState
    extends State<TvShowSeasonExpansionPanelList> {
  String? _expanded = "";

  /// A show with a single season has nothing to choose between, so that season
  /// stays open instead of hiding its episodes behind a tap.
  bool get _singleSeason => widget.seasons?.length == 1;

  bool _isExpanded(Query$showById$showById$seasons season) =>
      _singleSeason || _expanded == season.id;

  @override
  Widget build(BuildContext context) {
    if (widget.seasons == null) {
      return Text(AppLocalizations.of(context)!.noSeasonsFound);
    } else {
      return ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            if (_singleSeason) return;
            setState(() {
              if (isExpanded) {
                _expanded = widget.seasons?[index].id;
              } else {
                _expanded = null;
              }
            });
          },
          children: widget.seasons!.map<ExpansionPanel>((season) {
            return ExpansionPanel(
                headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                        AppLocalizations.of(context)!.season(season.number)),
                    onTap: _singleSeason
                        ? null
                        : () => setState(
                              () {
                                if (_expanded == season.id) {
                                  _expanded = null;
                                } else {
                                  _expanded = season.id;
                                }
                              },
                            )),
                body: TvShowSeasonList(
                  serverName: widget.serverName,
                  seasonId: season.id,
                  expanded: _isExpanded(season),
                ),
                isExpanded: _isExpanded(season));
          }).toList());
    }
  }
}
