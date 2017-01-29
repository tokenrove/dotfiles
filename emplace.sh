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

if [ "$(uname)" = Linux ]; then   # GNU userland
    reformat() { fmt -u; }
    setaf() { tput setaf "$@"; }
    reset() { tput sgr0; }
else
    reformat() { cat; }
    setaf() { tput AF "$@"; }
    reset() { tput me; }
fi

colored() {
    s=$1; shift
    if "$@"; then setaf 2; else setaf 1; fi ||:
    echo -n "$s "
    reset ||:
}

main() {
    for i in \
        emacs.d \
        ccl-init.lisp \
        gitconfig gitignore \
        mkshrc muttrc \
        sbclrc screenrc signature \
        Xdefaults xsession \
        zshenv zshrc
    do
        colored "$i" maybe ln $ln_args "$src/$i" ~/.$i 2>/dev/null
    done
    colored XCompose maybe ln $ln_args "$src/vendor/xcompose/dotXCompose" ~/.XCompose 2>/dev/null
}

main | reformat
echo
