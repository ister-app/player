import 'package:audio_service/audio_service.dart';
import 'package:dynamic_color/dynamic_color.dart';
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
      androidNotificationOngoing: true,
    ),
  );

  runApp(Main(initialServer: initialServer));
}

class Main extends StatelessWidget {
  const Main({super.key, this.initialServer});

  final String? initialServer;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
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
            colorScheme: lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue),
            brightness: Brightness.light,
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            brightness: Brightness.dark,
            fontFamily: 'Roboto',
          ),
          routerConfig: appRouter.config(
            deepLinkBuilder: initialServer != null
                ? (platformDeepLink) {
                    if (platformDeepLink.path == '/' || platformDeepLink.path.isEmpty) {
                      return DeepLink.path('/server/$initialServer');
                    }
                    return platformDeepLink;
                  }
                : null,
          ),
        );
      },
    );
  }
}
