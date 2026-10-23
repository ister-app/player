---
description: Beheer je Ister-mediaserver vanuit de app — gebruikers, bibliotheektoegang en -zichtbaarheid, podcastabonnementen en serveronderhoud.
---

# Beheer

Sommige schermen zijn er alleen voor **beheerders**. Ben je ingelogd met een beheeraccount, dan zie je twee extra items onder **Server** in het tabblad **Instellingen**; gewone gebruikers zien die niet en kunnen de beheerschermen dus niet bereiken.

De adminrol zelf wordt toegekend in je identity provider (bijvoorbeeld Keycloak), niet in de app — de speler geeft hem alleen weer.

![Het instellingenoverzicht met de beheeritems](../images/nl/settings.png)

## Gebruikers & toegang

**Gebruikers & toegang** toont iedereen die de server kent. Een gebruiker verschijnt hier na de eerste keer inloggen. Beheeraccounts dragen een **Admin**-label. Tik op een gebruiker om te beheren welke bibliotheken die mag zien.

![De gebruikerslijst](../images/nl/admin-users.png)

## Bibliotheektoegang per gebruiker

Open een gebruiker om de toegang tot **beperkte** bibliotheken te geven of in te trekken — één schakelaar per bibliotheek. Bibliotheken die voor iedereen zichtbaar zijn, staan vast aan: iedereen ziet ze al, dus valt er niets te verlenen. Wil je zulke bibliotheektoegang per gebruiker beheren, maak de bibliotheek dan eerst beperkt op de pagina **Bibliotheek-zichtbaarheid**.

![Bibliotheektoegang per gebruiker](../images/nl/admin-user-access.png)

## Bibliotheek-zichtbaarheid

**Bibliotheek-zichtbaarheid** bepaalt per bibliotheek of elke gebruiker die mag zien:

- **Voor iedereen zichtbaar** — elke ingelogde gebruiker ziet de bibliotheek.
- **Beperkt** — alleen gebruikers die je toegang hebt gegeven (op hun toegangspagina) zien de bibliotheek.

Beheerders zien altijd alle bibliotheken, ongeacht deze schakelaars.

![Schakelaars voor bibliotheek-zichtbaarheid](../images/nl/admin-libraries.png)

## Media uploaden

Met **Media uploaden** (Instellingen → Server) voeg je rechtstreeks vanuit de player media aan een bibliotheek toe: een hele serie, een album bij een artiest die er al staat, of een map vol artiesten. Het werkt in de desktop-apps, de webplayer en op Android en iOS. Op een telefoon of tablet blijft het scherm aan zolang een upload loopt; wordt de app toch weggelegd en stilgezet, dan gaat de upload gewoon verder zodra je de pagina weer opent.

1. Kies de **library** en de **directory** (schijf) waar het terecht moet komen. Bij elke directory staat de vrije ruimte; een directory waar de server niet kan schrijven is uitgegrijsd.
2. Vul eventueel **In map** in — de bestaande map waar de upload onder hoort, zoals de artiest bij een album. Laat het leeg om in de root van de directory te uploaden.
3. **Map kiezen…** en kies de map op je computer. Met **Als één map uploaden** aan houdt hij zijn naam op de server (die je kunt aanpassen, bijvoorbeeld om de `(2019)` toe te voegen die een seriemap nodig heeft); staat het uit, dan komen de mappen *erin* rechtstreeks in het doel — zo upload je een map vol artiesten of series.
4. Lees de **preview**. De server vertelt per bestand hoe de bibliotheek het gaat herkennen (serie, seizoen en aflevering; artiest, album en track; …) en op welk niveau hij de hoofdmap ziet. Een bestand met **Genegeerd** zou op die plek niet opgepikt worden en wordt niet geüpload; **Bestaat al** wordt overgeslagen, tenzij je **Bestaande bestanden overschrijven** aanzet.
5. **Upload starten.** Bestanden gaan in chunks omhoog, dus een weggevallen verbinding kost weinig: de upload probeert het opnieuw en gaat vanzelf verder. Je kunt **pauzeren** en doorgaan, en **annuleren** verwijdert wat niet af is van de server (bestanden die al compleet zijn blijven in de bibliotheek).

![De uploadpagina: library, directory en de map om te uploaden](../images/nl/admin-upload.png)

Elk voltooid bestand wordt meteen aan de bibliotheek toegevoegd; scannen achteraf is niet nodig. Wordt de app midden in een upload gesloten, dan biedt de pagina de volgende keer aan om verder te gaan — kies dezelfde map opnieuw en hij gaat door waar hij gebleven was.

## Games uploaden

Een **gamebibliotheek** krijgt haar games via dezelfde uploadpagina, maar begeleid, omdat de
scanner elke game verwacht als `<platform>/<Titel (jaar)>/…`. Op een desktop kan de pagina zelf
naar de games op deze computer zoeken; één map met de hand kiezen kan nog steeds.

### Games op deze computer

1. Kies de gamebibliotheek en haar map, dan **Games op deze computer zoeken**. De app kijkt in je
   gamemappen (`~/Games`, `~/ROMs`, EmuDecks `~/Emulation/roms` op Linux, `Games` onder je
   profiel op Windows — of de mappen die je instelt onder *Instellingen › Games*) en in elke
   Steam-library die Steam zelf kent. Hij herkent:
   - platformmappen (`snes/`, `n64/`, `ps1/`, …, met de namen die de server gebruikt) met daarin
     een map per game of losse ROM-bestanden — een losse `Super Mario World (USA).sfc` wordt de game
     *Super Mario World*, regio- en dumptags weg, met zijn `.bin`-tracks of andere bijbehorende
     bestanden erbij;
   - PlayStation 3-dumps, een paar niveaus diep waar dan ook, aan hun `PS3_GAME/PARAM.SFO`, met de
     titel van de disc;
   - volledig geïnstalleerde Steam-games, aan hun `appmanifest_<appid>.acf` (tools en runtimes
     blijven weg);
   - de eigen games van RPCS3: de disc-dumps uit zijn `games.yml` (als hun schijf gemount is) en de
     PSN-titels onder `dev_hdd0/game`, die in een `PS3_GAME/`-map verpakt omhooggaan.
   Games die Ister zelf installeerde worden nooit aangeboden. Met een gekozen **Platform** op de
   uploadpagina opent de lijst alleen met dat platform; de chips bovenaan verbreden hem.
