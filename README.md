# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games.

```sh
brew tap stephenlclarke/tap
```

## Container Project Repositories

The `container` / `container-compose` formulae are built from a four-repository preview stack:

- [`container`](https://github.com/stephenlclarke/container): fork-backed runtime and CLI. The `container` formula follows `main`; `container-release` follows the moving `release` branch package.
- [`container-compose`](https://github.com/stephenlclarke/container-compose): Compose plugin. The `container-compose` formula follows `main`; `container-compose-release` follows the matching moving `release` branch package.
- [`containerization`](https://github.com/stephenlclarke/containerization): Swift runtime library consumed by both packages. Main packages use `main`; release packages use `release`.
- [`container-builder-shim`](https://github.com/stephenlclarke/container-builder-shim): Go BuildKit bridge source. It is tracked here as a maintenance submodule, while `container` consumes an immutable builder image tag, currently `0.13.3`.

The tap source submodules track those repositories on `main` so formula maintenance can see the current source state. User installs do not build from those submodules; they consume prebuilt release-quality package assets. Go outputs in the stack are release artifacts, not debug builds.

## container

`container` installs Stephen Clarke's fork-backed prebuilt `container` CLI. Detailed install, Apple-package migration, upgrade, and removal instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

```sh
brew install stephenlclarke/tap/container
brew services start container
```

The latest stable release lane is available as `container-release`. The
`homebrew-release` package tag moves to the newest promoted release, like a
stable `latest` tag.

## container-compose

`container-compose` installs prebuilt Docker Compose style plugin assets for Apple's `container` CLI. Normal installs do not build Swift or Go source and do not require Go or Xcode. Detailed install and plugin registration instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

Install the latest `main` prebuilt:

```sh
brew install stephenlclarke/tap/container-compose
mkdir -p "$(brew --prefix container)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose)/libexec/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
brew services restart container
container compose version
```

The `release` branch publishes `container-compose-release`. Tagged release
branch copies publish branch-derived formula names such as
`container-compose-release-v0-1-0`.

For the latest stable release lane, install the matching release formulae:

```sh
brew install stephenlclarke/tap/container-release
brew install stephenlclarke/tap/container-compose-release
mkdir -p "$(brew --prefix container-release)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose-release)/libexec/container-plugins/compose" "$(brew --prefix container-release)/libexec/container-plugins/compose"
brew services restart container-release
container compose version
```

## Other Formulae

```sh
brew install stephenlclarke/tap/pacman
brew install stephenlclarke/tap/battlezone
brew install --HEAD stephenlclarke/tap/asteroids
brew install --HEAD stephenlclarke/tap/defender
brew install stephenlclarke/tap/fixdecoder-go
brew install --HEAD stephenlclarke/tap/fixdecoder-java
brew install stephenlclarke/tap/fixdecoder-rs
brew install --HEAD stephenlclarke/tap/fixdecoder-zig
```

The `fixdecoder-*` formulae install language-suffixed binaries such as `fixdecoder-rs` and `fixdecoder-zig` so the implementations can coexist.

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

`container-compose`, `container`, `containerization`, and `container-builder-shim` development now happen on `main`; release Homebrew installs are supplied as release prebuilt assets from `release` and `release-*` branches where those lanes exist. Debug snapshot formulae are no longer part of the tap.
