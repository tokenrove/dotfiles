#!/usr/bin/zsh
#
# $Id: zshrc,v 1.5 1999/08/11 18:28:48 tek Exp $
#

NETHACKOPTIONS="!autopickup,IBMgraphics,lit_corridor,!null,\
standout,showexp,showscore,color,hilite_pet,menustyle:Full,name:Teknovore"


PS1='%n@%m:%~%# '
PS2='%n@%m> '
PS3='%n@%m>> '
PS4='%n@%m>>> '

PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin

if [ `uname` = "SunOS" ]; then
  LS_OPTIONS=-F
  PATH=$PATH:/usr/X/bin:/usr/ucb:/opt/SUNWspro/bin:/usr/ccs/bin
else
  LS_OPTIONS=(-F --color=tty)
  PATH=$PATH:/usr/X11R6/bin:/usr/games:/usr/local/netscape
fi

alias emacs='xemacs20'
EDITOR='xemacs20 -nw'

VISUAL=$EDITOR
CVSEDITOR=$EDITOR
CVSROOT="tek@distorted.wiw.org:/home/tek/cvs"
CVS_RSH="ssh"

PAGER='less'
WATCH='all'

if [ -x dnsdomainname ]; then
  DOMNAME=`dnsdomainname`
else
  DOMNAME=`domainname`
fi

if [ $DOMNAME = "mu.shrooms.com" -o $DOMNAME = "wiw.org" ]
then
  EMAILADDRESS=tek@wiw.org
else
  EMAILADDRESS=js@ooc.com
fi

NNTPSERVER="news.thezone.net"
FULLNAME="Julian E. C. Squires"
MAIL="$HOME/Mail/inbox"

export NETHACKOPTIONS PATH PS1 PS2 PS3 PS4 LS_OPTIONS HOME EDITOR PAGER
export WATCH CVSROOT CVS_RSH EMAILADDRESS FULLNAME VISUAL MAIL

setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN

# Aliases
alias ls='ls $LS_OPTIONS'

#alias x='startx -- -bpp 16'
alias root='su -c sh'
alias info='emacs -f info'

#function dmalloc { eval `command dmalloc -b $*` }

alias sp='sidplay -16 -f44100 -ss'

cat ~/.todo

# EOF zshrc
