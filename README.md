# Homebrew Tap

Homebrew tap for `stephenlclarke/container` and `stephenlclarke/container-compose`.

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

The `container-compose` formula is mirrored from its `develop` lane because that formula builds from the `develop` branch and pins the matching `stephenlclarke/container` fork resource. No tap files in either source repository are modified by this aggregate tap.
