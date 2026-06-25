# Installing From The Tap

This tap provides Homebrew formulae for Stephen Clarke's tools and games. For the `container-compose` stack, install the fork-backed `container` runtime and one frozen plugin lane:

| Lane | Formula | Build type |
| --- | --- | --- |
| Release | `container-compose` | release |
| Snapshot | `container-compose-snapshot` | debug |

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

```sh
brew install stephenlclarke/tap/container
brew services start container
container --version
```

## Install container-compose

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

Do not install `container-compose` and `container-compose-snapshot` at the same time. They both install the `container-compose` command and the `compose` plugin payload.

## Switch Plugin Lanes

Stop the service, uninstall the current plugin lane, then install the other lane:

```sh
brew services stop container || true
brew uninstall container-compose container-compose-snapshot || true
```

Then run the install commands for the target lane.

## Upgrade

Update the tap and reinstall the installed packages:

```sh
brew update
brew reinstall container
brew reinstall container-compose
```

For the snapshot lane:

```sh
brew update
brew reinstall container
brew reinstall container-compose-snapshot
```

Re-register the plugin symlink after reinstalling `container-compose` or `container-compose-snapshot`.

## Remove container-compose

Remove the release plugin:

```sh
brew services stop container || true
rm -f "$(brew --prefix container)/libexec/container-plugins/compose"
brew uninstall container-compose
```

Remove the snapshot plugin:

```sh
brew services stop container || true
rm -f "$(brew --prefix container)/libexec/container-plugins/compose"
brew uninstall container-compose-snapshot
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
