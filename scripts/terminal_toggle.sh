#!/bin/bash

###
# Check for an open terminal window.
# Restore it if minimized, minimize it if active or restored.
# Launch a new terminal if none exists.
# Handle multiple terminal windows by focusing on one (or cycling through them).
###

# Specify terminal emulator.
terminal=$1

# Find terminal windows (case-insensitive).
mapfile -t windows < <(wmctrl -l -x | grep -i "$terminal" | awk '{print $1}')

if [ ${#windows[@]} -eq 0 ]; then
    # No terminal windows found, launch a new one.
    $terminal &
    exit 0
fi

# If only one terminal window exists --
if [ ${#windows[@]} -eq 1 ]; then
    window=${windows[0]}
    # Check if the window is minimized.
    is_minimized=$(xprop -id "$window" | grep -c "window state: Iconic")
    if [ "$is_minimized" -eq 1 ]; then
        # Restore (unminimize) the window.
        wmctrl -i -a "$window"
    else
        # Minimize the window.
        xdotool windowminimize "$window"
    fi
    exit 0
fi

# For multiple terminal windows, focus the first one or cycle through them -- 

### Option 1: Focus the first terminal window
#window = ${WINDOWS[0]}

#is_minimized = $(xprop -id "$window" | grep -c "window state: Iconic")
#if [ "$is_minimized" -eq 1 ]; then
#    wmctrl -i -a "$window"
#else
#    xdotool windowminimize "$window"
#fi

### Option 2: Store last focused terminal in file.
last_focused_file="$HOME/.last_terminal"

if [ -f "$last_focused_file" ]; then
    last_window=$(cat "$last_focused_file")
else
    last_window=""
fi

# Find the next window to focus.
next_window=""
found_last=0

for win in "${windows[@]}"; do
    if [ "$found_last" -eq 1 ]; then
        next_window="$win"
        break
    fi
    if [ "$win"="$last_window" ]; then
        found_last=1
    fi
done

# If no next window (end of list), loop back to the first.
if [ -z "$next_window" ]; then
    next_window=${windows[0]}
fi

# Save the focused window ID.
echo "$next_window" > "$last_focused_file"

# Toggle the selected window.
is_minimized=$(xprop -id "$next_window" | grep -c "window state: Iconic")
if [ "$is_minimized" -eq 1 ]; then
    wmctrl -i -a "$next_window"
else
    xdotool windowminimize "$next_window"
fi
