import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../components/TvShowScroll.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class ShowHomePage extends StatelessWidget {
  final String serverName;

  const ShowHomePage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.library),
        ),
        body: TvShowScroll(serverName: serverName));
  }
}
