# Installing From The Tap

The supported container stack has one Homebrew lane: the stable fork-backed
`container` runtime with the stable `container-compose` plugin. Both install
prebuilt release assets; users do not need Xcode, Swift, or Go.

Detailed Apple-package migration and runtime troubleshooting live in the
[`container-compose` install guide](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

## Requirements

- Apple silicon Mac.
- macOS 26.
- Homebrew.

## Install

```sh
brew tap stephenlclarke/tap
brew trust --tap stephenlclarke/tap
brew install stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container system version
container compose version
```

The `container` formula owns the plugin registration link inside its Homebrew
install root. Run its `post_install` hook after installing or upgrading the
plugin so `container help` lists `compose` under `PLUGINS`.

## Upgrade

```sh
brew update
brew upgrade stephenlclarke/tap/container stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container system version
container compose version
```

The version commands report the exact runtime, source commits, builder image,
plugin version, and dependency pins used by the installed stack.

## Remove container-compose

```sh
brew services stop stephenlclarke/tap/container || true
rm -f "$(brew --prefix stephenlclarke/tap/container)/libexec/container-plugins/compose"
brew uninstall stephenlclarke/tap/container-compose
```

## Remove container

```sh
brew services stop stephenlclarke/tap/container || true
brew uninstall stephenlclarke/tap/container
```

Remove the tap after uninstalling its formulae with:

```sh
brew untap stephenlclarke/tap
```

## Other Formulae

```sh
brew install stephenlclarke/tap/pacman
brew install stephenlclarke/tap/battlezone
brew install --HEAD stephenlclarke/tap/asteroids
brew install --HEAD stephenlclarke/tap/defender
brew install --HEAD stephenlclarke/tap/maze
brew install --HEAD stephenlclarke/tap/mazewar
brew install stephenlclarke/tap/fixdecoder-go
brew install --HEAD stephenlclarke/tap/fixdecoder-java
brew install stephenlclarke/tap/fixdecoder-rs
brew install --HEAD stephenlclarke/tap/fixdecoder-zig
brew install --HEAD stephenlclarke/tap/sqlterm
```
