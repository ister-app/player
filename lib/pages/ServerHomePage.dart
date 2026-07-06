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

/// How to escape a focus scope in one direction: [onEscape] hands focus to the
/// neighbouring area. When [atEdge] is set it decides up-front whether we're at
/// the edge (needed for left, where Flutter's directional search would otherwise
/// jump diagonally to another row and never report the edge); when it's null we
/// fall back to "the normal move found nothing", which is reliable for the
/// down/up/right edges.
typedef _Escape = ({bool Function()? atEdge, VoidCallback onEscape});

/// Overrides directional focus movement inside a focus scope so the D-pad can
/// cross into a neighbouring area (rail ⇄ content ⇄ mini player) at the edges
/// instead of getting stuck. Directions without an [escapes] entry move normally.
class _EdgeEscapeAction extends Action<DirectionalFocusIntent> {
  _EdgeEscapeAction(this.escapes);

  final Map<TraversalDirection, _Escape> escapes;

  @override
  void invoke(DirectionalFocusIntent intent) {
    final escape = escapes[intent.direction];
    final focus = FocusManager.instance.primaryFocus;
    if (escape == null) {
      focus?.focusInDirection(intent.direction);
      return;
    }
    if (escape.atEdge != null) {
      if (escape.atEdge!()) {
        escape.onEscape();
      } else {
        focus?.focusInDirection(intent.direction);
      }
      return;
    }
    // No explicit edge test: try to move, and escape only if nothing was there.
    final moved = focus?.focusInDirection(intent.direction) ?? false;
    if (!moved) escape.onEscape();
  }
}

class _ServerHomePageState extends State<ServerHomePage> {
  late Future<WellKnownInfo?> _wellKnownFuture;
  Future<void>? _initFuture;
  Future<String?>? _tokenFuture;
  OidcDeviceAuthorizationResponse? _deviceAuthResponse;

  // TV D-pad navigation between the left rail, the content, and the mini
  // player. Flutter's geometric directional traversal doesn't reliably cross
  // these areas (it lands on the wrong tile, or falls out of the app), so each
  // area is its own focus scope and we hand focus across at the edges via
  // [_EdgeEscapeAction].
  final FocusScopeNode _railScope = FocusScopeNode(debugLabel: 'railScope');
  final FocusScopeNode _contentScope =
      FocusScopeNode(debugLabel: 'contentScope');
  final FocusScopeNode _miniScope = FocusScopeNode(debugLabel: 'miniScope');
  final GlobalKey _contentKey = GlobalKey();

  static Future<void> startLogin(String serverUrl) async {
    await LoginManager.startLogin(serverUrl);
  }

  @override
  void initState() {
    super.initState();
    _wellKnownFuture = WellKnownService.fetch(widget.serverName);
  }

  @override
  void dispose() {
    _railScope.dispose();
    _contentScope.dispose();
    _miniScope.dispose();
    super.dispose();
  }

  /// Whether the focused widget sits against the left edge of the content, so
  /// left should escape to the rail. Uses geometry because Flutter's directional
  /// search would otherwise jump diagonally to a tile in another row instead of
  /// reporting that there's nothing further left.
  bool _focusAtContentLeftEdge() {
    final focused = FocusManager.instance.primaryFocus;
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (focused == null || box == null || !box.attached) return false;
    final contentLeft = box.localToGlobal(Offset.zero).dx;
    // 40 logical px clears the first column's padding but stays well left of
    // the second column.
    return focused.rect.left <= contentLeft + 40;
  }

  /// Moves focus into the mini player, but only when it actually has something
  /// focusable (i.e. media is playing); otherwise focus stays in the content.
  void _focusMiniPlayer() {
    final hasTarget =
        _miniScope.traversalDescendants.any((n) => n.canRequestFocus);
    if (hasTarget) _miniScope.requestFocus();
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
    // Android TV always uses the left rail: a D-pad reaches it by pressing LEFT
    // out of the horizontal content rows, whereas a bottom bar is trapped below
    // an ever-scrolling grid and can't be reached.
    final isWideScreen = MediaQuery.of(context).size.width >= 1280 ||
        PlatformService.isAndroidTvSync;

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
                FocusScope(
                  node: _railScope,
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      // Right anywhere in the rail jumps back to the content.
                      DirectionalFocusIntent: _EdgeEscapeAction({
                        TraversalDirection.right: (
                          atEdge: null,
                          onEscape: () => _contentScope.requestFocus(),
                        ),
                      }),
                    },
                    child: NavigationRail(
                      minWidth: 100,
                      labelType: NavigationRailLabelType.all,
                      selectedIndex: tabIndex,
                      onDestinationSelected: (i) => _navigate(context, i),
                      destinations: railDestinations,
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 5),
              ],
              Expanded(
                key: const ValueKey('router-content'),
                child: FocusScope(
                  node: _contentScope,
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      // At the content's edges, left escapes to the rail and
                      // down drops into the mini player; within the content the
                      // move happens normally.
                      if (isWideScreen)
                        DirectionalFocusIntent: _EdgeEscapeAction({
                          TraversalDirection.left: (
                            atEdge: _focusAtContentLeftEdge,
                            onEscape: () => _railScope.requestFocus(),
                          ),
                          TraversalDirection.down: (
                            atEdge: null,
                            onEscape: _focusMiniPlayer,
                          ),
                        }),
                    },
                    child: KeyedSubtree(
                      key: _contentKey,
                      child: const AutoRouter(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWideScreen
              ? FocusScope(
                  node: _miniScope,
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      // Up out of the mini player returns to the content.
                      DirectionalFocusIntent: _EdgeEscapeAction({
                        TraversalDirection.up: (
                          atEdge: null,
                          onEscape: () => _contentScope.requestFocus(),
                        ),
                      }),
                    },
                    child: const MiniPlayer(),
                  ),
                )
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
