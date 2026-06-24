#!/usr/bin/env bash
# USAGE:
#   scripts/sync-formulae.sh [--check] [--update-submodules]
#
# Synchronizes top-level Homebrew formulae from the source repository submodules.
# Top-level Formula/*.rb files are required because Homebrew does not discover
# formulae inside nested submodule paths.
#
# Options:
#   --check              verify synchronized formulae without writing files
#   --update-submodules  update submodules from their configured branches first
#   -h, --help           show this help

set -euo pipefail

readonly SELF_PATH="${BASH_SOURCE[0]:-$0}"
SCRIPT_NAME="$(basename "$SELF_PATH")"
readonly SCRIPT_NAME

check=0
update_submodules=0

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
        --update-submodules)
            update_submodules=1
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

if [[ "$update_submodules" -eq 1 ]]; then
    git submodule update --init --remote sources/container sources/container-compose
else
    git submodule update --init sources/container sources/container-compose
fi

formula_pairs=(
    "sources/container/Formula/container.rb:Formula/container.rb"
    "sources/container-compose/Formula/container-compose.rb:Formula/container-compose.rb"
)

status=0
for pair in "${formula_pairs[@]}"; do
    source_path="${pair%%:*}"
    target_path="${pair#*:}"

    [[ -f "$source_path" ]] || error "missing source formula: $source_path"

    if [[ "$check" -eq 1 ]]; then
        if [[ ! -f "$target_path" ]]; then
            printf 'missing synchronized formula: %s\n' "$target_path" >&2
            status=1
            continue
        fi
        if ! diff -u "$source_path" "$target_path"; then
            status=1
        fi
    else
        mkdir -p "$(dirname "$target_path")"
        cp "$source_path" "$target_path"
        printf 'synced %s from %s\n' "$target_path" "$source_path"
    fi
done

exit "$status"
