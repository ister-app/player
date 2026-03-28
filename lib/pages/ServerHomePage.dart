import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oidc/oidc.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';

import '../l10n/app_localizations.dart';
import '../utils/LoginManager.dart';
import '../utils/StreamTokenService.dart';

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
  late Future<WellKnownInfo?> _wellKnownFuture;
  Future<void>? _initFuture;
  Future<String?>? _tokenFuture;

  static Future<void> startLogin(String serverUrl) async {
    await LoginManager.startLogin(serverUrl);
  }

  @override
  void initState() {
    super.initState();
    _wellKnownFuture = WellKnownService.fetch(widget.serverName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WellKnownInfo?>(
      future: _wellKnownFuture,
      builder: (context, infoSnapshot) {
        if (infoSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.serverName)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final info = infoSnapshot.data;
        if (info == null) {
          final loc = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(title: Text(widget.serverName)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    loc.serverUnreachable,
                    style: const TextStyle(fontSize: 18),
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
            ),
          );
        }

        _initFuture ??=
            LoginManager.initIfNotExists(widget.serverName, info.oidcUrl);

        return FutureBuilder(
          future: _initFuture,
          builder: (context, initSnapshot) {
            if (initSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(title: Text(info.name)),
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            return GraphQLProvider(
              client: ClientManager.getClientForUrl(widget.serverName),
              child: StreamBuilder(
                stream: LoginManager.isLoggedInSteam(widget.serverName),
                builder: (BuildContext context,
                    AsyncSnapshot<OidcUser?> snapshot) {
                  if (LoginManager.isLoggedIn(widget.serverName)) {
                    _tokenFuture ??=
                        StreamTokenService.ensureToken(widget.serverName);
                    return FutureBuilder(
                      future: _tokenFuture,
                      builder: (context, tokenSnapshot) {
                        if (tokenSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            appBar: AppBar(title: Text(info.name)),
                            body: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return AutoRouter();
                      },
                    );
                  } else {
                    final loc = AppLocalizations.of(context)!;
                    return Scaffold(
                      appBar: AppBar(title: Text(info.name)),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_outline, size: 64),
                            const SizedBox(height: 24),
                            Text(
                              loc.loginTitle,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.loginDescription(widget.serverName),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                startLogin(widget.serverName);
                              },
                              icon: const Icon(Icons.login),
                              label: Text(loc.loginButton(widget.serverName)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
