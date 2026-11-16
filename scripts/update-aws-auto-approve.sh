#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# USAGE:
#   Usage: @SCRIPT_NAME@ [--help]
#
# DESCRIPTION:
#   Open an update for the latest AWS Auto Approve release, verify its
#   formula checksum and enable merging after the required Homebrew check.
#   Only this formula and branches created by this workflow are eligible.
#
# ENVIRONMENT:
#   GH_TOKEN    Repository-scoped GitHub Actions token for this tap.
#   AWS_AUTO_APPROVE_REVIEW_TOKEN
#               Fine-grained owner token: this tap only, pull requests write.
# ENDUSAGE
# ---------------------------------------------------------------------------

set -euo pipefail
readonly SELF_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_NAME="$(basename "$SELF_PATH")"
readonly SCRIPT_NAME
WORK_DIR=''

# Print embedded help.
usage() {
    awk -v name="$SCRIPT_NAME" '/^# USAGE:/ {p=1;next} p && /^# ENDUSAGE/ {exit} p {sub(/^# ?/, "");gsub(/@SCRIPT_NAME@/,name);print}' "$SELF_PATH"
}

# Print a normal status message.
info() { printf '[i] %s\n' "$*"; }

# Stop on a failed download or inconsistent release.
error() { printf '[x] %s\n' "$*" >&2; exit 1; }

# Remove only this invocation's downloaded assets.
cleanup() { if [[ -n "$WORK_DIR" ]]; then rm -rf "$WORK_DIR"; fi; }

# Enable merge only for this bot's single-file release update after required checks.
enable_merge() {
    local branch="$1" number author files head state attempt
    number="$(gh pr list --repo stephenlclarke/homebrew-tap --state open --head "$branch" --json number --jq '.[0].number // empty')"
    [[ "$number" =~ ^[0-9]+$ ]] || error 'No open release pull request was found.'
    author="$(gh pr view "$number" --repo stephenlclarke/homebrew-tap --json author --jq .author.login)"
    [[ "$author" == 'github-actions[bot]' ]] || error 'Refusing to auto-merge a pull request from another author.'
    files="$(gh pr diff "$number" --repo stephenlclarke/homebrew-tap --name-only)"
    [[ "$files" == Formula/aws-auto-approve.rb ]] || error 'Refusing to auto-merge changes outside the AWS Auto Approve formula.'
    head="$(gh pr view "$number" --repo stephenlclarke/homebrew-tap --json headRefOid --jq .headRefOid)"
    state="$(gh pr view "$number" --repo stephenlclarke/homebrew-tap --json mergeStateStatus --jq .mergeStateStatus)"
    if [[ "$state" == BEHIND ]]; then
        gh api --method PUT "repos/stephenlclarke/homebrew-tap/pulls/$number/update-branch" -f "expected_head_sha=$head" >/dev/null
        for ((attempt=0; attempt<5; attempt++)); do
            sleep 2
            state="$(gh pr view "$number" --repo stephenlclarke/homebrew-tap --json headRefOid --jq .headRefOid)"
            if [[ "$state" != "$head" ]]; then head="$state"; break; fi
        done
    fi
    [[ "$head" =~ ^[0-9a-f]{40}$ ]] || error 'The release pull request has an invalid head commit.'
    [[ -n "${AWS_AUTO_APPROVE_REVIEW_TOKEN:-}" ]] || error 'Set AWS_AUTO_APPROVE_REVIEW_TOKEN to enable the protected owner review.'
    gh workflow run homebrew.yml --repo stephenlclarke/homebrew-tap --ref "$branch" -f formula=aws-auto-approve || error 'Could not dispatch the required Homebrew check.'
    GH_TOKEN="$AWS_AUTO_APPROVE_REVIEW_TOKEN" gh pr review "$number" --repo stephenlclarke/homebrew-tap --approve || error 'The narrowly scoped owner review did not succeed.'
    gh pr merge "$number" --repo stephenlclarke/homebrew-tap --auto --squash --match-head-commit "$head" || error 'Could not enable protected auto-merge.'
}

# Verify the latest release and propose exactly its generated formula.
main() {
    local repository='stephenlclarke/aws-auto-approve' tap='stephenlclarke/homebrew-tap'
    local tag checksum actual branch
    if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then usage; return; fi
    if (($#)); then usage >&2; return 2; fi
    tag="$(gh release view --repo "$repository" --json tagName --jq .tagName)"
    [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || error 'Latest release is not a stable semantic version.'
    WORK_DIR="$(mktemp -d)"
    trap cleanup EXIT
    gh release download "$tag" --repo "$repository" --pattern aws-auto-approve.rb --pattern SHA256SUMS --dir "$WORK_DIR"
    checksum="$(awk '$2=="aws-auto-approve.rb" {print $1}' "$WORK_DIR/SHA256SUMS")"
    actual="$(sha256sum "$WORK_DIR/aws-auto-approve.rb" | awk '{print $1}')"
    [[ "$checksum" =~ ^[a-f0-9]{64}$ && "$checksum" == "$actual" ]] || error 'Released formula checksum does not match.'
    ruby -c "$WORK_DIR/aws-auto-approve.rb"
    grep -Fq "version \"${tag#v}\"" "$WORK_DIR/aws-auto-approve.rb" || error 'Formula version does not match the release.'
    if cmp -s Formula/aws-auto-approve.rb "$WORK_DIR/aws-auto-approve.rb"; then info 'The tap already has this release.'; return; fi
    branch="automation/aws-auto-approve-$tag"
    if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
        git fetch origin "$branch"
        git show FETCH_HEAD:Formula/aws-auto-approve.rb >"$WORK_DIR/branch-formula"
        cmp -s "$WORK_DIR/branch-formula" "$WORK_DIR/aws-auto-approve.rb" || error 'Existing branch differs from the verified release formula.'
        enable_merge "$branch"
        return
    fi
    git switch -c "$branch"
    cp "$WORK_DIR/aws-auto-approve.rb" Formula/aws-auto-approve.rb
    git config user.name 'github-actions[bot]'
    git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
    git add Formula/aws-auto-approve.rb
    git commit -m "chore: update aws-auto-approve to $tag"
    git push --set-upstream origin "$branch"
    printf 'Install the prebuilt AWS Auto Approve %s packages. The formula and its SHA-256 values come from the published release.\n\nThe release checksum was verified before committing. Auto-merge is restricted to this bot-created, single-formula update and waits for the required Formula Syntax check.\n' "$tag" >"$WORK_DIR/pr-body"
    gh pr create --repo "$tap" --base main --head "$branch" --title "chore: update aws-auto-approve to $tag" --body-file "$WORK_DIR/pr-body"
    # Explicit dispatch runs checks for this bot-created branch without a personal token.
    enable_merge "$branch"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then main "$@"; fi
