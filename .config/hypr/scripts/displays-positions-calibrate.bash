#!/bin/bash
#
# Calibrate displays
# This script is used to calibrate displays' positions.
#

main() {
    hypr_dir="$HOME/.config/hypr"

    monitors_cfg_json=$(hyprctl monitors -j)
    monitors_cnt=$(echo "$monitors_cfg_json" | jq 'length')

    if [[ $monitors_cnt -eq 0 ]]; then
        echo "No monitors found. Exiting."
        # exit 1
        return 0
    fi

    declare -a monitor_positions

    for ((i = 0; i < monitors_cnt; i++)); do
        # determine absolute position of the monitor setup
        x=$(echo "$monitors_cfg_json" | jq -r ".[$i].x")
        y=$(echo "$monitors_cfg_json" | jq -r ".[$i].y")
        if [[ -z "$min_x" || "$x" -le "$min_x" ]]; then
            min_x="$x"
        fi
        if [[ -z "$min_y" || "$y" -le "$min_y" ]]; then
            min_y="$y"
        fi
    done

    # echo "Minimum X: $min_x, Minimum Y: $min_y"

    tmpfile=$(mktemp)
    mv "$hypr_dir/monitors.conf" "$tmpfile"
    while read -r line; do
        if [[ "$line" =~ ^\s*monitor ]]; then
            monitor_position=$(echo "$line" | awk -F, '{print $3}')
            x=$(($(echo "$monitor_position" | cut -d'x' -f1)-$min_x))
            y=$(($(echo "$monitor_position" | cut -d'x' -f2)-$min_y))
            line=$(echo "$line" | sed "s/$monitor_position/${x}x${y}/")
            monitor_positions+=("$monitor_name:$monitor_position")
        fi
        echo "$line" >> "$hypr_dir/monitors.conf"
    done < "$tmpfile"
    rm "$tmpfile"

    hyprctl reload > /dev/null 2>&1
}

main "$@"

