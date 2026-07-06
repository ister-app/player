import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oidc/oidc.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../components/MiniPlayer.dart';
import '../l10n/app_localizations.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';
import '../utils/PlatformService.dart';
import '../utils/StreamTokenService.dart';
import '../utils/TabNavigationNotifier.dart';

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
  OidcDeviceAuthorizationResponse? _deviceAuthResponse;

  static Future<void> startLogin(String serverUrl) async {
    await LoginManager.startLogin(serverUrl);
  }

  @override
  void initState() {
    super.initState();
    _wellKnownFuture = WellKnownService.fetch(widget.serverName);
  }

  void _navigate(BuildContext context, int index) {
    tabNavigationNotifier.value = index;
    // AutoRouter.of(context) here resolves to the root router (ServerHomePage is
    // above the inner AutoRouter). Use innerRouterOf to reach ServerHomeRoute's stack.
    final innerRouter = context.router.root
        .innerRouterOf<StackRouter>(ServerHomeRoute.name);
    if (innerRouter != null && innerRouter.canPop()) {
      innerRouter.popUntilRoot();
    }
  }

  Widget _buildShell(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isWideScreen = MediaQuery.of(context).size.width >= 1280;

    final railDestinations = <NavigationRailDestination>[
      NavigationRailDestination(icon: const Icon(Icons.home), label: Text(loc.home)),
      NavigationRailDestination(icon: const Icon(Icons.book), label: Text(loc.library)),
      NavigationRailDestination(icon: const Icon(Icons.settings), label: Text(loc.settings)),
    ];
    final barDestinations = <NavigationDestination>[
      NavigationDestination(icon: const Icon(Icons.home), label: loc.home),
      NavigationDestination(icon: const Icon(Icons.book), label: loc.library),
      NavigationDestination(icon: const Icon(Icons.settings), label: loc.settings),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: tabNavigationNotifier,
      builder: (context, tabIndex, _) {
        return Scaffold(
          body: Row(
            children: [
              if (isWideScreen) ...[
                NavigationRail(
                  minWidth: 100,
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: tabIndex,
                  onDestinationSelected: (i) => _navigate(context, i),
                  destinations: railDestinations,
                ),
                const VerticalDivider(thickness: 1, width: 5),
              ],
              const Expanded(
                key: ValueKey('router-content'),
                child: AutoRouter(),
              ),
            ],
          ),
          bottomNavigationBar: isWideScreen
              ? const MiniPlayer()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MiniPlayer(),
                    NavigationBar(
                      selectedIndex: tabIndex,
                      onDestinationSelected: (i) => _navigate(context, i),
                      destinations: barDestinations,
                    ),
                  ],
                ),
        );
      },
    );
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
                        return _buildShell(context);
                      },
                    );
                  } else {
                    final loc = AppLocalizations.of(context)!;
                    return Scaffold(
                      appBar: AppBar(title: Text(info.name)),
                      body: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              if (_deviceAuthResponse == null)
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final isTV =
                                        await PlatformService.isAndroidTv();
                                    if (isTV) {
                                      try {
                                        await LoginManager.startDeviceLogin(
                                          widget.serverName,
                                          onVerification: (response) {
                                            setState(() {
                                              _deviceAuthResponse = response;
                                            });
                                          },
                                        );
                                      } catch (e) {
                                        LoggerService().logger.e('Device login failed: $e');
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            _deviceAuthResponse = null;
                                          });
                                        }
                                      }
                                    } else {
                                      startLogin(widget.serverName);
                                    }
                                  },
                                  icon: const Icon(Icons.login),
                                  label: Text(loc.loginButton(widget.serverName)),
                                ),
                              if (_deviceAuthResponse != null) ...[
                                Text(loc.deviceFlowInstructions),
                                const SizedBox(height: 16),
                                QrImageView(
                                  data: (_deviceAuthResponse!.verificationUriComplete ??
                                          _deviceAuthResponse!.verificationUri)
                                      .toString(),
                                  version: QrVersions.auto,
                                  size: 200,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                SelectableText(
                                  _deviceAuthResponse!.verificationUri.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _deviceAuthResponse!.userCode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        letterSpacing: 6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                const CircularProgressIndicator(),
                              ],
                            ],
                          ),
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
