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
