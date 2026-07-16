# player

A media player for [Ister](https://github.com/ister-app), the self-hosted media server.
Ships for Android (incl. Android TV and Android Auto), Linux (flatpak) and web.

## Development

```shell
flutter pub get
dart run build_runner build   # GraphQL types + routing, after changing .graphql/@RoutePage
flutter test                  # unit/widget tests
flutter analyze
```

## Integration tests

`integration_test/` drives the real app against the Helm chart's kind deployment: adding a
server, watching a movie over HLS, listening to an audiobook and a podcast, reading an epub
(with progress sync) and read-aloud. Bring the environment up from a checkout of the
[chart repo](https://github.com/ister-app/chart) and run everything with:

```shell
make -C ../chart player-e2e
```

or run it by hand: `make -C ../chart up`, start `../chart/ci/e2e/forward-for-player.sh`, then

```shell
flutter test integration_test -d linux --dart-define=ISTER_TEST_MODE=true
```

`ci/e2e-pins.env` pins which chart release, testdata commit and server version CI tests
against; releases require hard pins (see the comments in that file).

## Iso 639-3 data

https://iso639-3.sil.org/code_tables/download_tables

## Linux flatpak version

```bash
flutter build linux
flatpak-builder --user --force-clean --install-deps-from=flathub builddir app.ister.Player.yaml
flatpak-builder --run builddir app.ister.Player.yaml ister
```
