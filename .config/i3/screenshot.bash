#
# !/bin/sh
#

function usage() {
    echo "Usage: $0 [simple|full]"
}

# main
if [[ "$1" == "simple" ]]; then
    scrot -a "$(slop -f '%x,%y,%w,%h')" "$HOME/Pictures/Screenshots/$(date +Screenshot-%Y-%m-%d-%H:%M:%S.png)"
elif [[ $1 == "full" ]]; then
    scrot "$HOME/Pictures/Screenshots/$(date +Screenshot-%Y-%m-%d-%H:%M:%S.png)"
else
    usage
    exit 1
fi

exit 0
