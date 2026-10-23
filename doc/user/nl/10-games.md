---
description: Games spelen uit een Ister-gamebibliotheek met de desktop-app — installeren, emulators, saves synchroniseren tussen apparaten, en prestaties.
---

# Games

Een **gamebibliotheek** bevat emulatorgames (Game Boy, N64, PlayStation 1–3, …), pc-games en
Steam-games die je beheerder heeft geüpload. Je bladert erdoorheen zoals door elke andere
bibliotheek, op elk apparaat; **spelen werkt in de desktop-app** (Linux en Windows). De game draait
op je computer, in een emulator of als zichzelf — de server bewaart de bestanden en je savegames.

## Een game installeren

Open een game en druk op **Installeren**. De bestanden worden naar de gamesmap van deze computer
gedownload (`~/Games/Ister` op Linux, `%LOCALAPPDATA%\Ister\Games` op Windows; aan te passen onder
*Instellingen › Games*). Tijdens het downloaden toont de pagina hoe ver het is, de snelheid en de
resterende tijd, met **Pauzeren** en **Annuleren**; allebei houden wat al gedownload is, zodat
**Hervatten** of een latere *Installeren* verdergaat waar het stopte. Games installeren één voor
één — een tweede wacht in de rij, en de pagina zegt dat. De app afsluiten kost ook geen
installatie: die gaat verder zodra de app weer start (een gepauzeerde of geannuleerde wacht op jou).
Archieven (Windows-zips, Linux-tarbestanden) worden na de download uitgepakt; die laatste stap is
niet te onderbreken.

Een mislukte installatie zegt waarom (geen ruimte meer, server niet bereikbaar, game weg van de
server) met **Opnieuw proberen** ernaast; **Gedownloade bestanden verwijderen** gooit een halve
installatie weg. **Van dit apparaat verwijderen** haalt een geïnstalleerde game weg, je saves
blijven op de server.

Elke game die op deze computer staat, staat ook onder *Instellingen › Downloads*, in een sectie
**Games** met dezelfde knoppen, naast de gedownloade media.

Een **Steam-game** werkt anders: *In Steam installeren* zet de game in een van je
Steam-bibliotheekmappen (je kiest welke als er meerdere zijn) en Steam neemt het daarna over — het
controleert de bestanden bij de eerste start en downloadt zo nodig een update. Steam-games starten
via Steam, dus je Steam-account moet de game bezitten.

## Updates

Zijn de bestanden van een game op de server veranderd (opnieuw geüpload, een nieuwere build), dan
toont de gamepagina **Update beschikbaar** met de omvang van wat er veranderde, en **Bijwerken**
haalt alleen die bestanden op. De game blijft intussen speelbaar. Steam houdt zijn eigen games
zelf bij, dus een Steam-game meldt alleen dat.

## Spelen

Druk op **Spelen**. De pagina loopt de stappen af terwijl ze gebeuren: je nieuwste save wordt van
de server gehaald, de game start, en als die stopt wordt de save als nieuwe versie geüpload,
worden prestaties gelezen en wordt je speeltijd vastgelegd. Een kaart met de uitkomst — hoe lang
je speelde, welke save-versie omhoog ging, nieuwe prestaties — blijft op de pagina staan tot je
hem wegklikt. Mislukte een stap richting de server (verbinding weg), dan zegt de kaart dat en biedt
hij **Synchronisatie opnieuw**; de sessie blijft open tot dat lukt. Wat er start, hangt af van het
platform:

| Platform | Gestart met | Zelf installeren |
|---|---|---|
| NES, SNES, N64, Game Boy (Color/Advance), DS, PlayStation 1/2, GameCube, Wii | **RetroArch**, met de core voor het systeem | RetroArch (native of Flatpak), plus de core via *Online Updater › Core Downloader* |
| PlayStation 3 | **RPCS3** | RPCS3 (native, Flatpak of AppImage) met de PS3-firmware geïnstalleerd |
| Windows-/Linux-games | het eigen programma of startscript van de game | niets |
| Steam | **Steam** (`steam://`-link) | Steam, aangemeld met een account dat de game bezit |

De app vindt de emulators zelf (je PATH, de Flatpaks, de gebruikelijke Windows-mappen). Meldt hij
er een als ontbrekend, dan heeft de melding een knop naar *Instellingen › Games*, waar je hem
installeert of de app ernaar wijst. Mist RetroArch de core die een game nodig heeft, dan noemt de
melding welke.

Bij een Steam-game kan de app niet zien wanneer je stopt met spelen. Druk daarna op de gamepagina
op **Ik ben klaar met spelen**; dat synchroniseert je saves en je prestaties. Een sessie die de app
niet kon afronden — je sloot hem terwijl een game draaide — krijg je de volgende keer op de
gamepagina aangeboden: **Nu synchroniseren** uploadt de save en legt de tijd vast, **Negeren**
vergeet hem.

## Savegames

Elke speelsessie eindigt met het uploaden van je save als nieuwe **versie**; de server bewaart de
nieuwste tien. De gamepagina toont ze met het apparaat en het tijdstip waar ze vandaan komen.
**Terugzetten** maakt een oudere versie de huidige (de nieuwere blijft in de lijst staan),
**Verwijderen** haalt een versie weg.

Heb je sinds de laatste synchronisatie van dit apparaat op een ander apparaat gespeeld, en is de
lokale save op dit apparaat ook veranderd, dan vraagt de app vóór het starten met welke je verder
wilt. De dialoog toont beide kanten — de versie op de server met het apparaat en tijdstip waar ze
vandaan komt, en wanneer de save op deze computer het laatst veranderde — en wat je ook kiest, de
andere blijft in de geschiedenis op de server. *Op de server* downloadt de save van het andere
apparaat, *Op deze computer* uploadt de lokale als nieuwe versie.

Bij pc- en Steam-games komen de save-locaties uit het community-
[Ludusavi-manifest](https://github.com/mtkennerly/ludusavi-manifest); de gamepagina toont ze
onder *Save-locaties*. Een game die het niet kent, wordt pas gesynchroniseerd als een beheerder de
locaties instelt. Een Steam-game die ook via Steam Cloud synchroniseert, zegt dat erbij — beide
aan laten kan, maar bij een conflict kan Steam Cloud winnen.

## Prestaties

Na een sessie leest de app de trofeeën van een PlayStation 3-game uit RPCS3 en de prestaties van
een Steam-game uit de lokale bestanden van Steam, en meldt ze aan de server. De gamepagina toont
hoeveel je er hebt behaald en wanneer; elk apparaat ziet dezelfde lijst. Andere platformen hebben
nog geen prestatiebron.

## Instellingen

*Instellingen › Games* (alleen desktop) bevat de gamesmap, de gevonden emulators met een manier om
een ander programma te kiezen, de **gamemappen op deze computer** waarin de beheerders-uploadpagina
zoekt (standaard de gebruikelijke plekken; voeg je eigen mappen toe, Steam-libraries worden vanzelf
gevonden), en schakelaars voor save- en prestatiesynchronisatie.

## Verder lezen

- Door een bibliotheek bladeren: [Bladeren](03-browsing.md)
- Games naar de server uploaden (beheerders): [Beheer](09-admin.md#games-uploaden)
