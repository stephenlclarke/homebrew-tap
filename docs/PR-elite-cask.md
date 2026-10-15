# feat(cask): add signed Elite app installation and validation

## Summary

- Add `Casks/elite.rb` for the published universal 1.3.1 app with its immutable archive URL, SHA256 and Sonoma minimum.
- Add a separate macOS cask workflow, triggered only by cask files or its own workflow, for syntax, style, strict online audit, isolated installation, signature/notary/quarantine verification and removal.
- Document installation, upgrades and safe removal in the README and install guide.

## Type of Change

- [x] New feature
- [x] Documentation update
- [ ] Breaking change

## Motivation and Context

See [ISSUE-elite-cask.md](ISSUE-elite-cask.md). A binary cask installs the reviewed app directly. The original Homebrew workflow remains byte-for-byte unchanged, so a later cask-only update does not trigger unrelated formula installations. Source submodules remain unchanged.

## Testing

- [x] Ruby syntax, strict online Homebrew audit and both-architecture audit
- [x] Download SHA256 and size match the published manifest
- [x] Extracted app identity, both Mach-O architectures/minimums, strict signature, stapled ticket and Gatekeeper
- [x] Isolated Homebrew install/uninstall, quarantine retained and all existing save-file hashes preserved
- [x] Workflow YAML, shell and Markdown checks
- [ ] Hosted cask job after publication

The local smoke uses a temporary validation tap with the exact cask contents and an isolated application directory. It does not launch the app or overwrite a user application. The extracted CI audit/install/uninstall scripts also pass locally using the temporary tap; installed artifacts are removed and existing saves remain unchanged. Logs are retained at `/tmp/elite-homebrew-cask-validation` on the authoring Mac.

## Compatibility

The cask requires macOS 14 or later and contains arm64 and x86_64 binaries. It installs `Elite.app`, declares no architecture-specific dependencies or destructive removal hooks, and preserves `~/.xyzzy/elite`. The immutable download commit identifies the published archive; the app's embedded source revision is recorded separately in its manifest. Version discovery is intentionally manual until a newer reviewed archive and cask update are published.

## Style exception

Homebrew 7's `Cask/Url` rule treats a ZIP under a raw GitHub `releases/` path as a GitHub-generated source zipball. This URL is the already-built, signed app artifact, so replacing it with a source tarball would break installation and the required immutable release pin. Full style reports only this false positive; the cask-specific CI invocation excludes `Cask/Url` while retaining every other style check, strict online audit, SHA256 and app security verification. The cask itself has no inline suppression or quarantine exemption.

## Remaining risks

Native execution on Intel hardware and macOS Sonoma was not performed; both architectures and their 14.0 minimum load commands were inspected. The GitHub job is prepared and locally linted, but has not run remotely. The separate cask workflow passes YAML lint, actionlint, shell syntax and ShellCheck; scoped Markdown lint is clean. No commit is pushed and no GitHub issue or pull request is created during preparation.
