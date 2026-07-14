# Homebrew Tap

Homebrew tap for `stephenlclarke` tools and games:

```sh
brew tap stephenlclarke/tap
brew trust --tap stephenlclarke/tap
```

## Container Release Stack

The stable `container` and `container-compose` formulae install the matched
prebuilt runtime and Docker Compose v2 plugin. The canonical five-repository
stack map and current dependency pins live in `container-compose`'s
[README](https://github.com/stephenlclarke/container-compose#project-repositories)
and [STATUS.md](https://github.com/stephenlclarke/container-compose/blob/main/STATUS.md).

The four component source repositories and this tap use `main`. Bare semantic
`container-compose` tags publish stable plugin assets and update this tap after
package, checksum, and formula verification. Source submodules are maintenance
inputs only; Homebrew installs do not build from them.

Install the matched runtime and plugin:

```sh
brew install stephenlclarke/tap/container-compose
brew postinstall stephenlclarke/tap/container
brew services restart stephenlclarke/tap/container
container system version
container compose version
```

Complete install, upgrade, migration, and removal instructions live in
[INSTALL.md](INSTALL.md). Release policy lives in the
[`container-compose` branch guide](https://github.com/stephenlclarke/container-compose/blob/main/BRANCHES.md).

## Games

`maze`, `mazewar`, `asteroids`, and `defender` build a native macOS app bundle from their current `main` source and install a launcher command.

| Formula | Install command |
| --- | --- |
| `maze` | `brew install --HEAD stephenlclarke/tap/maze` |
| `mazewar` | `brew install --HEAD stephenlclarke/tap/mazewar` |
| `pacman` | `brew install stephenlclarke/tap/pacman` |
| `battlezone` | `brew install stephenlclarke/tap/battlezone` |
| `asteroids` | `brew install --HEAD stephenlclarke/tap/asteroids` |
| `defender` | `brew install --HEAD stephenlclarke/tap/defender` |

## FIX Decoders

The language-suffixed binaries can coexist:

| Formula | Install command |
| --- | --- |
| `fixdecoder-go` | `brew install stephenlclarke/tap/fixdecoder-go` |
| `fixdecoder-java` | `brew install --HEAD stephenlclarke/tap/fixdecoder-java` |
| `fixdecoder-rs` | `brew install stephenlclarke/tap/fixdecoder-rs` |
| `fixdecoder-zig` | `brew install --HEAD stephenlclarke/tap/fixdecoder-zig` |

## Utilities

| Formula | Install command |
| --- | --- |
| `sqlterm` | `brew install --HEAD stephenlclarke/tap/sqlterm` |

## Source Maintenance

The tap tracks these source repositories on `main`:

- `sources/container`
- `sources/container-compose`
- `sources/containerization`
- `sources/container-builder-shim`
- `sources/pacman`
- `sources/battlezone`
- `sources/asteroids`
- `sources/defender`
- `sources/maze`
- `sources/mazewar`
- `sources/fixdecoder_go`
- `sources/fixdecoder_java`
- `sources/fixdecoder_rs`
- `sources/fixdecoder_zig`
- `sources/sqlterm`
