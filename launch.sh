#!/bin/bash

# Terminate already running bar instances.
polybar-msg cmd quit

# Launch polybar on each open monitor.
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done
