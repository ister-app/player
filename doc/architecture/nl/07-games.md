---
description: Hoe de desktop-player games installeert, start en synchroniseert — de install-store, launchers per vorm, save-snapshots met conflictdetectie en de prestatie-readers.
---

# Games

Games zijn het enige mediatype dat de player niet streamt: hij **downloadt** de bestanden van een
game van de server, **start** een lokale emulator of de game zelf, en **synchroniseert** de saves
en prestaties van de gebruiker terug. Alles staat in `lib/utils/games/`; de UI is `GamePage` met
`GameActionsPanel` (`lib/components/games/`) en `GameSettingsPage`. Door een GAME-bibliotheek
bladeren werkt overal; installeren en spelen zit achter `kGamesSupported` (Linux en Windows, nooit
web), omdat alleen die builds een proces kunnen starten.

## GameLibraryService — `lib/utils/games/GameLibraryService.dart`

De singleton die installs en sessies bezit. Per game stelt hij twee notifiers bloot waar de pagina
naar luistert: `progressOf(gameId)` (download-/uitpakvoortgang) en `sessionOf(gameId)` (een
lopende of losgekoppelde sessie).

**Installeren.** `GET /game/{id}/manifest` (`GameApi`) somt elk bestand met zijn grootte op; de
service downloadt ze drie tegelijk met `DownloadHttp.getToFile(resume: true)` — een `.part` van
een eerdere poging wordt met een HTTP-`Range`-verzoek voortgezet (een server die 200 antwoordt,
herstart het bestand). Bestanden die al met de juiste grootte aanwezig zijn, worden overgeslagen,
dus opnieuw installeren na een fout is goedkoop. Daarna pakt `_postProcess` zips/tars uit met het
`archive`-pakket (in een isolate), markeert Linux-executables en schrijft voor een Steam-game de
`appmanifest_<appid>.acf` in de gekozen Steam-bibliotheek (`GameLaunchers.writeSteamManifest`,
`Vdf.write`) zodat Steam hem als geïnstalleerd toont. De boekhouding is `GameInstallStore`
(`installs.json` per server naast de gamemappen); `GameSettings.gamesRoot()` is `~/Games/Ister`
op Linux en `%LOCALAPPDATA%\Ister\Games` op Windows — *niet* de app-support-map, die
Flatpak-emulators niet kunnen lezen.

**Spelen.** `prepare` bouwt een `LaunchPlan` (hieronder) en haalt de save-head van de server op;
`launch` voert hem uit via `GameProcessRunner` en als het proces eindigt pusht `_afterSession` de
saves, leest de prestaties en roept de mutatie `recordGamePlayed` aan. Een Steam-start is
*losgekoppeld* (de app ziet het proces van Steam niet), daarom biedt de pagina "Ik ben klaar met
spelen", dat dezelfde na-sessie-stap draait.

## Launchers — `lib/utils/games/launch/`

`GameLaunchers.plan` kiest per `GameForm`:

| Vorm | Commando | Save-slots |
|---|---|---|
| `ROM` | `retroarch -L <core>_libretro.so <rom> --appendconfig <tmp cfg>` — de append-config wijst `savefile_directory`/`savestate_directory` naar `<game>/saves` zonder de `retroarch.cfg` van de gebruiker aan te raken; de core komt uit `launcher.retroArchCore` van de server of een override per platform | `<game>/saves` |
| `PS3_FOLDER` | `rpcs3 --no-gui <PS3_GAME/USRDIR/EBOOT.BIN>`; weigert met `firmwareMissing` als `dev_flash/vsh` ontbreekt | RPCS3's `dev_hdd0/home/00000001/savedata/<TITLEID>*` |
| `PC_PORTABLE_ZIP`, `PC_LINUX_PORTABLE` | het entry-bestand dat de server noemt, anders het enige exe / startscript in de bovenste niveaus van de uitgepakte boom | Ludusavi-sjablonen van de server |
| `PC_LINUX_INSTALLER` | eerste keer: de `.sh` met de stille vlaggen van MojoSetup naar `<game>/files/game`; daarna `game/start.sh` | Ludusavi-sjablonen |
| `STEAM` | `steam steam://rungameid/<appid>` (losgekoppeld) | Ludusavi-sjablonen, met `<base>` = `steamapps/common/<installdir>` |

