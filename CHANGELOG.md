# Changelog

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

