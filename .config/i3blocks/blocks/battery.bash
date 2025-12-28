#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$status" = "Charging" ]; then
    icon=""
else
    if [ "$capacity" -lt 20 ]; then
        icon=""
    elif [ "$capacity" -lt 40 ]; then
        icon=""
    elif [ "$capacity" -lt 60 ]; then
        icon=""
    elif [ "$capacity" -lt 80 ]; then
        icon=""
    else
        icon=""
    fi
fi

echo "$icon $capacity%"
