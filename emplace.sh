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

decolor="$(tput sgr0)"
to_color() { if "$@"; then tput setaf 2; else tput setaf 1; fi; }

for i in \
        emacs.d \
        ccl-init.lisp \
        gitconfig gitignore \
        mkshrc muttrc \
        sbclrc screenrc signature \
        Xdefaults xsession \
        zshenv zshrc
do
    color=$(to_color maybe ln $ln_args "$src/$i" ~/.$i 2>/dev/null)
    printf "${color}%s${decolor} " "$i"
done | fmt

color=$(to_color maybe ln $ln_args "$src/vendor/xcompose/dotXCompose" ~/.XCompose 2>/dev/null)
printf "${color}%s${decolor} " XCompose
echo
