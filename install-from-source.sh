#!/bin/sh

set -eu

mkdir -p ~/build ~/lib ~/bin
cd ~/build

# emacs 25
{
    if which apt-get; then sudo apt-get -y install libxpm-dev libgif-dev libgnutls28-dev texinfo libgtk2.0-dev; fi
    git clone git://git.savannah.gnu.org/emacs.git ~/build/emacs
    cd ~/build/emacs
    ./autogen.sh
    ./configure --prefix=$HOME/lib/emacs --without-dbus --without-gsettings --without-libsystemd --without-toolkit-scroll-bars --with-cairo
    make
    make install
    ln -s ~/lib/emacs/bin/* ~/bin
}

# dwm
{
    if which apt-get; then sudo apt-get -y install libft-dev; fi
    curl -O http://dl.suckless.org/dwm/dwm-6.1.tar.gz
    tar xzf dwm-6.1.tar.gz
    cd dwm-6.1
    cp ~/dotfiles/dwm/config.h .
    make
    make install PREFIX=$HOME/lib/dwm
    ln -s ~/lib/dwm/bin/* ~/bin
}

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
    opam init
    opam switch 4.03.0
    opam install merlin
}

# apl, jlang{
