#!/usr/bin/env bash
# Build Greenleaf's own packages and the AUR packages in packages/aur.list into a local
# pacman repo at build/repo/x86_64 (database: greenleaf.db).
#
# Usage: tools/build-repo.sh            build everything
#        tools/build-repo.sh NAME...    build only these packages (local or AUR)
#
# Run as your normal user. makepkg asks for sudo when it needs to install build dependencies.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
build=$root/build
repo=$build/repo/x86_64
db=$repo/greenleaf.db.tar.zst
export PKGDEST=$build/pkgdest SRCDEST=$build/sources BUILDDIR=$build/work

local_pkgs=(dmenu-greenleaf st-greenleaf dwm-greenleaf dwmblocks-greenleaf greenleaf-base)
mapfile -t aur_pkgs < <(grep -vE '^\s*(#|$)' "$root/packages/aur.list")

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
say() { printf '\n==> %s\n' "$*"; }

[[ $EUID -ne 0 ]] || die "run as your normal user, not root"
for cmd in git makepkg repo-add; do
    command -v "$cmd" >/dev/null || die "missing '$cmd' (install base-devel and git)"
done
mkdir -p "$repo" "$PKGDEST" "$SRCDEST" "$BUILDDIR" "$build/aur"

wanted=("$@")
is_wanted() { [[ ${#wanted[@]} -eq 0 ]] || printf '%s\n' "${wanted[@]}" | grep -qxF "$1"; }

add_to_repo() {
    local pkgs=()
    mapfile -t pkgs < <(find "$PKGDEST" -maxdepth 1 -name '*.pkg.tar.zst' ! -name '*-debug-*')
    [[ ${#pkgs[@]} -gt 0 ]] || return 0
    mv -f -- "${pkgs[@]}" "$repo/"
    find "$PKGDEST" -maxdepth 1 -name '*-debug-*.pkg.tar.zst' -delete
    (cd "$repo" && repo-add --new --remove "$db" "${pkgs[@]##*/}")
}

build_local() {
    local name=$1 dir=$root/packages/$1
    say "Building $name"
    if [[ $name == greenleaf-base ]]; then
        rm -rf "$dir/wallpapers"
        mkdir -p "$dir/wallpapers"
        find "$root/wallpapers" -maxdepth 1 -type f ! -name 'README.md' -exec cp -t "$dir/wallpapers" {} +
        # Depends on the other Greenleaf packages, which live in our repo, not the system's.
        (cd "$dir" && makepkg --nodeps --cleanbuild --clean --force)
    else
        (cd "$dir" && makepkg --syncdeps --cleanbuild --clean --force --needed)
    fi
    add_to_repo
}

build_aur() {
    local name=$1 dir=$build/aur/$1 reviewed head answer
    say "AUR: $name"
    if [[ -d $dir/.git ]]; then
        git -C "$dir" pull --ff-only --quiet
    else
        git clone --quiet "https://aur.archlinux.org/$name.git" "$dir"
    fi
    head=$(git -C "$dir" rev-parse HEAD)
    reviewed=$(cat "$dir/.git/greenleaf-reviewed" 2>/dev/null || true)
    if [[ $head != "$reviewed" ]]; then
        if [[ -n $reviewed ]]; then
            git -C "$dir" --no-pager diff "$reviewed" "$head"
        else
            git -C "$dir" --no-pager show "$head:PKGBUILD"
        fi
        read -r -p "Review the PKGBUILD above. Build $name? [y/N] " answer
        [[ $answer == [yY]* ]] || { echo "Skipped $name."; return 0; }
        echo "$head" > "$dir/.git/greenleaf-reviewed"
    fi
    (cd "$dir" && makepkg --syncdeps --cleanbuild --clean --force --needed)
    add_to_repo
}

for p in "${local_pkgs[@]}"; do is_wanted "$p" && build_local "$p"; done
for p in "${aur_pkgs[@]}";   do is_wanted "$p" && build_aur "$p"; done

say "Repo ready: $repo"
ls -1 "$repo"/*.pkg.tar.zst 2>/dev/null | sed 's|.*/|  |'
