# Administration

Some screens are only for **administrators**. If you are signed in with an admin account you'll see extra entries in the **Settings** tab; ordinary users never see these, so they can't reach the management screens.

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

## Podcasts

Managing which podcasts the server carries is an admin task. In a podcast library, **Add podcast** subscribes the server to a new feed, and **Unsubscribe** on a podcast's page removes it. Ordinary users can browse, download and play episodes, but never see these controls.

## Server maintenance

The server page also carries a **Management** section for admins, with the housekeeping actions:

- **Scan library** — pick up newly added files.
- **Analyse library** — extract technical media details (all libraries, or one at a time).
- **Rebuild search index** — regenerate the search index.

![The server maintenance actions](../images/en/settings-cluster.png)

## Where to next

- The rest of the server settings: [Settings](07-settings.md)
