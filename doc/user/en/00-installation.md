---
description: How to install the Ister media player on Android, Linux (Flatpak), Windows, macOS and the web, and connect it to your self-hosted media server.
---

# Installation

Before you can add a server you need the app itself. Ister runs on Android, Linux, Windows, macOS and the web, and every version talks to the same servers — pick whichever fits the device in front of you. Once it's installed, continue with [Getting started](01-getting-started.md).

## On the web

The quickest way to try Ister is in your browser — there's nothing to install:

**[player.ister.app](https://player.ister.app)**

Open that address in any modern browser and you're ready to add a server. It's handy on a computer that isn't yours, or for a quick look at your library without setting anything up.

## Android (phone, tablet and TV)

The Android app is published as an APK on the releases page:

**[github.com/ister-app/player/releases](https://github.com/ister-app/player/releases)**

Download `app-release.apk` from the latest release and open it to install. Your device will ask you to allow installing apps from this source the first time — that's expected for an app installed outside the Play Store. The same APK works on phones, tablets and Android TV (see [Platforms](08-platforms.md) for what's different on each). To update later, install a newer APK over the top.

## Linux

For Linux desktops each release ships a Flatpak bundle. Download `app.ister.Player.flatpak` from the [latest release](https://github.com/ister-app/player/releases) and install it:

```shell
flatpak install --user app.ister.Player.flatpak
```

Then launch it from your application menu, or run `flatpak run app.ister.Player`. Installing a newer bundle the same way updates the app.

## Windows

Windows builds are new and still experimental. Download `player-windows-x64-<version>.zip` from the [latest release](https://github.com/ister-app/player/releases), unpack it wherever you like and run `player.exe` from the unpacked folder — keep the folder together, the app needs the files next to the executable. Windows may warn that the app is unrecognised, because the build isn't signed with a commercial certificate; choose **More info → Run anyway** if you trust the download. The first sign-in briefly opens a local port to catch the login redirect, so Windows Firewall may ask for permission. To update, unpack a newer zip over the old folder.

## macOS

macOS builds are new and still experimental. Download `player-macos-<version>.zip` from the [latest release](https://github.com/ister-app/player/releases), unzip it and drag `Ister player.app` to your Applications folder.

The app isn't notarised by Apple, so macOS blocks it on first launch. Clear the download quarantine once from Terminal:

```shell
xattr -dr com.apple.quarantine "/Applications/Ister player.app"
```

After that it opens normally.

## Self-hosting the web build

You don't need to host anything to use [player.ister.app](https://player.ister.app), but if you'd rather serve the web app yourself, every release also attaches a `player-web-<version>.tar.gz` tarball — unpack it into any static web server. This is optional and aimed at people who already run their own hosting.

## Where to next

- Add your server and sign in: [Getting started](01-getting-started.md)
- What's different per device: [Platforms](08-platforms.md)
