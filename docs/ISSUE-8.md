# Install the current Elite GitHub Release

## Problem

The tap still installs Elite 1.3.1 after the signed, Apple-notarized [1.4.0 Release](https://github.com/stephenlclarke/elite/releases/tag/v1.4.0) was published. Update the cask to that actual Release asset and its exact checksum, while preserving quarantine, commanders and mission packs.

## Required behavior

Install the universal macOS 14 app with the current version, retain its protected-main artifact provenance, and use GitHub latest-release version discovery. Remove the obsolete raw-GitHub URL style exception. Run full style/online audit and isolated install/uninstall/security checks. Keep the existing formula job and source submodules unchanged.

## Tracking

[Issue #8](https://github.com/stephenlclarke/homebrew-tap/issues/8).
