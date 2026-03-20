# player

A media player for Ister

Generate graphql and route files:

```shell
dart run build_runner build
```

## Iso 639-3 data

https://iso639-3.sil.org/code_tables/download_tables

``
## Linux flatpak version

```bash
flutter build linux
flatpak-builder --user --force-clean --install-deps-from=flathub builddir app.ister.Player.yaml
flatpak-builder --run builddir app.ister.Player.yaml ister
```
