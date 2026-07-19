# Installation

Before you can add a server you need the app itself. Ister runs on Android, Linux and the web, and every version talks to the same servers — pick whichever fits the device in front of you. Once it's installed, continue with [Getting started](01-getting-started.md).

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

## Self-hosting the web build

You don't need to host anything to use [player.ister.app](https://player.ister.app), but if you'd rather serve the web app yourself, every release also attaches a `player-web-<version>.tar.gz` tarball — unpack it into any static web server. This is optional and aimed at people who already run their own hosting.

## Where to next

- Add your server and sign in: [Getting started](01-getting-started.md)
- What's different per device: [Platforms](08-platforms.md)
