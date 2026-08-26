import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/RelatedShowsRow.dart';
import '../l10n/app_localizations.dart';

/// Every show comparable to one show as a vertical grid — the "show all" page
/// behind [RelatedShowsRow]'s header, built from the same query the strip uses
/// (with a larger limit, since the strip only shows the first handful).
@RoutePage()
class RelatedShowsPage extends StatelessWidget {
  const RelatedShowsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    @QueryParam() this.showId,
  });

  final String serverName;
  final String? showId;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.relatedShows)),
      body: showId == null
          ? const SizedBox.shrink()
          : RelatedShowsRow(
              serverName: serverName,
              showId: showId!,
              limit: kRelatedShowsPageLimit,
              scrollDirection: Axis.vertical,
            ),
    );
  }
}
