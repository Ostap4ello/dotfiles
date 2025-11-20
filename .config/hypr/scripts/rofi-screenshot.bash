#!/bin/sh

#
# Rofi screenshot menu
# Display a screenshot menu using rofi
#

choice="$(
    echo "1   rectangle
2   window
3   monitor
4   entire screen" |
        rofi -dmenu \
            -p "Select screenshot type" \
            -format i \
            -no-custom \
            -theme-str 'entry { enabled: false;}'

)"

case "$choice" in
0)
    grim -t png -g "$(slurp)" - | swappy -f -
    ;;
1)
    info="$(hyprctl activewindow)"

    at="$(echo $info | grep -oP "at: \K\d+,\d+")"
    size="$(echo $info | grep size | sed "s/,/x/g" | grep -oP "size: \K\d+x\d+")"

    sleep 0.5

    grim -g "$at $size" - | swappy -f -
    ;;
2)
    grim -t png -g "$(slurp -o)" - | swappy -f -
    ;;
3)
    sleep 0.7

    grim -t png - | swappy -f -
    ;;
*) ;;
esac

exit 0;
