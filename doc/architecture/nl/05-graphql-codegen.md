# GraphQL en codegeneratie

## Bronnen en gegenereerde typen

Handgeschreven GraphQL-documenten staan als `.graphql`-bestanden onder `lib/graphql/`, naast het schema (`lib/graphql/schema.graphql`). `graphql_codegen` genereert per document een `.graphql.dart`-tegenhanger met getypeerde klassen:

- `Query$naam` — queryresultaattypen
- `Mutation$naam` — mutatieresultaattypen
- `Fragment$naam` — fragmenttypen (bijv. `Fragment$fragmentPlayQueue`, dat overal in de afspeelservices gebruikt wordt)

Union-resultaten worden op subtypen gematcht, bijv. `Query$search$search` voor de `search`-query.

## build_runner

Twee generatoren draaien samen: `graphql_codegen` en `auto_route_generator` (dat `AppRouter.gr.dart` en routeklassen voor `@RoutePage()`-pagina's schrijft).

```bash
dart run build_runner build   # of: watch
```

Draai dit na elke wijziging aan een `.graphql`-bestand, na het toevoegen van `@RoutePage()` aan een nieuwe pagina, of na aanpassing van `lib/routes/AppRouter.dart`.

**Bewerk `*.graphql.dart` of `*.gr.dart` nooit met de hand** — de volgende build overschrijft ze.

## Querypatronen

- **Pages** gebruiken de `Query(options: ..., builder: ...)`-widget uit `graphql_flutter`.
- **Services** gebruiken kale `graphQLClient.query(...)`-aanroepen (clients uit `ClientManager`).
- **Subscriptions** moeten via `ResilientSubscription` (`lib/utils/ResilientSubscription.dart`), nooit direct via `client.subscribe` — een door de server gestuurd `complete`-/`error`-frame sluit de stream anders voorgoed zonder reconnect.

## Nullable velden bewaken

Veel schemavelden zijn bewust nullable: `durationInMilliseconds`, `show`, `episodes`, mediabestandslijsten. Een mediabestand dat nog niet geanalyseerd is heeft **geen duur**. Bewaak deze velden altijd; neem geen aanwezigheid aan omdat "hij er in de praktijk altijd is".

## Gepagineerde lijsten

Gepagineerde lijsten (`PagedContentView`, `TvShowSlide`, `TvShowScroll` in `lib/components/`) volgen één patroon:

- Items worden **per pagina** opgeslagen in een `Map<int, List<T>>`.
- Elke `QueryResult`-emissie wordt **precies één keer** geparset, door `result.timestamp` te vergelijken met de laatst verwerkte.

Herintroduceer geen booleaanse "initialized"-grendel. Met `FetchPolicy.cacheAndNetwork` is de eerste emissie het cacheresultaat; zo'n grendel pint de UI daaraan vast en breekt pull-to-refresh.
