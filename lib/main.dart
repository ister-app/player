import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/url_strategy_stub.dart'
    if (dart.library.html) 'utils/url_strategy_web.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_route/auto_route.dart';
import 'package:player/routes/AppRouter.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/AppLogStore.dart';
import 'package:player/utils/AppMessenger.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:player/utils/LanguageService.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:player/utils/TvDirectionalFocusPolicy.dart';

import 'l10n/app_localizations.dart';
import 'utils/download/DownloadForegroundService.dart';
import 'utils/download/DownloadService.dart';
import 'utils/download/MusicCacheService.dart';

Future<void> main() async {
  configureUrlStrategy();
  if (kIsWeb) {
    const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
    LoggerService().logger.d('Is running in wasm: $isRunningWithWasm');
  }
  WidgetsFlutterBinding.ensureInitialized();
  // Mirror every log line into the rolling on-disk log (exported from the
  // settings page) and route uncaught errors through it, before the awaited
  // init below so boot failures are captured too.
  unawaited(AppLogStore.instance.install());
  FlutterError.onError = (details) {
    LoggerService().logger.e('Uncaught Flutter error',
        error: details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerService().logger
        .e('Uncaught error', error: error, stackTrace: stack);
    return false;
  };
  LoggerService().logger.i("Starting Ister Player");
  // Init the client manager and wait until lastClientUsed is loaded
  ClientManager.instance;
  await ClientManager.ensureInitialized();
  // Populate the in-memory well-known cache before the first frame. A cold web
  // load can land straight on a root deep link (e.g. a restored `/remote/...`
  // URL) that reaches ClientManager.createClient synchronously in initState,
  // before any page has run WellKnownService.fetch — without this the missing
  // cache entry throws and a release web build renders the crash as a grey
  // screen.
  await WellKnownService.hydrateCacheFromPrefs();
  final initialServer = ClientManager.instance.lastClientUsed;
  // The track menu labels languages from a synchronous function, so both
  // language tables have to be in memory before anything renders.
  await LanguageService().ensureLoaded();
  registerLanguageDataLicenses();
  // Detect Android TV up front so the UI can branch synchronously in build().
  await PlatformService.ensureInitialized();
  if (PlatformService.isAndroidTvSync) {
    // Android defaults to "touch" focus-highlight mode and doesn't reliably
    // flip to "traditional" for a D-pad remote, leaving focus rings invisible.
    // Force traditional so every focusable (buttons, tiles, nav) shows where
    // the selection is.
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  }
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
      // Tell Android Auto we emit content-style hints; browse nodes opt into
      // grid rendering per item (see IsterMediaService).
      androidBrowsableRootExtras: <String, dynamic>{
        'android.media.browse.CONTENT_STYLE_SUPPORTED': true,
        'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 1,
        'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1,
      },
    ),
  );

  // Resume queued downloads and make completed ones playable (no-op on web).
  unawaited(DownloadForegroundService.install());
  unawaited(DownloadService.instance.ensureStarted().then((_) {
    MusicCacheService.instance.ensurePeriodic();
    for (final server in DownloadService.instance.store.loadedServers) {
      MusicCacheService.instance.schedule(server, delay: const Duration(seconds: 15));
    }
  }));

  runApp(Main(initialServer: initialServer));
}

/// Page transitions with snapshotting switched off.
///
/// The default zoom transition rasterises the outgoing page once via
/// `OffsetLayer.toImageSync()`. A `TextureLayer` — the video surface — does not
/// report itself as unrasterisable the way a platform view does, so it is
/// dragged into that snapshot; the engine then paints it with a `PaintContext`
/// that carries neither an Impeller nor a Skia context and dereferences the
/// null `GrDirectContext`, segfaulting the raster thread. Leaving a video page
/// (e.g. tapping "home" mid-playback) therefore killed the app. Painting the
/// page live instead looks identical and costs nothing here.
const _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.linux: ZoomPageTransitionsBuilder(allowSnapshotting: false),
    TargetPlatform.windows:
        ZoomPageTransitionsBuilder(allowSnapshotting: false),
    // Android's predictive-back builder falls back to the same zoom
    // transition, and its external textures crash the same way.
    TargetPlatform.android:
        ZoomPageTransitionsBuilder(allowSnapshotting: false),
  },
);