`EmulatorRegistry` vindt de emulators: de override van de gebruiker (`GameSettings`), dan het PATH,
dan de Flatpak-id (`org.libretro.RetroArch`, `net.rpcs3.RPCS3`, `com.valvesoftware.Steam`), dan de
gebruikelijke Windows-installatiemappen; hij kent ook de cores-map van RetroArch en de configroot
van RPCS3 per variant. `GameProcessRunner` herschrijft een `flatpak:<id>`-commando naar `flatpak
run` en zet, als de player zelf in zijn Flatpak draait (`FLATPAK_ID` gezet), overal `flatpak-spawn
--host` voor — daarom geeft het manifest `--talk-name=org.freedesktop.Flatpak` en
`--filesystem=~/Games:create`.

`SteamLibraryLocator` leest de eigen VDF-bestanden van Steam (`libraryfolders.vdf`,
`loginusers.vdf`) met de kleine `Vdf`-parser: de bibliotheekmappen om in terug te zetten, de 32-bit
id van het meest recente account (`<storeUserId>`) en op Linux de Proton-prefix
(`compatdata/<appid>/pfx/drive_c`) van een game.

## Save-synchronisatie — `lib/utils/games/saves/`

`SavePathResolver` maakt van de sjablonen van de server (`Game.savePaths`, Ludusavi-placeholders
`<base>`, `<home>`, `<winAppData>`, `<xdgConfig>`, `<storeUserId>`, …) concrete mappen op deze
machine — Windows-placeholders lossen op Linux op binnen de Proton-prefix — breidt `*`-globs uit en
weigert alles buiten de gamemap, de homemap of die prefix. Elk sjabloon is een **slot**;
`SaveSnapshot.pack` zipt de slots als `<slotindex>/<relatief pad>` plus een `snapshot.json`, zodat
de zip op een machine met andere roots op de juiste plekken terugkomt.

`SaveSyncService.pull` draait vóór een start: is de server-head nieuwer dan de versie waarmee dit
apparaat het laatst synchroniseerde (`GameInstall.lastSaveVersion`), dan wordt hij gedownload en
uitgepakt — tenzij de lokale bestanden ook veranderden (`SaveSnapshot.fingerprint`, groottes en
mtimes), wat een **conflict** is waarover de pagina de gebruiker vraagt (mijn save houden →
uploaden als nieuwe head; die van de server → downloaden). `push` draait na de sessie:
ongewijzigde slots uploaden niets; anders gaat de zip naar
`POST /game/{id}/saves?baseVersion=<lastSaveVersion>`; een 409 (een ander apparaat schreef
tussendoor) wordt met een geforceerde upload beantwoord, want een net afgeronde sessie verliezen
is erger dan een tweede head in de historie. Een mislukte upload wordt als `outbox-*.zip` in de
installmap geparkeerd en vóór de volgende start opnieuw geprobeerd.

## Prestaties — `lib/utils/games/achievements/`

Gelezen uit de bestanden die de emulator/store achterlaat, dus zonder API-sleutels:

- `Ps3TrophyReader`: RPCS3's `trophy/<NPCOMMID>/TROPCONF.SFM` (XML-definities) en `TROPUSR.DAT`
  (big-endian tabellen; de type-6-entries bevatten de ontgrendelvlag en tijdstempels, layout uit
  RPCS3's `TROPUSR.h`), iconen `TROP<NNN>.PNG`.
- `SteamAchievementReader`: Steams `appcache/stats/UserGameStatsSchema_<appid>.bin` (stat-type 4 =
  prestatiebits met weergavenaam/omschrijving/icoon/verborgen) en
  `UserGameStats_<accountid>_<appid>.bin` (`cache/<statid>/AchievementTimes/<bit>` =
  unix-ontgrendeltijd), beide Valves binaire KeyValues (`BinaryKeyValues`). Steam schrijft het
  laatste bestand als de game afsluit, daarom gebeurt het lezen na "Ik ben klaar met spelen". Het
  formaat is waargenomen, niet gedocumenteerd: elke fout valt terug op "geen rapport".

`AchievementSyncService` onthoudt per game de laatst gemelde set (`achievements.json`) en roept
`POST /game/{id}/achievements` alleen aan bij een verandering, met icoon-uploads voor definities
die voor het eerst gezien worden.
