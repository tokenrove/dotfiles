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
    git submodule update --init --recursive
    mkdir -p ~/.emacs.d
    for i in \
        emacs.d/init.el emacs.d/init-org.el emacs.d/site-lisp \
        ccl-init.lisp \
        dictrc \
        gitconfig gitignore \
        mkshrc muttrc \
        nixpkgs \
        sbclrc screenrc signature \
        Xdefaults xsession Xmodmap.modelm \
        zshenv zshpath zshrc
    do
        colored "$i" maybe ln $ln_args "$src/$i" ~/.$i 2>/dev/null
    done
    mkdir -p ~/.config/common-lisp/source-registry.conf.d/
    colored asdf.conf maybe ln $ln_args "$src/asdf.conf" ~/.config/common-lisp/source-registry.conf.d/50-local.conf 2>/dev/null
    colored XCompose maybe ln $ln_args "$src/vendor/xcompose/dotXCompose" ~/.XCompose 2>/dev/null
}

main | reformat
echo
