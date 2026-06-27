#!/usr/bin/env bash
# USAGE:
#   scripts/sync-formulae.sh [--check]
#
# Synchronizes top-level Homebrew formulae that are still mirrored from source
# repository submodules. Container and container-compose prebuilt formulae are
# updated directly by their branch package workflows instead.
#
# Options:
#   --check              verify synchronized formulae without writing files
#   -h, --help           show this help

set -euo pipefail

readonly SELF_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_NAME="$(basename "$SELF_PATH")"
readonly SCRIPT_NAME

check=0

usage() {
    sed -n '2,13p' "$SELF_PATH" | sed 's/^# \{0,1\}//'
}

error() {
    printf '%s: %s\n' "$SCRIPT_NAME" "$*" >&2
    exit 2
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)
            check=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            error "unknown argument: $1"
            ;;
    esac
    shift
done

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

render_formula() {
    local repo_path="$1"
    local branch="$2"
    local source_path="$3"
    local target_path="$4"
    local tmp_path

    tmp_path="$(mktemp)"
    git -C "$repo_path" show "origin/$branch:$source_path" > "$tmp_path"

    if [[ "$check" -eq 1 ]]; then
        if [[ ! -f "$target_path" ]]; then
            printf 'missing synchronized formula: %s\n' "$target_path" >&2
            rm -f "$tmp_path"
            return 1
        fi
        diff -u "$tmp_path" "$target_path"
    else
        mkdir -p "$(dirname "$target_path")"
        cp "$tmp_path" "$target_path"
        printf 'synced %s from %s:%s:%s\n' "$target_path" "$repo_path" "$branch" "$source_path"
    fi

    rm -f "$tmp_path"
}

status=0

exit "$status"
