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

# Run tests
flutter test

# Lint
flutter analyze

# Build
flutter build linux --release
flutter build apk --release
```

## Architecture Overview

This is a Flutter media player app for the "Ister" media management system. It supports multiple servers with OIDC authentication, episode/movie browsing, and audio/video playback with language preferences and watch progress tracking.

### Layer Structure

**Pages** (`lib/pages/`) — Screen-level widgets decorated with `@RoutePage()`. Navigation uses `auto_route` with nested routes defined in `lib/routes/AppRouter.dart`. Route params like `:serverName`, `:showId`, `:episodeId` are passed via path; `@PathParam.inherit('serverName')` propagates the current server down the route tree.

**Components** (`lib/components/`) — Reusable widgets. `IsterPlayer` wraps the `media_kit` video widget. `RecentCarouselView` subscribes to `PlayQueueService` streams for live progress updates.

**Services** (`lib/utils/`) — Singleton business logic:
- `ClientManager` — Manages per-server `GraphQLClient` instances wrapped in `ValueNotifier` for reactivity. Auth tokens injected via `AuthLink`.
- `LoginManager` — Per-server OIDC authentication state. Static methods with `Map`-keyed server state.
- `PlayQueueService` — Fetches/creates/updates play queues on the server. Exposes a `StreamController<Fragment$fragmentPlayQueue>` for subscribers.
- `MediaPlayerHandler` — Extends `BaseAudioHandler` (audio_service). Wraps `media_kit` `Player`. Manages track selection (language preferences), emits `BehaviorSubject` streams for queue and playback state. Position updates are throttled (~10s) before syncing to server.
- `LanguageService` / `LanguagePreferences` — Stores and resolves preferred audio/subtitle language per server.

**GraphQL** (`lib/graphql/`) — `.graphql` source files + auto-generated `.graphql.dart` counterparts. `build_runner` + `graphql_codegen` produces typed classes: `Query$name`, `Mutation$name`, `Fragment$name`. The schema is at `lib/graphql/schema.graphql`. Do not edit `*.graphql.dart` files manually.

**DTOs** (`lib/dto/`) — `IsterMediaItem` (wraps episode or movie), `MediaItemId` (union of episodeId/movieId), `IsterMediaService`.

### Key Patterns

- **Multi-server:** All service calls require a server identifier; `ClientManager` and `LoginManager` keep per-server maps.
- **Reactive state:** Playback state flows via `audio_service` `BehaviorSubject` streams. UI components `listen()` in `initState` and cancel in `dispose`.
- **GraphQL widgets:** Pages use `Query(options: ..., builder: (result, ...) {...})` and `Mutation(...)` from `graphql_flutter` for declarative data fetching; raw `graphQLClient.query(...)` is used inside services.
- **Background audio (Android):** `audio_service` provides notification controls and `MediaSession` integration. `MediaPlayerHandler` is the registered `BaseAudioHandler`.
- **Code generation:** Two generators run together — `graphql_codegen` (GraphQL types) and `auto_route_generator` (routing). Always run `build_runner build` after changing `.graphql` files, adding `@RoutePage()` to a new page, or modifying `AppRouter.dart`.
