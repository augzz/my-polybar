#!/bin/bash

###
# Check for an open terminal window.
# Restore it if minimized, minimize it if active or restored.
# Launch a new terminal if none exists.
# Handle multiple terminal windows by focusing on one (or cycling through them).
###

# Specify your terminal emulator (e.g., gnome-terminal, xfce4-terminal, alacritty)
terminal="gnome-terminal"

# Find terminal windows (case-insensitive)
mapfile -t WINDOWS < <(wmctrl -l -x | grep -i "$terminal" | awk '{print $1}')

if [ ${#WINDOWS[@]} -eq 0 ]; then
    # No terminal windows found, launch a new one
    $terminal &
    exit 0
fi

# If only one terminal window exists
if [ ${#WINDOWS[@]} -eq 1 ]; then
    window=${WINDOWS[0]}
    # Check if the window is minimized
    is_minimized=$(xprop -id "$window" | grep -c "window state: Iconic")
    if [ "$is_minimized" -eq 1 ]; then
        # Restore (unminimize) the window
        wmctrl -i -a "$window"
    else
        # Minimize the window
        xdotool windowminimize "$window"
    fi
    exit 0
fi

# For multiple terminal windows, focus the first one or cycle through them
# Option 1: Focus the first terminal window
window=${WINDOWS[0]}
is_minimized=$(xprop -id "$window" | grep -c "window state: Iconic")
if [ "$is_minimized" -eq 1 ]; then
    wmctrl -i -a "$window"
else
    xdotool windowminimize "$window"
fi
