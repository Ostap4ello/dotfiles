#!/bin/bash

# Reload displays
# This script is used to reload the displays in the event that they are not
# working properly. This script is for HYPRLAND.

pkill -STOP Hyprland;
rmmod -f nvidia;
modprobe nvidia;
pkill -CONT Hyprland;

exit 0;
