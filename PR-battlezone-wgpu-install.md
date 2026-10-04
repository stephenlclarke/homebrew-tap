# fix(battlezone): install the published wgpu renderer

## Motivation

See ISSUE-battlezone-wgpu-install.md. The existing stable release pin installs Kitty instead of the requested native window version.

## Implementation

Pin the stable archive and verified checksum to Battlezone commit 457237526a80061a9469f227b98cad090616c44d. Retain upstream version 1.0.0 with revision 1 so existing installations upgrade. HEAD follows develop, which contains the port. Declare Linux ALSA/pkgconf dependencies. Fetch locked Cargo dependencies before installation and use Homebrew standard Cargo arguments for offline installation. Test installed --help and --version output. Update the games documentation.

## Validation

Homebrew formula style and strict online audit pass. A real source installation on Apple silicon macOS succeeds as 1.0.0_1. brew test, installed help/version commands, and brew linkage --test pass. Markdown lint passes with MD013 disabled for single-line prose.

## Compatibility and remaining risks

The executable remains battlezone. Interactive play requires a graphical desktop and compatible GPU; a terminal with Kitty support is no longer required. The application repository records successful native window rendering, gameplay start, resizing, and Escape exit. Linux installation/runtime remains unverified. A tagged wgpu release can replace this immutable commit archive later.
