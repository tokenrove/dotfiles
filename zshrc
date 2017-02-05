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
source ~/.zshpath

if [ "$(uname)" = FreeBSD -a "$TERM" = st-256color ]; then
    TERM=xterm-256color
fi

export GPG_TTY=$(tty)

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

function my-git-clones() {
    # we could use -execdir pwd instead, but it's not posix.
    find ~/src ~/work ~/doc ~/edu ~/web ~/mus \
         -name .git -prune -exec dirname '{}' ';' 2>/dev/null
}

function dirty-trees() {
    for i in $(my-git-clones); do
        [ -n "$(git -C $i diff --shortstat 2>/dev/null | tail -1)" ] && echo "$i"
    done
}

function unpushed-commits() {
    for i in $(my-git-clones); do
        [ -n "$(git -C $i log --branches --not --remotes --exit-code 2>/dev/null | tail -1)" ] && echo "$i"
    done
}

function changes-today() {
    local plus=0; local minus=0;
    for i in $(my-git-clones); do
        # remove HEAD to include unstaged changes; might be a better
        # way to present both.
        git -C $i diff --shortstat HEAD '@{yesterday}' 2>/dev/null | cut -d' ' -f 5,7 |
            if read inserts deletes; then
                if [ "$1" = "-v" ]; then
                    echo $(basename $i) ${inserts:-0} ${deletes:-0}
                fi
                plus=$(expr $plus + ${inserts:-0})
                minus=$(expr $minus + ${deletes:-0})
            fi
    done
    echo "+$plus -$minus"
}
