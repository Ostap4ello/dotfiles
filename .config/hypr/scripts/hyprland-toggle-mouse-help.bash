#!/bin/sh

#
# Toggle Mouse Help Functionality
#

# Toggle hyprbars
hyprbars_enabled=$(hyprctl -j getoption plugin:hyprbars:enabled | jq '.int')
hyprctl keyword "plugin:hyprbars:enabled $((1 - hyprbars_enabled))"
