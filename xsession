#!/bin/sh

if [ -z "$__run_with_own_shell" ]; then
    __run_with_own_shell=1 exec "$SHELL" "$0" "$@"
fi

PATH=$HOME/bin:$PATH

HOSTNAME=$(hostname)

if [ $HOSTNAME = temenos ]; then
    xrandr --newmode "1280x1024x60"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync
    xrandr --addmode VGA1 1280x1024x60
    #xrandr --output VGA1 --mode 1280x1024x60 --rotate left
    xrandr --output VGA1 --mode 1280x1024x60
fi

if [ $(uname) = DragonFly -o $(uname) = FreeBSD ]; then
    setxkbmap -layout dvorak,apl -option "ctrl:nocaps,compose:ralt,grp:menu_toggle"
    eval $(ssh-agent)
fi

xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Enabled' 0

if [ "$HOSTNAME" = mobcap ]; then
   xinput set-prop bcm5974 'Trackpad Thumb Detection' 1 1
   xinput set-prop bcm5974 'Trackpad Palm Detection' 1 1
   xinput set-prop bcm5974 'Trackpad Tap Button Emulation' 0 3 2 0
fi

xrdb .Xdefaults

#arbtt-capture &

xwrits &

redshift -l 45.5:-73.56 &

## -grab for xmonad
unclutter -grab -keystroke &

#xautolock -locker ~/src/mood-tracker/interrogator.tcl -time 10 &

## ibus interacts badly with compose key in emacs or something
XMODIFIERS=@im=none emacs &

if [ -z "${XMODIFIERS+x}" ]; then
   export GTK_IM_MODULE='uim'
   export QT_IM_MODULE='uim'
   uim-xim &
   export XMODIFIERS='@im=uim'
fi

if which stterm; then
    stterm -f Inconsolata-18 &
else
    st -f Inconsolata-18 &
fi

exec dwm
