# -*- shell-script -*-

# Lines configured by zsh-newuser-install
unset HISTFILE
HISTSIZE=10000
SAVEHIST=0
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/julian/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz vcs_info

zstyle ':vcs_info:*' formats '[%b%c%u]'
precmd () { vcs_info }
PS1='%B%(?..%F{red}%?%f )%F{black}%n@%m:%3~ %f%b%F{cyan}${vcs_info_msg_0_}%f%F{yellow}%#%f '
zstyle ':vcs_info:*' enable git
setopt promptsubst

unset RPROMPT                   # nix sets this by default!

unsetopt FLOWCONTROL            # let me use ^S
unsetopt CASE_GLOB

alias ls="ls -F"

# Note http://www.zsh.org/mla/users/2003/msg00600.html
export PATH=$PATH:~/bin

if [ "$(uname)" = FreeBSD -a "$TERM" = st-256color ]; then
    TERM=xterm-256color
fi

export GPG_TTY=$(tty)

# interactive shell path additions can follow:

if [ -d ~/lib/android-sdk-linux/tools ]; then
    export PATH=$PATH:~/lib/android-sdk-linux/tools
fi

maybe_source() { [ -r "$1" ] && source "$1" }

maybe_source $HOME/.opam/opam-init/init.zsh
maybe_source $HOME/.cargo/env
maybe_source $HOME/.travis/travis.sh
maybe_source $HOME/.secrets.sh

#### COMPLETION

if [ -r ~/work/salt/pillars/servers.sls ]; then
    # complete hosts from salt
    zstyle ':completion:*:ssh:*' hosts $(awk '/new_name/ { print $2 } ' ~/work/salt/pillars/servers.sls)
    zstyle ':completion:*:scp:*' hosts $(awk '/new_name/ { print $2 } ' ~/work/salt/pillars/servers.sls)
fi

#### FUNCTIONS

function perf-mode() {
    sudo cpupower -c all frequency-set -g performance &&
        sudo cpupower -c all set -b 0
}

function powersave-mode() {
    sudo cpupower -c all frequency-set -g powersave &&
        sudo cpupower -c all set -b 15
}

function fuck-rebar() {
    if [ -d ~/.cache/rebar3/hex ]; then rm -r ~/.cache/rebar3/hex; fi
    # Beware, this could delete your unstaged work; consider just
    # blowing away _build instead.
    git clean -xdf | awk '/Skipping/ { print $3 }' | xargs -r rm -r
}
