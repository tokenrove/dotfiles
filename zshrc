#!/usr/bin/zsh
#
# $Id: zshrc,v 1.16 1999/12/07 19:45:27 tek Exp $
#

WATCH='all'
HOSTNAME=`hostname`
EMAILADDRESS=tek@wiw.org

export PATH=$PATH:/usr/X11R6/bin:/usr/local/pgsql/bin:/mu/cross

case $HOSTNAME in
  distorted) 
  	EMACS=`where xemacs`
        export PORTSDIR=/usr/ports
	export BSDSRCDIR=/usr/src
        alias n='noose -q check'
#	alias less=zless
        ;;
  *) 
        if [ -x `where zile` ]; then
          EMACS=`where zile`
	elif [ -x `where xemacs` ]; then
          EMACS=`where xemacs`
        else
	  EMACS=/usr/bin/emacs 
        fi
	;;
esac

CVSROOT="tek@distorted.wiw.org:/home/tek/cvs"
CVS_RSH="ssh"

FULLNAME="Julian E. C. Squires"
MAIL="$HOME/Mail/inbox"

export WATCH CVSROOT CVS_RSH EMAILADDRESS FULLNAME VISUAL MAIL

setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN

# Aliases
alias ls='ls $LS_OPTIONS'
alias newscreen='ssh-agent screen'
alias wterm='wterm -tr -sb'

#alias x='startx -- -bpp 16'
if [ `uname` = "Linux" ]; then
  alias root='su -c sh'
fi
#alias info='emacs -f info'
alias j=jobs

function dmalloc { eval `command dmalloc -b $*` }

alias sp='sidplay -16 -f44100 -ss'
alias x='xemacs -nw'

# EOF zshrc
