#!/usr/bin/env bash
# Builds the documentation zip: runs the screenshot tour (integration_test/doc_tour_test.dart)
# against the already-running kind deployment, validates that every image the markdown
# references was actually captured, and packages doc/ as player-docs-<version>.zip.
#
# Preconditions (identical to the integration e2e): the chart's kind cluster is up, its
# port-forwards are active (chart repo: `make up` + ci/e2e/forward-for-player.sh, or
# `make player-e2e`), and the libraries have been scanned. Run from the repo root:
#
#   ci/build-docs.sh [version]
#
# The version defaults to the one in pubspec.yaml (without the +build suffix).
set -euo pipefail

cd "$(dirname "$0")/.."

version="${1:-$(grep -oP '^version:\s*\K[0-9]+\.[0-9]+\.[0-9]+' pubspec.yaml)}"
zip_name="player-docs-${version}.zip"
images_dir="doc/user/images"

flutter pub get

# One app run captures every locale: the tour switches the app's locale at
# runtime between passes (a second cold start — mpv/GL init on a fresh Xvfb —
# proved flaky) and files its screenshots into doc/user/images/<locale>/ with
# ImageMagick's `import` (the integration_test plugin has no takeScreenshot on
# Linux; X capture also gets the media_kit video texture, which an in-tree
# capture would miss).
# GDK_BACKEND=x11 pins the app to an X window `import` can grab. Wayland
# desktops cannot be captured (X screen grabs are blocked there), so the tour
# needs a real X display:
#   - DOC_DISPLAY=<display>: use that X server. For local dev without
#     installing anything, run Xvfb in a container and connect over TCP:
#       podman run -d --name docs-xvfb --rm -p 127.0.0.1:6099:6099 \
#         registry.fedoraproject.org/fedora:44 bash -c \
#         'dnf install -y -q xorg-x11-server-Xvfb >/dev/null && \
#          exec Xvfb :99 -screen 0 1280x720x24 -listen tcp -ac'
#       DOC_DISPLAY=localhost:99 ci/build-docs.sh
#   - otherwise, xvfb-run when available (CI).
#   - otherwise, the current DISPLAY (an X11 session; keep it unlocked and
#     leave the window alone while the tour runs).
export DOC_SCREENSHOT_DIR="$PWD/$images_dir"
export GDK_BACKEND=x11
# Headless X has no GPU; force Mesa's software GL so the media_kit video
# texture renders instead of staying black (harmless where it already works).
export LIBGL_ALWAYS_SOFTWARE=1
echo "=== capturing screenshots"
for locale in en nl; do
  rm -rf "$images_dir/$locale"
done
tour="flutter test integration_test/doc_tour_test.dart -d linux \
  --dart-define=ISTER_TEST_MODE=true"
if [ -n "${DOC_DISPLAY:-}" ]; then
  DISPLAY="$DOC_DISPLAY" $tour
elif command -v xvfb-run >/dev/null 2>&1; then
  # PulseAudio's null sink gives mpv an audio clock — without it, music and
  # movie positions never advance (same trick as the integration-e2e job).
  xvfb-run -a -s '-screen 0 1280x720x24' dbus-run-session -- bash -c \
    "pulseaudio --start --exit-idle-time=-1 >/dev/null 2>&1 || true; $tour"
else
  $tour
fi

# Every image the user guide references must exist and be non-empty — a missing
# or 0-byte PNG means a capture silently failed, and the docs must not ship a
# broken image.
echo "=== validating image references"
missing=0
while IFS= read -r ref; do
  md_file="${ref%%:*}"
  img_rel="${ref#*:}"
  img_path="$(realpath -m "$(dirname "$md_file")/$img_rel")"
  if [ ! -s "$img_path" ]; then
    echo "::error::$md_file references $img_rel but $img_path is missing or empty"
    missing=1
  fi
done < <(grep -RoP '!\[[^]]*\]\(\K[^)]+(?=\))' doc --include='*.md' | grep -vE '^https?://')
[ "$missing" -eq 0 ] || { echo "docs build failed: missing screenshots" >&2; exit 1; }

# Belt and braces: the tour itself must have produced at least one PNG per locale.
for locale in en nl; do
  count=$(find "$images_dir/$locale" -name '*.png' -size +0c 2>/dev/null | wc -l)
  [ "$count" -gt 0 ] || { echo "no screenshots captured for locale $locale" >&2; exit 1; }
  echo "$locale: $count screenshots"
done

echo "=== packaging $zip_name"
rm -f "$zip_name"
zip -qr "$zip_name" doc -x '*/.gitkeep'
echo "built $zip_name ($(du -h "$zip_name" | cut -f1))"
