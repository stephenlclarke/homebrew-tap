# fix(pacman): install the published wgpu renderer

## Motivation

See `ISSUE-pacman-wgpu-install.md`. The old formula downloads a Kitty-based release despite describing wgpu.

## Implementation

Pin the stable source archive and SHA256 to published wgpu commit `cd49a1a0f407801cdc492ba61b4cdc5f8afb42c5`, retain upstream version 1.0.0 with formula revision 1, and use the wgpu branch for HEAD. Build with Homebrew standard Cargo arguments, declare Linux ALSA/pkgconf requirements, and verify the installed help identifies the wgpu window.

## Compatibility

The executable remains `pacman`. Interactive play needs a graphical desktop and suitable GPU. Linux runtime behavior remains unverified. A future tagged wgpu release can replace the commit archive.

## Validation

Formula style, strict online audit, and checksum verification pass. A normal Homebrew source installation succeeds on macOS; `brew test stephenlclarke/tap/pacman` and `/opt/homebrew/bin/pacman --help` pass. Homebrew installed version `1.0.0_1` after updating its Rust build dependencies. Linux installation and live graphical play remain unverified.
