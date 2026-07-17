# Architecture overview

The Ister player is a Flutter media player for the Ister media management system. It connects to multiple Ister servers at once, authenticates with OIDC, and plays and tracks progress for TV episodes, movies, music, podcasts, audiobooks, epubs and comics.

## Platforms

- **Android**, including Android TV (D-pad navigation via `TvFocusable`) and Android Auto (audio-service browse tree)
- **Linux**, shipped as a flatpak (`app.ister.Player.yaml`)
- **Web**

The same widget tree serves touch, D-pad and web; platform differences are handled at the widget level, not with separate layouts.

## Tech stack

| Concern | Library |
| --- | --- |
| UI framework | Flutter |
| Audio/video playback | `media_kit` (mpv-based) |
| Background audio, media session, Android Auto | `audio_service` |
| API | GraphQL via `graphql_flutter`, typed code from `graphql_codegen` |
| Navigation | `auto_route` (generated typed routes) |
| Authentication | OIDC (`oidc` package, one `OidcUserManager` per server) |

## Chapters

1. [Layer structure](01-layers.md) — pages, components, services, GraphQL, DTOs
2. [Navigation and routes](02-navigation-routes.md) — the `auto_route` tree, path params, overlays
3. [Services](03-services.md) — every service singleton and its invariants
4. [Playback pipeline](04-playback-pipeline.md) — play queues, `MediaPlayerHandler`, progress sync
5. [GraphQL and code generation](05-graphql-codegen.md) — codegen workflow and query patterns
6. [Epub reader](06-epub-reader.md) — the native reader stack, sync and read-aloud

## Diagrams

- [Layer structure](../diagrams/layers.md)
- [Playback flow](../diagrams/playback-flow.md)
- [Route tree](../diagrams/route-tree.md)
- [Multi-server services](../diagrams/multi-server.md)

## The one rule to remember

Everything is **per server**. Service calls take a server identifier, tokens and clients live in per-server maps, and the media that is playing may belong to a different server than the one currently on screen — resolve the server from the playback handler (`MediaItemId`), never from the current route, when navigating out of playback UI.
