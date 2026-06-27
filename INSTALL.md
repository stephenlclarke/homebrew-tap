# Installing From The Tap

This tap provides Homebrew formulae for Stephen Clarke's tools and games. For the `container-compose` stack, choose one matching runtime and plugin lane:

| Lane | Runtime formula | Plugin formula | Build type |
| --- | --- | --- | --- |
| Main | `container` | `container-compose` | release |
| Latest stable release | `container-release` | `container-compose-release` | release |
| Tagged release | `container-release-v0-1-0` style | `container-compose-release-v0-1-0` style | release |

The latest stable release lane uses the moving `homebrew-release` package tag,
similar to a Docker `latest` tag. Tagged release formulae are for immutable
release branch copies.

Detailed `container` migration guidance, including what to do when Apple's signed `container` package is already installed, lives in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

## Requirements

- Apple silicon Mac.
- macOS 26 or newer for `container` and `container-compose`.
- Homebrew.

## Tap

```sh
brew tap stephenlclarke/tap
```

## Install container

Install the latest `main` runtime:

```sh
brew install stephenlclarke/tap/container
brew services start container
container --version
```

For the latest stable release runtime, use `container-release` and restart
`container-release` instead.

## Install container-compose

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

For the latest stable release lane:

```sh
brew install stephenlclarke/tap/container-release
brew install stephenlclarke/tap/container-compose-release
mkdir -p "$(brew --prefix container-release)/libexec/container-plugins"
ln -sfn "$(brew --prefix container-compose-release)/libexec/container-plugins/compose" "$(brew --prefix container-release)/libexec/container-plugins/compose"
brew services restart container-release
container compose version
```

## Switch Plugin Lanes

Stop the service, uninstall the current runtime and plugin lane, then install the target lane:

```sh
brew services stop container || true
brew services stop container-release || true
brew uninstall container container-release container-compose container-compose-release || true
```

Then run the install commands for the target lane.

## Upgrade

Update the tap and reinstall the installed packages:

```sh
brew update
brew reinstall container
brew reinstall container-compose
```

Re-register the plugin symlink after reinstalling `container-compose` or a release-branch formula.

## Remove container-compose

Remove the release plugin:

```sh
brew services stop container || true
rm -f "$(brew --prefix container)/libexec/container-plugins/compose"
brew uninstall container-compose
```

## Remove container

```sh
brew services stop container || true
brew uninstall container
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
