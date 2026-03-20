import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oidc/oidc.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';

import '../l10n/app_localizations.dart';
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
                final loc = AppLocalizations.of(context)!;
                body = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        loc.serverUnreachable,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.exception.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ClientManager.instance.lastClientUsed = null;
                          AutoRouter.of(context).replace(HomeRoute());
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(loc.backToServerOverview),
                      ),
                    ],
                  ),
                );
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
