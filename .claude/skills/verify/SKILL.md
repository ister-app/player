---
name: verify
description: Build, launch and drive the Ister player to verify a change end-to-end.
---

# Verifying changes in the Ister player

## Fast path: widget tests against a fixture backend

For UI flows, prefer `flutter test` widget tests over driving the GUI. The
whole HTTP surface can be faked with `package:http`'s zone override — the app
constructs `http.Client()` lazily, inside the test zone:

```dart
await http.runWithClient(() async {
  await tester.pumpWidget(...);
  ...
}, () => MockClient(handler));
```

See `test/reader_page_test.dart` for a complete example (fixture epub server,
progress-endpoint capture). Gotchas:

- `SharedPreferencesAsync` needs `SharedPreferencesAsyncPlatform.instance =
  InMemorySharedPreferencesAsync.empty()` in `setUp` — the legacy
  `setMockInitialValues` does not cover it.
- fwfh (`HtmlWidget`) renders text as `RichText`: use
  `find.textContaining(..., findRichText: true)`.
- Do NOT fake `dart:io HttpClient` via `HttpOverrides` — `IOClient` calls too
  many members for a `noSuchMethod` stub to survive.

## Running the real app (Linux)

```bash
flutter build linux --debug
GDK_BACKEND=x11 DISPLAY=:0 ./build/linux/x64/debug/bundle/player
```

- OIDC session and server list restore from
  `~/.local/share/app.ister.player/shared_preferences.json`; the app logs
  "Stream token fetched" once authenticated.
- `GDK_BACKEND=x11` makes the window an XWayland client, so ImageMagick can
  screenshot it: find the window id with a python-xlib tree walk (no
  xwininfo/xdotool on this machine), then `import -window <id> shot.png`.
- Synthetic clicks: `warp_pointer` + XTest button events work; XTest
  `MotionNotify` fake motion alone is unreliable under XWayland.
- **Caution:** the configured servers are real; clicks that save progress
  write real user data. Prefer the widget-test path for anything that mutates.
