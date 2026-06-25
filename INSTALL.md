# Installing From The Tap

This tap provides Homebrew formulae for Stephen Clarke's tools and games. For the `container` and `container-compose` stack, the tap installs prebuilt release assets and supports two lanes:

| Lane | Formulae | Build type |
| --- | --- | --- |
| `main` | `container`, `container-compose` | release |
| `develop` | `container-develop`, `container-compose-develop` | debug |

Install `container` and `container-compose` from the same lane. Detailed `container` migration guidance, including what to do when Apple's signed `container` package is already installed, lives in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/develop/INSTALL.md).

## Requirements

- Apple silicon Mac.
- macOS 26 or newer for `container` and `container-compose`.
- Homebrew.

## Tap

```sh
brew tap stephenlclarke/tap
```

## Install container

Install the `main` release lane:

```sh
brew install stephenlclarke/tap/container
brew services start container
container --version
```

Install the `develop` debug lane:

```sh
brew install stephenlclarke/tap/container-develop
brew services start container-develop
container --version
```

The two lanes both install the `container` command and service payload, so they conflict with each other. Uninstall one lane before installing the other.

## Install container-compose

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

The `container-compose` lane must match the installed `container` lane. Do not install the `develop` plugin against the `main` container formula.

## Switch Lanes

Stop services, uninstall the current lane, then install the other lane:

```sh
brew services stop container || true
brew services stop container-develop || true
brew uninstall container-compose container-compose-develop container container-develop || true
```

Then run the install commands for the target lane.

## Upgrade

Update the tap and reinstall the installed lane:

```sh
brew update
brew reinstall container container-compose
```

For the `develop` lane:

```sh
brew update
brew reinstall container-develop container-compose-develop
```

Re-register the plugin symlink after reinstalling `container-compose`.

## Remove container-compose

Remove the `main` plugin:

```sh
brew services stop container || true
rm -f "$(brew --prefix container)/libexec/container-plugins/compose"
brew uninstall container-compose
```

Remove the `develop` plugin:

```sh
brew services stop container-develop || true
rm -f "$(brew --prefix container-develop)/libexec/container-plugins/compose"
brew uninstall container-compose-develop
```

## Remove container

Remove the `main` lane:

```sh
brew services stop container || true
brew uninstall container
```

Remove the `develop` lane:

```sh
brew services stop container-develop || true
brew uninstall container-develop
```

If you want to remove the tap after uninstalling the formulae:

```sh
brew untap stephenlclarke/tap
```

## Other Formulae

Install the games and decoder tools directly:

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

Remove any of them with `brew uninstall <formula>`.
