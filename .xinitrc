#!/bin/sh
# Arrange displays: DP-2-1 on the left, DP-2-2 in the middle, and eDP-1 on the right
# xrandr --output DP-2-1 --auto --left-of DP-2-2 --output DP-2-2 --auto --output eDP-1 --auto --right-of DP-2-2
# xrandr --output DP-2-1 --auto --left-of DP-2-3 --output DP-2-3 --auto --output DP-2-2 --auto --right-of DP-2-3 --output eDP-1 --off
# Set wallpaper on all active monitors
feh --bg-fill "$(find ~/Pictures/wallpapers -type f | shuf -n 1)"
# Launch slstatus in the background
slstatus &
# Add a small delay to ensure everything is set up
sleep 2
# Start dwm
exec dwm
