#!/bin/bash

WINDOW_NAME=$1
COLOR_FILE="$HOME/.config/polybar/docky/colors.ini"
OVERLINE_COLOR=$(sed -n "/^module-fg[[:space:]]*=/ s/.*=[[:space:]]*\([^[:space:]]*\).*/\1/p" "$COLOR_FILE")
FOREGROUND_COLOR=$(sed -n "/^primary-alt[[:space:]]*=/ s/.*=[[:space:]]*\([^[:space:]]*\).*/\1/p" "$COLOR_FILE")
BACKGROUND_COLOR=$(sed -n "/^background[[:space:]]*=/ s/.*=[[:space:]]*\([^[:space:]]*\).*/\1/p" "$COLOR_FILE")
BACKGROUND_ALT_COLOR=$(sed -n "/^background-alt[[:space:]]*=/ s/.*=[[:space:]]*\([^[:space:]]*\).*/\1/p" "$COLOR_FILE")

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
        "xdg-open /home/augz")
            icon="" 
            ;;
        *)
            icon="" # Fallback icon
            ;;
    esac
    echo $icon
}

get_window_id() {
    local win_name=$1
    wmctrl -l -x | grep -i "$win_name" | head -n 1 | awk '{print $1}'
    return $?
}

get_window_status() {
    local win_id=$1
    xprop -id "$win_id" 2>/dev/null | grep -c "window state: Iconic"
    return $?
}

# Checks if a window is running or not and applies polybar formatting properties to it according to status.
monitor_window() {
    local window_id=$1
    
    while true; do
        # Check if window exists
        if wmctrl -l -x | grep -qi "$WINDOW_NAME"; then
            window_id=$(get_window_id "$WINDOW_NAME")
            # Check if window is minimized
            is_minimized=$(get_window_status "$window_id")
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

### POLYBAR STYLING FUNCTIONS ###
enable_overline() {
    echo "%{o${OVERLINE_COLOR}}%{+o}"" ${module_icon} ""%{-o}"
}

enable_background() {
    echo "%{B${BACKGROUND_COLOR}} ${module_icon} %{B-}"
}

enable_foreground() {
    echo "%{F${FOREGROUND_COLOR}}${module_icon}%{F-}"
}

enable_foreground_background() {
    echo "%{B${BACKGROUND_COLOR}}%{F${FOREGROUND_COLOR}} ${module_icon} %{B- F-}"
}

enable_foreground_overline() {
    echo "%{o${OVERLINE_COLOR}}%{+o}%{F${FOREGROUND_COLOR}}"${module_icon}"%{F-}%{-o}"
}

enable_background_overline() {
    echo "%{o${OVERLINE_COLOR}}%{+o}%{B${BACKGROUND_COLOR}}" ${module_icon} "%{B-}%{-o}"
}

disable_formatting() {
    echo "${module_icon}"
}
### ----------------------- ###

# MAIN
main() {
    module_icon=$(get_icon "$WINDOW_NAME")

    if [ "$2" == "toggle" ]; then
        window_id=$(get_window_id "$WINDOW_NAME")

        # Window does not exist -- launch a new one.
        if [ -z "$window_id" ]; then
            "$WINDOW_NAME" &
            sleep 1 
            new_window_id=$(get_window_id "$WINDOW_NAME")
            if [ -n "$new_window_id" ]; then
                enable_foreground
            fi

        # Window exists -- toggle window state.
        else
            is_minimized=$(get_window_status "$window_id")
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

    # Start monitoring window.
    window_id=$(get_window_id "$WINDOW_NAME")
    if [ -n "$window_id" ]; then
        monitor_window "$window_id"
    else
        disable_formatting
    fi
}

main "$@"
