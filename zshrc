#HOME=/home/tek
NETHACKOPTIONS="!autopickup,IBMgraphics,lit_corridor,!null,\
standout,showexp,showscore,color,hilite_pet,menustyle:Full,name:Teknovore"
PATH=/usr/bin:/bin:/usr/local/bin:/usr/sbin:/sbin:/usr/local/sbin\
:/usr/X11R6/bin:/usr/games:/usr/local/netscape:$HOME/bin
PS1='%n@%m:%~%# '
PS2='%n@%m> '
PS3='%n@%m>> '
PS4='%n@%m>>> '
LS_OPTIONS=(-F --color=tty)
EDITOR='/usr/bin/xemacs20'
VISUAL=$EDITOR
CVSEDITOR=$EDITOR
PAGER='less'
WATCH='all'
CVSROOT="$HOME/cvs"
CVS_RSH="ssh"

if [ `dnsdomainname` = "mu.shrooms.com" -o `dnsdomainname` = "wiw.org" ]
then
  EMAILADDRESS=tek@wiw.org
else
  EMAILADDRESS=js@ooc.com
fi

FULLNAME="Julian E. C. Squires"
MAIL="$HOME/Mail/inbox"
export NETHACKOPTIONS PATH PS1 PS2 PS3 PS4 LS_OPTIONS HOME EDITOR PAGER
export WATCH CVSROOT CVS_RSH EMAILADDRESS FULLNAME VISUAL MAIL
setopt AUTO_MENU NO_BEEP NO_BAD_PATTERN

# Aliases
alias ls='ls $LS_OPTIONS'

if [ -x xemacs20 ]; then
  alias emacs='xemacs20'
else
  alias emacs='emacs -nw'
fi

#alias x='startx -- -bpp 16'
alias root='su -c bash'
alias info='emacs -f info'

if [ ! -f /etc/redhat.release ]; then
  alias less='zless'
fi

#function dmalloc { eval `command dmalloc -b $*` }
alias sp='sidplay -16 -f44100 -ss'

cat ~/.todo
