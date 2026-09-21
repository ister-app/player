#!/usr/bin/env bash
#
# Resolve a server pin (SERVER_IMAGE_TAG, or the chart's appVersion) to the server
# *release* a player release may pin — by content, not by version number.
#
# A release version ("4.2.1") resolves to itself. A -snapshot tag is mutable and names
# a version that usually never exists: "4.2.2-snapshot" predicts a patch bump, but feat
# commits turn the real release into 4.3.0 and a `!` commit into 5.0.0. Guessing from
# the number (the closest newer release in the same major) failed the nightly release
# on every server major bump — 3.0.0, 4.0.0, 5.0.0 — while the e2e had run green
# against the very commit that release was cut from. So instead: read the commit the
# snapshot image was built from (its org.opencontainers.image.revision label) and take
# the oldest server release whose tag contains that commit. A snapshot tag freezes the
# moment the server releases, so that is the release the e2e's server became.
#
# No release contains the commit → the server has unreleased work the player was
# tested against: release the server first.
#
# Usage: ci/resolve-server-release.sh <tag>
#   Prints the resolved release version on stdout; everything else goes to stderr.
#   GH_TOKEN (optional) lifts the GitHub API rate limit. Needs curl and jq.

set -euo pipefail

tag="${1:?usage: $0 <server image tag>}"
repo="ister-app/server"
images=("$repo" "ister-app/migrations")

fail() { echo "::error::$*" >&2; exit 1; }

registry_token() {
  curl -fsS "https://ghcr.io/token?scope=repository:$1:pull" | jq -r .token
}

# GET a manifest (or image index) of $1:$2.
manifest() {
  curl -fsS -H "Authorization: Bearer $(registry_token "$1")" \
    -H 'Accept: application/vnd.oci.image.index.v1+json' \
    -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json' \
    -H 'Accept: application/vnd.oci.image.manifest.v1+json' \
    -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' \
    "https://ghcr.io/v2/$1/manifests/$2"
}

# The commit an image was built from: index → linux/amd64 manifest → config blob → label.
image_revision() {
  local m digest
  m=$(manifest "$repo" "$1") || return 1
  if jq -e '.manifests' >/dev/null <<<"$m"; then
    digest=$(jq -r '[.manifests[] | select(.platform.os == "linux" and .platform.architecture == "amd64")][0].digest // empty' <<<"$m")
    [ -n "$digest" ] || return 1
    m=$(manifest "$repo" "$digest") || return 1
  fi
  digest=$(jq -r '.config.digest // empty' <<<"$m")
  [ -n "$digest" ] || return 1
  curl -fsSL -H "Authorization: Bearer $(registry_token "$repo")" \
      "https://ghcr.io/v2/$repo/blobs/$digest" \
    | jq -r '.config.Labels["org.opencontainers.image.revision"] // empty'
}

# Does release $2 contain commit $1? (the tag is not behind the commit)
release_contains() {
  local auth=()
  [ -z "${GH_TOKEN:-}" ] || auth=(-H "Authorization: Bearer $GH_TOKEN")
  local behind
  behind=$(curl -fsS "${auth[@]}" "https://api.github.com/repos/$repo/compare/$1...v$2" \
    | jq -r '.behind_by') || return 1
  [ "$behind" = "0" ]
}

require_release_images() {
  local image
  for image in "${images[@]}"; do
    manifest "$image" "$1" >/dev/null 2>&1 \
      || fail "ghcr.io/$image:$1 does not exist — $2"
  done
}

base="${tag%-SNAPSHOT}"
base="${base%-snapshot}"

if [ "$base" = "$tag" ]; then
  require_release_images "$tag" "the pinned server version was never released. Release the server first, then bump the pins."
  echo "$tag"
  exit 0
fi

revision=$(image_revision "$tag") && [ -n "$revision" ] \
  || fail "could not read the source revision of ghcr.io/$repo:$tag — does the snapshot tag exist?"
echo "ghcr.io/$repo:$tag was built from $repo@$revision" >&2

# Release versions at or above the snapshot's own number, oldest first: the snapshot
# line only opens after the release before it, so nothing older can contain its commit.
candidates=$(curl -fsS -H "Authorization: Bearer $(registry_token "$repo")" \
    "https://ghcr.io/v2/$repo/tags/list?n=10000" \
  | jq -r '.tags[]' \
  | grep -P '^[0-9]+\.[0-9]+\.[0-9]+$' \
  | sort -V \
  | awk -v pin="$base" 'BEGIN { split(pin, p, ".") }
      { split($0, v, ".")
        if (v[1]+0 != p[1]+0) { if (v[1]+0 > p[1]+0) print; next }
        if (v[2]+0 != p[2]+0) { if (v[2]+0 > p[2]+0) print; next }
        if (v[3]+0 >= p[3]+0) print }')

for candidate in $candidates; do
  if release_contains "$revision" "$candidate"; then
    require_release_images "$candidate" "the server release that contains $revision is incomplete."
    [ "$candidate" = "$base" ] \
      || echo "::notice::$tag (built from ${revision:0:7}) was released as $candidate" >&2
    echo "$candidate"
    exit 0
  fi
done

fail "no server release contains $repo@${revision:0:7}, the commit $tag was built from — the player was tested against unreleased server work. Release the server first."
