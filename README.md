# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games.

```sh
brew tap stephenlclarke/tap
```

## Container Project Repositories

The `container` / `container-compose` formulae are built from a four-repository preview stack:

- [`container`](https://github.com/stephenlclarke/container): fork-backed runtime and CLI. The `container` formula follows the current fork-backed runtime package used by Compose.
- [`container-compose`](https://github.com/stephenlclarke/container-compose): Compose plugin. The `container-compose` formula follows the latest stable semantic release; `container-compose-pre` follows the latest pre-release slice.
- [`containerization`](https://github.com/stephenlclarke/containerization): Swift runtime library consumed by both packages.
- [`container-builder-shim`](https://github.com/stephenlclarke/container-builder-shim): Go BuildKit bridge source. It is tracked here as a maintenance submodule, while `container` consumes an immutable builder image tag, currently `0.13.6`.

The tap source submodules track those repositories on `main` so formula maintenance can see the current source state. User installs do not build from those submodules; they consume prebuilt release-quality package assets. Go outputs in the stack are release artifacts, not debug builds.

Homebrew metrics were refreshed on 2026-06-28 from the public [`install`](https://formulae.brew.sh/api/analytics/install/365d.json) and [`install-on-request`](https://formulae.brew.sh/api/analytics/install-on-request/365d.json) analytics endpoints. Counts are shown as `30d / 90d / 365d`; formulae omitted by Homebrew's analytics payload are shown as `0 / 0 / 0`.

| Formula | Lane | Install command | Total installs | Requested installs |
| --- | --- | --- | --- | --- |
| `container` | fork-backed runtime | `brew install stephenlclarke/tap/container` | `3 / 3 / 3` | `3 / 3 / 3` |
| `container-compose` | stable Compose plugin | `brew install stephenlclarke/tap/container-compose` | `3 / 3 / 3` | `3 / 3 / 3` |
| `container-compose-pre` | pre-release Compose plugin | `brew install stephenlclarke/tap/container-compose-pre` | `0 / 0 / 0` | `0 / 0 / 0` |

## container

`container` installs Stephen Clarke's fork-backed prebuilt `container` CLI. Detailed install, Apple-package migration, upgrade, and removal instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

```sh
brew install stephenlclarke/tap/container
brew services start container
```

## container-compose

`container-compose` installs prebuilt Docker Compose style plugin assets for Apple's `container` CLI. Normal installs do not build Swift or Go source and do not require Go or Xcode. The `container` formula owns the plugin registration link inside its own Homebrew install root. Detailed install instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

Install the stable plugin:

```sh
brew install stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container compose version
```

Install the pre-release plugin only when testing the next development slice:

```sh
brew uninstall --ignore-dependencies stephenlclarke/tap/container-compose
brew install --formula stephenlclarke/tap/container-compose-pre
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container compose version
```

## Games

| Formula | App | Install command | Total installs | Requested installs |
| --- | --- | --- | --- | --- |
| `pacman` | Pac-Man | `brew install stephenlclarke/tap/pacman` | `0 / 0 / 0` | `0 / 0 / 0` |
| `battlezone` | Battlezone | `brew install stephenlclarke/tap/battlezone` | `0 / 0 / 0` | `0 / 0 / 0` |
| `asteroids` | Asteroids | `brew install --HEAD stephenlclarke/tap/asteroids` | `0 / 0 / 0` | `0 / 0 / 0` |
| `defender` | Defender | `brew install --HEAD stephenlclarke/tap/defender` | `0 / 0 / 0` | `0 / 0 / 0` |

## FIX Decoders

The `fixdecoder-*` formulae install language-suffixed binaries such as `fixdecoder-rs` and `fixdecoder-zig` so the implementations can coexist.

| Formula | Implementation | Install command | Total installs | Requested installs |
| --- | --- | --- | --- | --- |
| `fixdecoder-go` | Go | `brew install stephenlclarke/tap/fixdecoder-go` | `0 / 0 / 0` | `0 / 0 / 0` |
| `fixdecoder-java` | Java | `brew install --HEAD stephenlclarke/tap/fixdecoder-java` | `0 / 0 / 0` | `0 / 0 / 0` |
| `fixdecoder-rs` | Rust | `brew install stephenlclarke/tap/fixdecoder-rs` | `0 / 0 / 0` | `0 / 0 / 0` |
| `fixdecoder-zig` | Zig | `brew install --HEAD stephenlclarke/tap/fixdecoder-zig` | `0 / 0 / 0` | `0 / 0 / 0` |

## Utilities

| Formula | App | Install command | Total installs | Requested installs |
| --- | --- | --- | --- | --- |
| `sqlterm` | SQLTerm | `brew install --HEAD stephenlclarke/tap/sqlterm` | `0 / 0 / 0` | `0 / 0 / 0` |

## Source Branches

The submodules are maintenance inputs for this aggregate tap, not user-facing install lanes. Homebrew users should install the top-level prebuilt formulae above.

- `sources/container`: `main`
- `sources/container-compose`: `main`
- `sources/containerization`: `main`
- `sources/container-builder-shim`: `main`
- `sources/pacman`: `main`
- `sources/battlezone`: `main`
- `sources/asteroids`: `main`
- `sources/defender`: `main`
- `sources/fixdecoder_go`: `main`
- `sources/fixdecoder_java`: `main`
- `sources/fixdecoder_rs`: `main`
- `sources/fixdecoder_zig`: `main`
- `sources/sqlterm`: `main`

`container-compose`, `container`, `containerization`, and `container-builder-shim` development now happen on `main`. Compose installs are supplied by the stable `container-compose` formula and the opt-in `container-compose-pre` formula. Debug snapshot and retired release-branch Compose formulae are no longer part of the active tap surface.
