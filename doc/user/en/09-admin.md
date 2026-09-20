---
description: Administer your Ister media server from the app — manage users, library access and visibility, podcast subscriptions and server maintenance.
---

# Administration

Some screens are only for **administrators**. If you are signed in with an admin account you'll see two extra entries under **Server** in the **Settings** tab; ordinary users never see these, so they can't reach the management screens.

The admin role itself is assigned in your identity provider (for example Keycloak), not in the app — the player only reflects it.

![The settings overview with the admin entries](../images/en/settings.png)

## Users & access

**Users & access** lists everyone the server knows. A user appears here after their first sign-in. Admin accounts carry an **Admin** chip. Tap a user to manage which libraries they can see.

![The user list](../images/en/admin-users.png)

## Per-user library access

Open a user to grant or revoke their access to **restricted** libraries — one switch per library. Libraries that are visible to everyone are shown locked on: everyone already sees them, so there's nothing to grant. To manage per-user access to such a library, first restrict it on the **Library visibility** page.

![Per-user library access](../images/en/admin-user-access.png)

## Library visibility

**Library visibility** controls, per library, whether every user can see it:

- **Visible to everyone** — any signed-in user sees the library.
- **Restricted** — only users you've granted access to (on their access page) see it.

Admins always see every library, regardless of these switches.

![Library visibility toggles](../images/en/admin-libraries.png)

## Uploading media

**Upload media** (Settings → Server) adds media to a library straight from the player: a whole show, an album for an artist that is already there, or a folder full of artists. It works in the desktop apps, the web player and on Android and iOS. On a phone or tablet the screen stays on while an upload runs; if the app is put away and suspended anyway, the upload simply continues the next time you open the page.

1. Pick the **library** and the **directory** (disk) it should land on. Each directory shows its free space; one the server cannot write to is greyed out.
2. Optionally fill in **Inside folder** — the existing folder the upload belongs under, such as the artist for an album. Leave it empty to upload into the root of the directory.
3. **Choose folder…** and pick the folder on your computer. With **Upload as one folder** on, it keeps its name on the server (which you can edit, for instance to add the `(2019)` a show folder needs); switched off, the folders *inside* it land directly in the target — the way to upload a folder full of artists or shows.
4. Read the **preview**. The server tells you, per file, how the library will recognise it (show, season and episode; artist, album and track; …), and at which level it sees the top folder. A file marked **Ignored** would not be picked up where it is going and is not uploaded; **Already there** is skipped unless you switch on **Overwrite existing files**.
5. **Start upload.** Files go up in chunks, so a dropped connection costs little: the upload retries and continues by itself. You can **pause** and continue, and **cancel** removes what is unfinished from the server (files that are already complete stay in the library).

![The upload page: library, directory and folder to upload](../images/en/admin-upload.png)

Every finished file is added to the library right away; there is no need to scan afterwards. If the app is closed mid-upload, the page offers to continue the next time you open it — choose the same folder again and it picks up where it stopped.

## Podcasts

Managing which podcasts the server carries is an admin task. In a podcast library, **Add podcast** subscribes the server to a new feed, and **Unsubscribe** on a podcast's page removes it. Ordinary users can browse, download and play episodes, but never see these controls.

## Server maintenance

The server page also carries a **Management** section for admins, with the housekeeping actions:

- **Scan for new files** — pick up newly added files. Quick and safe.
- **Fetch missing metadata** — download metadata and artwork only where they are missing. Safe to
  run anytime, for example after adding a TMDB key.
- **Rebuild library metadata** — pick one library, then delete and re-download **all** its metadata
  and artwork. Heavy and destructive, so it asks for confirmation first; use it after a wrong match
  or to fill newly added metadata fields on old items.
- **Rebuild search index** — regenerate the search index from the database. Search stays available
  while it runs.

Each action runs in the background; a snackbar confirms the start, and progress shows in the
activity list on the same page. The ⋮ menu on a movie, show, episode, artist, album or track offers
the same **Refresh metadata** for that single item.

![The server maintenance actions](../images/en/settings-cluster.png)

## Where to next

- The rest of the server settings: [Settings](07-settings.md)
