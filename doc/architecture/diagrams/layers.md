# Layer structure

```mermaid
flowchart TD
    subgraph UI
        Pages["Pages (lib/pages/)<br/>@RoutePage() screens"]
        Components["Components (lib/components/)<br/>reusable widgets"]
    end
    subgraph Logic
        Services["Services (lib/utils/)<br/>singleton business logic"]
        DTOs["DTOs (lib/dto/)<br/>IsterMediaItem, MediaItemId"]
    end
    subgraph Data
        GraphQL["GraphQL (lib/graphql/)<br/>.graphql + generated typed classes"]
        REST["REST endpoints<br/>.well-known, epub resources, reading progress"]
    end
    Server["Ister server"]

    Pages --> Components
    Pages --> Services
    Components --> Services
    Services --> DTOs
    Services --> GraphQL
    Services --> REST
    GraphQL --> Server
    REST --> Server
```

The four main layers of the player: pages compose components, both call into the service singletons in `lib/utils/`, and the services talk to the server through generated GraphQL types plus a handful of REST endpoints.
