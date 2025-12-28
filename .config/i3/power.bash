#!/bin/sh

function lock() {
    i3lock -k --image ~/.local/share/lock.png
}

choice="$(
    echo "1   reboot
2   poweroff
3   hibernate
4   suspend
5   lock" |
        rofi -dmenu \
            -dpi 150 \
            -p "Power Menu" \
            -format i \
            -no-custom \
            -theme-str 'entry { enabled: false;}'
)"
if [ -z "$choice" ]; then
    exit 0
fi

./session.bash save
case "$choice" in
0)
    reboot
    ;;
1)
    systemctl poweroff
    ;;
2)
    lock &
    disown && systemctl hibernate

    ;;
3)
    lock &
    disown && systemctl suspend
    ;;
4)
    lock
    ;;
*) ;;
esac

exit 0;
