import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:player/components/PlayerView.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

import 'support/harness.dart';

/// The locales the tour captures, in order; keep in sync with the app's
/// supportedLocales. A single app process serves all of them — the tour
/// switches the platform locale at runtime between passes, so the fragile
/// part of a cold start (mpv/GL init on a fresh Xvfb) happens only once.
const List<String> docLocales = ['en', 'nl'];

/// A guided tour along every documentable screen, taking a screenshot at each
/// stop. Not a functional test — the six feature e2e's assert behaviour; this
/// one only needs each page to render so the user guide has an image of it.
///
/// Screenshots are captured *externally* with ImageMagick's `import` grabbing
/// the app's X11 window: `IntegrationTestWidgetsFlutterBinding.takeScreenshot`
/// has no Linux implementation, and an in-tree `RepaintBoundary.toImage` would
/// miss the media_kit video texture. X capture gets the real compositor
/// output. ci/build-docs.sh runs this under Xvfb (CI) or the live display and
/// sets DOC_SCREENSHOT_DIR; without that variable the tour runs shot-less.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final screenshotDir = Platform.environment['DOC_SCREENSHOT_DIR'];

  // The locale of the pass currently running; shot() files under it.
  var docLocale = docLocales.first;

  Future<void> shot(WidgetTester tester, String name) async {
    // Settle what can settle; live playback never goes idle, hence pump-based.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    if (screenshotDir == null || screenshotDir.isEmpty) return;
    final file = File('$screenshotDir/$docLocale/$name.png');
    await file.parent.create(recursive: true);
    // The window is titled "player" (linux/runner/my_application.cc); fall
    // back to the whole display, which under Xvfb is the app anyway.
    var result =
        await Process.run('import', ['-window', 'player', file.path]);
    if (result.exitCode != 0 || !file.existsSync() || file.lengthSync() == 0) {
      result = await Process.run('import', ['-window', 'root', file.path]);
    }
    if (result.exitCode != 0) {
      fail('screenshot $name failed: ${result.stderr}');
    }
  }

  /// Pops the top-most route (a detail page pushed with [pushRoute]).
  Future<void> pop(WidgetTester tester) async {
    final context = tester.element(find.byType(Scaffold).last);
    await AutoRouter.of(context).maybePop();
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// Returns the app to the server overview between locale passes. Popping
  /// cannot get there: the server card *replaces* the overview with the shell
  /// (ServerList), so the overview is no longer on the root stack — replace
  /// the whole stack with a fresh overview instead. The sticky server must be
  /// cleared first, or the fresh ServerList auto-opens it again in initState.
  Future<void> resetToServerOverview(WidgetTester tester) async {
    ClientManager.instance.lastClientUsed = null;
    final context = tester.element(find.byType(Scaffold).last);
    await AutoRouter.of(context).root.replaceAll([const HomeRoute()]);
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// One full pass along every documentable screen in the current locale.
  Future<void> tour(WidgetTester tester) async {
    // The server overview with the add-server field and the seeded server.
    await pumpUntilFound(tester, find.textContaining('http://'),
        timeout: const Duration(seconds: 30));
    await shot(tester, 'server-overview');

    await enterServerShell(tester);
    // The dashboard: give the carousels a moment to load their artwork.
    await tester.pump(const Duration(seconds: 3));
    await shot(tester, 'home-dashboard');

    // Library tab.
    await tester.tap(find.byIcon(Icons.book).first, warnIfMissed: false);
    await tester.pump(const Duration(seconds: 2));
    await shot(tester, 'library');

    // A show's overview (episode list included).
    final shows = await gqlRaw('{ shows(size: 1) { content { id name } } }');
    final showId = (shows['shows']['content'] as List).first['id'] as String;
    await pushRoute(tester, ShowOverviewRoute(showId: showId));
    await tester.pump(const Duration(seconds: 3));
    await shot(tester, 'show-overview');
    await pop(tester);

    // An album; tapping the first track starts playback and auto-opens the
    // full player, giving the music-player and mini-player shots for free.
    final albums = await gqlRaw('{ albums(size: 1) { content { id name } } }');
    final albumId = (albums['albums']['content'] as List).first['id'] as String;
    await pushRoute(tester, AlbumRoute(albumId: albumId));
    await pumpUntil(
      tester,
      () => tester
          .widgetList<ListTile>(find.byType(ListTile))
          .any((t) => t.onTap != null),
      timeout: const Duration(seconds: 30),
      description: 'a tappable track row on the album page',
    );
    await shot(tester, 'album');

    final trackTile = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .firstWhere((t) => t.onTap != null);
    trackTile.onTap!();
    final player = MediaPlayerHandler.instance.player;
    await pumpUntil(
      tester,
      () => player.state.playing,
      timeout: const Duration(minutes: 3),
      description: 'music playback to start',
    );
    // The full player overlay opened itself on playback start.
    await tester.pump(const Duration(seconds: 1));
    await shot(tester, 'music-player');
    PlayerView.activeBackHandler?.call();
    await tester.pump(const Duration(seconds: 1));
    // Back on the album page with the mini player docked at the bottom.
    await shot(tester, 'mini-player');
    await MediaPlayerHandler.instance.pause();
    await pop(tester);

    // A podcast; subscribe to the in-cluster test feed first if the chart e2e
    // hasn't already (same bootstrap as podcast_test.dart).
    var podcasts =
        await gqlRaw('{ podcasts(size: 1) { content { id title } } }');
    if ((podcasts['podcasts']['content'] as List).isEmpty) {
      await gqlRaw(
          'mutation { subscribePodcast(feedUrl: "http://podcast-feed:8080/feed.xml") { id } }');
      await gqlRaw('mutation { refreshPodcasts }');
      podcasts = await gqlRaw('{ podcasts(size: 1) { content { id title } } }');
    }
    final podcastId =
        (podcasts['podcasts']['content'] as List).first['id'] as String;
    await pushRoute(tester, PodcastRoute(podcastId: podcastId));
    await tester.pump(const Duration(seconds: 3));
    await shot(tester, 'podcast');
    await pop(tester);

    // Books: the same query the epub e2e uses. A "plain" epub (an author, no
    // audiobook chapters, no media overlays) backs the reader shot; any book
    // with an author backs the detail shot; a comic (no author, cbz "epubs")
    // backs the comic-reader shot.
    final books = await gqlRaw(
        '{ books(size: 50) { content { id name author { id } chapters { id } '
        'epubFiles { id mediaOverlays directory { node { url } } } } } }');
    final content = books['books']['content'] as List;

    final book = content.firstWhere(
        (b) =>
            b['author'] != null && (b['epubFiles'] as List? ?? []).isNotEmpty,
        orElse: () => fail('no book with an epub found'));
    await pushRoute(tester, BookRoute(bookId: book['id'] as String));
    await tester.pump(const Duration(seconds: 3));
    await shot(tester, 'book-detail');
    await pop(tester);

    final epubBook = content.firstWhere(
        (b) =>
            b['author'] != null &&
            ((b['chapters'] as List? ?? []).isEmpty) &&
            (b['epubFiles'] as List? ?? [])
                .any((f) => f['mediaOverlays'] != true),
        orElse: () => fail('no plain epub book found'));
    final epubFile = (epubBook['epubFiles'] as List)
        .firstWhere((f) => f['mediaOverlays'] != true);
    await pushRoute(
        tester,
        ReaderRoute(
            bookId: epubBook['id'] as String,
            mediaFileId: epubFile['id'] as String,
            nodeUrl: epubFile['directory']['node']['url'] as String));
    await pumpUntil(
      tester,
      () => find
          .textContaining('sentence', findRichText: true)
          .evaluate()
          .isNotEmpty,
      timeout: const Duration(minutes: 1),
      description: 'the chapter text to render',
    );
    await shot(tester, 'epub-reader');
    await pop(tester);

    final comic = content.firstWhere(
        (b) =>
            b['author'] == null &&
            (b['epubFiles'] as List? ?? []).isNotEmpty &&
            ((b['chapters'] as List? ?? []).isEmpty),
        orElse: () => fail('no comic volume found'));
    final comicFile = (comic['epubFiles'] as List).first;
    await pushRoute(
        tester,
        ComicReaderRoute(
            bookId: comic['id'] as String,
            mediaFileId: comicFile['id'] as String,
            nodeUrl: comicFile['directory']['node']['url'] as String));
    await pumpUntil(
      tester,
      () => find.byType(PageView).evaluate().isNotEmpty,
      timeout: const Duration(minutes: 1),
      description: 'the comic pages to render',
    );
    await tester.pump(const Duration(seconds: 2));
    await shot(tester, 'comic-reader');
    await pop(tester);

    // Search, seeded with the first movie's name so results show up.
    final movies = await gqlRaw('{ movies(size: 1) { content { id name } } }');
    final movie = (movies['movies']['content'] as List).first;
    final movieName = movie['name'] as String;
    await pushRoute(tester, SearchRoute());
    await pumpUntilFound(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField).first,
        movieName.substring(0, movieName.length < 4 ? movieName.length : 4));
    // The server ranks across all kinds; which items win is irrelevant for the
    // screenshot, so just give the debounced search time to render results.
    await tester.pump(const Duration(seconds: 8));
    await shot(tester, 'search');
    await pop(tester);

    // Settings tab and its sub-pages.
    await tester.tap(find.byIcon(Icons.settings).first, warnIfMissed: false);
    await tester.pump(const Duration(seconds: 2));
    await shot(tester, 'settings');
    final settingsStops = <(PageRouteInfo, String)>[
      (ServerSettingsLanguageRoute(), 'settings-languages'),
      (ServerSettingsPlaybackRoute(), 'settings-playback'),
      (ServerSettingsClusterRoute(), 'settings-cluster'),
      (ServerActivityRoute(), 'activity'),
      (ServerNowPlayingRoute(), 'now-playing'),
      (ServerSettingsSharingRoute(), 'settings-sharing'),
      (ServerSettingsAboutRoute(), 'settings-about'),
    ];
    for (final (route, name) in settingsStops) {
      await pushRoute(tester, route);
      await tester.pump(const Duration(seconds: 2));
      await shot(tester, name);
      await pop(tester);
    }

    // Admin / beheer screens — reachable because the tour boots with an admin
    // token (see bootApp(admin: true)). AdminUserAccessRoute needs a real user
    // id, so ask the server for one first.
    final users = await gqlRaw('query { users { id name } }');
    final user = (users['users'] as List).first as Map<String, dynamic>;
    final adminStops = <(PageRouteInfo, String)>[
      (AdminUsersRoute(), 'admin-users'),
      (
        AdminUserAccessRoute(
            userId: user['id'] as String,
            // name is nullable server-side (e.g. a service account); the admin
            // UI falls back to the id, so mirror that here.
            userName: (user['name'] ?? user['id']) as String),
        'admin-user-access'
      ),
      (AdminLibrariesRoute(), 'admin-libraries'),
    ];
    for (final (route, name) in adminStops) {
      await pushRoute(tester, route);
      await tester.pump(const Duration(seconds: 2));
      await shot(tester, name);
      await pop(tester);
    }

    // The movie last: HLS transcode + playback leaves the player hot, so no
    // other stop should follow it within a pass.
    //
    // The test fixtures' movies have no audio track, so mpv's only clock is
    // the video output: without working GL (e.g. X over TCP) the video stays
    // black and mpv burns to EOF in seconds — run this tour on a local X
    // server (Xvfb on CI, or the unix-socket podman recipe in doc/README.md).
    //
    // The server seeds a new play queue's progress from the latest watch
    // status; earlier tour runs can leave that at the very end, where mpv
    // completes instantly. Pin it to mid-movie first (the same updatePlayQueue
    // write the playback heartbeat uses), so the page opens mid-play — which
    // is also the frame the user guide wants.
    final movieId = movie['id'] as String;
    final pq = await gqlRaw(
        'mutation { createPlayQueue(input: { sourceType: MOVIE, sourceId: "$movieId" }) '
        '{ id playQueueItems { id } } }');
    final pqId = pq['createPlayQueue']['id'] as String;
    final pqItemId =
        (pq['createPlayQueue']['playQueueItems'] as List).first['id'] as String;
    await gqlRaw(
        'mutation { updatePlayQueue(id: "$pqId", progressInMilliseconds: 90000, '
        'playQueueItemId: "$pqItemId") { id } }');

    await pushRoute(tester, MovieRoute(movieId: movieId));
    await pumpUntil(
      tester,
      () =>
          player.state.playing &&
          !player.state.completed &&
          player.state.position > const Duration(seconds: 10),
      // A cold HLS transcode of the mid-movie segment can take a while.
      timeout: const Duration(minutes: 3),
      description: 'movie playback to run mid-movie',
    );
    // Freeze the frame for the shot: without an audio track the position is
    // mpv's video clock, and pausing pins the progress bar mid-movie even on
    // a machine whose video output free-runs (see the note above).
    await MediaPlayerHandler.instance.pause();
    await tester.pump(const Duration(milliseconds: 300));
    // Bring the player controls up: desktop chrome appears on mouse *hover*,
    // so the shot shows the playback controls (and stays presentable even if
    // a headless GL stack leaves the video frame black).
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(640, 250));
    await tester.pump(const Duration(milliseconds: 100));
    await mouse.moveTo(const Offset(640, 300));
    await tester.pump(const Duration(milliseconds: 400));
    await shot(tester, 'movie-playing');
    await mouse.removePointer();
    await MediaPlayerHandler.instance.stop();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('screenshot tour for the user guide', (tester) async {
    // No DEBUG ribbon on documentation screenshots.
    WidgetsApp.debugAllowBannerOverride = false;
    for (final locale in docLocales) {
      docLocale = locale;
      binding.platformDispatcher.localeTestValue = Locale(locale);
      binding.platformDispatcher.localesTestValue = [Locale(locale)];
      if (locale == docLocales.first) {
        // Admin token: the tour documents the beheer/admin screens, which are
        // gated behind PermissionsService/AdminGate and hidden for plain users.
        await bootApp(tester, admin: true);
      } else {
        await resetToServerOverview(tester);
      }
      await tour(tester);
    }
  });
}
