# GraphQL and code generation

## Sources and generated types

Hand-written GraphQL documents live as `.graphql` files under `lib/graphql/`, next to the schema (`lib/graphql/schema.graphql`). `graphql_codegen` generates a `.graphql.dart` counterpart per document with typed classes:

- `Query$name` — query result types
- `Mutation$name` — mutation result types
- `Fragment$name` — fragment types (e.g. `Fragment$fragmentPlayQueue`, used throughout the playback services)

Union results are matched on subtypes, e.g. `Query$search$search` for the `search` query.

## build_runner

Two generators run together: `graphql_codegen` and `auto_route_generator` (which writes `AppRouter.gr.dart` and route classes for `@RoutePage()` pages).

```bash
dart run build_runner build   # or: watch
```

Run it after changing any `.graphql` file, adding `@RoutePage()` to a new page, or modifying `lib/routes/AppRouter.dart`.

**Never edit `*.graphql.dart` or `*.gr.dart` by hand** — they are overwritten by the next build.

## Query patterns

- **Pages** use the `Query(options: ..., builder: ...)` widget from `graphql_flutter`.
- **Services** use raw `graphQLClient.query(...)` calls (clients from `ClientManager`).
- **Subscriptions** must go through `ResilientSubscription` (`lib/utils/ResilientSubscription.dart`), never `client.subscribe` directly — a server-sent `complete`/`error` frame otherwise closes the stream forever without a reconnect.

## Nullable-field guarding

Many schema fields are nullable by design: `durationInMilliseconds`, `show`, `episodes`, media file lists. A media file that has not been analyzed yet has **no duration**. Always guard these; do not assume presence because "it's always there in practice".

## Paged lists

Paged lists (`PagedContentView`, `TvShowSlide`, `TvShowScroll` in `lib/components/`) follow one pattern:

- Items are stored **per page** in a `Map<int, List<T>>`.
- Each `QueryResult` emission is parsed **exactly once**, by comparing `result.timestamp` against the last processed one.

Do not reintroduce a boolean "initialized" latch. With `FetchPolicy.cacheAndNetwork` the first emission is the cached result; a latch pins the UI to it and breaks pull-to-refresh.
