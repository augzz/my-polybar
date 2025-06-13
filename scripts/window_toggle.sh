#! /bin/bash

#
# Generic window toggler. Uses wmctrl and xdotool to either maximize or minimize app window.
#

app_name=$1

# Find app window id.
window_id=$(wmctrl -l | grep -i "$app_name" | head -n 1 | awk '{print $1}')

if [ -z "$window_id" ]; then
    # If no app window id is found, launch app.
    "$app_name" &
    exit 0
fi

# Check if the app window is minimized.
is_minimized=$(xprop -id "$window_id" | grep -c "window state: Iconic")

if [ "$is_minimized" -eq 1 ]; then
    # Restore (unminimize) the window.
    wmctrl -i -a "$window_id"
else
    # Minimize the window.
    xdotool windowminimize "$window_id"
fi
