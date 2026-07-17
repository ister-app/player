# Multi-server services

```mermaid
flowchart TD
    WK["WellKnownService<br/>GET /.well-known/ister<br/>(name, OIDC url, server url)<br/>cache: memory + SharedPreferences"]
    CM["ClientManager<br/>per-server GraphQLClient<br/>in ValueNotifier"]
    LM["LoginManager<br/>per-server OidcUserManager<br/>id = serverUrl → separate token storage"]
    STS["StreamTokenService<br/>short-lived stream tokens<br/>self-refreshing timers"]
    GQL["GraphQL API"]
    Media["Media / image URLs<br/>?token=..."]

    WK -->|"in-memory cache MUST be populated<br/>before createClient"| CM
    CM -->|"AuthLink → LoginManager.getToken"| LM
    CM --> GQL
    LM -->|OIDC tokens, deduplicated refresh| GQL
    STS --> Media
    CM -.->|token queries per server| STS
```

Server discovery to authenticated traffic: `WellKnownService` resolves a server name to its URLs, `ClientManager` builds one `GraphQLClient` per server with tokens injected from `LoginManager`, and `StreamTokenService` signs media and image URLs with short-lived tokens.
