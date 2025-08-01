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

  @override
  Widget build(BuildContext context) {
    if (widget.seasons == null) {
      return Text("No seasons found");
    } else {
      return ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
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
                    onTap: () => setState(
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
                  expanded: _expanded == season.id,
                ),
                isExpanded: _expanded == season.id);
          }).toList());
    }
  }
}
