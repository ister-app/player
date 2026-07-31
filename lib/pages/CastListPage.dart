import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/CastRow.dart';
import '../l10n/app_localizations.dart';

/// The full cast of a movie, show or episode as a vertical grid — the "show
/// all" page behind [PagedCastRow]'s header. Supply exactly one of
/// [showId]/[movieId]/[episodeId], like the row itself.
@RoutePage()
class CastListPage extends StatelessWidget {
  const CastListPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    this.showId,
    this.movieId,
    this.episodeId,
  });

  final String serverName;
  final String? showId;
  final String? movieId;
  final String? episodeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.cast)),
      body: PagedCastRow(
        serverName: serverName,
        showId: showId,
        movieId: movieId,
        episodeId: episodeId,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
