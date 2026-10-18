---
description: Playing games from an Ister game library on the desktop app — installing, emulators, save sync between devices, and achievements.
---

# Games

A **game library** holds emulator games (Game Boy, N64, PlayStation 1–3, …), PC games and Steam
games your administrator uploaded. You browse it like any other library on every device; **playing
works on the desktop app** (Linux and Windows). The game runs on your computer, in an emulator or
as itself — the server keeps the files and your save games.

## Installing a game

Open a game and press **Install**. The files are downloaded to the games folder of this computer
(`~/Games/Ister` on Linux, `%LOCALAPPDATA%\Ister\Games` on Windows; change it under *Settings ›
Games*). A download that is interrupted continues where it stopped. Archives (Windows zips, Linux
tar files) are unpacked after the download; **Remove from this device** deletes everything again,
your saves stay on the server.

A **Steam game** is different: *Install into Steam* puts the game into one of your Steam library
folders (you pick which one when there are several) and Steam takes it from there — it verifies
the files on first start and may download an update. Steam games start through Steam, so your
Steam account has to own the game.

## Playing

Press **Play**. Before the game starts the app downloads your newest save from the server; when
the game ends it uploads the save as a new version and records your play time. What starts
depends on the platform:

| Platform | Started with | Install it yourself |
|---|---|---|
| NES, SNES, N64, Game Boy (Color/Advance), DS, PlayStation 1/2, GameCube, Wii | **RetroArch**, with the core for the system | RetroArch (native or Flatpak), plus the core via *Online Updater › Core Downloader* |
| PlayStation 3 | **RPCS3** | RPCS3 (native, Flatpak or AppImage) with the PS3 firmware installed |
| Windows / Linux games | the game's own executable or start script | nothing |
| Steam | **Steam** (`steam://` link) | Steam, signed in to an account that owns the game |

The app finds the emulators on its own (your PATH, the Flatpaks, the usual Windows folders). When
it reports one missing, install it or point the app at it under *Settings › Games*. When
RetroArch misses the core a game needs, the message names it.

With a Steam game the app cannot see when you stop playing. Press **I finished playing** on the
game page afterwards; that syncs your saves and your achievements.

## Save games

Every play session ends with your save being uploaded as a new **version**; the server keeps the
newest ten. The game page lists them with the device and time each came from. **Restore** makes
an older version the current one (the newer one stays in the list), **Delete** removes a version.

If you played on another device since this one last synced, and this device's local save changed
too, the app asks before starting which one to continue with: *keep mine* uploads the local save
as the new version, *use the server's* downloads the other device's.

For PC and Steam games the save locations come from the community
[Ludusavi manifest](https://github.com/mtkennerly/ludusavi-manifest); the game page shows them
under *Save locations*. A game it does not know has no sync until an administrator sets the
locations. A Steam game that also syncs through Steam Cloud says so — keeping both on is fine, but
Steam Cloud may win on a conflict.

## Achievements

After a session the app reads the trophies of a PlayStation 3 game from RPCS3 and the achievements
of a Steam game from Steam's local files, and reports them to the server. The game page shows how
many you unlocked and when; every device sees the same list. Other platforms have no achievement
source yet.

## Settings

*Settings › Games* (desktop only) holds the games folder, the detected emulators with a way to pick
another executable, and switches for save and achievement sync.

## Where to next

- Browsing a library: [Browsing](03-browsing.md)
- Uploading games to the server (administrators): [Administration](09-admin.md)
