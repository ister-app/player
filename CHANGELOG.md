# Changelog

## player v2.1.1

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:2.1.1` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Fixes

- fix(notification): re-publish the session after a service recreate ([`f8cd0ff`](https://github.com/ister-app/player/commit/f8cd0ff))

### Run

```sh
docker pull ghcr.io/ister-app/player:2.1.1
```

**Full changelog**: https://github.com/ister-app/player/compare/v2.1.0...v2.1.1

## player v2.1.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:2.1.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(shows): give the related-shows row bones and its own page ([`727ff0d`](https://github.com/ister-app/player/commit/727ff0d))
- feat(music): show the playback history of tracks, albums and artists ([`e8f49be`](https://github.com/ister-app/player/commit/e8f49be))
- feat: show a related-shows row on the show page ([`f47c5fe`](https://github.com/ister-app/player/commit/f47c5fe))

### Fixes

- fix(ui): give the about page one card for all data sources ([`2f427c5`](https://github.com/ister-app/player/commit/2f427c5))
- fix(ui): make the loading skeletons match the pages they stand in for ([`3a92ce5`](https://github.com/ister-app/player/commit/3a92ce5))
- fix(routing): push episodes through their show route from outside the shell ([`bc51cdb`](https://github.com/ister-app/player/commit/bc51cdb))

### Other

- test(downloads): wait for the segment window instead of the clock ([`ea9e073`](https://github.com/ister-app/player/commit/ea9e073))
- docs(tour): stop playback after the mini-player shot ([`97b2fed`](https://github.com/ister-app/player/commit/97b2fed))
- perf(images): key the image caches on a token-free url ([`5f6b5b8`](https://github.com/ister-app/player/commit/5f6b5b8))
- ci(e2e): pin the server snapshot with related shows and container history ([`667e2b6`](https://github.com/ister-app/player/commit/667e2b6))
- build(docker): pin the nginx base image to 1.31.4-alpine ([`e93727a`](https://github.com/ister-app/player/commit/e93727a))
- ci: bump actions/setup-java to v6 ([`85e1f7c`](https://github.com/ister-app/player/commit/85e1f7c))

### Run

```sh
docker pull ghcr.io/ister-app/player:2.1.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v2.0.0...v2.1.0

## player v2.0.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:2.0.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Breaking changes

