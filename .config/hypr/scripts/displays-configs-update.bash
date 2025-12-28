#!/bin/bash
#
# Update persistent monitors configuration
# This script updates the monitors-persistent.conf file with the current monitors.conf settings.
#

mon_config="${HOME}/.config/hypr/monitors.conf"
pers_config="${HOME}/.config/hypr/monitors-persistent.conf"

# Get configured monitors
declare -a monitors
while read -r line; do
    if [[ "$line" =~ ^\s*#.*$ || -z "$line" ]]; then continue; fi;
    monitors+=("$line")
done < "$mon_config"

# Update persistent settings
if [[ ! -f "$pers_config" || ! -s "$pers_config" ]]; then
    echo "# Persistent monitors settings" > "$pers_config"
    echo "# Created by $0" >> "$pers_config"
    echo "" >> "$pers_config"
fi

for monitor in "${monitors[@]}"; do
    # Remove last saved configuration for this monitor
    line=$(echo "$monitor" | cut -d',' -f 1)
    sed --in-place -e "/^${line},.*$/d" "$pers_config"
    # Append current configuration
    echo "$monitor" >> "$pers_config"
done
