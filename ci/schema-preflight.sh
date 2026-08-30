#!/usr/bin/env bash
#
# Fail fast when the player's GraphQL operations don't fit the schema of the
# server that is actually running — i.e. the pinned SERVER_IMAGE_TAG is behind
# the player. Without this gate that skew surfaces half an hour later as a
# cryptic FieldUndefined error in the middle of a random integration test
# (historically the single biggest cause of red e2e runs; see ci/e2e-pins.env
# for the trail of pins this pattern produced).
#
# Validates every operation document in lib/graphql/*.graphql against the
# schema fetched from the running server via introspection, so it also catches
# the "mutable -snapshot tag froze on an older image" case: what matters is
# what is deployed, not what the tag claims.
#
# Usage: ci/schema-preflight.sh
#   Needs the same host access as the integration tests (the server on
#   localhost:8080/api, the mock OIDC issuer on localhost:18081) — in CI the
#   "Start port-forwards" step, locally chart/ci/e2e/forward-for-player.sh.
#   Override with ISTER_SERVER / ISTER_TOKEN_URL, matching the harness.

set -euo pipefail
cd "$(dirname "$0")/.."

API="${ISTER_SERVER:-http://localhost:8080/api}"
TOKEN_URL="${ISTER_TOKEN_URL:-http://localhost:18081/default/token}"

# Same mint as integration_test/support/harness.dart: the Host header makes the
# issued `iss` claim match the in-cluster issuer URL the server validates.
token=$(curl -fsS -X POST "$TOKEN_URL" \
  -H 'Host: mock-oidc:8080' \
  -d grant_type=client_credentials -d client_id=e2e -d client_secret=e2e-secret \
  -d scope=ister | jq -r '.access_token')
[ -n "$token" ] && [ "$token" != "null" ] || {
  echo "::error::schema preflight could not mint a token at $TOKEN_URL" >&2
  exit 1
}

# The fat @graphql-inspector/cli bundles the url-loader, so the schema pointer
# can be the live endpoint directly. schema.graphql is the local schema copy —
# type definitions, not an operation document — hence the ignore. Pinned to a
# major so npx stays replayable.
if npx --yes @graphql-inspector/cli@5 validate 'lib/graphql/*.graphql' "$API/graphql" \
    --ignore 'lib/graphql/schema.graphql' \
    --header "Authorization: Bearer $token"; then
  echo "schema preflight OK: all player operations fit the running server's schema"
else
  echo "::error::the running server (SERVER_IMAGE_TAG=${SERVER_IMAGE_TAG:-from chart}) is missing fields/arguments the player uses — bump SERVER_IMAGE_TAG in ci/e2e-pins.env to a build that has them (or wait for the server release). Details above." >&2
  exit 1
fi
