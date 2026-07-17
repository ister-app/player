# Playback flow

```mermaid
sequenceDiagram
    participant UI as UI (page / MiniPlayer / PlayerView)
    participant H as MediaPlayerHandler<br/>(audio_service BaseAudioHandler)
    participant PQ as PlayQueueService
    participant MK as media_kit Player
    participant ST as StreamTokenService
    participant S as Ister server (GraphQL)

    UI->>H: startPlayQueueForMovie/Album/Book/Podcast(...)
    H->>PQ: create / fetch play queue
    PQ->>S: createPlayQueue mutation
    S-->>PQ: Fragment$fragmentPlayQueue
    H->>ST: token for media URL
    H->>MK: open(url?token=..., start position)
    MK-->>H: position / buffering streams
    Note over H,MK: stall watchdog re-opens hung HLS loads
    H-->>UI: playbackState / mediaItem streams (BehaviorSubject)
    loop ~ every 10 s of position delta
        H->>S: update progress (guarded by _syncGeneration)
    end
    H->>S: flush progress on pause / stop
```

Playback always runs through `MediaPlayerHandler`: the UI starts a play queue, the handler drives the `media_kit` player with stream-token-signed URLs, and throttled progress sync flows back to the server.
