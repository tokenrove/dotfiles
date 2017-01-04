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

alias ls="ls -F"

# Note http://www.zsh.org/mla/users/2003/msg00600.html
export PATH=$PATH:~/bin

# interactive shell path additions can follow:

if [ -d ~/lib/android-sdk-linux/tools ]; then
    export PATH=$PATH:~/lib/android-sdk-linux/tools
fi

maybe_source() { if [ -e "$1" ]; then source "$1"; fi; }

maybe_source $HOME/.opam/opam-init/init.zsh
maybe_source $HOME/.cargo/env
