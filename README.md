# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games.

```sh
brew tap stephenlclarke/tap
```

## container

`container` installs Stephen Clarke's fork-backed prebuilt `container` CLI. Detailed install, Apple-package migration, upgrade, and removal instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/develop/INSTALL.md).

Install the `main` release lane:

```sh
brew install stephenlclarke/tap/container
brew services start container
```

Install the `develop` debug lane:

```sh
brew install stephenlclarke/tap/container-develop
brew services start container-develop
```

## container-compose

`container-compose` installs a Docker Compose style plugin for Apple's `container` CLI. Install it from the same lane as `container`. Detailed install and plugin registration instructions live in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/develop/INSTALL.md).

Install the `main` release lane:

```sh
brew install stephenlclarke/tap/container-compose
mkdir -p "$(brew --prefix container)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose)/libexec/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
brew services restart container
container compose version
```

Install the `develop` debug lane:

```sh
brew install stephenlclarke/tap/container-compose-develop
mkdir -p "$(brew --prefix container-develop)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose-develop)/libexec/container-plugins/compose" "$(brew --prefix container-develop)/libexec/container-plugins/compose"
brew services restart container-develop
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

## Maintenance

Top-level `Formula/*.rb` files are synchronized from the source repositories with:

```sh
scripts/sync-formulae.sh
```

To refresh source submodules and then sync:

```sh
scripts/sync-formulae.sh --update-submodules
```
