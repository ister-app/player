# Ister player documentation

This directory holds the documentation for the Ister media player app.

## Contents

- `user/en/` — the end-user guide in English (9 chapters, from installation to platform notes)
- `user/nl/` — de gebruikershandleiding in het Nederlands (same chapters, translated/adapted)
- `user/images/` — screenshots referenced by the guide, per locale (`en/`, `nl/`). **Generated at build time, never committed.**
- `architecture/en/` and `architecture/nl/` — developer-facing architecture documentation (layers, routes, services, playback pipeline, GraphQL codegen, epub reader)
- `architecture/diagrams/` — hand-authored mermaid diagrams (committed; no screenshots involved)

## Building the docs zip locally

The screenshots in `doc/user/images/` are captured from a running app against the chart repo's
dev stack, so you need that stack up first:

1. From a checkout of the [chart repo](https://github.com/ister-app/chart), bring up the kind
   deployment and port-forwards:

   ```shell
   make up
   ci/e2e/forward-for-player.sh
   ```

   (or run `make player-e2e` from the chart repo, which does all of it)

2. From the player repo root, build the docs. The screenshots need an X display; on a
   Wayland desktop, run Xvfb in a container instead of installing it:

   ```shell
   podman run -d --name docs-xvfb --rm -p 127.0.0.1:6099:6099 \
     registry.fedoraproject.org/fedora:44 bash -c \
     'dnf install -y -q xorg-x11-server-Xvfb >/dev/null && \
      exec Xvfb :99 -screen 0 1280x720x24 -listen tcp -ac'
   DOC_DISPLAY=localhost:99 ci/build-docs.sh
   podman stop docs-xvfb
   ```

   (on a machine with `xvfb-run` — like CI — plain `ci/build-docs.sh` is enough)

   Known limitation of the container display: the media_kit video texture does not render
   there, so the movie screenshot shows correct playback chrome over a black frame. For a
   pristine full set, run on a real X11 session (`ci/build-docs.sh` on the live display) or
   let the release CI build it.

The script drives the app, captures every screenshot referenced by the chapters into
`doc/user/images/<locale>/`, validates that all referenced PNGs were captured, and packages the
result as a zip. Do not commit the generated images.
