# chore(elite): publish the verified 1.5.1 cask

## Change

Update the cask version, public ZIP checksum and exact released source provenance. Update README and INSTALL manifest links. The existing Elite repository generator produced the cask from the original release plan and downloaded the public archive to verify its size and SHA-256. No install hooks, save cleanup, workflow or protection changes.

## Validation

Ruby syntax passes. The existing distribution suite passes all 44 tests and cask consistency passes. All five public release assets match their published digests; the extracted universal app passes Developer ID signing, hardened runtime, timestamp, notarization staple, Gatekeeper, minimum macOS 14, source/resource binding and actual diagnostics checks. The earlier 1.5.0 packet passed hosted cask style, audit, isolated installation/security and uninstall checks. Those checks and independent review must pass again for this updated 1.5.1 PR head.

## Compatibility

Requires macOS Sonoma 14 or later on Apple silicon or Intel. Installation, upgrades and removal preserve saved commanders and mission packs in ~/.xyzzy/elite. See ISSUE-elite-1-5-release.md.
