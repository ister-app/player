---
description: Zo past de Ister-mediaspeler zich aan op Android-telefoons en -tablets, Android TV, Android Auto, Linux-, Windows- en macOS-desktops, iPhone en iPad, en de browser.
---

# Platforms

Dezelfde app draait op Android-telefoons en -tablets, Android TV, Android Auto, Linux-, Windows- en macOS-desktops, iPhone en iPad, en het web. Dit hoofdstuk beschrijft wat er per platform anders is.

## Android

Op telefoons en tablets krijg je de volledige ervaring uit de rest van deze handleiding, met de tabbladen in een balk onderaan.

### Audio op de achtergrond

Muziek, podcasts en luisterboeken spelen door als je van app wisselt of het scherm vergrendelt. De afspeelknoppen verschijnen in het notificatiepaneel en op het vergrendelscherm, en bluetooth-bediening (koptelefoons, carkits) werkt zoals je verwacht. Het streamen is gehard voor de achtergrond, zodat audio een haperende verbinding overleeft zonder stilletjes te stoppen.

### Android TV

Op een tv schakelt de app naar een indeling voor de afstandsbediening: de navigatiebalk links, duidelijkere focusmarkering en volledige D-pad-navigatie — verplaats de markering met de pijltjes en druk op select om te openen of af te spelen. Alles wat met aanraken kan, kan ook met de afstandsbediening.

Inloggen vraagt je op de tv geen wachtwoord in te typen. In plaats daarvan toont de app een **QR-code en een korte code**: scan de code met je telefoon (of open het adres en voer de code in) en rond het inloggen daar af — de tv logt vanzelf in zodra je klaar bent.

### Android Auto

In de auto verschijnt Ister tussen de media-apps van Android Auto. Je krijgt een eenvoudige, in één blik leesbare bladerstructuur — recente items en je bibliotheken — en afspeelknoppen op het autoscherm, terwijl je telefoon in je zak blijft.

## Linux

Op Linux komt de app als flatpak, met de desktopindeling: navigatiebalk, toetsenbordnavigatie, schaalbare vensters. Alles werkt native — inclusief de e-boek- en stripslezer, die veel spelers op de desktop laten liggen.

### Steam Deck en Steam Machine (SteamOS)

De flatpak draait ook op SteamOS-apparaten, gewoon vanuit Game Mode:

1. Schakel naar **desktop mode** en installeer de flatpak zoals op elke Linux-machine — zie [Installatie](00-installation.md).
2. Kies in Steam **Een niet-Steam-game toevoegen** en selecteer **Ister player**.
3. Terug in Game Mode start je hem vanuit je bibliotheek.

Ister herkent de SteamOS-sessie en start beeldvullend in de tv-indeling: dezelfde afstandsbedieningvriendelijke navigatie als op Android TV, aangestuurd door de controller. De controller werkt direct met het standaard **Gamepad**-Steam Input-sjabloon: D-pad en linkerstick verplaatsen de selectie, **A** kiest, **B** gaat terug, **X** pauzeert/hervat, en de schouderknoppen springen naar het vorige/volgende item. Had je eerder een toetsenbord-achtige indeling ingesteld, zet die dan terug naar het Gamepad-sjabloon — met allebei actief komt elke druk dubbel binnen. (Toetsenbord-indelingen blijven werken, bijvoorbeeld voor een afstandsbediening; met de startoptie `--env=ISTER_GAMEPAD=0` schakel je de ingebouwde controllerondersteuning uit als je die route verkiest.)

Op andere Linux-desktops (een HTPC bijvoorbeeld) zet je dezelfde indeling handmatig aan: **Instellingen → Dit apparaat → Tv-/controllermodus**.

Twee opmerkingen over het beeld. Videodecodering gebeurt in hardware, dus ook een handheld speelt 4K-HEVC soepel af — hapert het, controleer dan of je kwaliteitsinstelling geen transcode afdwingt waar de server achteraan moet rennen. En gebruik je HDR: de **HDR-schakelaar van de Deck laat SDR-apps er verbleekt uitzien**, Ister ook — zet HDR voor Ister uit in de beeldscherminstellingen per game (Quick Access → tandwiel) tot HDR-videoweergave in een toekomstige release landt. De interface van de app zelf rendert altijd in SDR.

## Windows en macOS

Beide desktopbuilds zijn nieuw en nog experimenteel — ze gebruiken dezelfde desktopindeling als Linux, lezers inbegrepen. Op Windows verschijnt wat er speelt in het mediapaneel van het systeem en werken de mediatoetsen van je toetsenbord; op macOS gebeurt hetzelfde via Now Playing. Op macOS is de TestFlight-build ondertekend en installeert die zonder waarschuwingen; de losse zip en de Windows-build zijn niet ondertekend, dus daar vraagt het besturingssysteem de eerste keer om bevestiging — zie [Installatie](00-installation.md).

## iPhone en iPad

De iOS-versie is nieuw en komt via TestFlight in plaats van de App Store — zie [Installatie](00-installation.md). Hij gebruikt dezelfde telefoon- en tabletindeling als Android, lezers inbegrepen, en wat er speelt verschijnt op het toegangsscherm en in het bedieningspaneel.

Twee beperkingen zijn goed om te weten. iOS vraagt eenmalig toestemming voor je lokale netwerk; zonder die toestemming is een server in je eigen netwerk niet bereikbaar. En downloads lopen alleen door zolang de app openstaat — iOS laat apps niet op de achtergrond downloaden, dus Ister houdt het scherm aan tijdens een download en pakt de volgende keer verder op waar hij gebleven was.

## Web

De webversie draait in je browser tegen dezelfde servers — niets te installeren. Handig op machines die niet van jou zijn, of voor een snelle blik in de bibliotheek.

## Verder lezen

- Terug naar het begin: [Aan de slag](01-getting-started.md)
- De spelerfuncties die deze platforms delen: [Afspelen](04-playback.md)
