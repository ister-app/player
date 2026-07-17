# Lagenstructuur

Zie het [lagendiagram](../diagrams/layers.md) voor het totaalplaatje; dit hoofdstuk beschrijft de conventies per laag.

## Pages — `lib/pages/`

Widgets op schermniveau, één per route, geannoteerd met `@RoutePage()`. Routeparameters komen binnen via `@PathParam`-/`@QueryParam`-annotaties op de constructor; de actuele servernaam propageert de routeboom in via `@PathParam.inherit('serverName')`. Pages halen data op met de `Query`-widget uit `graphql_flutter` en delegeren alles wat stateful of schermoverstijgend is aan de services.

Een page toevoegen betekent: de `@RoutePage()`-klasse schrijven, hem opnemen in `lib/routes/AppRouter.dart`, en `dart run build_runner build` draaien (zie [hoofdstuk 5](05-graphql-codegen.md)).

## Components — `lib/components/`

Herbruikbare widgets, zonder kennis van de navigatieboom. De belangrijkste:

- `IsterPlayer` — omhult de `media_kit`-videowidget.
- `CarouselItemView` — de gedeelde tegel voor series/films/albums; met optioneel `placeholderIcon` voor items zonder artwork. Elk albumhoesoppervlak valt terug op een muzieknoot-placeholder en gebruikt `errorBuilder` op `CachedNetworkImage` (de `cached_network_image_ce`-fork — `errorWidget` is daar deprecated).
- `RecentCarouselView` — abonneert zich op `PlayQueueService`-streams voor live voortgangsupdates.
- `PlayerView` — de fullscreen speler-UI die de muziekspeler en de party-modus-remote delen (zie [hoofdstuk 2](02-navigation-routes.md)).
- `TvFocusable` — omhult aantikbare widgets voor Android TV: voegt de focus node toe, koppelt select/enter aan `onTap`, en tekent de highlight alleen tijdens directionele navigatie. Gebruik dit in plaats van lay-outvertakkingen op `PlatformService.isAndroidTv`.
- Gepagineerde lijsten (`PagedContentView`, `TvShowSlide`, `TvShowScroll`) — zie het paginapatroon in [hoofdstuk 5](05-graphql-codegen.md).

## Services — `lib/utils/`

Singleton-bedrijfslogica: serverdiscovery, auth, GraphQL-clients, afspelen, instellingen, zoeken, en de interne delen van de epub-lezer (`lib/utils/epub/`) en striplezer (`lib/utils/comic/`). Elke service staat beschreven in [hoofdstuk 3](03-services.md). Services houden **maps per server** bij — elke aanroep krijgt een serveridentifier mee.

## GraphQL — `lib/graphql/`

Handgeschreven `.graphql`-documenten naast hun gegenereerde `.graphql.dart`-tegenhangers, plus het schema in `lib/graphql/schema.graphql`. `graphql_codegen` produceert `Query$naam`-, `Mutation$naam`- en `Fragment$naam`-klassen. Bewerk gegenereerde bestanden nooit; bewaak de vele nullable schemavelden. Details in [hoofdstuk 5](05-graphql-codegen.md).

## DTO's — `lib/dto/`

Kleine typen die playback en de audio-service-browse-tree delen:

- `IsterMediaItem` — omhult een aflevering, film of track achter één interface.
- `MediaItemId` — codeert `serverName;type;id` in de `audio_service` `MediaItem.id`-string, zodat een media-item altijd naar zijn server te herleiden is.
- `IsterMediaService` — media-lookups voor de Android Auto-browse-tree.
