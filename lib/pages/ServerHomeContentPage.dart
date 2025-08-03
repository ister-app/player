import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/TvShowSlide.dart';
import 'package:player/graphql/scanLibrary.graphql.dart';

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
    GraphQLClient graphQLClient = GraphQLProvider.of(context).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverName),
        actions: [
          MenuAnchor(
            menuChildren: <Widget>[
              MenuItemButton(
                  onPressed: () {
                    scanLibrary(graphQLClient);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text(AppLocalizations.of(context)!.scanLibrary),
                  )),
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
          )
        ],
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

  Future<void> scanLibrary(GraphQLClient graphQLClient) async {
    final MutationOptions options = MutationOptions(
      document: documentNodeMutationscanLibrary,
    );
    final QueryResult result = await graphQLClient.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return;
    }
  }
}
