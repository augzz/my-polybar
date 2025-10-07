#!/bin/bash

### 
# Uses xprop and wmctrl to manage and query windows.
# Filter for minimized windows by checking their state.
# Format the output to display icons according to window class -
# with clickable actions to restore (unminimize) windows.
# For use with polybar.
### 

polybar_action="$1"

is_minimized() {
    local win_id=$1
    xprop -id "$win_id" | grep -q "_NET_WM_STATE_HIDDEN"
    return $?
}

# Maps an application class (string) to an icon.
get_icon() {
    local win_class=$1
    local win_class_lower="${win_class,,}"
    case $win_class_lower in
        "firefox")
            icon=" " # Firefox
            ;;
        "code")
            icon=" " # IDE
            ;;
        "terminal"|"gnome-terminal")
            icon=" " # Terminal
            ;;
        "spotify")
            icon=" " # Spotify
            ;;
        *)
            icon=" " # Fallback icon
            ;;
    esac
    echo $icon
}

# Get list of all windows with classes.
current_windows=$(wmctrl -l -x)
output=""

# Loop though current_windows.
while IFS= read -r line; do
    # Collect PID and class.
    win_id=$(echo "$line" | awk '{print $1}')
    win_class=$(echo "$line" | awk '{print $3}' | cut -d'.' -f2)
    # Get icon for window.
    win_icon=`get_icon "$win_class"`
    # Check if window is currently minimized.
    if is_minimized "$win_id"; then
        if [ -n "$output" ]; then
            output="$output      $win_icon"
        else
            output="$win_icon"
        fi
    fi
done <<< "$current_windows"

if [ -z "$output" ]; then
    echo " "
else
    echo "$output"
fi

# Handle click actions.
case $polybar_action in
    "restore")
        # Restore the minimized window using xdotool.
        first_minimized=$(wmctrl -l | while IFS= read -r line; do
            win_id=$(echo "$line" | awk '{print $1}')
            if is_minimized "$win_id"; then
                echo "$win_id"
                break
            fi
        done)

        if [ -n "$first_minimized" ]; then
            xdotool windowactivate "$first_minimized"
        fi
        ;;
esac
