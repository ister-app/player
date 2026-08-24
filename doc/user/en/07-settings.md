---
description: Set your language, playback and sharing preferences in Ister — stored per user on your self-hosted media server, so they follow you across devices.
---

# Settings

Each server has its own **Settings** tab. Your preferences are stored on the server, per user — set them once and every device you sign in on uses them.

![The settings overview](../images/en/settings.png)

## Language preferences

Choose your preferred **spoken language** and **subtitle language**. When a movie or episode offers multiple audio tracks or subtitles, the player picks your preferred ones automatically; you can still override per video from the player controls.

![The language preferences page](../images/en/settings-languages.png)

## Playback settings

Tune how media is streamed to this device's account:

- **Direct play** — play files as-is when your device supports the format, for the best quality and lowest server load.
- **Transcoding** — let the server convert media on the fly when needed.
- **Maximum video height** — cap the resolution (for example on a metered or slow connection).

Because these live on the server, they follow you across devices.

![The playback settings page](../images/en/settings-playback.png)

## Sharing & privacy

Control who can see and steer your playback — the other side of [Party mode](06-party-mode.md):

- **Now playing** — who can see what you're currently playing: everyone, only you, or specific people.
- **Remote control** — who can control your playback from their device: everyone, only you, specific people, or the same audience as *Now playing*.

Set to *only you*, your sessions stay private and no one can see or drive them. You can still make an exception for a single session from the player (**Share this session**).

![The sharing and privacy settings page](../images/en/settings-sharing.png)

## Server

The server page is the whole picture of your Ister server in one place: which server this is, the nodes it runs on — with their version, address and whether they are still reporting in — what those nodes are working on right now, the work still queued up, and any recent failures. Useful for a quick "is everything up?" check, and for watching a scan or a transcode make progress.

Administrators also find the maintenance actions at the bottom of this page — see [Administration](09-admin.md).

![The server page](../images/en/settings-cluster.png)

## About & data sources

The **About & data sources** page credits the external sources — such as metadata and artwork providers — that the descriptions and covers on this server come from, along with their licenses where the server reports them. It also lists the app's **open-source licenses**, and the app version (with its build commit) at the bottom.

![The about and data sources page](../images/en/settings-about.png)

## Where to next

- How these settings affect the player: [Playback](04-playback.md)
- Managing users and libraries (admins): [Administration](09-admin.md)
- Platform-specific notes: [Platforms](08-platforms.md)
