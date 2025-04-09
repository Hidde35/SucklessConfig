#!/bin/sh
# Arrange displays: DP-2-1 on the left, DP-2-2 in the middle, and eDP-1 on the right
xrandr --output DP-2-1 --auto --left-of DP-2-2 --output DP-2-2 --auto --output eDP-1 --auto --right-of DP-2-2
# Set wallpaper on all monitors
# feh --bg-fill "$(find ~/Pictures/wallpapers -type f | shuf -n 1)"
feh --bg-fill ~/Pictures/wallpapers/new_zealand_picton.jpg
# Launch slstatus in the background
slstatus &
# Add a small delay to ensure everything is set up
sleep 2
# Start dwm
exec dwm
