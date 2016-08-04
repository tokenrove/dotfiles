#!/bin/sh
#
# Install links to these dotfiles.

set -eu

src=$(realpath $(dirname "$0"))

usage() { echo "$0 [-nf]"; exit 1; }

force=false
nope=false

while [ $# -gt 0 ]; do
    case "$1" in
    -f) force=true; shift;;
    -n) nope=true; shift;;
    *) usage;;
    esac
done

maybe() { if $nope; then echo "$@"; else "$@"; fi; }

ln_args=-sn
if $force; then ln_args=-snf; fi

for i in emacs.d gitconfig screenrc xsession zshrc xmonad mkshrc; do
    maybe ln $ln_args "$src/$i" ~/.$i || echo "Warning: $i not emplaced"
done

maybe ln $ln_args "$src/vendor/xcompose/dotXCompose" ~/.XCompose
