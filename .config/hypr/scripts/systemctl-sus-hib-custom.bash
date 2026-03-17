#!/bin/sh

#
# Conditional suspend
# Perform suspend / hibernate / suspend-then-hibernate
# only when not on charging
#

main () {
    local cmd="$1"
    if [[ ! "$cmd" =~ ^(suspend|hibernate|suspend-then-hibernate)$ ]]; then
        echo "Wrong command."\
            "Only suspend/hibernate/suspend-then-hibernate are supported as of now"
        exit 1
    fi

    local bat_status="$(cat /sys/class/power_supply/BAT0/status)"
    if [[ "$bat_status" != "Discharging" ]]; then
        echo "Device is docked. Doing nothing"
        exit 0
    fi

    systemctl "$cmd"

    exit 0;
}

main "$@"
