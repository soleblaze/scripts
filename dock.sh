#!/usr/bin/bash

# Setup Monitors
if [ "$(xrandr | grep '^DP1 connected' | grep -v "2560x1440")" ] ; then
    # DPI for this monitor is actually 109, but that makes the fonts too small
#    xrandr --output LVDS1 --off
    xrandr --dpi 125 --output DP1 --auto --output eDP1 --off
    dispwin -d1 ~/.config/colors/desktop.icc
    xrdb -merge ~/.Xresources
    echo 'Xft.dpi: 145' | xrdb -merge
else
    # Internal Monitor
#    xrandr --output DP3 --off
    xrandr --dpi 125 --output eDP1 --auto --output DP1 --off
    dispwin ~/.config/colors/laptop.icc
    xrdb -merge ~/.Xresources
fi
 
# enable ctrl-alt-backspace
setxkbmap -option terminate:ctrl_alt_bksp
# Setup keyboard
xmodmap ~/.Xmodmap
xcape -e 'Control_R=Escape'

# Fix wallpaper
feh --bg-fill ~/.config/awesome/images/wallpaper.png

# reconnect to tmux sessions in order to fix dpi issues with different monitors
for session in $(tmux list-sessions | cut -d":" -f1); do
    tmux detach-client -s $session
    sleep .5
    urxvt -e tmux -2 attach-session -t $session &
done
