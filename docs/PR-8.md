# Update Elite to the published 1.4.0 Release

## Summary

Update the Elite cask to the actual versioned GitHub Release ZIP and SHA-256. Its comment records artifact commit `bba862c558530ea2d40d634f84fbd490d9cc3401`; the executable retains source `36fa5cfef1e781f68dcb1fdbf7dae1e1e1f76224`. Livecheck now identifies the latest published GitHub Release from the project homepage. README and installation instructions link to the 1.4.0 manifest.

## Motivation and context

See [ISSUE-8.md](ISSUE-8.md). Users should receive the latest reviewed app from Homebrew. A normal GitHub Release asset allows full style checks, so the cask workflow no longer excludes the URL cop. The existing formula workflow and source submodules remain unchanged.

## Testing

Ruby syntax, full style, strict online audit and livecheck pass locally. Public ZIP size and SHA match its manifest. Isolated Homebrew install/uninstall verifies 1.4.0/source identity, arm64 and x86_64, strict signature, validated stapled ticket, Gatekeeper and quarantine. All existing player files remain byte-identical; the app was never launched or replaced in the user's Applications folder. Evidence is at `/tmp/elite-1.4-homebrew-validation` on the authoring Mac. Hosted required checks and review remain final publication gates.

## Compatibility and risks

macOS 14 or later, universal app, normal quarantine and save-preserving uninstall. No new app permissions or destructive hooks. Installer validation does not claim native Intel gameplay.

## Linked issue

Closes [Issue #8](https://github.com/stephenlclarke/homebrew-tap/issues/8).
