#!/usr/bin/env bash
# USAGE: test-aws-release-update.sh - verify the auto-merge boundary without GitHub writes.
set -euo pipefail
unset BASH_ENV ENV
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT
# shellcheck source=scripts/update-aws-auto-approve.sh
source "$ROOT/scripts/update-aws-auto-approve.sh"
TEST_AUTHOR='app/github-actions'
TEST_FILES='Formula/aws-auto-approve.rb'
TEST_HEAD='1111111111111111111111111111111111111111'
TEST_DISPATCH=0
TEST_REVIEW=0
TEST_COMMITS='{"total_commits":1,"commits":[{"commit":{"verification":{"verified":true}}}]}'
AWS_AUTO_APPROVE_REVIEW_TOKEN=fixture-review-token

# Replace only the external GitHub boundary; record any requested mutation.
gh() {
    case "$1 $2" in
        'pr list') printf '7\n' ;;
        'pr view')
            case "${*: -1}" in
                .author.login) printf '%s\n' "$TEST_AUTHOR" ;;
                .headRefOid) printf '%s\n' "$TEST_HEAD" ;;
                .mergeStateStatus) printf 'CLEAN\n' ;;
            esac ;;
        'pr diff') printf '%s\n' "$TEST_FILES" ;;
        'workflow run') printf 'dispatch\n' >>"$TEST_ROOT/calls"; return "$TEST_DISPATCH" ;;
        'pr merge') printf 'merge %s\n' "$*" >>"$TEST_ROOT/calls" ;;
        'pr review') printf 'review\n' >>"$TEST_ROOT/calls"; return "$TEST_REVIEW" ;;
        'api repos/stephenlclarke/homebrew-tap/compare/'*) printf '%s\n' "$TEST_COMMITS" | jq -r "${@: -1}" ;;
        'api repos/stephenlclarke/homebrew-tap/git/ref/heads/main') printf '%s\n' "$TEST_HEAD" ;;
        'api --method') printf 'branch\n' >>"$TEST_ROOT/calls" ;;
        'api graphql') printf 'signed-commit\n' >>"$TEST_ROOT/calls"; printf '2222222222222222222222222222222222222222\n' ;;
        *) printf 'Unexpected GitHub operation\n' >&2; return 9 ;;
    esac
}

# Confirm a proposed update is accepted or rejected at the intended boundary.
check() {
    local expected="$1" status=0
    : >"$TEST_ROOT/calls"
    (enable_merge automation/aws-auto-approve-v0.1.0) >"$TEST_ROOT/output" 2>&1 || status=$?
    [[ "$status" == "$expected" ]]
    if [[ "$expected" == 0 ]]; then
        grep -Fq -- '--auto --squash --match-head-commit 1111111111111111111111111111111111111111' "$TEST_ROOT/calls"
    elif grep -q '^merge ' "$TEST_ROOT/calls"; then
        printf 'Rejected update reached the merge operation\n' >&2
        exit 1
    fi
}

check 0
TEST_AUTHOR=someone-else
check 1
TEST_AUTHOR='app/github-actions'
TEST_FILES=$'Formula/aws-auto-approve.rb\nFormula/unrelated.rb'
check 1
TEST_FILES='Formula/aws-auto-approve.rb'
TEST_HEAD=invalid
check 1
TEST_HEAD='1111111111111111111111111111111111111111'
TEST_DISPATCH=1
check 1
TEST_DISPATCH=0
AWS_AUTO_APPROVE_REVIEW_TOKEN=''
check 1
AWS_AUTO_APPROVE_REVIEW_TOKEN=fixture-review-token
TEST_REVIEW=1
check 1
TEST_REVIEW=0
TEST_COMMITS='{"total_commits":1,"commits":[{"commit":{"verification":{"verified":false}}}]}'
check 1
[[ ! -s "$TEST_ROOT/calls" ]]
TEST_COMMITS='{"total_commits":251,"commits":[{"commit":{"verification":{"verified":true}}}]}'
check 1
[[ ! -s "$TEST_ROOT/calls" ]]
TEST_COMMITS='{"total_commits":2,"commits":[{"commit":{"verification":{"verified":true}}}]}'
check 1
[[ ! -s "$TEST_ROOT/calls" ]]
TEST_COMMITS='{"total_commits":1,"commits":[{"commit":{"verification":{"verified":true}}}]}'
WORK_DIR="$TEST_ROOT/work"
mkdir "$WORK_DIR"
printf 'fixture formula\n' >"$WORK_DIR/aws-auto-approve.rb"
create_signed_update stephenlclarke/homebrew-tap automation/aws-auto-approve-v0.1.0 v0.1.0
jq -e '
    .query | contains("createCommitOnBranch")
' "$WORK_DIR/commit-request.json" >/dev/null
jq -e '
    .variables.input |
    .branch.repositoryNameWithOwner == "stephenlclarke/homebrew-tap" and
    .branch.refName == "automation/aws-auto-approve-v0.1.0" and
    .expectedHeadOid == "1111111111111111111111111111111111111111" and
    .message.headline == "chore: update aws-auto-approve to v0.1.0" and
    (.fileChanges.additions | length) == 1 and
    .fileChanges.additions[0].path == "Formula/aws-auto-approve.rb"
' "$WORK_DIR/commit-request.json" >/dev/null
jq -r '.variables.input.fileChanges.additions[0].contents' "$WORK_DIR/commit-request.json" | base64 --decode >"$TEST_ROOT/decoded-formula"
cmp "$TEST_ROOT/decoded-formula" "$WORK_DIR/aws-auto-approve.rb"
grep -Fxq signed-commit "$TEST_ROOT/calls"
printf 'AWS release auto-merge: 11 checks passed.\n'
