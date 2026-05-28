#!/bin/bash
#
# Monitor BAT0 baterry for state and power putthrough in real time
# Ostap4ello (2026)
#

bat="/sys/class/power_supply/BAT0"

if [[ $1 == "-a" ]]; then
	printf "%sW" "$(echo "scale=2; $(cat $bat/current_now) * $(cat $bat/voltage_now)  / 10^12" | bc -l)"
else
while true; do
	printf " "
	printf "Status: %s; " "$(cat $bat/status)"
	printf "Pthr: %s Watt; " "$(echo "scale=2; $(cat $bat/current_now) * $(cat $bat/voltage_now)  / 10^12" | bc -l)"
	printf "\r"
  	sleep 0.5s;
done;
fi
