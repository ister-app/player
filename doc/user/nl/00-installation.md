# Installatie

Voordat je een server kunt toevoegen, heb je de app zelf nodig. Ister draait op Android, Linux en het web, en elke versie praat met dezelfde servers — kies wat past bij het apparaat dat je voor je hebt. Zodra de app geïnstalleerd is, ga je verder met [Aan de slag](01-getting-started.md).

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

## Het web zelf hosten

Om [player.ister.app](https://player.ister.app) te gebruiken hoef je niets te hosten, maar wil je de webapp liever zelf serveren, dan hangt aan elke release ook een `player-web-<versie>.tar.gz`-tarball — pak die uit in een willekeurige statische webserver. Dit is optioneel en bedoeld voor wie al eigen hosting draait.

## Verder lezen

- Voeg je server toe en log in: [Aan de slag](01-getting-started.md)
- Wat er per apparaat anders is: [Platforms](08-platforms.md)
