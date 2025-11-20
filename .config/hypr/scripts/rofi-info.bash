#!/bin/sh

#
# Rofi hints
# Display some useful info in a rofi popup
#

rofi \
    -theme-str '* {font: "JuliaMono 8";}' \
    -e "$(cat ~/.config/hypr/scripts/info-hints.txt)"
exit 0;
