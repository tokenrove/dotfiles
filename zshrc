#!/usr/bin/zsh
#
# $Id: zshrc,v 1.6 1999/08/13 03:34:27 tek Exp $
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

WATCH='all'

DOMNAME="baddomainname"
if [ -x dnsdomainname 
  -o -x `where dnsdomainname` 
  -o -x ~/bin/dnsdomainname ]; then
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

PAGER=less

case $HOSTNAME in
  distorted) 
  	EMACS=/usr/bin/xemacs20
	alias less=zless
        ;;
  moe) 
	EMACS=/usr/bin/xemacs-20.4-nomule
	;;
  ned) 
	EMACS=/opt/SUNWspro/bin/xemacs-20.4 
	;;
  *) 
	EMACS=/usr/bin/emacs 
	;;
esac  

alias emacs=$EMACS
EDITOR=$EMACS

VISUAL=$EDITOR
CVSEDITOR=$EDITOR
CVSROOT="tek@distorted.wiw.org:/home/tek/cvs"
CVS_RSH="ssh"

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
