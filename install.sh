#!/bin/sh

set -e

gh_repo="papirus-mer-icon-theme"
gh_desc="Papirus mer icon theme"

cat <<- EOF



      ppppp                         ii
      pp   pp     aaaaa   ppppp          rr  rrr   uu   uu     sssss
      ppppp     aa   aa   pp   pp   ii   rrrr      uu   uu   ssss
      pp        aa   aa   pp   pp   ii   rr        uu   uu      ssss
      pp          aaaaa   ppppp     ii   rr          uuuuu   sssss
                          pp
                          pp

      |  \/  |___ _ _ __ ___  __| |___  | __|__| (_) |_(_)___ _ _
      | |\/| / -_) '_/ _/ _ \/ _` / -_) | _|/ _` | |  _| / _ \ ' \
      |_|  |_\___|_| \__\___/\__,_\___| |___\__,_|_|\__|_\___/_||_|

  $gh_desc
  https://github.com/mercode-org/$gh_repo


EOF

: "${DESTDIR:=/usr/share/icons}"
: "${TAG:=master}"
: "${THEMES:=Papirus-Mer}"
: "${uninstall:=false}"

_msg() {
    echo "=>" "$@" >&2
}

_rm() {
    # removes parent directories if empty
    _sudo rm -rf "$1"
    _sudo rmdir -p "$(dirname "$1")" 2>/dev/null || true
}

_sudo() {
    if [ -w "$DESTDIR" ] || [ -w "$(dirname "$DESTDIR")" ]; then
        "$@"
    else
        sudo "$@"
    fi
}

_download() {
    _msg "Getting the latest version from GitHub ..."
    wget -O "$temp_file" \
        "https://github.com/mercode-org/$gh_repo/archive/$TAG.tar.gz"
    _msg "Unpacking archive ..."
    tar -xzf "$temp_file" -C "$temp_dir"
}

_uninstall() {
    for theme in "$@"; do
        test -d "$DESTDIR/$theme" || continue
        _msg "Deleting '$theme' ..."
        _rm "$DESTDIR/$theme"
    done
}

_install() {
    _sudo mkdir -p "$DESTDIR"

    for theme in "$@"; do
        test -d "$temp_dir/$gh_repo-$TAG/$theme" || continue
        _msg "Installing '$theme' ..."
        _sudo cp -R "$temp_dir/$gh_repo-$TAG/$theme" "$DESTDIR"
        _sudo cp -f \
            "$temp_dir/$gh_repo-$TAG/AUTHORS" \
            "$temp_dir/$gh_repo-$TAG/LICENSE" \
            "$DESTDIR/$theme" || true
        _sudo gtk-update-icon-cache -q "$DESTDIR/$theme" || true
    done

    # Try to restore the color of folders from a config
    if which papirus-folders > /dev/null 2>&1; then
        papirus-folders -R || true
    fi
}

_cleanup() {
    _msg "Clearing cache ..."
    rm -rf "$temp_file" "$temp_dir"
    rm -f "$HOME/.cache/icon-cache.kcache"
    _msg "Done!"
}

trap _cleanup EXIT HUP INT TERM

temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"

if [ "$uninstall" = "false" ]; then
    _download
    _uninstall $THEMES
    _install $THEMES
else
    _uninstall $THEMES
fi
