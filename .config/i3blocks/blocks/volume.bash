#!/bin/bash
volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    echo " Muted"
else
    if [ "$volume" -lt 33 ]; then
        icon=""
    elif [ "$volume" -lt 66 ]; then
        icon=""
    else
        icon=""
    fi
    echo "$icon $volume%"
fi
