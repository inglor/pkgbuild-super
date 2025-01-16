#!/bin/bash

# shellcheck source=/dev/null
source "$HOME/.config/pacman/makepkg.conf"
source /usr/share/makepkg/integrity/verify_signature.sh
source /usr/share/makepkg/util/message.sh
colorize

ignored_pkg=("linux-prjc" "intellij-idea-ce-eap" "intellij-idea-ue-eap")

rebuild_package() {
  msg2 "Rebuilding package '$1' ..."
  pushd "$1" > /dev/null || exit
  nice pkgctl build --repo extra --arch x86_64
	msg2 "Package $1 built"
  arch-repo-release.sh -p
  popd || exit
}

for p in $(find . -type f \( -iname "PKGBUILD" \)  -printf %h\\0 | xargs -0 -I "{}" sh -c 'printf "{}\t" | sed 's/..//' '); do
  if [[ ! " ${ignored_pkg[*]} " =~ ${p} ]]; then
    rebuild_package "$p"
  fi
done
arch-repo-release.sh -u
