# Container formulae omit required runtime assets

## Problem

The stable and current Container formulae install the CLI, API server, and
plugin subtree, but discard the Container Engine gateway, semantic helper, and
Engine-Linux service archives already present in their signed packages.
`container system start` consequently cannot launch `container-engine`, and
the installed API server cannot activate the packaged journald or GELF
services.

## Required behavior

- Install `bin/container-engine` in both Container formulae.
- Install the complete staged `libexec/container` directory.
- Assert representative gateway, helper, and service assets in formula tests.
- Preserve existing Compose plugin linking and lifecycle behavior.

## Tracking

- Tap issue: <https://github.com/stephenlclarke/homebrew-tap/issues/5>
- Source issue: <https://github.com/stephenlclarke/container/issues/261>
