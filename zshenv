#
# Some standard environment kung-fu.
#

PATH=$HOME/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/games:\
/usr/local/games
EDITOR=zile
VISUAL=$EDITOR
IRCSERVER=distorted
IRCNAME=`finger $LOGNAME | head -1 | sed -e 's/^.*Name: //'`
PAGER=less
PS1='%n@%m:%~%# '
NETHACKOPTIONS="!autopickup,lit_corridor,!null,\
standout,showexp,showscore,color,hilite_pet,menustyle:Full"

NNTPSERVER="whimper"
LS_OPTIONS="-F"
CVSEDITOR=$EDITOR
CVS_RSH="ssh"

export PATH EDITOR VISUAL IRCSERVER IRCNAME PAGER PS1 NETHACKOPTIONS
export NNTPSERVER LS_OPTIONS CVSEDITOR CVS_RSH
