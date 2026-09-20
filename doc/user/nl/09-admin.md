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
