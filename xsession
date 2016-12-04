
HOSTNAME=$(hostname)

if [ $HOSTNAME = temenos ]; then
    xrandr --newmode "1280x1024x60"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync
    xrandr --addmode VGA1 1280x1024x60
    #xrandr --output VGA1 --mode 1280x1024x60 --rotate left
    xrandr --output VGA1 --mode 1280x1024x60
fi

if [ `uname` = DragonFly ]; then
    setxkbmap dvorak -option "ctrl:nocaps,compose:ralt"
fi

xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Enabled' 0

xrdb .Xdefaults

#arbtt-capture &

redshift -l 45.5:-73.56 &

## -grab for xmonad
unclutter -grab &

#xautolock -locker ~/src/mood-tracker/interrogator.tcl -time 10 &

## ibus interacts badly with compose key in emacs or something
XMODIFIERS=@im=none emacs &

if which stterm; then
    stterm -f Inconsolata-22 &
else
    st -f Inconsolata-22 &
fi

dwm
