# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (GraphQL types + routing) — required after changing .graphql files or @RoutePage annotations
dart run build_runner build

# Watch mode for code generation during development
dart run build_runner watch

# Run tests (single file: flutter test test/widget_test.dart)
flutter test

# Integration tests (integration_test/) — need the chart's kind deployment running and
# its port-forwards active (chart repo: `make up`, then ci/e2e/forward-for-player.sh,
# or `make player-e2e` from the chart repo does all of it):
flutter test integration_test -d linux --dart-define=ISTER_TEST_MODE=true

# Lint
flutter analyze

# Build
flutter build linux --release
flutter build apk --release
flutter build web --release

# Linux flatpak
flutter build linux
flatpak-builder --user --force-clean --install-deps-from=flathub builddir app.ister.Player.yaml
flatpak-builder --run builddir app.ister.Player.yaml ister

# Docs zip (markdown from doc/ + generated screenshots) — needs the same kind deployment
# and port-forwards as the integration tests, plus an X display (see doc/README.md for a
# podman Xvfb recipe on Wayland):
ci/build-docs.sh
```

Localizations (en/nl) are generated from `lib/l10n/app_*.arb` via `l10n.yaml` during a normal build; edit the `.arb` files, not `app_localizations*.dart`.

Do not remove the `analyzer.exclude` entries in `analysis_options.yaml` — without them the flatpak build dirs and plugin symlinks pull a vendored Flutter SDK into analysis and `flutter analyze` takes hours instead of seconds.

## Commits and releases

Commit subjects must follow [Conventional Commits](https://www.conventionalcommits.org/) (see `CONTRIBUTING.md`); a `commit-lint` job enforces it, and the nightly release workflow derives the version bump and release notes from the subjects. `feat` → minor, `fix`/`perf`/`refactor`/`test`/`docs`/`build`/`ci`/`chore` → patch, `!` or a `BREAKING CHANGE:` body → major. Never hand-edit `version` in `pubspec.yaml` — the release workflow writes it (`<semver>+<commit count>`).

## Integration tests and e2e pins

`integration_test/` runs the real app against the chart's kind deployment (server on
`localhost:8080/api`, mock OIDC issuer on `localhost:18081`): add-server flow, movie playback over
HLS, audiobook/podcast playback, epub reading with progress sync, read-aloud. The shared harness
(`integration_test/support/harness.dart`) mints a client-credentials JWT at the mock issuer and
installs it via `LoginManager.testTokenProvider` — a seam that is only consulted when built with
`--dart-define=ISTER_TEST_MODE=true`, because the interactive OIDC flow cannot run headless.
Navigate with `enterServerShell`/`pushRoute` (typed routes), never `pushPath`: a server identifier
containing a path (`localhost:8080/api`) breaks URL-based deep links.

`integration_test/doc_tour_test.dart` is not a functional test but the screenshot tour for the
user guide: one boot, every documentable screen, a `shot()` per stop, run once per locale (en/nl)
in a single app process — the tour switches the platform locale at runtime between passes, because
a second cold start (mpv/GL init on a fresh Xvfb) proved flaky. Screenshots are captured
*externally* with ImageMagick `import` on the app's X11 window (`takeScreenshot` has no Linux
implementation; X capture also gets the media_kit video texture) into `$DOC_SCREENSHOT_DIR` —
without that variable the tour runs shot-less. `ci/build-docs.sh` drives it under Xvfb,
validates every markdown image reference, and zips `doc/`; the `docs`
job in `release.yml` attaches the zip to the release. The fixture movies/episodes carry a silent
audio track on purpose (testdata `create_mkv.sh`): without one, mpv's only clock is the video
output and a GL-less player free-runs to EOF instantly.

`ci/e2e-pins.env` pins the chart release tag (or chart commit sha), testdata commit and
(optionally) server version the suite runs against; the `integration-e2e` job in `workflow.yml`
reads it. The release gate refuses to release when the pins are soft (a moving branch ref — a
`vX.Y.Z` tag or a full 40-char commit sha both pass, since a chart's e2e fixtures often depend on
an unreleased player and the two repos would otherwise deadlock) or when the pinned server
version — stripped of `-SNAPSHOT` — was never released; the release commit strips `-SNAPSHOT` from
the pins.

## Architecture Overview

This is a Flutter media player app for the "Ister" media management system. It supports multiple servers with OIDC authentication; browsing and playback of episodes, movies, music, podcasts and audiobooks/epubs; and language preferences and watch-progress tracking. It ships for Android (incl. Android TV and Android Auto), Linux (flatpak) and web.

### Layer Structure

**Pages** (`lib/pages/`) — Screen-level widgets decorated with `@RoutePage()`. Navigation uses `auto_route` with nested routes defined in `lib/routes/AppRouter.dart`. Route params like `:serverName`, `:showId`, `:episodeId` are passed via path; `@PathParam.inherit('serverName')` propagates the current server down the route tree.

**Components** (`lib/components/`) — Reusable widgets. `IsterPlayer` wraps the `media_kit` video widget. `CarouselItemView` is the shared tile for shows/movies/albums (optional `placeholderIcon` for items without artwork). `RecentCarouselView` subscribes to `PlayQueueService` streams for live progress updates.

**Services** (`lib/utils/`) — Singleton business logic:
- `WellKnownService` — Server discovery: fetches `/.well-known/ister` (3 lines: name, OIDC url, server url), caches in memory + SharedPreferences. The in-memory cache **must** be populated before `ClientManager.createClient` runs; UI pages fetch it, and `LoginManager.waitForToken` bootstraps it for audio-service session restore.
- `ClientManager` — Per-server `GraphQLClient` instances wrapped in `ValueNotifier`. Auth tokens injected via `AuthLink` → `LoginManager.getToken`. `getHttpOrHttps` picks `http` only for localhost/IP hosts.
- `LoginManager` — Per-server OIDC state (static, `Map`-keyed). Each `OidcUserManager` gets `id: serverUrl` so servers don't share token storage. Init is deduplicated via a futures map and retryable after failure; token refresh is deduplicated per server (refresh-token rotation).
- `StreamTokenService` — Short-lived per-server stream tokens appended to media/image URLs; self-refreshing timers with a minimum delay and retry-on-failure so the chain never dies silently.
- `PlayQueueService` — Fetches/creates/updates play queues on the server. Exposes a broadcast `StreamController<Fragment$fragmentPlayQueue>` for subscribers. Lookup helpers use `.where(...).firstOrNull` — items may legitimately be absent from a queue.
- `MediaPlayerHandler` — Singleton extending `BaseAudioHandler` (audio_service). Wraps the `media_kit` `Player` and handles every playable kind: episodes, movies, album tracks, podcast episodes and audiobook chapters (each has its own `startPlayQueueFor…`, and the queue item's non-null field discriminates). Long-form audio (podcasts, audiobooks) resumes at its recorded progress unless it already played to the end. Manages track selection (language preferences), a stall watchdog that re-opens hung HLS loads at the stream-open position, and progress sync: throttled to ~10s of position delta, flushed on pause/stop, and guarded by a generation counter (`_syncGeneration`) so in-flight responses can't revert a skip. UI must go through `handler.play()/pause()` — the in-video controls bypass this, which the watchdog compensates for.
- `UserSettingsService` — The user's playback settings (spoken/subtitle languages, direct play, transcode, max video height) as the **server** stores them, per user per server, with a local cache. `LanguagePreferences` and `PlaybackPreferences` are thin read/write facades over it — call those, not the GraphQL mutation. `LanguageService` supplies the ISO 639-3 language table from `assets/`.
- `SearchService` — Wraps the `search` query; the server ranks across movies, shows, episodes, persons, albums and tracks and returns a union, so results are matched on `Query$search$search` subtypes.
- `ResilientSubscription` — Use this for GraphQL subscriptions instead of `client.subscribe` directly. `graphql`'s socket client only re-subscribes when the *socket* drops; a server-sent `complete`/`error` frame silently closes the Dart stream forever. This re-opens it with backoff.
- `PlatformService` — Cached Android TV (leanback) detection. The UI branches on it for focus highlights and remote-friendly controls; `TvFocusable` wraps tappable widgets for D-pad/keyboard reach.
- **Epub reader** (`lib/utils/epub/`, `lib/pages/ReaderPage.dart`, `lib/components/reader/`) — Native, pure-Flutter (no webview; Linux has none). `EpubResourceClient` lazily fetches individual epub entries through the node's `/epub/{mediaFileId}/resource/` endpoint (stream-token auth, LRU cache); `EpubPackage` parses container.xml/OPF/nav/NCX client-side (the server persists no spine/TOC); `ChapterContent` splits a chapter into top-level blocks, and the block index is the locator coordinate (`ister:v1;spine=…;block=…` in the opaque `readingLocation` field — old web-reader epubcfi strings deliberately fail `EpubLocator.tryParse` and fall back to the progress fraction). `ReadingSyncService` uses the REST pair `GET /book-progress` / debounced `POST /reading-progress` (not the GraphQL `updateReadingProgress` mutation — REST carries the audiobook chapter mapping the server mirrors, so reading and listening resume in the same place); its audio⇄text mapping is sentence-exact via the SMIL timeline when it matches the audiobook chapter duration, interpolated otherwise. `ReadAloudController` plays EPUB 3 media overlays on a dedicated media_kit `Player` (clip-scheduled; pauses `MediaPlayerHandler` on start) with per-sentence highlighting in `ChapterView`.
- `AppMessenger` — `showAppSnackBar` for context-less singletons (e.g. `MediaPlayerHandler`); a no-op when no messenger is mounted, so it's safe during headless audio-service startup.

**GraphQL** (`lib/graphql/`) — `.graphql` source files + auto-generated `.graphql.dart` counterparts. `build_runner` + `graphql_codegen` produces typed classes: `Query$name`, `Mutation$name`, `Fragment$name`. The schema is at `lib/graphql/schema.graphql`. Do not edit `*.graphql.dart` (or `*.gr.dart`) files manually. Many schema fields are nullable (`durationInMilliseconds`, `show`, `episodes`, media file lists) — guard them; a media file that hasn't been analyzed yet has no duration.

**DTOs** (`lib/dto/`) — `IsterMediaItem` (wraps episode/movie/track), `MediaItemId` (encodes `serverName;type;id` into the audio_service `MediaItem.id` string), `IsterMediaService` (media lookups for the audio-service browse tree).

### Key Patterns

- **Multi-server:** All service calls require a server identifier; services keep per-server maps. The playing media can belong to a *different* server than the one being browsed — when navigating from playback UI (e.g. mini player → album), resolve the server from the handler/`MediaItemId`, not the current route.
- **Reactive state:** Playback state flows via `audio_service` `BehaviorSubject` streams. UI components `listen()` in `initState` and cancel in `dispose`; prefer `positionSecondsStream` over the raw position stream to avoid per-frame rebuilds.
- **GraphQL widgets:** Pages use `Query(options: ..., builder: ...)` from `graphql_flutter`; raw `graphQLClient.query(...)` is used inside services. Paged lists (`PagedContentView`, `TvShowSlide`, `TvShowScroll`) store items **per page** in a `Map<int, List<T>>` and parse each result emission exactly once by comparing `result.timestamp` — do not reintroduce a boolean "initialized" latch, it pins the UI to the first cached result and breaks pull-to-refresh with `FetchPolicy.cacheAndNetwork`.
- **Player overlays:** `MusicPlayerRoute` and `RemoteControlRoute` (party mode) are pushed on the root router as transparent routes; both render the shared `PlayerView` (`lib/components/PlayerView.dart`) — slide-up/drag-dismiss, portrait/landscape layouts, accent colour, queue tabs — through a `PlayerViewController` adapter (local `MediaPlayerHandler` vs. remote session subscriptions). `PlayerView.activeBackHandler` coordinates with `_MusicPlayerAwareDelegate.popRoute` in `AppRouter.dart` so the back button plays the dismiss animation instead of popping instantly; `MediaPlayerHandler.musicPlayerOpen` guards against double-pushing the music player.
- **Background audio (Android):** `audio_service` provides notification controls and `MediaSession` integration; the foreground service stays alive while paused (`androidStopForegroundOnPause: false`) and audio focus is held across track gaps — Android 16 blocks re-acquiring either from the background. mpv gets reconnect/network-timeout options for backgrounded HLS.
- **Code generation:** Two generators run together — `graphql_codegen` (GraphQL types) and `auto_route_generator` (routing). Always run `build_runner build` after changing `.graphql` files, adding `@RoutePage()` to a new page, or modifying `AppRouter.dart`.
- **Artwork placeholders:** every album-cover surface falls back to a music-note placeholder (and uses `errorBuilder` on `CachedNetworkImage`, from the `cached_network_image_ce` fork — `errorWidget` is deprecated there).
- **Android TV:** the same widget tree serves touch and D-pad. Wrap tappable items in `TvFocusable` (it adds the focus node, maps select/enter to `onTap`, and only draws the highlight during directional navigation) rather than branching the layout on `PlatformService.isAndroidTv`.
