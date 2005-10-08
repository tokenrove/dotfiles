#!/usr/bin/zsh
#
# $Id: zshrc,v 1.16 1999/12/07 19:45:27 tek Exp $
#

export SBCL_HOME=~/sbcl/lib/sbcl

export PATH=~/bin:~/sbcl/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
# The irony is that whereis, hostname, etc are all in /usr/bsd on iris, so
# we can't just set this in the case below.
export PATH=$PATH:/usr/bsd:/usr/etc:/etc:/cross/bin:/usr/X11R6/bin
export PATH=$PATH:/usr/local/cm3/bin

WATCH='all'
HOSTNAME=`hostname -s || hostname`
EMAILADDRESS=julian@cipht.net
#MAIL="$HOME/Mail/inbox"

case $HOSTNAME in
  distorted) 
  	EMACS=`where xemacs`
        export PORTSDIR=/usr/ports
	export BSDSRCDIR=/usr/src
        export PATH=$PATH:/usr/X11R6/bin:/usr/local/pgsql/bin:/mu/cross/bin
        export PATH=$PATH:/usr/games:/usr/local/games
        ;;
  iris)
        # make ^C and backspace not Suck
        stty intr '^C' echoe
        ;;
  codec)
	export PATH=$PATH:/usr/pkg/bin
        ;;
  wolfsbane)
	export PATH=$PATH:/cross/bin:/rhomb/bin
	CVSROOT=/rhomb/cvs
	MAIL=/var/mail/tek
	;;
  *) 
        if [ -x `where xemacs` ]; then
          EMACS=`where xemacs`
	elif [ -x `where zile` ]; then
          EMACS=`where zile`
        else
	  EMACS=`where emacs`
        fi
        CVSROOT=/home/tek/cvs
	;;
esac

CVS_RSH="ssh"

FULLNAME="Julian E. C. Squires"
export EDITOR=vim
export VISUAL=$EDITOR
export CVSEDITOR=$EDITOR
export XEDITOR='gvim --remote +:%l:norm%c| %f'

#export LILYPONDPREFIX=/home/tek/share/lilypond/1.8.0.cvs1

export WATCH CVSROOT CVS_RSH EMAILADDRESS FULLNAME VISUAL MAIL

setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN EXTENDED_GLOB
# I like emacs keys even though I use vi by default
bindkey -e

# completions.
autoload -U compinit; compinit

function dmalloc { eval `command dmalloc -b $*` }

# Aliases
alias ls='ls --color=auto -F'
alias sp='sidplay -16 -f44100 -ss'
alias x='xemacs -nw'
alias j='jobs -ld'
alias n='noose -q check'
alias slrntz='slrn -h news.thezone.net -f .newsrc.thezone'
alias u='cvs -q update -Pd'
alias uv='cvs -q update -Pd | grep -v \?'
alias d='i=`mktemp /tmp/tekcvs.XXXXXX` && cvs diff -u $1 $2 $3 $4 $5 $6 > $i; vim -R $i && rm $i && echo'
alias c='cook --par=4'
alias lisp='sbcl --linedit'

if [ X"`where ledit`" != X ]; then
    alias bc='ledit bc'
    alias ocaml='ledit ocaml'
fi

ulimit -c unlimited

alias l='xlock -mode ifs -erasemode venetian'
alias tim="timidity -Os -a -p 256 -s 44100 -EFreverb=2 \
           -L /usr/share/timidity/patches -c gravis.cfg"

alias irssi="echo you don\'t really want to go on irc."

alias atermsh="aterm -rv +sb -tr -sh 50 -fade 50"


# EOF zshrc
