#!/bin/sh

if xrandr | grep -q "DP-2-1 connected" && xrandr | grep -q "DP-2-2 connected"; then
    if ! xrandr | grep -q "DP-2-3 connected"; then
        # DP-2-1 and DP-2-2 connected, but DP-2-3 not present
        xrandr --output DP-2-1 --auto --left-of DP-2-2 --output DP-2-2 --auto --output eDP-1 --auto --right-of DP-2-2
    else
        # Multiple screens setup with DP-2-3
        xrandr --output DP-2-1 --auto --left-of DP-2-3 --output DP-2-3 --auto --output DP-2-2 --auto --right-of DP-2-3 --output eDP-1 --off # disable laptop screen
    fi
else
    # Auto config
    xrandr --auto
fi

# Set wallpaper on all active monitors
feh --bg-fill "$(find ~/Pictures/wallpapers -type f | shuf -n 1)"
# Launch slstatus in the background
slstatus &
# Add a small delay to ensure everything is set up
sleep 2
# Start dwm
exec dwm
