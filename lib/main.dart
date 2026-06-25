import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/url_strategy_stub.dart'
    if (dart.library.html) 'utils/url_strategy_web.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {
  configureUrlStrategy();
  if (kIsWeb) {
    const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
    LoggerService().logger.d('Is running in wasm: $isRunningWithWasm');
  }
  WidgetsFlutterBinding.ensureInitialized();
  LoggerService().logger.i("Starting Ister Player");
  // Init the client manager and wait until lastClientUsed is loaded
  ClientManager.instance;
  await ClientManager.ensureInitialized();
  final initialServer = ClientManager.instance.lastClientUsed;
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  // store this in a singleton
  await AudioService.init(
    builder: () => MediaPlayerHandler.instance,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'app.ister.player.channel.audio',
      androidNotificationChannelName: 'Ister Player',
      // Keep the foreground service alive while paused / between tracks. On
      // Android 16 a backgrounded app may not restart a foreground service, so
      // tearing it down on every pause would block the next track from playing
      // until the app is reopened. (androidNotificationOngoing is incompatible
      // with this and unnecessary — the service stays foreground regardless.)
      androidStopForegroundOnPause: false,
    ),
  );

  runApp(Main(initialServer: initialServer));
}

class Main extends StatefulWidget {
  const Main({super.key, this.initialServer});

  final String? initialServer;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late final RouterConfig<UrlState> _routerConfig;

  @override
  void initState() {
    super.initState();
    final appRouter = AppRouter();
    _routerConfig = appRouter.config(
      deepLinkBuilder: widget.initialServer != null
          ? (platformDeepLink) {
              if (platformDeepLink.path == '/' || platformDeepLink.path.isEmpty) {
                return DeepLink.path('/server/${widget.initialServer}');
              }
              return platformDeepLink;
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ister',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('nl'), // Dutch
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      routerConfig: _routerConfig,
    );
  }
}