- feat(settings)!: clearer maintenance actions with hints, confirmation and feedback ([`6687de2`](https://github.com/ister-app/player/commit/6687de2))

### Features

- feat(metadata): show the extended TMDB metadata on detail pages ([`206512d`](https://github.com/ister-app/player/commit/206512d))
- feat(player): option to leave out subtitles in the language being spoken ([`91a1ba1`](https://github.com/ister-app/player/commit/91a1ba1))
- feat(settings): rework language preferences and name languages in the UI language ([`ac5d29e`](https://github.com/ister-app/player/commit/ac5d29e))

### Fixes

- fix(ui): stop accent extraction from disposing shared artwork images ([`05f4acd`](https://github.com/ister-app/player/commit/05f4acd))
- fix(player): keep back out of the player from emptying the navigator ([`dea0b61`](https://github.com/ister-app/player/commit/dea0b61))
- fix(settings): make the section headers stand out from the rows ([`9728137`](https://github.com/ister-app/player/commit/9728137))
- fix(ui): reserve the person page's played-track and album space while loading ([`c9d75c5`](https://github.com/ister-app/player/commit/c9d75c5))
- fix(servers): only call a server connected when it answers now ([`5f9a28e`](https://github.com/ister-app/player/commit/5f9a28e))
- fix(ui): keep a snackbar's action beside its text ([`9d4a19c`](https://github.com/ister-app/player/commit/9d4a19c))
- fix(log): keep the exported error log populated in release builds ([`635e7b6`](https://github.com/ister-app/player/commit/635e7b6))

### Other

- ci(e2e): pin the chart to bac9a05 for the scanLibraries rename ([`0352d77`](https://github.com/ister-app/player/commit/0352d77))
- ci(e2e): pin the server to the v3.0.0 release ([`3f7328f`](https://github.com/ister-app/player/commit/3f7328f))
- refactor(album): collapse the app-bar icons into one overflow menu ([`0b07477`](https://github.com/ister-app/player/commit/0b07477))
- refactor(settings): give every settings sub-page the same shape ([`f4ceed2`](https://github.com/ister-app/player/commit/f4ceed2))
- refactor(settings): group the settings screen by scope ([`20a75dd`](https://github.com/ister-app/player/commit/20a75dd))
- ci(e2e): pin the server snapshot that carries hideSubtitlesMatchingAudio ([`afe012b`](https://github.com/ister-app/player/commit/afe012b))

### Run

```sh
docker pull ghcr.io/ister-app/player:2.0.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.19.0...v2.0.0

## player v1.19.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.19.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): choose an item count for the automatic sleep timer ([`50304bf`](https://github.com/ister-app/player/commit/50304bf))
- feat(settings): merge the server-activity screen into the server page ([`7a82c80`](https://github.com/ister-app/player/commit/7a82c80))
- feat: save the app error log from the settings page ([`3c6a515`](https://github.com/ister-app/player/commit/3c6a515))
- feat(history): playback history per media item with delete and mark-played ([`e71d8d4`](https://github.com/ister-app/player/commit/e71d8d4))
- feat(shows): scroll the overview to the video player when an episode starts ([`1d98b67`](https://github.com/ister-app/player/commit/1d98b67))
- feat(player): sleep timer in the video controls ([`3e5a046`](https://github.com/ister-app/player/commit/3e5a046))
- feat(player): stop returns the video page to its cover and play button ([`1dbf7fa`](https://github.com/ister-app/player/commit/1dbf7fa))
- feat(downloads): choose which connections downloads may use ([`7ad11b8`](https://github.com/ister-app/player/commit/7ad11b8))
- feat(downloads): keep the next unwatched episodes downloaded ([`439260e`](https://github.com/ister-app/player/commit/439260e))
- feat(servers): guided add-server flow and a friendlier server overview ([`4585f5d`](https://github.com/ister-app/player/commit/4585f5d))
- feat(video): show the cover with a play button before playing, and until the stream runs ([`fe6f7d2`](https://github.com/ister-app/player/commit/fe6f7d2))
- feat(downloads): list cached music under one entry ([`5bcac5c`](https://github.com/ister-app/player/commit/5bcac5c))
- feat(downloads): show the downloads pages inside the server shell ([`0db9d7a`](https://github.com/ister-app/player/commit/0db9d7a))
- feat(downloads): read downloaded epubs, cbz and pdf files offline ([`f28548b`](https://github.com/ister-app/player/commit/f28548b))
- feat(downloads): keep downloads running in the background on Android ([`3dd0670`](https://github.com/ister-app/player/commit/3dd0670))
- feat(downloads): download episodes that share one media file ([`a88ca96`](https://github.com/ister-app/player/commit/a88ca96))
- feat(downloads): offline downloads, local playback and a music cache ([`5b5d459`](https://github.com/ister-app/player/commit/5b5d459))

### Fixes

- fix(player): rotate fullscreen video to both landscape sides ([`0420dbd`](https://github.com/ister-app/player/commit/0420dbd))
- fix(search): open the episode page when an episode result is tapped ([`981d517`](https://github.com/ister-app/player/commit/981d517))
- fix(player): slide sheets up from the bottom of the window ([`de44720`](https://github.com/ister-app/player/commit/de44720))
- fix(cast): show the cast without bands of empty space ([`3abae00`](https://github.com/ister-app/player/commit/3abae00))
- fix(player): no "episode 0" flash when returning from the mini player ([`90ac35f`](https://github.com/ister-app/player/commit/90ac35f))
- fix(downloads): one token refresh when requests run in parallel ([`fa239cd`](https://github.com/ister-app/player/commit/fa239cd))
- fix(home): continue-watching row no longer breaks after an episode page visit ([`c97f3b9`](https://github.com/ister-app/player/commit/c97f3b9))
- fix(downloads): label episode downloads with their season ([`ec89baf`](https://github.com/ister-app/player/commit/ec89baf))
- fix(downloads): clearer row status and auto-retry after a token rejection ([`ed1c091`](https://github.com/ister-app/player/commit/ed1c091))
- fix(downloads): start a downloaded video while its page is showing ([`ee2a80c`](https://github.com/ister-app/player/commit/ee2a80c))
- fix(downloads): retry network failures on their own ([`4087d49`](https://github.com/ister-app/player/commit/4087d49))
- fix(downloads): keep the Android foreground service up between downloads ([`df2e60c`](https://github.com/ister-app/player/commit/df2e60c))
- fix(downloads): tell what 'fill cache now' did ([`fb1f41c`](https://github.com/ister-app/player/commit/fb1f41c))
- fix(player): let the portrait cover shrink so the bottom bar stays on screen ([`6faf2d6`](https://github.com/ister-app/player/commit/6faf2d6))

### Other

- ci(e2e): pin the server to the 2.19.1-snapshot line for playback history ([`f5a0fbb`](https://github.com/ister-app/player/commit/f5a0fbb))
- perf(downloads): run the download on a background isolate ([`8efc990`](https://github.com/ister-app/player/commit/8efc990))
- perf(downloads): fetch segments in a bounded window per playlist ([`47c1eca`](https://github.com/ister-app/player/commit/47c1eca))
- ci(e2e): capture why a container died in the kind diagnostics ([`3293d59`](https://github.com/ister-app/player/commit/3293d59))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.19.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.18.0...v1.19.0

## player v1.18.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.18.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(person): play the recently added tab as an artist queue and show the added date ([`0044063`](https://github.com/ister-app/player/commit/0044063))
- feat(person): show appears-on albums and recently added tracks ([`9593b05`](https://github.com/ister-app/player/commit/9593b05))

### Fixes

- fix(e2e): generate the Dragonfly s01e08 subtitle fixture in CI ([`4d5abc8`](https://github.com/ister-app/player/commit/4d5abc8))

### Other

- ci(e2e): pin the server to 2.17.1-snapshot, v2.17.0 released before the recently-added API ([`69dd7ec`](https://github.com/ister-app/player/commit/69dd7ec))
- docs: warn that the darwin libmpv pins live in Package.swift, not the Makefiles ([`f5d1033`](https://github.com/ister-app/player/commit/f5d1033))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.18.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.17.3...v1.18.0

## player v1.17.3

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.17.3` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Run

```sh
docker pull ghcr.io/ister-app/player:1.17.3
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.17.2...v1.17.3

## player v1.17.2

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.17.2` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Run

```sh
docker pull ghcr.io/ister-app/player:1.17.2
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.17.1...v1.17.2

## player v1.17.1

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.17.1` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Fixes

- fix(player): stop losing a seek issued while the file still loads ([`46edc38`](https://github.com/ister-app/player/commit/46edc38))
- fix(player): re-pin media-kit so mpv's event pump keeps running on Android ([`dfb182b`](https://github.com/ister-app/player/commit/dfb182b))

### Other

- ci: pin the chart that publishes the e2e API port ([`4bdee09`](https://github.com/ister-app/player/commit/4bdee09))
- test(player): scrub back inside the demuxer's back buffer ([`6117d24`](https://github.com/ister-app/player/commit/6117d24))
- docs: describe the media_kit fork and the libmpv build chain ([`1dd80ab`](https://github.com/ister-app/player/commit/1dd80ab))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.17.1
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.17.0...v1.17.1

## player v1.17.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.17.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): wrap the skip buttons around play/pause ([`955a2da`](https://github.com/ister-app/player/commit/955a2da))
- feat(player): show skip-intro earlier and count down the auto-skip ([`ad4ec82`](https://github.com/ister-app/player/commit/ad4ec82))
- feat(player): brightness/device-volume swipes and exponential seek ([`13fc8b3`](https://github.com/ister-app/player/commit/13fc8b3))

### Fixes

- fix(player): pin media-kit with the Android video-out-params surface fix ([`0ebe457`](https://github.com/ister-app/player/commit/0ebe457))
- fix(player): boot straight into the server shell, without the list below it ([`79cd8c4`](https://github.com/ister-app/player/commit/79cd8c4))
- fix(player): stop snapshotting page transitions over the video texture ([`3c76e4b`](https://github.com/ister-app/player/commit/3c76e4b))
- fix(player): bump media-kit fork so video-crop resizes the texture ([`46c1bf8`](https://github.com/ister-app/player/commit/46c1bf8))
- fix(player): scale the video crop to mpv's coded frame, not the display size ([`df60d1c`](https://github.com/ister-app/player/commit/df60d1c))

### Dependency updates

- chore(deps): upgrade locked dependencies ([`08c642e`](https://github.com/ister-app/player/commit/08c642e))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.17.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.16.0...v1.17.0

## player v1.16.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.16.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): human-readable server activity screen ([`03c3aff`](https://github.com/ister-app/player/commit/03c3aff))
- feat(player): surface segment skip in the shared player view and remote control ([`b3a757e`](https://github.com/ister-app/player/commit/b3a757e))
- feat(player): skip-intro and next-episode buttons with auto-skip setting ([`5fa9ea4`](https://github.com/ister-app/player/commit/5fa9ea4))
- feat(player): expose media segments and autoSkipIntro in schema and fragments ([`97047bd`](https://github.com/ister-app/player/commit/97047bd))

### Fixes

- fix(player): read decoded video size from videoParams/rect for the crop ([`c03d43c`](https://github.com/ister-app/player/commit/c03d43c))

### Other

- test(player): cover intro/outro skip end-to-end and pin the segment fixtures ([`4875808`](https://github.com/ister-app/player/commit/4875808))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.16.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.15.0...v1.16.0

## player v1.15.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.15.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): apply server-detected crop and add zoom-to-fill toggle ([`d45ccaa`](https://github.com/ister-app/player/commit/d45ccaa))
- feat(player): custom video player controls ([`42d90e3`](https://github.com/ister-app/player/commit/42d90e3))
- feat(episodes): play and surface multi-episode files (s04e06-e07) ([`977f87f`](https://github.com/ister-app/player/commit/977f87f))
- feat(windows): system media controls through SMTC ([`7195979`](https://github.com/ister-app/player/commit/7195979))
- feat(desktop): add the windows and macos runner projects ([`51db4d8`](https://github.com/ister-app/player/commit/51db4d8))

### Fixes

- fix(player): correct external-subtitle timing against the TS timeline ([`959ea1d`](https://github.com/ister-app/player/commit/959ea1d))
- fix(player): side-load native subtitles as external SRTs ([`ee2fd0f`](https://github.com/ister-app/player/commit/ee2fd0f))
- fix(player): seek without stream re-open and surface HLS subtitles again ([`196fa24`](https://github.com/ister-app/player/commit/196fa24))
- fix(ci): repoint the e2e server pin to 2.13.0 for targetDeviceId and mediaFileParts ([`e651e6e`](https://github.com/ister-app/player/commit/e651e6e))
- fix(web): retry playback after a swallowed autoplay rejection ([`b617e4c`](https://github.com/ister-app/player/commit/b617e4c))
- fix(windows): silence the experimental-coroutine deprecation error ([`ac1a3b9`](https://github.com/ister-app/player/commit/ac1a3b9))
- fix(linux): drop the unused runner/ copy of the GTK runner ([`8b3d235`](https://github.com/ister-app/player/commit/8b3d235))

### Other

- test(player): detect stream re-open via track-list reset instead of timing ([`406eddc`](https://github.com/ister-app/player/commit/406eddc))
- test(player): probe raw sub-text for duplicate cue rendering ([`7601682`](https://github.com/ister-app/player/commit/7601682))
- docs(player): pin down why native subtitles must be WEBVTT, add mpv probe ([`0b750c5`](https://github.com/ister-app/player/commit/0b750c5))
- build(player): bump media-kit pin for dependency refresh and hls.js 1.7.0 ([`5187ea5`](https://github.com/ister-app/player/commit/5187ea5))
- build(player): bump media-kit pin for subtitle cleanup and extension_picky ([`e21b65d`](https://github.com/ister-app/player/commit/e21b65d))
- perf(player): use optimizedDeepEquals for cache rebroadcasts ([`72aa60e`](https://github.com/ister-app/player/commit/72aa60e))
- ci: dedupe release version stamping and cache the desktop release builds ([`8c05351`](https://github.com/ister-app/player/commit/8c05351))
- chore: ignore the Swift Package Manager build directories ([`9fa2178`](https://github.com/ister-app/player/commit/9fa2178))
- docs: document the windows and macos builds ([`0eae09f`](https://github.com/ister-app/player/commit/0eae09f))
- ci: build windows and macos, and attach their zips to the release ([`5e78636`](https://github.com/ister-app/player/commit/5e78636))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.15.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.14.1...v1.15.0

## player v1.14.1

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.14.1` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Other

- build(flatpak): update the mpv stack to FFmpeg 9 ([`c2afc6a`](https://github.com/ister-app/player/commit/c2afc6a))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.14.1
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.14.0...v1.14.1

## player v1.14.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.14.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): fit the queue tabs to the viewport instead of growing past it ([`6ee0abb`](https://github.com/ister-app/player/commit/6ee0abb))
- feat(devices): pull a playing queue to this device (HANDOFF_QUEUE) ([`87395ec`](https://github.com/ister-app/player/commit/87395ec))

### Fixes

- fix(playback): don't crash starting an item whose media file isn't ready ([`05f997b`](https://github.com/ister-app/player/commit/05f997b))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.14.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.13.0...v1.14.0

## player v1.13.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.13.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): toggle sort direction by re-clicking the sort field ([`829c84b`](https://github.com/ister-app/player/commit/829c84b))
- feat: bake last_update frontmatter into the docs zip ([`32fb447`](https://github.com/ister-app/player/commit/32fb447))
- feat(player): switch servers from the home title and surface refresh ([`a36d7fb`](https://github.com/ister-app/player/commit/a36d7fb))
- feat(player): park the queue on the next item when the item sleep timer ends ([`e21e8e2`](https://github.com/ister-app/player/commit/e21e8e2))
- feat(player): sleep timer and listen-together beside the overflow menu ([`758f18f`](https://github.com/ister-app/player/commit/758f18f))
- feat(player): move the secondary player actions to a bottom action bar ([`0b17169`](https://github.com/ister-app/player/commit/0b17169))
- feat(player): stop playback from the players and the mini player ([`edaffc0`](https://github.com/ister-app/player/commit/edaffc0))

### Fixes

- fix(e2e): stop the app cache from shadowing gqlRaw server-state probes ([`79186f7`](https://github.com/ister-app/player/commit/79186f7))
- fix(ci): repoint the e2e server pin to the snapshot that has STOP ([`b677820`](https://github.com/ister-app/player/commit/b677820))
- fix(player): show name on episode cards and year on show cards ([`8c53542`](https://github.com/ister-app/player/commit/8c53542))
- fix(player): reset per-server state when switching servers in place ([`a15465f`](https://github.com/ister-app/player/commit/a15465f))

### Other

- test(e2e): dump the server-side queue when the watch-status wait fails ([`c8d05a4`](https://github.com/ister-app/player/commit/c8d05a4))
- chore: drop stray resume-sync-play scratch file ([`e0b3ed0`](https://github.com/ister-app/player/commit/e0b3ed0))
- test(e2e): harden the movie watch-status wait against starved CI nodes ([`45dd946`](https://github.com/ister-app/player/commit/45dd946))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.13.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.12.0...v1.13.0

## player v1.12.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.12.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(player): end playback locally when the shared session goes away ([`407f25e`](https://github.com/ister-app/player/commit/407f25e))
- feat(player): media-type artwork placeholder in the player views ([`3478407`](https://github.com/ister-app/player/commit/3478407))
- feat(player): watch-together entry points on the video surface ([`2377b90`](https://github.com/ister-app/player/commit/2377b90))
- feat(follow): watch-together wording for video sessions ([`65492c3`](https://github.com/ister-app/player/commit/65492c3))
- feat(follow): open the video page when following a watch session ([`934f342`](https://github.com/ister-app/player/commit/934f342))
- feat(player): unify listen-along actions into one listen-together sheet ([`e498960`](https://github.com/ister-app/player/commit/e498960))

### Fixes

- fix(player): close the video page when the queue ends instead of freezing on the last frame ([`63e77e1`](https://github.com/ister-app/player/commit/63e77e1))
- fix(tv): keep D-pad moves inside the scrollable so below-the-fold content is reachable ([`272134c`](https://github.com/ister-app/player/commit/272134c))
- fix(player): scale the mpv demuxer cache to device RAM ([`d4c55f0`](https://github.com/ister-app/player/commit/d4c55f0))
- fix(follow): leave follow mode when starting own playback ([`bf716e1`](https://github.com/ister-app/player/commit/bf716e1))
- fix(player): recover from silently dead websockets ([`59b6402`](https://github.com/ister-app/player/commit/59b6402))

### Other

- ci: drop the stale pub-cache fallback that corrupts resolution after a git pin bump ([`e1b9846`](https://github.com/ister-app/player/commit/e1b9846))
- build: refresh dependency lock ([`cd2c53c`](https://github.com/ister-app/player/commit/cd2c53c))
- perf(player): quiet resume after a remote play command ([`457e2da`](https://github.com/ister-app/player/commit/457e2da))
- perf(player): slim response for the progress heartbeat ([`7042ac9`](https://github.com/ister-app/player/commit/7042ac9))
- perf(player): keep heartbeat mutations out of the GraphQL cache ([`0e776e4`](https://github.com/ister-app/player/commit/0e776e4))
- build: bump media-kit fork for the linux triple-buffer black-flash fix ([`2d58cac`](https://github.com/ister-app/player/commit/2d58cac))
- refactor(player): extract SessionListenersList from the listeners sheet ([`352a069`](https://github.com/ister-app/player/commit/352a069))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.12.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.11.0...v1.12.0

## player v1.11.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.11.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(books): show whole-book progress in continue watching ([`762fd73`](https://github.com/ister-app/player/commit/762fd73))
- feat(player): announce the sleep timer and let it count media items ([`a701ee7`](https://github.com/ister-app/player/commit/a701ee7))
- feat(player): give the remote control the same player as local playback ([`2c336ba`](https://github.com/ister-app/player/commit/2c336ba))
- feat(devices): show and remove the devices listening along ([`833c247`](https://github.com/ister-app/player/commit/833c247))

### Fixes

- fix(player): refresh the continue-watching row once per item switch ([`2bc8603`](https://github.com/ister-app/player/commit/2bc8603))
- fix(player): hide listen-along for your own playing session ([`dd3c961`](https://github.com/ister-app/player/commit/dd3c961))

### Other

- refactor(player): share the queue logic between the local and remote player ([`d51d9bc`](https://github.com/ister-app/player/commit/d51d9bc))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.11.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.10.0...v1.11.0

## player v1.10.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.10.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(devices): play on, hand off to and listen along on another device ([`0fbe245`](https://github.com/ister-app/player/commit/0fbe245))
- feat(devices): devices settings page ([`5a68ba7`](https://github.com/ister-app/player/commit/5a68ba7))
- feat(devices): device registration and command channel ([`d4d6fca`](https://github.com/ister-app/player/commit/d4d6fca))
- feat(playlist): create a playlist from the add-to-playlist sheet ([`87601bf`](https://github.com/ister-app/player/commit/87601bf))
- feat(playlist): cover mosaic and artwork rows for every playlist kind ([`4c0a1f1`](https://github.com/ister-app/player/commit/4c0a1f1))
- feat(playlist): play a smart playlist from the tapped track ([`b0098a0`](https://github.com/ister-app/player/commit/b0098a0))
- feat(library): save the browse filter as a smart playlist ([`26b054f`](https://github.com/ister-app/player/commit/26b054f))
- feat(auto): playlists in the Android Auto browse tree ([`414f9d4`](https://github.com/ister-app/player/commit/414f9d4))
- feat(library): playlists with manual items and smart filters ([`f92c9cf`](https://github.com/ister-app/player/commit/f92c9cf))
- feat(player): tight audio sync for listen-along (same-room mode) ([`0381f28`](https://github.com/ister-app/player/commit/0381f28))
- feat(player): listen along with another device's play queue ([`5b2bca0`](https://github.com/ister-app/player/commit/5b2bca0))
- feat(library): custom filters with saved views and filtered play queues ([`c54a2d6`](https://github.com/ister-app/player/commit/c54a2d6))
- feat(library): browse kind switcher and grid/list layout toggle ([`7dfa99b`](https://github.com/ister-app/player/commit/7dfa99b))

### Fixes

- fix(ci): pin the chart with widened database probe timeouts ([`027a161`](https://github.com/ister-app/player/commit/027a161))
- fix(ci): pin server 2.7.1-snapshot for the listen-along tight-sync schema ([`09a4438`](https://github.com/ister-app/player/commit/09a4438))
- fix(player): stop watchdog and progress sync reverting the previous item during a queue switch ([`c198bc5`](https://github.com/ister-app/player/commit/c198bc5))

### Other

- test(e2e): playlist playback against the kind deployment ([`7c844d9`](https://github.com/ister-app/player/commit/7c844d9))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.10.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.9.0...v1.10.0

## player v1.9.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.9.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat(auto): resume the last music play queue in Android Auto ([`90937ec`](https://github.com/ister-app/player/commit/90937ec))
- feat(auto): render discover sections as cover grids under clickable headers ([`884b783`](https://github.com/ister-app/player/commit/884b783))
- feat(player): restore the last music play queue paused after a restart ([`ecd2aff`](https://github.com/ister-app/player/commit/ecd2aff))
- feat(rating): tint rating stars with the page accent colour ([`9563645`](https://github.com/ister-app/player/commit/9563645))
- feat(library): move the library switcher into the app-bar title ([`707d5ad`](https://github.com/ister-app/player/commit/707d5ad))
- feat(artist): play the ranked artist list as the queue ([`d92000e`](https://github.com/ister-app/player/commit/d92000e))
- feat: navigate to the artist/album page from the player's metadata lines ([`e2b3949`](https://github.com/ister-app/player/commit/e2b3949))
- feat: inline the Android Auto discover groups in the library views ([`562b168`](https://github.com/ister-app/player/commit/562b168))
- feat: restyle the library view switch as scrolling text pills ([`e5852d2`](https://github.com/ister-app/player/commit/e5852d2))
- feat: discover groups in the Android Auto browse tree ([`ea55d85`](https://github.com/ister-app/player/commit/ea55d85))
- feat: link the Ister website and GitHub from the about page ([`c970978`](https://github.com/ister-app/player/commit/c970978))
- feat: make every page URL-addressable for bookmarks and deep links ([`90687fc`](https://github.com/ister-app/player/commit/90687fc))
- feat: clickable carousel headers opening full vertical lists ([`9fa418e`](https://github.com/ister-app/player/commit/9fa418e))

### Fixes

- fix: don't bounce a fresh music play to the start screen ([`814a7c1`](https://github.com/ister-app/player/commit/814a7c1))
- fix(ci): fall back to the next same-major server release when the pinned patch was never released ([`eaeb3a5`](https://github.com/ister-app/player/commit/eaeb3a5))
- fix: readable card captions on narrow continue-watching grids ([`7a6e2d2`](https://github.com/ister-app/player/commit/7a6e2d2))

### Other

- build(android): compile against SDK 37 for permission_handler 13 ([`0c60f75`](https://github.com/ister-app/player/commit/0c60f75))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.9.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.8.0...v1.9.0

## player v1.8.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.8.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: match the person-page play buttons to the album page ([`5eb3d49`](https://github.com/ister-app/player/commit/5eb3d49))
- feat: put the artist top-track lists behind shared tabs ([`526c8c0`](https://github.com/ister-app/player/commit/526c8c0))
- feat: discover view with per-type top-list carousels on the library tab ([`921cd5c`](https://github.com/ister-app/player/commit/921cd5c))
- feat: sleep timer with automatic start window ([`2174631`](https://github.com/ister-app/player/commit/2174631))
- feat: most played, last played and highest rated tracks on the artist page ([`aba664b`](https://github.com/ister-app/player/commit/aba664b))

### Fixes

- fix: drop late play-queue responses from a replaced queue ([`87c7c80`](https://github.com/ister-app/player/commit/87c7c80))
- fix: show source attribution on the show overview page ([`24be092`](https://github.com/ister-app/player/commit/24be092))
- fix: keep the album stats visible on narrow screens ([`2af88a3`](https://github.com/ister-app/player/commit/2af88a3))
- fix: only auto-add the web hosting origin when it serves an Ister well-known ([`0854972`](https://github.com/ister-app/player/commit/0854972))
- fix: hide the app navigation chrome when a reader is fullscreen ([`e96eb2c`](https://github.com/ister-app/player/commit/e96eb2c))

### Other

- ci: pin e2e server to released 2.4.0 (was 2.3.1-snapshot) ([`8b55ec0`](https://github.com/ister-app/player/commit/8b55ec0))
- ci: run e2e against server 2.3.1-snapshot for the discover top-lists ([`3d63619`](https://github.com/ister-app/player/commit/3d63619))
- test: pin the sleep timer button and sheet flow in the player ([`2098b27`](https://github.com/ister-app/player/commit/2098b27))
- docs: add SEO descriptions and link the published docs site ([`f1622c6`](https://github.com/ister-app/player/commit/f1622c6))
- docs: add GPLv3 license ([`a9bbdab`](https://github.com/ister-app/player/commit/a9bbdab))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.8.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.7.0...v1.8.0

## player v1.7.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.7.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: add a whole album to the play queue from the album page ([`64ebca7`](https://github.com/ister-app/player/commit/64ebca7))
- feat: reader fullscreen toggle, typography settings and epub tap zones ([`3b785e6`](https://github.com/ister-app/player/commit/3b785e6))

### Fixes

- fix: always show the play queue tabs, with an empty state ([`d023b24`](https://github.com/ister-app/player/commit/d023b24))
- fix: keep the audio_service notification icons through release resource shrinking ([`e2232c3`](https://github.com/ister-app/player/commit/e2232c3))
- fix: request notification permission so the Android media notification shows again ([`b9bd951`](https://github.com/ister-app/player/commit/b9bd951))

### Other

- ci: count a lost result event after an all-green run as a pass ([`fdb5f33`](https://github.com/ister-app/player/commit/fdb5f33))
- build: update oidc to 3.x ([`1941156`](https://github.com/ister-app/player/commit/1941156))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.7.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.6.0...v1.7.0

## player v1.6.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.6.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: freshen up the person page ([`30c92b3`](https://github.com/ister-app/player/commit/30c92b3))
- feat: play audiobooks directly from the Android Auto book list ([`d0a5a3e`](https://github.com/ister-app/player/commit/d0a5a3e))
- feat: preview the hovered rating value on the rating stars ([`a9098fe`](https://github.com/ister-app/player/commit/a9098fe))
- feat: polish the album page with disc grouping and scroll-to-track from search ([`55e4131`](https://github.com/ister-app/player/commit/55e4131))

### Fixes

- fix: show a not-found message when a person fails to load ([`5ed334f`](https://github.com/ister-app/player/commit/5ed334f))
- fix: keep the TV focus highlight off rows whose menu button holds focus ([`cd9d1c8`](https://github.com/ister-app/player/commit/cd9d1c8))

### Dependency updates

- chore(deps): upgrade pub dependencies ([`10475cf`](https://github.com/ister-app/player/commit/10475cf))
- chore(deps): update github actions (major) ([`574c9db`](https://github.com/ister-app/player/commit/574c9db))
- chore(deps): update com.android.application to v9.3.1 and kotlin.android to v2.4.10 ([`86bfbfd`](https://github.com/ister-app/player/commit/86bfbfd))
- chore(deps): update gradle to v9.6.1 ([`f128ea6`](https://github.com/ister-app/player/commit/f128ea6))
- chore(deps): update dependency flutter to v3.44.8 ([`214c0ae`](https://github.com/ister-app/player/commit/214c0ae))

### Other

- test: cover the per-track artist line on the album page ([`b7703c9`](https://github.com/ister-app/player/commit/b7703c9))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.6.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.5.0...v1.6.0

## player v1.5.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.5.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: browse audiobooks and podcasts in Android Auto ([`ac984e4`](https://github.com/ister-app/player/commit/ac984e4))

### Other

- docs: add installation chapter linking releases and the web app ([`191de2d`](https://github.com/ister-app/player/commit/191de2d))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.5.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.4.0...v1.5.0

## player v1.4.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.4.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: sharing & privacy controls for now-playing and remote control ([`ab42f50`](https://github.com/ister-app/player/commit/ab42f50))
- feat: gate admin actions and add library-access management UI ([`06fba69`](https://github.com/ister-app/player/commit/06fba69))
- feat: prefer local artwork over scraped provider images ([`8f0a8a9`](https://github.com/ister-app/player/commit/8f0a8a9))
- feat: apply forest logo palette to launcher/web icons and app theme ([`b133164`](https://github.com/ister-app/player/commit/b133164))
- feat: show metadata and image source attribution ([`26bca4e`](https://github.com/ister-app/player/commit/26bca4e))

### Fixes

- fix: tolerate null user name in doc-tour admin stop ([`9e4eaa3`](https://github.com/ister-app/player/commit/9e4eaa3))
- fix: hide podcast subscribe and unsubscribe for non-admins ([`81563bd`](https://github.com/ister-app/player/commit/81563bd))

### Other

- ci: pin the e2e server to the 2.2.0 release ([`6b5caa7`](https://github.com/ister-app/player/commit/6b5caa7))
- ci: let the release gate accept a chart commit sha pin ([`f3d9064`](https://github.com/ister-app/player/commit/f3d9064))
- ci: re-pin chart to the admin-aware e2e fixture ([`bada546`](https://github.com/ister-app/player/commit/bada546))
- docs: cover ratings, sharing/privacy, reader & comic options and more ([`01ebc25`](https://github.com/ister-app/player/commit/01ebc25))
- ci: re-pin chart to the reachable fixture-aware mock commit ([`70e199c`](https://github.com/ister-app/player/commit/70e199c))
- docs: document admin screens and capture them in the doc tour ([`cbb93bb`](https://github.com/ister-app/player/commit/cbb93bb))
- ci: pin the fixture-aware chart mock and server 2.1.2-snapshot ([`109b533`](https://github.com/ister-app/player/commit/109b533))
- chore: recolor the app icon greens to a lime/olive palette ([`451ef24`](https://github.com/ister-app/player/commit/451ef24))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.4.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.3.0...v1.4.0

## player v1.3.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.3.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: server-synced reading direction, fullscreen readers and comic reader extras ([`2368cee`](https://github.com/ister-app/player/commit/2368cee))

### Fixes

- fix: defer notifier writes that fire while the widget tree is building or locked ([`ca42496`](https://github.com/ister-app/player/commit/ca42496))
- fix: keep notification artwork alive after stream-token rotation ([`3928284`](https://github.com/ister-app/player/commit/3928284))
- fix: render comic libraries on the server home page ([`499862f`](https://github.com/ister-app/player/commit/499862f))

### Other

- ci: survive a commit racing onto main during a release ([`fbf805d`](https://github.com/ister-app/player/commit/fbf805d))
- ci: push the release commit and tag atomically ([`8aa774c`](https://github.com/ister-app/player/commit/8aa774c))
- test: capture all doc-tour locales in a single app run ([`7ed5491`](https://github.com/ister-app/player/commit/7ed5491))
- test: cover comic library rendering on the server home page ([`dd747cc`](https://github.com/ister-app/player/commit/dd747cc))
- ci: deploy the released web build to GitHub Pages (player.ister.app) ([`290141c`](https://github.com/ister-app/player/commit/290141c))

### Other changes

- Replace default Flutter web icons with the green chair launcher icon ([`ff04f63`](https://github.com/ister-app/player/commit/ff04f63))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.3.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.2.0...v1.3.0

## player v1.2.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.2.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: add user and architecture docs with a screenshot-capture release pipeline ([`c43f19b`](https://github.com/ister-app/player/commit/c43f19b))
- feat(test): integration e2e suite against the chart deployment in kind ([`e772c2a`](https://github.com/ister-app/player/commit/e772c2a))
- feat(comic): continue-reading tiles for comic series in the recent carousel ([`80b76a4`](https://github.com/ister-app/player/commit/80b76a4))
- feat(comic): series browsing — COMIC library grid, series page and reader dispatch ([`904abf1`](https://github.com/ister-app/player/commit/904abf1))
- feat(comic): PDF volumes via pdfium (pdfrx) in the shared page reader ([`4c03e4d`](https://github.com/ister-app/player/commit/4c03e4d))
- feat(comic): CBZ reader with zoom, RTL, spreads and page picker ([`58bf8f9`](https://github.com/ister-app/player/commit/58bf8f9))
- feat(comic): manifest client, locator, progress sync and preferences ([`7fe0375`](https://github.com/ister-app/player/commit/7fe0375))
- feat(graphql): sync schema for comics — series types, nullable Book.author, MediaFile format/pageCount ([`33c592b`](https://github.com/ister-app/player/commit/33c592b))
- feat(reader): render epubs natively instead of launching the web reader ([`49f3712`](https://github.com/ister-app/player/commit/49f3712))

### Fixes

- fix: show Book.title everywhere instead of the metadata title ([`bfa1f44`](https://github.com/ister-app/player/commit/bfa1f44))
- fix(reader): retry epub resource fetches on transient socket errors ([`08861c9`](https://github.com/ister-app/player/commit/08861c9))
- fix(player): defer the videoPageOpen bump to after the first frame ([`bef21ea`](https://github.com/ister-app/player/commit/bef21ea))
- fix(comic): label double-page spreads as a page range ([`9cb27a3`](https://github.com/ister-app/player/commit/9cb27a3))
- fix(comic): show the read button for cbz/pdf-only volumes on the book page ([`cd336d3`](https://github.com/ister-app/player/commit/cd336d3))
- fix(server-home): back-to-servers escape on the login and loading states ([`377b088`](https://github.com/ister-app/player/commit/377b088))
- fix(recent): render podcast tiles square like the podcast library carousel ([`616b37e`](https://github.com/ister-app/player/commit/616b37e))

### Dependency updates

- fix(deps): upgrade dependencies (xml 7, flutter_widget_from_html_core 0.17) ([`30f2934`](https://github.com/ister-app/player/commit/30f2934))

### Other

- ci: pin the e2e against server 2.1.0 on chart v0.4.0 ([`d7e2551`](https://github.com/ister-app/player/commit/d7e2551))
- ci: anchor the e2e-pins -snapshot gate to the value line ([`28ac708`](https://github.com/ister-app/player/commit/28ac708))
- docs: describe the docs-build pipeline in CLAUDE.md ([`ddb13e3`](https://github.com/ister-app/player/commit/ddb13e3))
- ci: retry an e2e file when the desktop runner loses the final result event ([`1825476`](https://github.com/ister-app/player/commit/1825476))
- ci: pin the e2e against testdata with silent audio tracks in the video fixtures ([`c9d184b`](https://github.com/ister-app/player/commit/c9d184b))
- ci: pin the e2e against the chart release deploying server 2.0.1 ([`679af36`](https://github.com/ister-app/player/commit/679af36))
- ci: give the integration tests an audio sink ([`82c6052`](https://github.com/ister-app/player/commit/82c6052))
- test(e2e): make the reader and audio tests deterministic on CI ([`eb78168`](https://github.com/ister-app/player/commit/eb78168))
- ci: run integration tests per file and harden the reading-progress poll ([`b7a895f`](https://github.com/ister-app/player/commit/b7a895f))
- ci: pin the e2e against chart v0.3.0 ([`37c94df`](https://github.com/ister-app/player/commit/37c94df))
- ci: skip the integration e2e cleanly when the pinned chart predates it ([`75d6042`](https://github.com/ister-app/player/commit/75d6042))
- ci: only feed KEY=value lines from the e2e pins into GITHUB_ENV ([`26c0c2f`](https://github.com/ister-app/player/commit/26c0c2f))
- ci: accept the lowercase -snapshot suffix in the release gate ([`ef70946`](https://github.com/ister-app/player/commit/ef70946))
- ci: pin the e2e against chart v0.2.2 and the current testdata commit ([`486bc8a`](https://github.com/ister-app/player/commit/486bc8a))
- docs: describe the integration e2e suite, test seam and version pins ([`782e71f`](https://github.com/ister-app/player/commit/782e71f))
- test(comic): cover the COMIC continue-reading tile in the recent carousel ([`12860de`](https://github.com/ister-app/player/commit/12860de))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.2.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.1.0...v1.2.0

## player v1.1.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.1.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Features

- feat: show release year / birth year next to the title on detail pages ([`da86724`](https://github.com/ister-app/player/commit/da86724))
- feat(recent): render one book tile for the merged continue-watching entry ([`1b11c4f`](https://github.com/ister-app/player/commit/1b11c4f))
- feat(person): sort albums, books and filmography newest-first ([`0ba49ab`](https://github.com/ister-app/player/commit/0ba49ab))
- feat: sort the library grid by name, date added or release year ([`c5912e9`](https://github.com/ister-app/player/commit/c5912e9))
- feat: show app version and commit hash in settings ([`a730ed4`](https://github.com/ister-app/player/commit/a730ed4))

### Fixes

- fix: show audiobook cover in its 2:3 aspect ratio in the player ([`b31dd73`](https://github.com/ister-app/player/commit/b31dd73))

### Dependency updates

- chore(deps): bump connectivity_plus, package_info_plus and uuid ([`71271fd`](https://github.com/ister-app/player/commit/71271fd))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.1.0
```

**Full changelog**: https://github.com/ister-app/player/compare/v1.0.0...v1.1.0

## player v1.0.0

The web player ships as an image; the Android and Linux builds are attached to this release.

| Platform | Where |
|---|---|
| Web | `ghcr.io/ister-app/player:1.0.0` |
| Android | `app-release.apk` below |
| Linux | `app.ister.Player.flatpak` below |

### Fixes

- fix(ci): push an annotated release tag ([`65a1e93`](https://github.com/ister-app/player/commit/65a1e93))

### Other

- docs: refresh CLAUDE.md for server-side settings and new media kinds ([`4d23b1e`](https://github.com/ister-app/player/commit/4d23b1e))
- ci: release nightly from a green main ([`8c988d5`](https://github.com/ister-app/player/commit/8c988d5))

### Other changes

- Resume an audiobook where the listener actually left off ([`3f62660`](https://github.com/ister-app/player/commit/3f62660))
- Upgrade oidc to 2.0 and adapt to its breaking changes ([`5bb485e`](https://github.com/ister-app/player/commit/5bb485e))
- Keep playback settings on the server instead of on the device ([`d8fe7f4`](https://github.com/ister-app/player/commit/d8fe7f4))
- Count a saved reading location as book progress ([`0bbb13f`](https://github.com/ister-app/player/commit/0bbb13f))
- Make iPhone fullscreen consistently use the native player ([`be6a054`](https://github.com/ister-app/player/commit/be6a054))
- Fix white bars around video on iPad and iPhone Safari ([`2087081`](https://github.com/ister-app/player/commit/2087081))
- Let each podcast remember how its episodes are sorted ([`588ca4d`](https://github.com/ister-app/player/commit/588ca4d))
- Show book covers in their own portrait aspect ratio ([`0916f05`](https://github.com/ister-app/player/commit/0916f05))
- Resume audiobook chapters and podcast episodes where they left off ([`ce76e24`](https://github.com/ister-app/player/commit/ce76e24))
- Load more podcast episodes after the frame, not during build ([`5372f7a`](https://github.com/ister-app/player/commit/5372f7a))
- Ask how to read a book before starting it ([`22f0a1d`](https://github.com/ister-app/player/commit/22f0a1d))
- Add book and podcast library support ([`6d25e8c`](https://github.com/ister-app/player/commit/6d25e8c))
- Rate the playing track by its track id, not the queue-item id ([`0f7aacc`](https://github.com/ister-app/player/commit/0f7aacc))
- Show track star ratings inline and rate the playing track ([`d160018`](https://github.com/ister-app/player/commit/d160018))
- Hydrate the well-known cache before the first frame ([`b6f89d0`](https://github.com/ister-app/player/commit/b6f89d0))
- Share the full player UI between local playback and party-mode remote ([`a233e9d`](https://github.com/ister-app/player/commit/a233e9d))
- Serve web entrypoints with no-cache so new deploys are picked up ([`6ed7e78`](https://github.com/ister-app/player/commit/6ed7e78))
- Add party mode: remote control of active playback sessions ([`569cd74`](https://github.com/ister-app/player/commit/569cd74))
- Add per-user star ratings for movies, shows, episodes, albums and tracks ([`8130117`](https://github.com/ister-app/player/commit/8130117))
- Fetch cast as a separate paginated call ([`1afbc3b`](https://github.com/ister-app/player/commit/1afbc3b))
- Add a live server activity dashboard with a now-playing view ([`0d0d3f4`](https://github.com/ister-app/player/commit/0d0d3f4))
- Derive the music player accent via ColorScheme.fromImageProvider ([`aab391e`](https://github.com/ister-app/player/commit/aab391e))
- Keep video playback embedded on non-TV devices ([`9f17e5e`](https://github.com/ister-app/player/commit/9f17e5e))
- Polish skeleton loading on the show overview page ([`94cb10a`](https://github.com/ister-app/player/commit/94cb10a))
- Generalize the artist page into a person page ([`5841632`](https://github.com/ister-app/player/commit/5841632))
- Send streamSettings with play-queue progress updates ([`fa2aff5`](https://github.com/ister-app/player/commit/fa2aff5))
- Move library management actions into Server settings ([`1457fee`](https://github.com/ister-app/player/commit/1457fee))
- Sync GraphQL schema with server (Episode.number non-null) ([`d18b3f1`](https://github.com/ister-app/player/commit/d18b3f1))
- Enrich search, artist filmography, and music player UX ([`2d2f031`](https://github.com/ister-app/player/commit/2d2f031))
- Fix fullscreen re-entry from the embedded video tap target ([`17c20de`](https://github.com/ister-app/player/commit/17c20de))
- Play videos fullscreen, pausing on exit ([`43ecfe1`](https://github.com/ister-app/player/commit/43ecfe1))
- Use directional navigation mode on TV so the progress slider releases focus ([`3350a71`](https://github.com/ister-app/player/commit/3350a71))
- Use rail navigation on Android TV with reliable D-pad focus crossing ([`c0fbb5e`](https://github.com/ister-app/player/commit/c0fbb5e))
- Make D-pad focus visible on Android TV ([`21429af`](https://github.com/ister-app/player/commit/21429af))
- Add Android TV support: manifest, D-pad focus, remote controls ([`c84ceed`](https://github.com/ister-app/player/commit/c84ceed))
- Auto-skip unplayable tracks with a toast instead of stalling ([`ae3a28f`](https://github.com/ister-app/player/commit/ae3a28f))
- Support new GraphQL API: unified play queue, search, queue editing, shuffle ([`8cdcb0f`](https://github.com/ister-app/player/commit/8cdcb0f))
- Add cast/credits support and person-based artist pages ([`a93e5a2`](https://github.com/ister-app/player/commit/a93e5a2))
- Fix stale current-track state after switching tracks ([`fc6b27e`](https://github.com/ister-app/player/commit/fc6b27e))
- Fix mini player not showing on web ([`d8d91f6`](https://github.com/ister-app/player/commit/d8d91f6))
- Add video mini player, reusing the music mini bar ([`3f93ba1`](https://github.com/ister-app/player/commit/3f93ba1))
- Fix web build: dynamic dispatch for mpv setProperty calls ([`146ffad`](https://github.com/ister-app/player/commit/146ffad))
- Complete Android Auto support for music libraries ([`dfc4cc8`](https://github.com/ister-app/player/commit/dfc4cc8))
- Update CLAUDE.md with service architecture and gotchas ([`7864ff2`](https://github.com/ister-app/player/commit/7864ff2))
- Fix code review findings and add album art placeholders ([`e251fd4`](https://github.com/ister-app/player/commit/e251fd4))
- Update dependencies and Android toolchain ([`a0235be`](https://github.com/ister-app/player/commit/a0235be))
- Exclude build and vendored dirs from analysis ([`e0a9cb4`](https://github.com/ister-app/player/commit/e0a9cb4))
- Add music support: albums, artists and music player ([`d96a717`](https://github.com/ister-app/player/commit/d96a717))
- Fix library lazy loading ([`fca387a`](https://github.com/ister-app/player/commit/fca387a))
- Remove dynamic colour ([`2ed8af8`](https://github.com/ister-app/player/commit/2ed8af8))
- Set in web de default server ([`f49c904`](https://github.com/ister-app/player/commit/f49c904))
- Weg build wasm and without cdn ([`6851910`](https://github.com/ister-app/player/commit/6851910))
- Web version working ([`25909da`](https://github.com/ister-app/player/commit/25909da))
- Style change and library refresh fix ([`54d3c28`](https://github.com/ister-app/player/commit/54d3c28))
- Settings page with subpages ([`97f343d`](https://github.com/ister-app/player/commit/97f343d))
- Serverlist show server info ([`0cef45d`](https://github.com/ister-app/player/commit/0cef45d))
- Added support for more libraries and movies ([`4f26f6e`](https://github.com/ister-app/player/commit/4f26f6e))
- Dynamic colour added ([`59048eb`](https://github.com/ister-app/player/commit/59048eb))
- Multi server support and some bug fixes ([`eebe035`](https://github.com/ister-app/player/commit/eebe035))
- Update depedencies ([`6b48400`](https://github.com/ister-app/player/commit/6b48400))
- Update depedencies ([`7e0672c`](https://github.com/ister-app/player/commit/7e0672c))
- Github action flatpak ([`c6efe7b`](https://github.com/ister-app/player/commit/c6efe7b))
- Refactor playback with audio_service and MediaPlayerHandler Replace PlayQueue component with MediaPlayerHandler (BaseAudioHandler) for background audio support. Add ProgressSyncer for throttled watch progress updates and TrackSelector for automatic language selection. Add redirect to github.com/ister-app after successful OIDC login. ([`ef82d43`](https://github.com/ister-app/player/commit/ef82d43))
- Fix empty language field moveable ([`05a2d4f`](https://github.com/ister-app/player/commit/05a2d4f))
- Make list size of all items and the not loaded once as skelleton ([`de25574`](https://github.com/ister-app/player/commit/de25574))
- Feature added to set preferred language for the media ([`4d40d40`](https://github.com/ister-app/player/commit/4d40d40))
- Cancel playQueueSubscription when RecentCarouselView is disposed ([`ab3e950`](https://github.com/ister-app/player/commit/ab3e950))
- Feature blurhash added ([`5fea5e5`](https://github.com/ister-app/player/commit/5fea5e5))
- Close fullscreen video oncompleted ([`187a4ca`](https://github.com/ister-app/player/commit/187a4ca))
- Rollback depedency update ([`5f53e31`](https://github.com/ister-app/player/commit/5f53e31))
- Add server home screend add tab navigation and a library page ([`1566b82`](https://github.com/ister-app/player/commit/1566b82))
- Update depedencies ([`1279be8`](https://github.com/ister-app/player/commit/1279be8))
- Fix recreating playqueue when resizing screen ([`62e07eb`](https://github.com/ister-app/player/commit/62e07eb))
- Update depedencies ([`042bf72`](https://github.com/ister-app/player/commit/042bf72))
- Update depedencies ([`c70b402`](https://github.com/ister-app/player/commit/c70b402))
- Trigger refresh indicator with menu ([`94b8d39`](https://github.com/ister-app/player/commit/94b8d39))
- Dynamic load more tvshows and fix spinner ([`2ea815b`](https://github.com/ister-app/player/commit/2ea815b))
- Replaced CarouselView with ListView for horizontal ([`dca6a12`](https://github.com/ister-app/player/commit/dca6a12))
- Added refresh functionality in `ServerHomeContentPage` and handle empty views. ([`6e8125b`](https://github.com/ister-app/player/commit/6e8125b))
- Episode title ellipsis ([`787d1df`](https://github.com/ister-app/player/commit/787d1df))
- Show dialog with JSON info episode view ([`81cbe96`](https://github.com/ister-app/player/commit/81cbe96))
- Update depedencies ([`688dbdf`](https://github.com/ister-app/player/commit/688dbdf))
- Only show player if mediafile is present ([`4527e66`](https://github.com/ister-app/player/commit/4527e66))
- Only show player if episode query is completed ([`085b95d`](https://github.com/ister-app/player/commit/085b95d))
- Update playqueue current item correct ([`bae7764`](https://github.com/ister-app/player/commit/bae7764))
- Added logger ([`9380d31`](https://github.com/ister-app/player/commit/9380d31))
- - Scan library button - `localhost:8080` uses http - Show progress in recent Carousel - In next item of playqueue reuse playqueue ([`fd65cda`](https://github.com/ister-app/player/commit/fd65cda))
- Add github workflow and fix episode number ([`46fc1d8`](https://github.com/ister-app/player/commit/46fc1d8))
- basic functionality ([`14f1c5b`](https://github.com/ister-app/player/commit/14f1c5b))
- Initial commit ([`3c7b982`](https://github.com/ister-app/player/commit/3c7b982))

### Run

```sh
docker pull ghcr.io/ister-app/player:1.0.0
```

