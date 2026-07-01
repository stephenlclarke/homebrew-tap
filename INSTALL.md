# Installing From The Tap

This tap provides Homebrew formulae for Stephen Clarke's tools and games. For the `container-compose` stack, use the fork-backed `container` runtime and choose one Compose plugin lane:

| Lane | Runtime formula | Plugin formula | Use when |
| --- | --- | --- | --- |
| Stable | `container` | `container-compose` | Normal install and upgrade path. |
| Pre-release | `container` | `container-compose-pre` | Testing the next `develop/VERSION` slice before promotion. |

The runtime and plugin are the only Homebrew-installed pieces of the container stack. `containerization` is a Swift package dependency compiled into those packages, and `container-builder-shim` is consumed as a Linux/arm64 builder image pinned by `container` rather than as a macOS Homebrew formula. The tap tracks all four source repositories on `main` for maintenance visibility.

Detailed `container` migration guidance, including what to do when Apple's signed `container` package is already installed, lives in [`container-compose/INSTALL.md`](https://github.com/stephenlclarke/container-compose/blob/main/INSTALL.md).

## Requirements

- Apple silicon Mac.
- macOS Sequoia or newer for `container` and `container-compose`.
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

## Install container-compose

Install the stable plugin:

```sh
brew install stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container compose version
```

The `container` formula owns the plugin registration link inside its own
Homebrew install root. Run the matching `container` formula's `post_install`
hook after installing or upgrading `container-compose`.

## Switch Plugin Lanes

`container-compose` and `container-compose-pre` install the same command and plugin path, so uninstall one lane before installing the other.

```sh
# Stay on stable
brew upgrade stephenlclarke/tap/container-compose

# Stay on pre-release
brew upgrade stephenlclarke/tap/container-compose-pre

# Switch stable -> pre-release
brew uninstall --ignore-dependencies stephenlclarke/tap/container-compose
brew install --formula stephenlclarke/tap/container-compose-pre
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container

# Switch pre-release -> stable
brew uninstall --ignore-dependencies stephenlclarke/tap/container-compose-pre
brew install --formula stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
```

## Upgrade

Update the tap and upgrade the installed lane:

```sh
brew update
brew upgrade stephenlclarke/tap/container stephenlclarke/tap/container-compose
```

Use `container-compose-pre` in the upgrade command if that is the installed lane. The `container` formula refreshes the plugin symlink during reinstall. If an
older install still cannot find the plugin, run
`brew postinstall stephenlclarke/tap/container`.

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

Install the games, decoder tools, and utilities directly:

```sh
brew install stephenlclarke/tap/pacman
brew install stephenlclarke/tap/battlezone
brew install --HEAD stephenlclarke/tap/asteroids
brew install --HEAD stephenlclarke/tap/defender
brew install stephenlclarke/tap/fixdecoder-go
brew install --HEAD stephenlclarke/tap/fixdecoder-java
brew install stephenlclarke/tap/fixdecoder-rs
brew install --HEAD stephenlclarke/tap/fixdecoder-zig
brew install --HEAD stephenlclarke/tap/sqlterm
```

Remove any of them with `brew uninstall <formula>`.
