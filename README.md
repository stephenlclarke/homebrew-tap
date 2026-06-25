# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games.

```sh
brew tap stephenlclarke/tap
```

## container

`container` installs Stephen Clarke's fork-backed prebuilt `container` CLI. Detailed install, Apple-package migration, upgrade, and removal instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

```sh
brew install stephenlclarke/tap/container
brew services start container
```

## container-compose

`container-compose` installs prebuilt Docker Compose style plugin assets for Apple's `container` CLI. Normal installs do not build Swift or Go source and do not require Go or Xcode. Detailed install and plugin registration instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

Install the latest frozen release:

```sh
brew install stephenlclarke/tap/container-compose
mkdir -p "$(brew --prefix container)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose)/libexec/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
brew services restart container
container compose version
```

Install the latest frozen snapshot:

```sh
brew install stephenlclarke/tap/container-compose-snapshot
mkdir -p "$(brew --prefix container)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose-snapshot)/libexec/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
brew services restart container
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
- `sources/pacman`: `main`
- `sources/battlezone`: `main`
- `sources/asteroids`: `main`
- `sources/defender`: `main`
- `sources/fixdecoder_go`: `main`
- `sources/fixdecoder_java`: `main`
- `sources/fixdecoder_rs`: `main`
- `sources/fixdecoder_zig`: `main`

`container-compose` development now happens on `main`; release and snapshot Homebrew installs are supplied as prebuilt assets from frozen compose branches through `container-compose` and `container-compose-snapshot`. The old `develop` source-build lane is not the normal install path.
