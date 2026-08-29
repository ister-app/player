---
description: How the Ister media player adapts to Android phones and tablets, Android TV, Android Auto, Linux, Windows and macOS desktops, iPhone and iPad, and the web browser.
---

# Platforms

The same app runs on Android phones and tablets, Android TV, Android Auto, Linux, Windows and macOS desktops, iPhone and iPad, and the web. This chapter covers what's different on each.

## Android

On phones and tablets you get the full experience described in the rest of this guide, with the tabs in a bottom bar.

### Background audio

Music, podcasts and audiobooks keep playing when you switch apps or lock the screen. Playback controls appear in the notification shade and on the lock screen, and Bluetooth controls (headphones, car kits) work as you'd expect. Streaming is hardened for the background, so audio survives flaky connections without dying silently.

### Android TV

On a TV the app switches to a remote-friendly layout: the navigation rail on the left, larger focus highlights, and full D-pad navigation — move the highlight with the directional pad and press select to open or play. Everything reachable by touch is reachable by remote.

Signing in doesn't ask you to type a password on the TV. Instead the app shows a **QR code and a short code**: scan the code with your phone (or open the address and enter the code) and finish the login there — the TV signs in automatically once you're done.

### Android Auto

In the car, Ister appears in Android Auto's media apps. You get a simple, glanceable browse tree — recent items and your libraries — and playback controls on the car screen, while the phone stays in your pocket.

## Linux

On Linux the app ships as a flatpak, with the desktop layout: navigation rail, keyboard navigation, resizable windows. Everything works natively — including the ebook and comic readers, which many players leave out on desktop.

### Steam Deck and Steam Machine (SteamOS)

The flatpak also runs on SteamOS devices, straight from Game Mode:

1. Switch to **desktop mode** and install the flatpak as on any Linux machine — see [Installation](00-installation.md).
2. In Steam, choose **Add a Non-Steam Game** and pick **Ister player**.
3. Back in Game Mode, launch it from your library.

Ister detects the SteamOS session and starts fullscreen in the TV layout: the same remote-friendly navigation as on Android TV, driven by the controller. For the controller to reach the app, apply a **keyboard-style Steam Input layout** to it (controller settings for Ister in Game Mode): D-pad and left stick → arrow keys, **A** → Enter, **B** → Escape, **X** → Space (play/pause), and optionally the shoulder buttons → left/right arrows for seeking. A community layout named "Ister player" is available where published; the mapping above recreates it in a minute.

On other Linux desktops (an HTPC, say) the same layout can be switched on by hand: **Settings → This device → TV / controller mode**.

Two notes on the picture. Video decoding is done in hardware, so even a handheld plays 4K HEVC smoothly — if playback stutters, check that your quality setting isn't forcing a transcode the server has to catch up with. And if you use HDR: the Deck's **HDR toggle makes SDR apps look washed out**, Ister included — turn HDR off for Ister in the per-game display settings (Quick Access → gear icon) until HDR video output lands in a future release. The app's interface itself always renders in SDR.

## Windows and macOS

Both desktop builds are new and still experimental — they use the same desktop layout as Linux, readers included. On Windows, playback shows up in the system's media panel and the keyboard's media keys work; on macOS the same happens through Now Playing. On macOS the TestFlight build is signed and installs without warnings; the downloadable zip and the Windows build aren't signed, so the operating system asks for confirmation the first time you open them — see [Installation](00-installation.md).

## iPhone and iPad

The iOS version is new and comes via TestFlight rather than the App Store — see [Installation](00-installation.md). It uses the same phone and tablet layout as Android, readers included, and playback appears on the lock screen and in Control Centre.

Two limits are worth knowing. iOS asks once for permission to use your local network; without it a server on your own network can't be reached. And downloads only continue while the app is open — iOS doesn't let apps download in the background, so Ister keeps the screen on while a download runs and picks up where it left off next time you open it.

## Web

The web version runs in your browser against the same servers — nothing to install. Handy on machines that aren't yours, or for a quick look at the library.

## Where to next

- Back to the start: [Getting started](01-getting-started.md)
- The player features these platforms share: [Playback](04-playback.md)
