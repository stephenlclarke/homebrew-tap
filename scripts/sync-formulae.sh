#!/usr/bin/env bash
# USAGE:
#   scripts/sync-formulae.sh [--check] [--update-submodules]
#
# Synchronizes top-level Homebrew formulae from the source repository submodules
# and branch refs. Top-level Formula/*.rb files are required because Homebrew
# does not discover formulae inside nested submodule paths.
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

git submodule update --init sources/container sources/container-compose

if [[ "$update_submodules" -eq 1 ]]; then
    git -C sources/container fetch --quiet origin main develop
    git -C sources/container-compose fetch --quiet origin main develop
fi

render_formula() {
    local repo_path="$1"
    local branch="$2"
    local source_path="$3"
    local target_path="$4"
    local tmp_path

    tmp_path="$(mktemp)"
    git -C "$repo_path" show "origin/$branch:$source_path" > "$tmp_path"

    case "$target_path" in
        Formula/container.rb)
            perl -0pi -e 's/(depends_on macos: :sequoia)\n/$1\n\n  conflicts_with "container-develop", because: "both install the container CLI and service"\n/' "$tmp_path"
            ;;
        Formula/container-develop.rb)
            perl -0pi -e 's/class Container < Formula/class ContainerDevelop < Formula/' "$tmp_path"
            perl -0pi -e 's/(depends_on macos: :sequoia)\n/$1\n\n  conflicts_with "container", because: "both install the container CLI and service"\n/' "$tmp_path"
            ;;
        Formula/container-compose.rb)
            perl -0pi -e 's/(depends_on macos: :sequoia)\n/$1\n\n  conflicts_with "container-compose-develop", because: "both install the container-compose command and compose plugin"\n/' "$tmp_path"
            ;;
        Formula/container-compose-develop.rb)
            perl -0pi -e 's/class ContainerCompose < Formula/class ContainerComposeDevelop < Formula/' "$tmp_path"
            perl -0pi -e 's/depends_on "container"/depends_on "container-develop"/' "$tmp_path"
            perl -0pi -e 's/(depends_on macos: :sequoia)\n/$1\n\n  conflicts_with "container-compose", because: "both install the container-compose command and compose plugin"\n/' "$tmp_path"
            perl -0pi -e 's/Homebrew-installed container CLI/Homebrew-installed develop container CLI/g' "$tmp_path"
            perl -0pi -e "s/container's user plugin directory/container-develop's plugin directory/g" "$tmp_path"
            perl -0pi -e 's/brew --prefix container\)/brew --prefix container-develop\)/g' "$tmp_path"
            perl -0pi -e 's/brew services restart container\b/brew services restart container-develop/g' "$tmp_path"
            ;;
    esac

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
render_formula sources/container main Formula/container.rb Formula/container.rb || status=1
render_formula sources/container develop Formula/container.rb Formula/container-develop.rb || status=1
render_formula sources/container-compose main Formula/container-compose.rb Formula/container-compose.rb || status=1
render_formula sources/container-compose develop Formula/container-compose.rb Formula/container-compose-develop.rb || status=1

exit "$status"
