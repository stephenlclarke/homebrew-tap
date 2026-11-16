#!/usr/bin/env bash
# USAGE: test-aws-release-update.sh - verify the auto-merge boundary without GitHub writes.
set -euo pipefail
unset BASH_ENV ENV
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT
# shellcheck source=scripts/update-aws-auto-approve.sh
source "$ROOT/scripts/update-aws-auto-approve.sh"
TEST_AUTHOR='github-actions[bot]'
TEST_FILES='Formula/aws-auto-approve.rb'
TEST_HEAD='1111111111111111111111111111111111111111'
TEST_DISPATCH=0
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
        'pr review') printf 'review\n' >>"$TEST_ROOT/calls" ;;
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
TEST_AUTHOR='github-actions[bot]'
TEST_FILES=$'Formula/aws-auto-approve.rb\nFormula/unrelated.rb'
check 1
TEST_FILES='Formula/aws-auto-approve.rb'
TEST_HEAD=invalid
check 1
TEST_HEAD='1111111111111111111111111111111111111111'
TEST_DISPATCH=1
check 1
printf 'AWS release auto-merge: 5 checks passed.\n'
