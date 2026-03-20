import 'package:audio_service/audio_service.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerService().logger.i("Starting Ister Player");
  // Init the client manager
  ClientManager.instance;
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

  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

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
          routerConfig: appRouter.config(),
        );
      },
    );
  }
}
