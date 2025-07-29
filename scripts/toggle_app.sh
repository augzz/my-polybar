#!/bin/bash

# Uses wmctrl and xdotool to toggle app window and manage properties in Polybar.

app_name=$1
overline_color="#374646" 
foreground_color="#9D5515"  
background_color="#1b1b1b" 

# Map icon (icomoon feather font) according to app name.
get_icon() {
    name=$1
    case $name in
        "firefox")
            icon="" 
            ;;
        "spotify")
            icon="" 
            ;;
        "code")
            icon="" 
            ;;
        "gnome-terminal")
            icon="" 
            ;;
        *)
            icon="" # Fallback icon
            ;;
    esac
    echo $icon
}

get_win_id() {
    local win_name=$1
    wmctrl -l -x | grep -i "$win_name" | head -n 1 | awk '{print $1}'
    return $?
}

# POLYBAR STYLING FUNCTIONS
enable_overline() {
    echo "%{o${overline_color}}%{+o}"" ${module_icon} ""%{-o}"
}

enable_background() {
    echo "%{B${background_color}} ${module_icon} %{B-}"
}

enable_foreground() {
    echo "%{F${foreground_color}}${module_icon}%{F-}"
}

enable_foreground_background() {
    echo "%{B${background_color}}%{F${foreground_color}} ${module_icon} %{B- F-}"
}

enable_foreground_overline() {
    echo "%{o${overline_color}}%{+o}%{F${foreground_color}}"${module_icon}"%{F-}%{-o}"
}

enable_background_overline() {
    echo "%{o${overline_color}}%{+o}%{B${background_color}}" ${module_icon} "%{B-}%{-o}"
}

disable_formatting() {
    echo "${module_icon}"
}

monitor_window() {
    local window_id=$1
    while true; do
        # Check if window exists
        if wmctrl -l -x | grep -qi "$app_name"; then
            window_id=$(wmctrl -l -x | grep -i "$app_name" | head -n 1 | awk '{print $1}')
            # Check if window is minimized
            is_minimized=$(xprop -id "$window_id" 2>/dev/null | grep -c "window state: Iconic")
            if [ "$is_minimized" -eq 0 ]; then
                # Window is active
                enable_foreground
            else
                # Window is minimized
                enable_foreground_overline
            fi
        else
            # Window is closed
            disable_formatting
        fi
        sleep 1  
    done
}

# MAIN
module_icon=`get_icon "$app_name"`

# Handle toggle action (called on click)
if [ "$2" == "toggle" ]; then
    window_id=$(wmctrl -l -x | grep -i "$app_name" | head -n 1 | awk '{print $1}')
    if [ -z "$window_id" ]; then
        # Launch app if no window is found
        "$app_name" &
        sleep 1  # Wait for window to appear
        new_window_id=$(wmctrl -l -x | grep -i "$app_name" | head -n 1 | awk '{print $1}')
        if [ -n "$new_window_id" ]; then
            enable_foreground
        fi
    else
        # Toggle window state
        is_minimized=$(xprop -id "$window_id" 2>/dev/null | grep -c "window state: Iconic")
        if [ "$is_minimized" -eq 1 ]; then
            # Restore window
            wmctrl -i -a "$window_id"
            enable_foreground
        else
            # Minimize window
            xdotool windowminimize "$window_id"
            #enable_foreground
        fi
    fi
    exit 0
fi

# Start monitoring for Polybar output
window_id=$(wmctrl -l -x | grep -i "$app_name" | head -n 1 | awk '{print $1}')
if [ -n "$window_id" ]; then
    monitor_window "$window_id"
else
    # Output without overline if no window is open
    disable_formatting
fi
