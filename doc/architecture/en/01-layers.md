# Layer structure

See the [layer diagram](../diagrams/layers.md) for the picture; this chapter gives the conventions per layer.

## Pages — `lib/pages/`

Screen-level widgets, one per route, annotated with `@RoutePage()`. Route parameters arrive through `@PathParam` / `@QueryParam` constructor annotations; the current server name propagates down the route tree with `@PathParam.inherit('serverName')`. Pages fetch data with the `Query` widget from `graphql_flutter` and delegate anything stateful or cross-screen to the services.

Adding a page means adding the `@RoutePage()` class, wiring it into `lib/routes/AppRouter.dart`, and running `dart run build_runner build` (see [chapter 5](05-graphql-codegen.md)).

## Components — `lib/components/`

Reusable widgets, free of navigation-tree knowledge. Notable ones:

- `IsterPlayer` — wraps the `media_kit` video widget.
- `CarouselItemView` — the shared tile for shows/movies/albums; takes an optional `placeholderIcon` for items without artwork. Every album-cover surface falls back to a music-note placeholder and uses `errorBuilder` on `CachedNetworkImage` (the `cached_network_image_ce` fork — `errorWidget` is deprecated there).
- `RecentCarouselView` — subscribes to `PlayQueueService` streams for live progress updates.
- `PlayerView` — the full-screen player UI shared by the music player and the party-mode remote (see [chapter 2](02-navigation-routes.md)).
- `TvFocusable` — wraps tappable widgets for Android TV: adds the focus node, maps select/enter to `onTap`, draws the highlight only during directional navigation. Use it instead of branching layouts on `PlatformService.isAndroidTv`.
- Paged lists (`PagedContentView`, `TvShowSlide`, `TvShowScroll`) — see the paged-list pattern in [chapter 5](05-graphql-codegen.md).

## Services — `lib/utils/`

Singleton business logic: server discovery, auth, GraphQL clients, playback, settings, search, the epub reader internals (`lib/utils/epub/`) and comic reader internals (`lib/utils/comic/`). Each service is documented in [chapter 3](03-services.md). Services keep **per-server maps** — every call takes a server identifier.

## GraphQL — `lib/graphql/`

Hand-written `.graphql` documents next to their generated `.graphql.dart` counterparts, plus the schema at `lib/graphql/schema.graphql`. `graphql_codegen` produces `Query$name`, `Mutation$name` and `Fragment$name` classes. Never edit generated files; guard the many nullable schema fields. Details in [chapter 5](05-graphql-codegen.md).

## DTOs — `lib/dto/`

Small cross-cutting types used by playback and the audio-service browse tree:

- `IsterMediaItem` — wraps an episode, movie or track behind one interface.
- `MediaItemId` — encodes `serverName;type;id` into the `audio_service` `MediaItem.id` string, so a media item can always be traced back to its server.
- `IsterMediaService` — media lookups for the Android Auto browse tree.
