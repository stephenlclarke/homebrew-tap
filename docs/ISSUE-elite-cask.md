# Elite has no binary Homebrew installation

## Problem

Elite publishes a signed, notarized universal macOS app, but the tap has no cask for it. The existing workflow validates only source formulae and does not watch or test `Casks/`.

## Required behavior

- Install the published Elite 1.3.1 app from its immutable archive URL and exact SHA256.
- Declare macOS Sonoma 14 or later, supporting both packaged architectures.
- Preserve quarantine, user saves and mission packs during installation and removal.
- Validate the cask separately without changing the existing formula job or submodules.
- Exercise installation and removal in a temporary app directory without launching the game.

## Tracking

The change is prepared on `feat/elite-cask`; no GitHub issue or pull request has been created. The [published manifest](https://github.com/stephenlclarke/elite/blob/1ef005e0c73971a360a0e3bb52792a9286a761d3/releases/macos/Elite-1.3.1-universal.json) records the release evidence.
