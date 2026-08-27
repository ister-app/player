---
description: Zo installeer je de Ister-mediaspeler op Android, Linux (Flatpak), Windows, macOS, iOS en in de browser, klaar om te verbinden met je zelfgehoste mediaserver.
---

# Installatie

Voordat je een server kunt toevoegen, heb je de app zelf nodig. Ister draait op Android, Linux, Windows, macOS, iOS en het web, en elke versie praat met dezelfde servers — kies wat past bij het apparaat dat je voor je hebt. Zodra de app geïnstalleerd is, ga je verder met [Aan de slag](01-getting-started.md).

## In de browser

De snelste manier om Ister te proberen is in je browser — je hoeft niets te installeren:

**[player.ister.app](https://player.ister.app)**

Open dat adres in een moderne browser en je kunt meteen een server toevoegen. Handig op een computer die niet van jou is, of voor een snelle blik in je bibliotheek zonder iets op te zetten.

## Android (telefoon, tablet en tv)

De Android-app wordt als APK op de releases-pagina gepubliceerd:

**[github.com/ister-app/player/releases](https://github.com/ister-app/player/releases)**

Download `app-release.apk` uit de nieuwste release en open het bestand om te installeren. De eerste keer vraagt je toestel je om installeren uit deze bron toe te staan — dat hoort zo bij een app die je buiten de Play Store om installeert. Dezelfde APK werkt op telefoons, tablets en Android TV (zie [Platforms](08-platforms.md) voor wat er per apparaat anders is). Bijwerken doe je later door een nieuwere APK er overheen te installeren.

## Linux

Voor Linux-desktops levert elke release een Flatpak-bundel. Download `app.ister.Player.flatpak` uit de [nieuwste release](https://github.com/ister-app/player/releases) en installeer die:

```shell
flatpak install --user app.ister.Player.flatpak
```

Start de app daarna vanuit je programmamenu, of met `flatpak run app.ister.Player`. Een nieuwere bundel op dezelfde manier installeren werkt de app bij.

## Windows

Windows-builds zijn nieuw en nog experimenteel. Download `player-windows-x64-<versie>.zip` uit de [nieuwste release](https://github.com/ister-app/player/releases), pak het uit waar je wilt en start `player.exe` uit de uitgepakte map — houd die map bij elkaar, de app heeft de bestanden naast het programma nodig. Windows kan melden dat de app onbekend is, omdat de build niet met een commercieel certificaat is ondertekend; kies **Meer informatie → Toch uitvoeren** als je de download vertrouwt. Bij de eerste keer inloggen opent de app kort een lokale poort om de login-redirect op te vangen, dus Windows Firewall kan om toestemming vragen. Bijwerken doe je door een nieuwere zip over de oude map uit te pakken.

## macOS

macOS-builds zijn nieuw en nog experimenteel. Download `player-macos-<versie>.zip` uit de [nieuwste release](https://github.com/ister-app/player/releases), pak het uit en sleep `Ister player.app` naar je map Programma's.

De app is niet door Apple genotariseerd, dus macOS blokkeert hem bij de eerste start. Haal de download-quarantaine er eenmalig af via Terminal:

```shell
xattr -dr com.apple.quarantine "/Applications/Ister player.app"
```

Daarna opent hij gewoon.

## iOS

Voor iOS is er geen kant-en-klare download. Apple staat alleen apps toe die zijn ondertekend voor je eigen Apple ID, dus de iPhone- en iPad-versie bouw je op een Mac en zet je van daaruit over. Je hebt een Mac nodig met [Xcode](https://apps.apple.com/app/xcode/id497799835) en de [Flutter SDK](https://docs.flutter.dev/get-started/install/macos), plus een Apple ID.

1. Kloon de repository en draai `flutter pub get`.
2. Open `ios/Runner.xcworkspace` in Xcode, kies het **Runner**-target en zet onder **Signing & Capabilities** *Automatically manage signing* aan en je Apple ID bij **Team**. Meldt Xcode dat de bundle-identifier al bezet is, maak er dan iets unieks van — en pas het URL-scheme in `ios/Runner/Info.plist` daarop aan, want het inloggen gebruikt dat.
3. Sluit de iPhone aan, zet daarop **Instellingen → Privacy en beveiliging → Ontwikkelaarsmodus** aan en draai `flutter run --release -d <je iPhone>`.
4. Bij de eerste start meldt iOS dat de ontwikkelaar niet vertrouwd is: **Instellingen → Algemeen → VPN en apparaatbeheer → jouw Apple ID → Vertrouwen**.

Met een gratis Apple ID werkt de app na **zeven dagen** niet meer en moet je opnieuw bouwen; met een betaald Apple Developer Program-lidmaatschap is dat een jaar.

Twee dingen werken anders dan op andere platforms. Je server moet bereikbaar zijn — de eerste keer dat je verbindt vraagt iOS toestemming voor het lokale netwerk, en weiger je die, dan zijn servers in je eigen netwerk onbereikbaar. En downloads lopen alleen door zolang Ister openstaat: iOS geeft geen enkele app toestemming om op de achtergrond te blijven downloaden, dus de app houdt het scherm aan zolang een download bezig is.

## Het web zelf hosten

Om [player.ister.app](https://player.ister.app) te gebruiken hoef je niets te hosten, maar wil je de webapp liever zelf serveren, dan hangt aan elke release ook een `player-web-<versie>.tar.gz`-tarball — pak die uit in een willekeurige statische webserver. Dit is optioneel en bedoeld voor wie al eigen hosting draait.

## Verder lezen

- Voeg je server toe en log in: [Aan de slag](01-getting-started.md)
- Wat er per apparaat anders is: [Platforms](08-platforms.md)