2. De lijst is per platform gegroepeerd. Games die de bibliotheek al heeft staan als **Al in de
   bibliotheek** en zijn niet aangevinkt; een game zonder jaar of twee games die in dezelfde map
   zouden belanden krijgen ook een label. Tik op het potlood om een **titel** of **jaar** te
   corrigeren. **Opnieuw zoeken** na het verplaatsen van bestanden; het menu biedt **Andere map
   kiezen…** voor een game die de zoektocht miste, en de link naar de mapinstellingen.
3. **N games uploaden** brengt de selectie terug naar de uploadpagina; **Upload starten** stuurt ze
   één voor één, elk als eigen map `Titel (jaar)`. Een game die de server al heeft wordt
   overgeslagen, een mislukte stopt de rest niet (**Mislukte opnieuw** achteraf), en als de laatste
   game boven is wacht de pagina op de scan en toont welke ervan de bibliotheek al noemt, met een
   knop naar elke gamepagina.

Sluit je de app midden in een batch, dan biedt de uploadpagina de volgende keer aan om
**verder te gaan**: de game die bezig was hervat waar hij stopte en de rest volgt — niets hoeft
opnieuw gekozen te worden.

### Eén map met de hand

**Map kiezen…** en kies de map van de game. Het veld *In map* is een lijst **Platform** (de
mappen die de server kent: `ps3`, `steam`, `snes`, …) die zegt waaruit een game van dat platform
moet bestaan; de mapnaam wordt gesplitst in **Titel van de game** en **Jaar** (optioneel), en de
regel eronder toont waar hij belandt (`ps3/Demon's Souls (2009)/`). De **voorvertoning** vertelt
wat de server per platform nodig heeft:

- een ROM: het startbare bestand (`.cue`/`.chd`, `.z64`, `.gba`, …) met zijn bijbehorende
  bestanden (de `.bin`-bestanden van een `.cue`) ernaast;
- een PlayStation 3-game: de map zoals RPCS3 hem verwacht, met `PS3_GAME/PARAM.SFO` erin;
- een Steam-game: Steams `appmanifest_<appid>.acf` naast de map `steamapps/common/<installdir>`
  van de game;
- een Windows-game: één kant-en-klare `.zip`; een Linux-game: een GOG `.sh`-installer of een
  `.tar`-archief.

Een PS3- of Steam-map zonder markeerbestand staat als *Niet geüpload* met de reden: de hele
gamemap, markeerbestand inbegrepen, moet in één sessie omhoog, en de server scant hem pas als die
sessie klaar is. Na **Upload starten** wacht de pagina tot de scan de game toont en meldt
**Gevonden in de bibliotheek** met een knop naar zijn pagina, plus — bij pc- en Steam-games — of de
save-locaties bekend zijn (uit het Ludusavi-manifest of ingesteld door een beheerder) of nog
ingesteld moeten worden voordat saves synchroniseren. Heeft de scan de game binnen twee minuten
niet opgenomen, dan zegt de pagina dat; kijk wat later in de bibliotheek.

De mapindeling, de platformmapnamen en de regels per platform staan in de naamconventies van de
server. Spelen, saves en prestaties vanuit de gebruiker gezien: [Games](10-games.md).

## Podcasts

Beheren welke podcasts de server bevat is een beheertaak. In een podcastbibliotheek abonneert **Podcast toevoegen** de server op een nieuwe feed, en **Abonnement opzeggen** op de pagina van een podcast verwijdert hem. Gewone gebruikers kunnen afleveringen bekijken, downloaden en afspelen, maar zien deze knoppen nooit.

## Serveronderhoud

De serverpagina bevat voor beheerders ook een sectie **Beheer** met de onderhoudsacties:

- **Zoeken naar nieuwe bestanden** — nieuw toegevoegde bestanden oppikken. Snel en veilig.
- **Ontbrekende metadata ophalen** — metadata en afbeeldingen alleen downloaden waar ze ontbreken.
  Altijd veilig, bijvoorbeeld na het toevoegen van een TMDB-key.
- **Bibliotheekmetadata opnieuw opbouwen** — kies één bibliotheek en verwijder en download **al**
  zijn metadata en afbeeldingen opnieuw. Zwaar en destructief, dus er wordt eerst om bevestiging
  gevraagd; gebruik dit na een verkeerde match of om nieuwe metadatavelden op oude items te vullen.
- **Zoekindex opnieuw opbouwen** — de zoekindex opnieuw opbouwen vanuit de database. Zoeken blijft
  beschikbaar tijdens het opbouwen.

Elke actie draait op de achtergrond; een snackbar bevestigt de start en de voortgang staat in de
activiteitenlijst op dezelfde pagina. Het ⋮-menu op een film, show, aflevering, artiest, album of
track biedt hetzelfde **Metadata vernieuwen** voor dat ene item.

![De onderhoudsacties van de server](../images/nl/settings-cluster.png)

## Verder lezen

- De overige serverinstellingen: [Instellingen](07-settings.md)
