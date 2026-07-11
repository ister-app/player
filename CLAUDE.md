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

# Lint
flutter analyze

# Build
flutter build linux --release
flutter build apk --release

# Linux flatpak
flutter build linux
flatpak-builder --user --force-clean --install-deps-from=flathub builddir app.ister.Player.yaml
flatpak-builder --run builddir app.ister.Player.yaml ister
```

Localizations (en/nl) are generated from `lib/l10n/app_*.arb` via `l10n.yaml` during a normal build; edit the `.arb` files, not `app_localizations*.dart`.

Do not remove the `analyzer.exclude` entries in `analysis_options.yaml` — without them the flatpak build dirs and plugin symlinks pull a vendored Flutter SDK into analysis and `flutter analyze` takes hours instead of seconds.

## Architecture Overview

This is a Flutter media player app for the "Ister" media management system. It supports multiple servers with OIDC authentication, episode/movie/music browsing, and audio/video playback with language preferences and watch progress tracking.

### Layer Structure

**Pages** (`lib/pages/`) — Screen-level widgets decorated with `@RoutePage()`. Navigation uses `auto_route` with nested routes defined in `lib/routes/AppRouter.dart`. Route params like `:serverName`, `:showId`, `:episodeId` are passed via path; `@PathParam.inherit('serverName')` propagates the current server down the route tree.

**Components** (`lib/components/`) — Reusable widgets. `IsterPlayer` wraps the `media_kit` video widget. `CarouselItemView` is the shared tile for shows/movies/albums (optional `placeholderIcon` for items without artwork). `RecentCarouselView` subscribes to `PlayQueueService` streams for live progress updates.

**Services** (`lib/utils/`) — Singleton business logic:
- `WellKnownService` — Server discovery: fetches `/.well-known/ister` (3 lines: name, OIDC url, server url), caches in memory + SharedPreferences. The in-memory cache **must** be populated before `ClientManager.createClient` runs; UI pages fetch it, and `LoginManager.waitForToken` bootstraps it for audio-service session restore.
- `ClientManager` — Per-server `GraphQLClient` instances wrapped in `ValueNotifier`. Auth tokens injected via `AuthLink` → `LoginManager.getToken`. `getHttpOrHttps` picks `http` only for localhost/IP hosts.
- `LoginManager` — Per-server OIDC state (static, `Map`-keyed). Each `OidcUserManager` gets `id: serverUrl` so servers don't share token storage. Init is deduplicated via a futures map and retryable after failure; token refresh is deduplicated per server (refresh-token rotation).
- `StreamTokenService` — Short-lived per-server stream tokens appended to media/image URLs; self-refreshing timers with a minimum delay and retry-on-failure so the chain never dies silently.
- `PlayQueueService` — Fetches/creates/updates play queues on the server. Exposes a broadcast `StreamController<Fragment$fragmentPlayQueue>` for subscribers. Lookup helpers use `.where(...).firstOrNull` — items may legitimately be absent from a queue.
- `MediaPlayerHandler` — Singleton extending `BaseAudioHandler` (audio_service). Wraps the `media_kit` `Player`, handles episodes, movies and album tracks (`IsterMediaTypes` discriminates). Manages track selection (language preferences), a stall watchdog that re-opens hung HLS loads at the stream-open position, and progress sync: throttled to ~10s of position delta, flushed on pause/stop, and guarded by a generation counter (`_syncGeneration`) so in-flight responses can't revert a skip. UI must go through `handler.play()/pause()` — the in-video controls bypass this, which the watchdog compensates for.
- `LanguageService` / `LanguagePreferences` — Preferred audio/subtitle languages (global, not per server); language data comes from the ISO 639-3 table in `assets/`.

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
