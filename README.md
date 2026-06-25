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

`container-compose` installs a Docker Compose style plugin for Apple's `container` CLI. Detailed install and plugin registration instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

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
