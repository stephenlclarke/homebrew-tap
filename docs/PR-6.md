# Pull request handoff: retain complete Container runtime packages

## Summary

- Install `container-engine` from the stable and current signed archives.
- Install each archive's complete `libexec/container` runtime tree.
- Assert the gateway, semantic helper, and logging service archives in both
  formula tests.

## Type of Change

- [x] Bug fix
- [ ] New feature
- [ ] Breaking change
- [x] Documentation update

## Motivation and Context

The Container package now depends on a separately supervised Engine gateway
and includes signed helper and Engine-Linux service assets. The tap discarded
those files even though they were present in the release archives. Installing
the archive's complete staged runtime restores the supported package boundary
and prevents future runtime subdirectories from being silently omitted.

Fixes <https://github.com/stephenlclarke/homebrew-tap/issues/5>.
Companion to <https://github.com/stephenlclarke/container/pull/262>.

## Testing

- [x] Tested locally
- [x] Added/updated tests
- [x] Added/updated docs
- [x] Ruby syntax
- [ ] Homebrew audit
- [ ] Stable formula reinstall and runtime health

## Compatibility

The installation is additive. Existing binary names, plugin paths, Compose
linking, and service commands remain unchanged.

## Remaining risks

The stable and current archives must continue to contain every asserted asset.
Homebrew installation tests provide the authoritative check for that contract.
