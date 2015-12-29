#!/usr/bin/bash

# Setup Monitors
if xrandr | grep '^DP1 connected' | grep -q -v "3840x2160" ; then
    # DELL P2415Q
    xrandr --dpi 216 --output DP1 --auto --output eDP1 --off
    dispwin -d1 ~/.config/colors/desktop.icc
    xrdb -merge ~/.Xresources
    echo 'Xft.dpi: 216' | xrdb -merge
else
    # Internal Monitor
    # Dell XPS 9343 1920x1080 13.3" 
    xrandr --dpi 144 --output eDP1 --auto --output DP1 --off
    dispwin ~/.config/colors/laptop.icc
    xrdb -merge ~/.Xresources
fi
 
# enable ctrl-alt-backspace
setxkbmap -option terminate:ctrl_alt_bksp
# Setup keyboard
xmodmap ~/.Xmodmap
killall xcape
xcape -e 'Control_R=Escape;Super_R=Tab'

# Resize i3 bar
i3-msg restart

# Fix wallpaper
nitrogen --restore

# reconnect to tmux sessions in order to fix dpi issues with different monitors
for session in $(tmux list-sessions | cut -d":" -f1); do
    tmux detach-client -s "$session"
    sleep .5
    termite -e "tmux -2 attach-session -t $session" &
done
