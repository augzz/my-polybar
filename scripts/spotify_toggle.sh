#!/bin/bash

# Check if Spotify is running
if pgrep -x "spotify" > /dev/null; then
    # Get Spotify window ID
    WINDOW_ID=$(xdotool search --onlyvisible --class "spotify" | head -n 1)

    # Check if Spotify window is active (focused)
    ACTIVE_WINDOW=$(xdotool getactivewindow)

    if [ -n "$WINDOW_ID" ] && [ "$WINDOW_ID" = "$ACTIVE_WINDOW" ]; then
        # If Spotify is active, minimize it
        xdotool windowminimize "$WINDOW_ID"
    else
        # If Spotify is not active or minimized, activate it
        xdotool windowactivate "$WINDOW_ID" 2>/dev/null || spotify &
    fi

else
    # If Spotify is not running, launch it
    spotify &
fi
