---
description: How to install the Ister media player on Android, Linux (Flatpak), Windows, macOS, iOS and the web, and connect it to your self-hosted media server.
---

# Installation

Before you can add a server you need the app itself. Ister runs on Android, Linux, Windows, macOS, iOS and the web, and every version talks to the same servers — pick whichever fits the device in front of you. Once it's installed, continue with [Getting started](01-getting-started.md).

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

macOS builds are new and still experimental. The easiest route is **TestFlight**: install Apple's [TestFlight app](https://apps.apple.com/app/testflight/id899247664) from the Mac App Store (needs macOS 12 or newer), accept the invitation from the person running your server (or the project), and Ister installs and updates like any other app — no Terminal, no warnings.

Alternatively, download `player-macos-<version>.zip` from the [latest release](https://github.com/ister-app/player/releases), unzip it and drag `Ister player.app` to your Applications folder. That build isn't notarised by Apple, so macOS blocks it on first launch; clear the download quarantine once from Terminal:

```shell
xattr -dr com.apple.quarantine "/Applications/Ister player.app"
```

After that it opens normally.

## iOS

The iPhone and iPad version is distributed through **TestFlight**: install Apple's [TestFlight app](https://apps.apple.com/app/testflight/id899247664), accept the invitation from the person running your server (or the project), and Ister installs and updates like any other app — no Mac, no cable. New releases appear in TestFlight automatically.

Building it yourself remains possible for developers. You need a Mac with [Xcode](https://apps.apple.com/app/xcode/id497799835) and the [Flutter SDK](https://docs.flutter.dev/get-started/install/macos), and an Apple ID.

1. Clone the repository and run `flutter pub get`.
2. Open `ios/Runner.xcworkspace` in Xcode, select the **Runner** target, and under **Signing & Capabilities** tick *Automatically manage signing* and pick your Apple ID under **Team**. If Xcode reports that the bundle identifier is taken, change it to something unique — and change the URL scheme in `ios/Runner/Info.plist` to match, because signing in uses it.
3. Connect the iPhone, enable **Settings → Privacy & Security → Developer Mode** on it, and run `flutter run --release -d <your iPhone>`.
4. On first launch iOS says the developer isn't trusted: **Settings → General → VPN & Device Management → your Apple ID → Trust**.

With a free Apple ID a self-built app stops working after **seven days** and you have to rebuild it; a paid Apple Developer Program membership extends that to a year. The TestFlight route has neither limit.

Two things work differently than on other platforms. Your server has to be reachable — the first time you connect, iOS asks permission to use the local network, and refusing it makes servers on your home network unreachable. And downloads only continue while Ister is open: iOS gives no app permission to keep downloading in the background, so the app keeps the screen on while a download runs.

## Self-hosting the web build

You don't need to host anything to use [player.ister.app](https://player.ister.app), but if you'd rather serve the web app yourself, every release also attaches a `player-web-<version>.tar.gz` tarball — unpack it into any static web server. This is optional and aimed at people who already run their own hosting.

## Where to next

- Add your server and sign in: [Getting started](01-getting-started.md)
- What's different per device: [Platforms](08-platforms.md)
