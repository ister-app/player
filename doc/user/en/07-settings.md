---
description: Set your language, playback, download and sharing preferences in Ister — the ones stored on your self-hosted media server follow you across devices.
---

# Settings

Each server has its own **Settings** tab, grouped by how far a setting reaches: what follows you across devices, what only holds on this device, who else may see or steer your playback, the server itself, and the app.

![The settings overview](../images/en/settings.png)

## Playback

These live on the server, per user — set them once and every device you sign in on uses them.

### Language & subtitles

Choose your preferred **spoken language** and **subtitle language**. When a movie or episode offers multiple audio tracks or subtitles, the player picks your preferred ones automatically; you can still override per video from the player controls. **No subtitles in the spoken language** suppresses subtitles you would not need anyway.

![The language preferences page](../images/en/settings-languages.png)

### Playback

Tune how media is streamed to you:

- **Direct play** — play files as-is when your device supports the format, for the best quality and lowest server load.
- **Transcoding** — let the server convert media on the fly when needed.
- **Maximum quality** — cap the resolution (for example on a metered or slow connection).
- **Skip intros automatically** — jump past a recognised intro without asking.

![The playback settings page](../images/en/settings-playback.png)

## This device

Unlike the settings above, these are stored on this device only and do not travel with your account.

### Downloads

Keep media on the device to play it offline. The settings decide **when** downloading happens (any connection, or unmetered only), at **what** quality for video and audio, whether subtitles come along, and how many downloads run at once. The **music cache** separately keeps recently played tracks around on its own storage budget, without touching anything you downloaded by hand.

![The download settings page](../images/en/settings-downloads.png)

### Sleep timer

Stop playback after a while or after a number of items. With the **automatic sleep timer** on, the timer arms itself between the hours you set — handy for listening yourself to sleep.

![The sleep timer page](../images/en/settings-sleep-timer.png)

## Sharing & devices

### Sharing & privacy

Control who can see and steer your playback — the other side of [Party mode](06-party-mode.md):

- **Now playing** — who can see what you're currently playing: everyone, only you, or specific people.
- **Remote control** — who can control your playback from their device: everyone, only you, specific people, or the same audience as *Now playing*.

Set to *only you*, your sessions stay private and no one can see or drive them. You can still make an exception for a single session from the player (**Share this session**).

![The sharing and privacy settings page](../images/en/settings-sharing.png)

### Devices

Every device you sign in on registers itself here, with whether it is online right now and what it is playing. From this page you can start playback on another device or hand the current session over to it, and rename or remove devices you no longer use.

![The devices page](../images/en/settings-devices.png)

### Now playing

A live list of everything playing on this server right now — yours and, where people allow it, other users' sessions. It is the starting point for listening along with someone.

![The now playing page](../images/en/now-playing.png)

## Server

### Status & maintenance

The server page is the whole picture of your Ister server in one place: which server this is, the nodes it runs on — with their version, address and whether they are still reporting in — what those nodes are working on right now, the work still queued up, and any recent failures. Useful for a quick "is everything up?" check, and for watching a scan or a transcode make progress.

Administrators also find the maintenance actions at the bottom of this page — see [Administration](09-admin.md).

![The server page](../images/en/settings-cluster.png)

### Users & access, Library visibility

Administrators get two extra entries here for managing who may sign in and which libraries they reach — see [Administration](09-admin.md).

## App

**Save error log** writes the app's log to a file, which is what to attach when reporting a problem.

The **About & data sources** page credits the external sources — such as metadata and artwork providers — that the descriptions and covers on this server come from, along with their licenses where the server reports them. It also lists the app's **open-source licenses**. The app version, with its build commit, sits at the very bottom of the settings list.

![The about and data sources page](../images/en/settings-about.png)

## Where to next

- How these settings affect the player: [Playback](04-playback.md)
- Managing users and libraries (admins): [Administration](09-admin.md)
- Platform-specific notes: [Platforms](08-platforms.md)
