---
description: Stel je taal-, afspeel-, download- en privacyvoorkeuren voor Ister in — wat op je zelfgehoste mediaserver staat, reist mee tussen apparaten.
---

# Instellingen

Elke server heeft een eigen tabblad **Instellingen**, gegroepeerd naar hoe ver een instelling reikt: wat met je meereist tussen apparaten, wat alleen hier geldt, wie je afspelen mag zien of sturen, de server zelf, en de app.

![Het instellingenoverzicht](../images/nl/settings.png)

## Afspelen

Deze staan op de server, per gebruiker — stel ze één keer in en elk apparaat waarop je inlogt gebruikt ze.

### Taal & ondertiteling

Kies je voorkeurstaal voor **gesproken audio** en voor **ondertiteling**. Biedt een film of aflevering meerdere audiosporen of ondertitels, dan kiest de speler automatisch jouw voorkeuren; per video kun je ze via de spelerknoppen alsnog aanpassen. **Geen ondertiteling in de gesproken taal** onderdrukt ondertitels die je toch niet nodig hebt.

![De pagina met taalvoorkeuren](../images/nl/settings-languages.png)

### Afspelen

Bepaal hoe media naar je wordt gestreamd:

- **Direct afspelen** — speel bestanden ongewijzigd af als je apparaat het formaat aankan, voor de beste kwaliteit en de minste serverbelasting.
- **Transcoderen** — laat de server media waar nodig ter plekke omzetten.
- **Maximale kwaliteit** — begrens de resolutie (bijvoorbeeld op een trage of gebundelde verbinding).
- **Intro's automatisch overslaan** — spring zonder vragen over een herkende intro heen.

![De pagina met afspeelinstellingen](../images/nl/settings-playback.png)

## Dit apparaat

Anders dan hierboven worden deze instellingen alleen op dit apparaat bewaard; ze reizen niet mee met je account.

### Downloads

Bewaar media op het apparaat om offline af te spelen. De instellingen bepalen **wanneer** er gedownload wordt (elke verbinding, of alleen zonder databundel), in **welke** kwaliteit voor video en audio, of ondertitels meekomen, en hoeveel downloads tegelijk lopen. De **muziekcache** houdt daarnaast recent gespeelde nummers vast binnen een eigen opslagbudget, zonder aan je handmatige downloads te komen.

![De pagina met downloadinstellingen](../images/nl/settings-downloads.png)

### Slaaptimer

Stop het afspelen na een tijd of na een aantal items. Staat de **automatische slaaptimer** aan, dan schakelt de timer zichzelf in tussen de uren die je instelt — handig om jezelf in slaap te luisteren.

![De pagina met de slaaptimer](../images/nl/settings-sleep-timer.png)

## Delen & apparaten

### Delen & privacy

Bepaal wie je afspelen mag zien en sturen — de andere kant van [Feestmodus](06-party-mode.md):

- **Nu speelt** — wie mag zien wat je op dit moment afspeelt: iedereen, alleen jij, of bepaalde mensen.
- **Afstandsbediening** — wie je afspelen vanaf hun apparaat mag bedienen: iedereen, alleen jij, bepaalde mensen, of hetzelfde publiek als bij *Nu speelt*.

Zet je het op *alleen ik*, dan blijven je sessies privé en kan niemand ze zien of sturen. Je kunt nog steeds een uitzondering maken voor één sessie vanuit de speler (**Deze sessie delen**).

![De pagina met instellingen voor delen en privacy](../images/nl/settings-sharing.png)

### Apparaten

Elk apparaat waarop je inlogt meldt zich hier aan, met of het nu online is en wat het afspeelt. Vanaf deze pagina start je het afspelen op een ander apparaat of draag je de huidige sessie over, en hernoem of verwijder je apparaten die je niet meer gebruikt.

![De apparatenpagina](../images/nl/settings-devices.png)

### Speelt nu

Een live lijst van alles wat er op dit moment op deze server speelt — dat van jou en, waar mensen dat toestaan, sessies van andere gebruikers. Het is het startpunt om met iemand mee te luisteren.

![De pagina Speelt nu](../images/nl/now-playing.png)

## Server

### Status & onderhoud

De serverpagina geeft het complete beeld van je Ister-server op één plek: om welke server het gaat, op welke nodes hij draait — met hun versie, adres en of ze zich nog melden — waar die nodes op dit moment mee bezig zijn, wat er nog in de wachtrij staat en welke fouten er recent optraden. Handig voor een snelle check of alles draait, en om een scan of transcodering te volgen.

Beheerders vinden onderaan deze pagina ook de onderhoudsacties — zie [Beheer](09-admin.md).

![De serverpagina](../images/nl/settings-cluster.png)

### Gebruikers & toegang, Bibliotheek-zichtbaarheid

Beheerders krijgen hier twee extra ingangen om te regelen wie mag inloggen en welke bibliotheken ze bereiken — zie [Beheer](09-admin.md).

## App

**Foutenlog opslaan** schrijft het log van de app naar een bestand; dat is wat je meestuurt bij het melden van een probleem.

De pagina **Over & bronvermelding** vermeldt de externe bronnen — zoals leveranciers van metadata en afbeeldingen — waar de beschrijvingen en covers op deze server vandaan komen, met hun licenties waar de server die doorgeeft. Ook staan er de **open-source licenties** van de app. De app-versie, met de build-commit, staat helemaal onderaan de instellingenlijst.

![De pagina over en bronvermelding](../images/nl/settings-about.png)

## Verder lezen

- Wat deze instellingen doen in de speler: [Afspelen](04-playback.md)
- Gebruikers en bibliotheken beheren (beheerders): [Beheer](09-admin.md)
- Platformspecifieke bijzonderheden: [Platforms](08-platforms.md)
