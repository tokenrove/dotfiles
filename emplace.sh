#!/bin/sh
#
# Install links to these dotfiles.

set -eu

src=$(dirname "$0")

for i in emacs.d gitconfig screenrc xsession zshrc xmonad; do
    ln -s "$src/$i" ~/.$i
done

ln -s "$src/vendor/xcompose/dotXCompose" ~/.XCompose
