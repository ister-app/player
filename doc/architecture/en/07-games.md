---
description: How the desktop player installs, launches and syncs games — the install store, per-form launchers, save snapshots with conflict detection, and the achievement readers.
---

# Games

Games are the one media type the player does not stream: it **downloads** a game's files from the
server, **launches** a local emulator or the game itself, and **syncs** the user's saves and
achievements back. Everything lives in `lib/utils/games/`; the UI is `GamePage` with
`GameActionsPanel` (`lib/components/games/`) and `GameSettingsPage`. Browsing a GAME library
works everywhere; installing and playing is gated by `kGamesSupported` (Linux and Windows, never
web), because only those builds can start a process.

## GameLibraryService — `lib/utils/games/GameLibraryService.dart`

The singleton that owns installs and sessions. Per game it exposes two notifiers the page
listens to: `progressOf(gameId)` (download/extract progress) and `sessionOf(gameId)` (a running
or detached session).

**Install.** `GET /game/{id}/manifest` (`GameApi`) lists every file with its size; the service
downloads them three at a time with `DownloadHttp.getToFile(resume: true)` — a `.part` left by an
earlier attempt is continued with an HTTP `Range` request (a server answering 200 restarts the
file). Files already present with the right size are skipped, so a re-install after a failure is
cheap. Afterwards `_postProcess` unpacks zips/tars with the `archive` package (in an isolate),
marks Linux executables, and for a Steam game writes the `appmanifest_<appid>.acf` into the chosen
Steam library (`GameLaunchers.writeSteamManifest`, `Vdf.write`) so Steam lists it as installed.
The bookkeeping is `GameInstallStore` (`installs.json` per server next to the game folders);
`GameSettings.gamesRoot()` is `~/Games/Ister` on Linux and `%LOCALAPPDATA%\Ister\Games` on Windows —
*not* the app-support dir, which Flatpak emulators cannot read.

**Play.** `prepare` builds a `LaunchPlan` (below) and pulls the server's save head; `launch`
runs it through `GameProcessRunner` and, when the process exits, `_afterSession` pushes the saves,
reads achievements and calls the `recordGamePlayed` mutation. A Steam launch is *detached* (the
app cannot see Steam's process), so the page offers "I finished playing", which runs the same
after-session step.

## Launchers — `lib/utils/games/launch/`

`GameLaunchers.plan` picks per `GameForm`:

| Form | Command | Save slots |
|---|---|---|
| `ROM` | `retroarch -L <core>_libretro.so <rom> --appendconfig <tmp cfg>` — the append-config points `savefile_directory`/`savestate_directory` at `<game>/saves` without touching the user's `retroarch.cfg`; the core comes from the server's `launcher.retroArchCore` or a per-platform override | `<game>/saves` |
| `PS3_FOLDER` | `rpcs3 --no-gui <PS3_GAME/USRDIR/EBOOT.BIN>`; refuses with `firmwareMissing` when `dev_flash/vsh` is absent | RPCS3's `dev_hdd0/home/00000001/savedata/<TITLEID>*` |
| `PC_PORTABLE_ZIP`, `PC_LINUX_PORTABLE` | the entry the server named, else the single exe / start script found at the top levels of the extracted tree | Ludusavi templates from the server |
| `PC_LINUX_INSTALLER` | first run: the `.sh` with MojoSetup's silent flags into `<game>/files/game`; later runs: `game/start.sh` | Ludusavi templates |
| `STEAM` | `steam steam://rungameid/<appid>` (detached) | Ludusavi templates, with `<base>` = `steamapps/common/<installdir>` |

`EmulatorRegistry` finds the emulators: the user's override (`GameSettings`), then the PATH,
then the Flatpak id (`org.libretro.RetroArch`, `net.rpcs3.RPCS3`, `com.valvesoftware.Steam`),
then the usual Windows install folders; it also knows RetroArch's cores dir and RPCS3's config
root per flavour. `GameProcessRunner` rewrites a `flatpak:<id>` command to `flatpak run` and, when
the player itself runs inside its Flatpak (`FLATPAK_ID` set), prefixes everything with
`flatpak-spawn --host` — which is why the manifest grants `--talk-name=org.freedesktop.Flatpak`
and `--filesystem=~/Games:create`.

`SteamLibraryLocator` reads Steam's own VDF files (`libraryfolders.vdf`, `loginusers.vdf`) with
the tiny `Vdf` parser: the library folders to restore into, the most recent account's 32-bit id
(`<storeUserId>`), and the Proton prefix (`compatdata/<appid>/pfx/drive_c`) of a game on Linux.

## Save sync — `lib/utils/games/saves/`

`SavePathResolver` turns the server's templates (`Game.savePaths`, Ludusavi placeholders
`<base>`, `<home>`, `<winAppData>`, `<xdgConfig>`, `<storeUserId>`, …) into concrete folders on
this machine — Windows placeholders resolve into the Proton prefix on Linux — expands `*` globs,
and refuses anything outside the game folder, the home dir or that prefix. Each template is a
**slot**; `SaveSnapshot.pack` zips the slots as `<slot index>/<relative path>` plus a
`snapshot.json`, so the zip restores into the right places on a machine whose roots differ.

`SaveSyncService.pull` runs before a launch: when the server head is newer than the version this
device synced last (`GameInstall.lastSaveVersion`) it is downloaded and unpacked — unless the
local files changed too (`SaveSnapshot.fingerprint`, sizes and mtimes), which is a **conflict**
the page asks the user about (keep mine → upload as new head; use the server's → download).
`push` runs after the session: unchanged slots upload nothing; otherwise the zip goes to
`POST /game/{id}/saves?baseVersion=<lastSaveVersion>`; a 409 (another device wrote in between)
is answered with a forced upload, since losing a just-finished session is worse than a second
head in the history. A failed upload is parked as `outbox-*.zip` in the install dir and replayed
before the next launch.

## Achievements — `lib/utils/games/achievements/`

Read from the files the emulator/store leaves behind, so no API keys are needed:

- `Ps3TrophyReader`: RPCS3's `trophy/<NPCOMMID>/TROPCONF.SFM` (XML definitions) and
  `TROPUSR.DAT` (big-endian tables; the type-6 entries hold the unlock flag and timestamps,
  layout from RPCS3's `TROPUSR.h`), icons `TROP<NNN>.PNG`.
- `SteamAchievementReader`: Steam's `appcache/stats/UserGameStatsSchema_<appid>.bin` (stat type
  4 = achievement bits with display name/desc/icon/hidden) and
  `UserGameStats_<accountid>_<appid>.bin` (`cache/<statid>/AchievementTimes/<bit>` = unix unlock
  time), both Valve's binary KeyValues (`BinaryKeyValues`). Steam writes the latter when the game
  exits, which is why the read happens after "I finished playing". The format is observed, not
  documented: every failure degrades to "no report".

`AchievementSyncService` remembers the last reported set per game (`achievements.json`) and only
calls `POST /game/{id}/achievements` on a change, uploading icons for definitions seen for the
first time.
