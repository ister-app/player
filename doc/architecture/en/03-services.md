# Services

All services live in `lib/utils/` as singletons (or static, `Map`-keyed state) and are **per server**: calls take a server identifier and internal state is keyed by it. See the [multi-server diagram](../diagrams/multi-server.md) for how the discovery/auth chain fits together.

## WellKnownService — `lib/utils/WellKnownService.dart`

Server discovery. Fetches `/.well-known/ister` — a three-line document: display name, OIDC URL, server URL — and caches it in memory and in SharedPreferences.

**Invariant:** the in-memory cache must be populated *before* `ClientManager.createClient` runs. UI pages fetch it as part of their flow; for headless audio-service session restore, `LoginManager.waitForToken` bootstraps it.

## ClientManager — `lib/utils/ClientManager.dart`

One `GraphQLClient` per server, wrapped in a `ValueNotifier` so widgets can rebuild on client replacement. Auth tokens are injected through an `AuthLink` that calls `LoginManager.getToken`. `getHttpOrHttps` chooses plain `http` only for localhost/IP hosts.

## LoginManager — `lib/utils/LoginManager.dart`

Per-server OIDC state, static and `Map`-keyed. Each `OidcUserManager` is created with `id: serverUrl`, so servers never share token storage. Initialization is deduplicated through a futures map and retryable after failure. Token refresh is deduplicated per server — required because refresh tokens rotate. `LoginManager.testTokenProvider` is a test seam consulted only under `--dart-define=ISTER_TEST_MODE=true`.

## StreamTokenService — `lib/utils/StreamTokenService.dart`

Short-lived per-server stream tokens appended to media and image URLs. Self-refreshing timers with a minimum delay and retry-on-failure, so the refresh chain never dies silently.

## PlayQueueService — `lib/utils/PlayQueueService.dart`

Fetches, creates and updates play queues on the server, and exposes a broadcast `StreamController<Fragment$fragmentPlayQueue>` for subscribers (e.g. `RecentCarouselView` live progress). Lookup helpers use `.where(...).firstOrNull` — items may legitimately be absent from a queue, so don't "fix" that into `.first`.

## MediaPlayerHandler — `lib/utils/MediaPlayerHandler.dart`

The playback singleton; covered in depth in [chapter 4](04-playback-pipeline.md). Extends `BaseAudioHandler` (`audio_service`), wraps the `media_kit` `Player`, and handles every playable kind. UI must go through `handler.play()/pause()`.

## UserSettingsService — `lib/utils/UserSettingsService.dart`

The user's playback settings (spoken/subtitle languages, direct play, transcode, max video height) as the **server** stores them — per user, per server, with a local cache. `LanguagePreferences` and `PlaybackPreferences` are thin read/write facades over it; call those, never the GraphQL mutation directly. `LanguageService` supplies the ISO 639-3 language table from `assets/`.

## SearchService — `lib/utils/SearchService.dart`

Wraps the `search` query. The server ranks across movies, shows, episodes, persons, albums and tracks and returns a union type, so results are matched on `Query$search$search` subtypes.

## ResilientSubscription — `lib/utils/ResilientSubscription.dart`

**Always use this for GraphQL subscriptions instead of `client.subscribe`.** The `graphql` package's socket client only re-subscribes when the *socket* drops; a server-sent `complete`/`error` frame silently closes the Dart stream forever. `ResilientSubscription` re-opens it with backoff.

## PlatformService — `lib/utils/PlatformService.dart`

Cached Android TV (leanback) detection. The UI branches on it for focus highlights and remote-friendly controls; prefer wrapping widgets in `TvFocusable` over layout branches.

## Epub reader stack — `lib/utils/epub/`

`EpubResourceClient`, `EpubPackage`, `ChapterContent`, `EpubLocator`, `ReadingSyncService`, `ReadAloudController`, `SmilDocument`, plus `ReaderPage` and the widgets in `lib/components/reader/`. Detailed in [chapter 6](06-epub-reader.md). The comic reader has a parallel stack in `lib/utils/comic/`.

## AppMessenger — `lib/utils/AppMessenger.dart`

`showAppSnackBar` for context-less singletons such as `MediaPlayerHandler`. It is a no-op when no messenger is mounted, making it safe during headless audio-service startup.