/// Keeps a snackbar's action on the same line as its text.
///
/// Material moves the action to a second row once its label is wider than a
/// quarter of the bar — *and* then still reserves 40% of the width beside the
/// text, so the text wraps too. A Dutch "Ongedaan maken" trips that at every
/// phone width, turning a one-line snackbar into a 110px block. At 1.0 the
/// action always stays inline and the text simply takes what is left, wrapping
/// only when it genuinely does not fit.
const appSnackBarTheme = SnackBarThemeData(actionOverflowThreshold: 1.0);

/// The stack the app boots into when [lastServer] was already in use, for a
/// launch that carries no deep link of its own.
///
/// Built from the route rather than from the path `/server/<name>`: a path
/// deep link also prefix-matches "/", which would leave [HomeRoute] — the
/// server list — sitting underneath the server's shell, so the Android back
/// button would surface that list instead of leaving the app. Going through
/// the route also keeps a server identifier that contains a path
/// (`localhost:8080/api`) out of a URL round-trip it does not survive.
DeepLink bootDeepLink(PlatformDeepLink platformDeepLink, String lastServer) {
  if (platformDeepLink.path.isEmpty || platformDeepLink.path == '/') {
    return DeepLink.single(ServerHomeRoute(serverName: lastServer));
  }
  return platformDeepLink;
}

class Main extends StatefulWidget {
  const Main({super.key, this.initialServer});

  final String? initialServer;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late final RouterConfig<UrlState> _routerConfig;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    // Doze / a network switch while backgrounded can leave the GraphQL
    // websocket half-open: HTTP recovers per request, but the socket never
    // errors and every subscription silently freezes. Resume is exactly when
    // that state becomes user-visible, so force a reconnect cycle here — the
    // socket client re-registers all live subscriptions on the new connection.
    _lifecycleListener =
        AppLifecycleListener(onResume: ClientManager.resetWebSockets);
    final appRouter = AppRouter();
    _routerConfig = appRouter.config(
      deepLinkBuilder: widget.initialServer != null
          ? (platformDeepLink) =>
              bootDeepLink(platformDeepLink, widget.initialServer!)
          : null,
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // POST_NOTIFICATIONS is a runtime permission since targetSdk 33; without
      // it the audio_service foreground notification is silently suppressed.
      // Request after the first frame so an activity is attached — main() also
      // runs during headless audio-service restore, where there is none.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Permission.notification.request();
      });
    }
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ister',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      // On Android TV use directional navigation mode. Among other things it
      // tells widgets like Slider to only bind left/right to adjustment and let
      // up/down move focus out — so the progress bar no longer traps the D-pad.
      // The traversal policy keeps vertical D-pad moves inside the page's
      // scrollable while unvisited items remain, so below-the-fold content
      // (e.g. the season list on the show page) isn't shadowed by the mini
      // player bar.
      builder: PlatformService.isAndroidTvSync
          ? (context, child) => FocusTraversalGroup(
                policy: TvDirectionalFocusPolicy(),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(navigationMode: NavigationMode.directional),
                  child: child ?? const SizedBox.shrink(),
                ),
              )
          : null,
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4D7C0F)),
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        pageTransitionsTheme: _pageTransitionsTheme,
        snackBarTheme: appSnackBarTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4D7C0F), brightness: Brightness.dark),
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        pageTransitionsTheme: _pageTransitionsTheme,
        snackBarTheme: appSnackBarTheme,
      ),
      routerConfig: _routerConfig,
    );
  }
}
