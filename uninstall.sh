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

echo "=> Removing $gh_desc ..."
for i in Papirus-Mer; do
  rm -rf "$HOME/.icons/$i"
  rm -rf "$HOME/.local/share/icons/$i"
  sudo rm -rf "/usr/local/share/icons/$i"
  sudo rm -rf "/usr/share/icons/$i"
done

echo "=> Done!/Tamam!"
