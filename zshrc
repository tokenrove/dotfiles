# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/julian/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

VISUAL=emacsclient
export VISUAL

autoload -Uz vcs_info

zstyle ':vcs_info:*' formats '[%b%c%u]'
precmd () { vcs_info }
#PS1='%B%F{black}%! %n@%m:%3~ %U${vcs_info_msg_0_}%u%#%f%b '
PS1='%B%F{black}%! %n@%m:%3~ %f%b%F{cyan}${vcs_info_msg_0_}%f%F{yellow}%#%f '
#PS1='%! %n@%m:%3~ %U${vcs_info_msg_0_}%u%# '
zstyle ':vcs_info:*' enable git
setopt promptsubst

alias ls="ls -F"

# OPAM configuration
. /home/julian/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH=$PATH:~/bin

export ANDROID_HOME=~/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
