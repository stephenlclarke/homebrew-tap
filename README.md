# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games.

This repository is an aggregate tap. The source repositories continue to own their own Homebrew formulae:

- [`stephenlclarke/container`](https://github.com/stephenlclarke/container): `sources/container/Formula/container.rb`
- [`stephenlclarke/container-compose`](https://github.com/stephenlclarke/container-compose): `sources/container-compose/Formula/container-compose.rb`

Homebrew only discovers formulae from top-level tap paths such as `Formula/*.rb`, so this repository keeps synchronized copies there. The copies are generated from the submodules with:

```sh
scripts/sync-formulae.sh
```

To refresh the submodules from their configured branches and then sync the top-level formulae:

```sh
scripts/sync-formulae.sh --update-submodules
```

## Install

```sh
brew tap stephenlclarke/tap
brew install --build-from-source --HEAD stephenlclarke/tap/container
brew install --build-from-source --HEAD stephenlclarke/tap/container-compose
```

Other formulae:

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

After installing `container-compose`, register the plugin with the Homebrew-installed `container` keg:

```sh
mkdir -p "$(brew --prefix container)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose)/libexec/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
brew services restart container
```

Verify plugin discovery:

```sh
container compose version
```

## Source Branches

The submodules currently track:

- `sources/container`: `main`
- `sources/container-compose`: `develop`
- `sources/pacman`: `main`
- `sources/battlezone`: `main`
- `sources/asteroids`: `main`
- `sources/defender`: `main`
- `sources/fixdecoder_go`: `main`
- `sources/fixdecoder_java`: `main`
- `sources/fixdecoder_rs`: `main`
- `sources/fixdecoder_zig`: `main`

The `container-compose` formula is mirrored from its `develop` lane because that formula builds from the `develop` branch and pins the matching `stephenlclarke/container` fork resource. No tap files in either source repository are modified by this aggregate tap.
