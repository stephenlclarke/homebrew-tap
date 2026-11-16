#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# USAGE:
#   Usage: @SCRIPT_NAME@ [--help]
#
# DESCRIPTION:
#   Open a GitHub-signed update for the latest AWS Auto Approve release, verify its
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

# Reject unsigned history before requesting a protected merge.
verify_update_signatures() {
    local head="$1" verified
    verified="$(gh api "repos/stephenlclarke/homebrew-tap/compare/main...$head" --jq '
        .total_commits > 0 and .total_commits <= 250 and
        (.commits | length) == .total_commits and
        all(.commits[]; .commit.verification.verified == true)
    ')"
    [[ "$verified" == true ]] || error 'Every update commit must have a verified signature.'
}

# Use GitHub signing without exporting a commit-signing private key to Actions.
create_signed_update() {
    local tap="$1" branch="$2" tag="$3" base head
    base="$(gh api "repos/$tap/git/ref/heads/main" --jq .object.sha)"
    [[ "$base" =~ ^[0-9a-f]{40}$ ]] || error 'The tap main commit is invalid.'
    gh api --method POST "repos/$tap/git/refs" -f "ref=refs/heads/$branch" -f "sha=$base" >/dev/null
    jq -n --arg repository "$tap" --arg branch "$branch" --arg base "$base" \
        --arg message "chore: update aws-auto-approve to $tag" \
        --rawfile formula "$WORK_DIR/aws-auto-approve.rb" '{
            query: "mutation($input:CreateCommitOnBranchInput!){createCommitOnBranch(input:$input){commit{oid}}}",
            variables: {input: {
                branch: {repositoryNameWithOwner: $repository, branchName: $branch},
                expectedHeadOid: $base,
                message: {headline: $message},
                fileChanges: {additions: [{path: "Formula/aws-auto-approve.rb", contents: ($formula | @base64)}]}
            }}
        }' >"$WORK_DIR/commit-request.json"
    head="$(gh api graphql --input "$WORK_DIR/commit-request.json" --jq .data.createCommitOnBranch.commit.oid)"
    [[ "$head" =~ ^[0-9a-f]{40}$ ]] || error 'GitHub did not return the signed update commit.'
    verify_update_signatures "$head"
}

# Enable merge only for this bot's single-file release update after required checks.
enable_merge() {
    local branch="$1" number author files head state attempt
    number="$(gh pr list --repo stephenlclarke/homebrew-tap --state open --head "$branch" --json number --jq '.[0].number // empty')"
    [[ "$number" =~ ^[0-9]+$ ]] || error 'No open release pull request was found.'
    author="$(gh pr view "$number" --repo stephenlclarke/homebrew-tap --json author --jq .author.login)"
    [[ "$author" == 'app/github-actions' ]] || error 'Refusing to auto-merge a pull request from another author.'
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
    verify_update_signatures "$head"
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
    tag="$(gh release list --repo "$repository" --exclude-drafts --exclude-pre-releases --limit 1 --json tagName --jq '.[0].tagName // empty')"
    if [[ -z "$tag" ]]; then info 'No published AWS Auto Approve release yet.'; return; fi
    [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || error 'Latest release is not a stable semantic version.'
    WORK_DIR="$(mktemp -d)"
    trap cleanup EXIT
    gh release download "$tag" --repo "$repository" --pattern aws-auto-approve.rb --pattern SHA256SUMS --dir "$WORK_DIR"
    checksum="$(awk '$2=="aws-auto-approve.rb" {print $1}' "$WORK_DIR/SHA256SUMS")"
    actual="$(sha256sum "$WORK_DIR/aws-auto-approve.rb" | awk '{print $1}')"
    [[ "$checksum" =~ ^[a-f0-9]{64}$ && "$checksum" == "$actual" ]] || error 'Released formula checksum does not match.'
    ruby -c "$WORK_DIR/aws-auto-approve.rb"
    for architecture in arm64 x86_64; do
        grep -Fq "releases/download/$tag/aws-auto-approve-${tag#v}-macos-$architecture.tar.gz\"" "$WORK_DIR/aws-auto-approve.rb" || error 'Formula version does not match the release.'
    done
    if cmp -s Formula/aws-auto-approve.rb "$WORK_DIR/aws-auto-approve.rb"; then info 'The tap already has this release.'; return; fi
    branch="automation/aws-auto-approve-$tag"
    if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
        git fetch origin "$branch"
        git show FETCH_HEAD:Formula/aws-auto-approve.rb >"$WORK_DIR/branch-formula"
        cmp -s "$WORK_DIR/branch-formula" "$WORK_DIR/aws-auto-approve.rb" || error 'Existing branch differs from the verified release formula.'
        enable_merge "$branch"
        return
    fi
    create_signed_update "$tap" "$branch" "$tag"
    printf 'Install the prebuilt AWS Auto Approve %s packages. The formula and its SHA-256 values come from the published release.\n\nThe release checksum was verified before committing. Auto-merge is restricted to this bot-created, single-formula update and waits for the required Formula Syntax check.\n' "$tag" >"$WORK_DIR/pr-body"
    gh pr create --repo "$tap" --base main --head "$branch" --title "chore: update aws-auto-approve to $tag" --body-file "$WORK_DIR/pr-body"
    # Explicit dispatch runs checks for this bot-created branch without a personal token.
    enable_merge "$branch"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then main "$@"; fi
