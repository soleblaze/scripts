#!/usr/bin/bash

# Setup Monitors
if [ "$(xrandr | grep 'DP3 connected' | grep -v "2560x1440")" ] ; then
    # DPI for this monitor is actually 109, but that makes the fonts too small
#    xrandr --output LVDS1 --off
    xrandr --dpi 125 --output DP3 --auto --output LVDS1 --off
    dispwin -d1 ~/.config/colors/desktop.icc
    xrdb -merge ~/.Xresources27
else
    # Internal Monitor
#    xrandr --output DP3 --off
    xrandr --dpi 125 --output LVDS1 --auto --output DP3 --off
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
