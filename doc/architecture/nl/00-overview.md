# Architectuuroverzicht

De Ister-player is een Flutter-mediaspeler voor het Ister-mediabeheersysteem. De app verbindt met meerdere Ister-servers tegelijk, authenticeert via OIDC, en speelt tv-afleveringen, films, muziek, podcasts, audioboeken, epubs en strips af — inclusief voortgangsregistratie.

## Platformen

- **Android**, inclusief Android TV (D-pad-navigatie via `TvFocusable`) en Android Auto (audio-service-browse-tree)
- **Linux**, uitgeleverd als flatpak (`app.ister.Player.yaml`)
- **Web**

Dezelfde widget-tree bedient touch, D-pad en web; platformverschillen worden op widgetniveau opgelost, niet met aparte lay-outs.

## Technologiestack

| Onderdeel | Bibliotheek |
| --- | --- |
| UI-framework | Flutter |
| Audio-/videoweergave | `media_kit` (op mpv gebaseerd) |
| Achtergrondaudio, media session, Android Auto | `audio_service` |
| API | GraphQL via `graphql_flutter`, getypeerde code uit `graphql_codegen` |
| Navigatie | `auto_route` (gegenereerde getypeerde routes) |
| Authenticatie | OIDC (`oidc`-package, één `OidcUserManager` per server) |

## Hoofdstukken

1. [Lagenstructuur](01-layers.md) — pages, components, services, GraphQL, DTO's
2. [Navigatie en routes](02-navigation-routes.md) — de `auto_route`-boom, path-params, overlays
3. [Services](03-services.md) — alle service-singletons en hun invarianten
4. [Afspeelpijplijn](04-playback-pipeline.md) — play queues, `MediaPlayerHandler`, voortgangssync
5. [GraphQL en codegeneratie](05-graphql-codegen.md) — codegen-workflow en querypatronen
6. [Epub-lezer](06-epub-reader.md) — de native leesstack, sync en voorlezen

## Diagrammen

- [Lagenstructuur](../diagrams/layers.md)
- [Afspeelflow](../diagrams/playback-flow.md)
- [Routeboom](../diagrams/route-tree.md)
- [Multi-server-services](../diagrams/multi-server.md)

## De ene regel om te onthouden

Alles is **per server**. Service-aanroepen krijgen een serveridentifier mee, tokens en clients leven in maps per server, en het spelende medium kan bij een *andere* server horen dan de server die op het scherm staat. Los bij navigatie vanuit de afspeel-UI de server dus op via de playback-handler (`MediaItemId`), nooit via de huidige route.
