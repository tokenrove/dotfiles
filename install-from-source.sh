#!/bin/sh
#
# Hand-rolled recipes for some things I almost always build myself on
# my machines.

set -eu

mkdir -p ~/build ~/lib ~/bin
cd ~/build

if which gmake; then MAKE=gmake; else MAKE=make; fi

unless() {
    case "$1" in
        /*) if [ -x "$1" ]; then
                echo "$1 already exists; not building"
                exit 1
            fi;;
        *) unless "$HOME/bin/$1";;
    esac
}

emacs() {
    unless emacs
    if which apt-get; then sudo apt-get -y install libxpm-dev libgif-dev libgnutls28-dev texinfo libgtk2.0-dev; fi
    if [ "$(uname)" = FreeBSD ]; then sudo pkg install cairo; fi
    git clone git://git.savannah.gnu.org/emacs.git ~/build/emacs
    cd ~/build/emacs
    ./autogen.sh
    ./configure --prefix=$HOME/lib/emacs --without-dbus --without-gsettings --without-libsystemd --without-toolkit-scroll-bars --with-cairo
    $MAKE
    $MAKE install
    ln -s ~/lib/emacs/bin/* ~/bin
}

dwm() {
    unless dwm
    if which apt-get; then sudo apt-get -y install libft-dev; fi
    curl -O http://dl.suckless.org/dwm/dwm-6.1.tar.gz
    tar xzf dwm-6.1.tar.gz
    cd dwm-6.1
    cp ~/dotfiles/dwm/config.h .
    make
    make install PREFIX=$HOME/lib/dwm
    ln -s ~/lib/dwm/bin/* ~/bin
}

marelle() {
    unless marelle
    if [ ! -x "$(which swipl)" ]; then
        echo "bailing: need swipl installed; too lazy to get it ourselves."
        exit 1
    fi
    git clone https://github.com/larsyencken/marelle ~/lib/marelle
    cat > ~/bin/marelle <<EOF
#!/bin/bash
exec swipl -q -t main -s ~/lib/marelle/marelle.pl "$@"
EOF
    chmod a+x ~/bin/marelle
}

opam() {
    unless ~/.opam/4.04.0/ocp-indent
    opam init
    opam switch 4.04.0
    opam install merlin ocp-indent
}

otp() {
    if [ "${ERL_TOP:-x}" = x ]; then
        echo "ERL_TOP should be set; your zshenv is probably busted"
        exit 1
    fi
    unless "$ERL_TOP/bin/erl"
    git clone https://github.com/erlang/otp.git
    cd otp
    ./otp_build all
}

rebar3() {
    unless rebar3
    cd ~/bin && wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
}

quicklisp() {
    unless ~/lib/quicklisp
    wget https://beta.quicklisp.org/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp.asc
    gpg --keyserver keys.gnupg.net --verify quicklisp.lisp.asc
    sbcl --non-interactive --load quicklisp.lisp --eval '(quicklisp-quickstart:install :path "~/lib/quicklisp")'
}

if [ $# = 0 ]; then
    echo "Usage: $0 [package to install...]"
    echo
    echo Packages: \
         dwm \
         emacs \
         marelle \
         opam otp \
         quicklisp \
         rebar3
    exit 0
fi

while [ $# -gt 0 ]; do
    ("$1")
    shift
done
