#!/bin/bash

# Find Firefox window
window=$(wmctrl -l | grep -i "firefox" | head -n 1 | awk '{print $1}')

if [ -z "$window" ]; then
    # If no Firefox window is found, launch Firefox
    firefox &
    exit 0
fi

# Check if the window is minimized
is_minimized=$(xprop -id "$window" | grep -c "window state: Iconic")

if [ "$is_minimized" -eq 1 ]; then
    # Restore (unminimize) the window
    wmctrl -i -a "$window"
else
    # Minimize the window
    xdotool windowminimize "$window"
fi
