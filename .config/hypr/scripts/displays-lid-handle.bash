#!/bin/bash

lid_state_file="/proc/acpi/button/lid/LID0/state";

monitor_count=$(hyprctl monitors | grep "Monitor" | wc -l);
lid_state=$(cat $lid_state_file | awk '{print $2}')

function handle_lid() {
    local state=$1;
    if [[ "$state" == "open" ]]; then
        hyprctl keyword monitor "eDP-1,preffered,auto,1.6"
        hyprctl keyword monitor "eDP-2,preffered,auto,1.6"
        hyprctl reload
    elif [[ "$state" == "close" ]]; then
        hyprctl keyword monitor "eDP-1,disable"
        hyprctl keyword monitor "eDP-2,disable"
    fi
}

function usage() {
    echo "Usage: $0 [open|close|check]";
    exit 1;
}

function main () {
    if [[ "$1" == "open" ]]; then
        handle_lid "open";
    elif [[ $monitor_count -eq 1 ]]; then
        handle_lid "open";
        echo "No external monitors connected. Exiting.";
        exit 0;
    elif [[ "$1" == "close" ]]; then
        handle_lid "close";
    elif [[ "$1" == "check" ]]; then
        if [[ $lid_state  == "open" ]]; then
            handle_lid "open";
        else
            handle_lid "close";
        fi
    else
        usage;
    fi

    echo "[$(date)]: Lid is $lid_state \
        " >> ~/.lidlog;
    exit 0;
}

main $@;
