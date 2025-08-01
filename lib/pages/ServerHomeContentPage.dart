import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/TvShowSlide.dart';

import '../components/RecentCarouselView.dart';
import '../l10n/app_localizations.dart';

@RoutePage()
class ServerHomeContentPage extends StatefulWidget {
  const ServerHomeContentPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<StatefulWidget> createState() => _ServerHomeContentPageState();
}

class _ServerHomeContentPageState extends State<ServerHomeContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
      ),
      body: ListView(children: [
        Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "${AppLocalizations.of(context)!.watchNext}:",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )),
        SizedBox(
            height: 200,
            child: RecentCarouselView(
              serverName: widget.serverName,
            )),
        Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "${AppLocalizations.of(context)!.recentlyAddedShows}:",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )),
        SizedBox(
            height: 200,
            child: Tvshowslide(
              serverName: widget.serverName,
            ))
      ]),
    );
  }
}
