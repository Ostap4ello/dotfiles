#!/bin/bash

# Reload displays
# This script is used to reload the displays in the event that they are not
# working properly. This script is for HYPRLAND.

hypr_dir="$HOME/.config/hypr"

tmpfile1=$(mktemp)
tmpfile2=$(mktemp)
tmpfile3=$(mktemp)
# mv $hypr_dir/monitors.conf "$tmpfile"
# touch $hypr_dir/monitors.conf
cp "$hypr_dir/monitors.conf" "$tmpfile1"
cp "$hypr_dir/monitors-persistent.conf" "$tmpfile2"
cp "$hypr_dir/dms/outputs.conf" "$tmpfile3"

echo " " > "$hypr_dir/monitors.conf"
echo " " > "$hypr_dir/monitors-persistent.conf"
echo " " > "$hypr_dir/dms/outputs.conf"

hyprctl reload
mv "$tmpfile1" "$hypr_dir/monitors.conf"
mv "$tmpfile2" "$hypr_dir/monitors-persistent.conf"
mv "$tmpfile3" "$hypr_dir/dms/outputs.conf"

hyprctl reload
rm "$tmpfile1"
rm "$tmpfile2"
rm "$tmpfile3"

# hyprctl dispatch dpms off
# sleep 1
# hyprctl dispatch dpms on
# hyprctl reload

pkill -STOP Hyprland
sleep 1
pkill -CONT Hyprland

systemctl --user restart dms

"$hypr_dir/scripts/displays-lid-handle.bash" check

# pkill waybar
# waybar & disown

exit 0;
