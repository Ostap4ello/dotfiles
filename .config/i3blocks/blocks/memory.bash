#!/bin/bash
memory=$(free -m | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}')
echo " $memory"
