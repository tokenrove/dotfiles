#!/bin/sh

set -eu

mkdir -p ~/build ~/lib ~/bin

# emacs 25
echo installing emacs from git
{
    sudo apt-get -y install libxpm-dev libgif-dev libgnutls-dev
    git clone git://git.savannah.gnu.org/emacs.git ~/build/emacs
    cd ~/build/emacs
    ./autogen.sh
    ./configure --prefix=$HOME/lib/emacs --without-dbus --without-gsettings --without-libsystemd --without-toolkit-scroll-bars --with-cairo
    make
    make install
    ln -s ~/lib/emacs/bin/* ~/bin
}

# sbcl

# marelle
{
    git clone https://github.com/larsyencken/marelle ~/lib/marelle
    cat > ~/bin/marelle <<EOF
#!/bin/bash
exec swipl -q -t main -s ~/lib/marelle/marelle.pl "$@"
EOF
    chmod a+x ~/bin/marelle
}

# opam
{
    opam switch 4.03.0
    opam install merlin
}
