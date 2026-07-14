# Contributing

## Commit messages

This repository uses [Conventional Commits](https://www.conventionalcommits.org/). This is not
cosmetic: the nightly release workflow derives the version bump and the release notes from the
commit subjects, so an unlabelled commit ends up in a catch-all section and never bumps anything
above a patch. A `commit-lint` job on every pull request enforces the format.

```
<type>[(optional scope)][!]: <description>
```

| Type | Use for | Release |
|---|---|---|
| `feat` | new behaviour a user can see | **minor** (1.2.0 → 1.3.0) |
| `fix` | a bug fix | patch (1.2.0 → 1.2.1) |
| `perf` | a change that only makes things faster | patch |
| `refactor` | a change with no behaviour change | patch |
| `test` | tests only | patch |
| `docs` | documentation only | patch |
| `build` | build files, Gradle, the Dockerfile, the flatpak manifest | patch |
| `ci` | workflows | patch |
| `chore` | anything else (incl. dependency bumps) | patch |

A `!` before the colon, or a `BREAKING CHANGE:` line in the body, makes the next release a
**major**.

Scopes are optional and free-form; the platform or the screen is the obvious choice (`android`,
`web`, `tv`, `player`, `library`).

Examples from a good day:

```
feat(tv): move focus with the D-pad on the details screen
fix(web): stop the white bars around video in Safari
chore(deps): bump media_kit
```

## Versions and releases

Do not edit `version` in `pubspec.yaml` by hand — the release workflow writes it. The version is
`<semver>+<build>`, where the build number is the commit count: Android's `versionCode` must never
go backwards, and the commit count is monotonic for free.

Releases run nightly, on their own, when `main` has new commits *and* the last commit built green.
They publish `ghcr.io/ister-app/player` under semver tags and attach the APK, the flatpak bundle
and the web tarball to a GitHub Release. To cut one early, or to force a specific bump, run the
**Release** workflow by hand (`workflow_dispatch`).
