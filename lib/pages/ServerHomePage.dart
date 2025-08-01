import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oidc/oidc.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:player/utils/ClientManager.dart';

import '../utils/LoginManager.dart';

@RoutePage()
class ServerHomePage extends StatefulWidget {
  const ServerHomePage({
    super.key,
    @PathParam('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerHomePage> createState() => _ServerHomePageState();
}

class _ServerHomePageState extends State<ServerHomePage> {
  static Future<void> startLogin(
      String serverUrl, String discoveryDocumentUri) async {
    await LoginManager.startLogin(serverUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: ClientManager.getClientForUrl(widget.serverName),
        child: Query(
            options:
                QueryOptions(document: documentNodeQuerygetServerInfoQuery),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              Widget body;
              if (result.hasException) {
                body = Text(result.exception.toString());
              } else if (result.isLoading) {
                body = Text('Loading');
              } else {
                LoginManager.initIfNotExists(widget.serverName,
                    result.data?["getServerInfo"]["openIdUrl"]);

                // return Text(result.data?["getServerInfo"]["openIdUrl"]);
                return StreamBuilder(
                    stream: LoginManager.isLoggedInSteam(widget.serverName),
                    builder: (BuildContext context,
                        AsyncSnapshot<OidcUser?> snapshot) {
                      if (LoginManager.isLoggedIn(widget.serverName)) {
                        return AutoRouter();
                      } else {
                        return Scaffold(
                          appBar: AppBar(title: Text(widget.serverName)),
                          body: IconButton(
                              onPressed: () {
                                startLogin(widget.serverName,
                                    result.data?["getServerInfo"]["openIdUrl"]);
                              },
                              icon: Icon(Icons.login)),
                        );
                      }
                    });
              }
              return Scaffold(
                appBar: AppBar(title: Text(widget.serverName)),
                body: body,
              );
            }));
  }
}
